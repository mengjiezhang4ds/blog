---
title: "趋势分析"
author: "学R不思则罔"
date: '2022-05-24'
output:
  prettydoc::html_pretty:
    theme: cayman
    highlight: github
thumbnail: "yga.png"
categories: ["R"]
tags: ["ols","ndvi","residual analysis"]
description: "基于MODIS-NDVI数据、DEM及气象数据，辅以趋势分析、多元回归残差法、残差分析等方法，反演了XX地区time1—time2植被覆盖度及分析了其“格局—过程—趋势”的变化特征，探究了其对气候变化与人类活动的双重响应机制"
toc: yes
---





## 1.准备工作

### 1.1加载扩展包


```r
library(raster)
library(terra)
library(extrafont)
library(showtext)
library(tidyverse)
library(tidyterra)
library(ggspatial)
library(sf)
library(tictoc)
```

### 1.2 读取字体


```r
showtext_auto(enable = TRUE)
font_add("Times", "./font/Times New Roman.ttf")
font_add("KaiTi", "./font/KaiTi.ttf")
```

### 1.3 读取数据


```r
lapply(X = list.files("D:/post/geography/raster/raster_regression/rawdata", full.names = TRUE), FUN = function(x) {
  temp_file <- list.files(path = x, pattern = ".tif$", full.names = TRUE) %>%
    raster::stack()
  print(paste("====================栅格数据：", stringr::str_sub(names(temp_file)[1], 1, 3), "====================="))
  print(temp_file)
  print(paste("极大值：", cellStats(temp_file, stat = "max", na.rm = TRUE), "极小值：", cellStats(temp_file, stat = "min", na.rm = TRUE)))
})
```

```
#> [1] "====================栅格数据： fvc ====================="
#> class      : RasterStack 
#> dimensions : 1380, 1777, 2452260, 20  (nrow, ncol, ncell, nlayers)
#> resolution : 250, 250  (x, y)
#> extent     : 645582.1, 1089832, 2257185, 2602185  (xmin, xmax, ymin, ymax)
#> crs        : +proj=aea +lat_0=0 +lon_0=105 +lat_1=25 +lat_2=47 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs 
#> names      : fvc2001, fvc2002, fvc2003, fvc2004, fvc2005, fvc2006, fvc2007, fvc2008, fvc2009, fvc2010, fvc2011, fvc2012, fvc2013, fvc2014, fvc2015, ... 
#> min values :       0,       0,       0,       0,       0,       0,       0,       0,       0,       0,       0,       0,       0,       0,       0, ... 
#> max values :       1,       1,       1,       1,       1,       1,       1,       1,       1,       1,       1,       1,       1,       1,       1, ... 
#> 
#>  [1] "极大值： 1 极小值： 0" "极大值： 1 极小值： 0" "极大值： 1 极小值： 0"
#>  [4] "极大值： 1 极小值： 0" "极大值： 1 极小值： 0" "极大值： 1 极小值： 0"
#>  [7] "极大值： 1 极小值： 0" "极大值： 1 极小值： 0" "极大值： 1 极小值： 0"
#> [10] "极大值： 1 极小值： 0" "极大值： 1 极小值： 0" "极大值： 1 极小值： 0"
#> [13] "极大值： 1 极小值： 0" "极大值： 1 极小值： 0" "极大值： 1 极小值： 0"
#> [16] "极大值： 1 极小值： 0" "极大值： 1 极小值： 0" "极大值： 1 极小值： 0"
#> [19] "极大值： 1 极小值： 0" "极大值： 1 极小值： 0"
#> [1] "====================栅格数据： PRE ====================="
#> class      : RasterStack 
#> dimensions : 1224, 1670, 2044080, 20  (nrow, ncol, ncell, nlayers)
#> resolution : 250, 250  (x, y)
#> extent     : 653080.6, 1070581, 2267879, 2573879  (xmin, xmax, ymin, ymax)
#> crs        : +proj=aea +lat_0=0 +lon_0=105 +lat_1=25 +lat_2=47 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs 
#> names      :  PRE2001,  PRE2002,  PRE2003,  PRE2004,  PRE2005,  PRE2006,  PRE2007,  PRE2008,  PRE2009,  PRE2010,  PRE2011,  PRE2012,  PRE2013,  PRE2014,  PRE2015, ... 
#> min values : 1580.353, 1360.508,  708.649, 1099.398,  167.706, 1709.667, 1193.549, 1639.979, 1249.248, 1322.639, 1122.373, 1486.465, 1803.782, 1473.699, 1460.109, ... 
#> max values : 3606.125, 3065.649, 2144.795, 3103.484, 3780.365, 3072.009, 2552.735, 3421.017, 3226.432, 2906.868, 2230.595, 3450.666, 3421.577, 2395.376, 2440.535, ... 
#> 
#>  [1] "极大值： 3606.125 极小值： 1580.35302734375"        
#>  [2] "极大值： 3065.64892578125 极小值： 1360.50805664062"
#>  [3] "极大值： 2144.794921875 极小值： 708.648986816406"  
#>  [4] "极大值： 3103.48388671875 极小值： 1099.39794921875"
#>  [5] "极大值： 3780.36499023438 极小值： 167.705993652344"
#>  [6] "极大值： 3072.00903320312 极小值： 1709.6669921875" 
#>  [7] "极大值： 2552.73510742188 极小值： 1193.54895019531"
#>  [8] "极大值： 3421.01708984375 极小值： 1639.97900390625"
#>  [9] "极大值： 3226.43188476562 极小值： 1249.248046875"  
#> [10] "极大值： 2906.86791992188 极小值： 1322.63903808594"
#> [11] "极大值： 2230.59497070312 极小值： 1122.373046875"  
#> [12] "极大值： 3450.666015625 极小值： 1486.46496582031"  
#> [13] "极大值： 3421.57690429688 极小值： 1803.78198242188"
#> [14] "极大值： 2395.3759765625 极小值： 1473.69897460938" 
#> [15] "极大值： 2440.53491210938 极小值： 1460.10900878906"
#> [16] "极大值： 3130.3798828125 极小值： 1874.76098632812" 
#> [17] "极大值： 3060.76708984375 极小值： 1341.56994628906"
#> [18] "极大值： 3060.76708984375 极小值： 1341.56994628906"
#> [19] "极大值： 3771.94409179688 极小值： 1412.29602050781"
#> [20] "极大值： 2876.18408203125 极小值： 371.153991699219"
#> [1] "====================栅格数据： RHU ====================="
#> class      : RasterStack 
#> dimensions : 1224, 1670, 2044080, 20  (nrow, ncol, ncell, nlayers)
#> resolution : 250, 250  (x, y)
#> extent     : 653080.6, 1070581, 2267879, 2573879  (xmin, xmax, ymin, ymax)
#> crs        : +proj=aea +lat_0=0 +lon_0=105 +lat_1=25 +lat_2=47 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs 
#> names      : RHU2001, RHU2002, RHU2003, RHU2004, RHU2005, RHU2006, RHU2007, RHU2008, RHU2009, RHU2010, RHU2011, RHU2012, RHU2013, RHU2014, RHU2015, ... 
#> min values :  76.001,  76.776,  75.740,  73.950,  72.946,  76.066,  72.599,  66.572,  64.089,  71.354,  70.921,  76.856,  74.848,  74.503,  76.988, ... 
#> max values :  84.381,  83.704,  80.936,  83.616,  77.497,  84.890,  80.423,  77.516,  81.444,  86.459,  75.184,  88.802,  86.186,  97.799,  96.353, ... 
#> 
#>  [1] "极大值： 84.3809967041016 极小值： 76.0009994506836"
#>  [2] "极大值： 83.7040023803711 极小值： 76.7760009765625"
#>  [3] "极大值： 80.9359970092773 极小值： 75.7399978637695"
#>  [4] "极大值： 83.6159973144531 极小值： 73.9499969482422"
#>  [5] "极大值： 77.4970016479492 极小值： 72.9459991455078"
#>  [6] "极大值： 84.8899993896484 极小值： 76.0660018920898"
#>  [7] "极大值： 80.4229965209961 极小值： 72.5989990234375"
#>  [8] "极大值： 77.515998840332 极小值： 66.5719985961914" 
#>  [9] "极大值： 81.4440002441406 极小值： 64.088996887207" 
#> [10] "极大值： 86.4589996337891 极小值： 71.3539962768555"
#> [11] "极大值： 75.1839981079102 极小值： 70.9209976196289"
#> [12] "极大值： 88.802001953125 极小值： 76.8560028076172" 
#> [13] "极大值： 86.1859970092773 极小值： 74.8479995727539"
#> [14] "极大值： 97.7990036010742 极小值： 74.5029983520508"
#> [15] "极大值： 96.3529968261719 极小值： 76.9879989624023"
#> [16] "极大值： 98.1169967651367 极小值： 78.0609970092773"
#> [17] "极大值： 92.5920028686523 极小值： 77.0930023193359"
#> [18] "极大值： 95.9570007324219 极小值： 76.5839996337891"
#> [19] "极大值： 93.8209991455078 极小值： 76.8730010986328"
#> [20] "极大值： 100 极小值： 74.7890014648438"             
#> [1] "====================栅格数据： SSD ====================="
#> class      : RasterStack 
#> dimensions : 1224, 1670, 2044080, 21  (nrow, ncol, ncell, nlayers)
#> resolution : 250, 250  (x, y)
#> extent     : 653080.6, 1070581, 2267879, 2573879  (xmin, xmax, ymin, ymax)
#> crs        : +proj=aea +lat_0=0 +lon_0=105 +lat_1=25 +lat_2=47 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs 
#> names      :  SSD2001, SSD2001new,  SSD2002,  SSD2003,  SSD2004,  SSD2005,  SSD2006,  SSD2007,  SSD2008,  SSD2009,  SSD2010,  SSD2011,  SSD2012,  SSD2013,  SSD2014, ... 
#> min values :  -24.204,      0.000,  194.378,  426.534,  704.122,  589.961,  236.344,  513.041,  399.223,  284.604,  461.545,  328.935,  662.979,  774.561, 1029.247, ... 
#> max values : 2000.280,   2000.280, 2077.797, 2252.701, 2231.740, 1816.549, 1841.212, 2229.594, 2006.888, 2186.171, 1873.813, 2140.895, 1845.517, 1928.647, 2143.827, ... 
#> 
#>  [1] "极大值： 2000.28002929688 极小值： -24.2040004730225"
#>  [2] "极大值： 2000.28002929688 极小值： 0"                
#>  [3] "极大值： 2077.79711914062 极小值： 194.378005981445" 
#>  [4] "极大值： 2252.70092773438 极小值： 426.533996582031" 
#>  [5] "极大值： 2231.73999023438 极小值： 704.122009277344" 
#>  [6] "极大值： 1816.54895019531 极小值： 589.960998535156" 
#>  [7] "极大值： 1841.21203613281 极小值： 236.343994140625" 
#>  [8] "极大值： 2229.59399414062 极小值： 513.041015625"    
#>  [9] "极大值： 2006.88793945312 极小值： 399.222991943359" 
#> [10] "极大值： 2186.1708984375 极小值： 284.60400390625"   
#> [11] "极大值： 1873.81298828125 极小值： 461.545013427734" 
#> [12] "极大值： 2140.89501953125 极小值： 328.934997558594" 
#> [13] "极大值： 1845.51696777344 极小值： 662.97900390625"  
#> [14] "极大值： 1928.64697265625 极小值： 774.560974121094" 
#> [15] "极大值： 2143.82690429688 极小值： 1029.24694824219" 
#> [16] "极大值： 2113.68896484375 极小值： 830.060974121094" 
#> [17] "极大值： 1755.46899414062 极小值： 827.135009765625" 
#> [18] "极大值： 2054.876953125 极小值： 611.421997070312"   
#> [19] "极大值： 1919.97204589844 极小值： 594.530029296875" 
#> [20] "极大值： 2012.71899414062 极小值： 709.236999511719" 
#> [21] "极大值： 2097.01708984375 极小值： 1442.44702148438" 
#> [1] "====================栅格数据： TEM ====================="
#> class      : RasterStack 
#> dimensions : 1224, 1670, 2044080, 20  (nrow, ncol, ncell, nlayers)
#> resolution : 250, 250  (x, y)
#> extent     : 653080.6, 1070581, 2267879, 2573879  (xmin, xmax, ymin, ymax)
#> crs        : +proj=aea +lat_0=0 +lon_0=105 +lat_1=25 +lat_2=47 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs 
#> names      : TEM2001, TEM2002, TEM2003, TEM2004, TEM2005, TEM2006, TEM2007, TEM2008, TEM2009, TEM2010, TEM2011, TEM2012, TEM2013, TEM2014, TEM2015, ... 
#> min values :  14.854,  14.788,  14.883,  12.725,  14.406,  15.004,  15.455,  15.874,  15.961,  16.131,  14.799,  14.613,  14.265,  11.552,  12.194, ... 
#> max values :  23.627,  23.946,  23.917,  23.598,  23.243,  23.522,  23.779,  23.254,  23.523,  23.398,  23.047,  23.607,  23.748,  23.967,  24.590, ... 
#> 
#>  [1] "极大值： 23.6270008087158 极小值： 14.8540000915527"
#>  [2] "极大值： 23.9459991455078 极小值： 14.7880001068115"
#>  [3] "极大值： 23.9169998168945 极小值： 14.8830003738403"
#>  [4] "极大值： 23.5979995727539 极小值： 12.7250003814697"
#>  [5] "极大值： 23.2430000305176 极小值： 14.4060001373291"
#>  [6] "极大值： 23.5219993591309 极小值： 15.003999710083" 
#>  [7] "极大值： 23.7789993286133 极小值： 15.4549999237061"
#>  [8] "极大值： 23.253999710083 极小值： 15.8739995956421" 
#>  [9] "极大值： 23.5230007171631 极小值： 15.9610004425049"
#> [10] "极大值： 23.3980007171631 极小值： 16.1310005187988"
#> [11] "极大值： 23.0470008850098 极小值： 14.798999786377" 
#> [12] "极大值： 23.6070003509521 极小值： 14.6129999160767"
#> [13] "极大值： 23.7479991912842 极小值： 14.2650003433228"
#> [14] "极大值： 23.9669990539551 极小值： 11.5520000457764"
#> [15] "极大值： 24.5900001525879 极小值： 12.1940002441406"
#> [16] "极大值： 23.9729995727539 极小值： 10.8900003433228"
#> [17] "极大值： 24.19700050354 极小值： 11.7580003738403"  
#> [18] "极大值： 24.0590000152588 极小值： 11.789999961853" 
#> [19] "极大值： 24.7019996643066 极小值： 12.201000213623" 
#> [20] "极大值： 24.4689998626709 极小值： 11.7779998779297"
#> [1] "====================栅格数据： WIN ====================="
#> class      : RasterStack 
#> dimensions : 1224, 1670, 2044080, 29  (nrow, ncol, ncell, nlayers)
#> resolution : 250, 250  (x, y)
#> extent     : 653080.6, 1070581, 2267879, 2573879  (xmin, xmax, ymin, ymax)
#> crs        : +proj=aea +lat_0=0 +lon_0=105 +lat_1=25 +lat_2=47 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs 
#> names      : WIN2001, WIN2001new, WIN2002, WIN2002new, WIN2003, WIN2003new, WIN2004, WIN2005, WIN2005new, WIN2006, WIN2006new, WIN2007, WIN2007new, WIN2008, WIN2008new, ... 
#> min values :  -1.616,      0.000,  -1.153,      0.000,  -1.071,      0.000,   0.911,  -0.026,      0.000,  -0.007,      0.000,  -0.362,      0.000,  -0.236,      0.000, ... 
#> max values :   5.836,      5.836,   6.486,      6.486,   5.919,      5.919,   5.343,   5.112,      5.112,   5.614,      5.614,   5.556,      5.556,   5.160,      5.160, ... 
#> 
#>  [1] "极大值： 5.83599996566772 极小值： -1.61600005626678"   
#>  [2] "极大值： 5.83599996566772 极小值： 0"                   
#>  [3] "极大值： 6.48600006103516 极小值： -1.15299999713898"   
#>  [4] "极大值： 6.48600006103516 极小值： 0"                   
#>  [5] "极大值： 5.91900014877319 极小值： -1.07099997997284"   
#>  [6] "极大值： 5.91900014877319 极小值： 0"                   
#>  [7] "极大值： 5.34299993515015 极小值： 0.91100001335144"    
#>  [8] "极大值： 5.11199998855591 极小值： -0.0260000005364418" 
#>  [9] "极大值： 5.11199998855591 极小值： 0"                   
#> [10] "极大值： 5.61399984359741 极小值： -0.00700000021606684"
#> [11] "极大值： 5.61399984359741 极小值： 0"                   
#> [12] "极大值： 5.55600023269653 极小值： -0.361999988555908"  
#> [13] "极大值： 5.55600023269653 极小值： 0"                   
#> [14] "极大值： 5.15999984741211 极小值： -0.236000001430511"  
#> [15] "极大值： 5.15999984741211 极小值： 0"                   
#> [16] "极大值： 5.35599994659424 极小值： -0.920000016689301"  
#> [17] "极大值： 5.35599994659424 极小值： 0"                   
#> [18] "极大值： 5.30299997329712 极小值： -0.97299998998642"   
#> [19] "极大值： 5.30299997329712 极小值： 0"                   
#> [20] "极大值： 5.39499998092651 极小值： 0.19200000166893"    
#> [21] "极大值： 5.67799997329712 极小值： 0.310999989509583"   
#> [22] "极大值： 5.4850001335144 极小值： 0.35699999332428"     
#> [23] "极大值： 5.16499996185303 极小值： 1.43599998950958"    
#> [24] "极大值： 4.90199995040894 极小值： 1.48300004005432"    
#> [25] "极大值： 5.20599985122681 极小值： 1.45200002193451"    
#> [26] "极大值： 5.30399990081787 极小值： 1.45700001716614"    
#> [27] "极大值： 5.21099996566772 极小值： 1.4559999704361"     
#> [28] "极大值： 4.61700010299683 极小值： 1.57700002193451"    
#> [29] "极大值： 5.84600019454956 极小值： 2.61700010299683"
```

```
#> [[1]]
#>  [1] "极大值： 1 极小值： 0" "极大值： 1 极小值： 0" "极大值： 1 极小值： 0"
#>  [4] "极大值： 1 极小值： 0" "极大值： 1 极小值： 0" "极大值： 1 极小值： 0"
#>  [7] "极大值： 1 极小值： 0" "极大值： 1 极小值： 0" "极大值： 1 极小值： 0"
#> [10] "极大值： 1 极小值： 0" "极大值： 1 极小值： 0" "极大值： 1 极小值： 0"
#> [13] "极大值： 1 极小值： 0" "极大值： 1 极小值： 0" "极大值： 1 极小值： 0"
#> [16] "极大值： 1 极小值： 0" "极大值： 1 极小值： 0" "极大值： 1 极小值： 0"
#> [19] "极大值： 1 极小值： 0" "极大值： 1 极小值： 0"
#> 
#> [[2]]
#>  [1] "极大值： 3606.125 极小值： 1580.35302734375"        
#>  [2] "极大值： 3065.64892578125 极小值： 1360.50805664062"
#>  [3] "极大值： 2144.794921875 极小值： 708.648986816406"  
#>  [4] "极大值： 3103.48388671875 极小值： 1099.39794921875"
#>  [5] "极大值： 3780.36499023438 极小值： 167.705993652344"
#>  [6] "极大值： 3072.00903320312 极小值： 1709.6669921875" 
#>  [7] "极大值： 2552.73510742188 极小值： 1193.54895019531"
#>  [8] "极大值： 3421.01708984375 极小值： 1639.97900390625"
#>  [9] "极大值： 3226.43188476562 极小值： 1249.248046875"  
#> [10] "极大值： 2906.86791992188 极小值： 1322.63903808594"
#> [11] "极大值： 2230.59497070312 极小值： 1122.373046875"  
#> [12] "极大值： 3450.666015625 极小值： 1486.46496582031"  
#> [13] "极大值： 3421.57690429688 极小值： 1803.78198242188"
#> [14] "极大值： 2395.3759765625 极小值： 1473.69897460938" 
#> [15] "极大值： 2440.53491210938 极小值： 1460.10900878906"
#> [16] "极大值： 3130.3798828125 极小值： 1874.76098632812" 
#> [17] "极大值： 3060.76708984375 极小值： 1341.56994628906"
#> [18] "极大值： 3060.76708984375 极小值： 1341.56994628906"
#> [19] "极大值： 3771.94409179688 极小值： 1412.29602050781"
#> [20] "极大值： 2876.18408203125 极小值： 371.153991699219"
#> 
#> [[3]]
#>  [1] "极大值： 84.3809967041016 极小值： 76.0009994506836"
#>  [2] "极大值： 83.7040023803711 极小值： 76.7760009765625"
#>  [3] "极大值： 80.9359970092773 极小值： 75.7399978637695"
#>  [4] "极大值： 83.6159973144531 极小值： 73.9499969482422"
#>  [5] "极大值： 77.4970016479492 极小值： 72.9459991455078"
#>  [6] "极大值： 84.8899993896484 极小值： 76.0660018920898"
#>  [7] "极大值： 80.4229965209961 极小值： 72.5989990234375"
#>  [8] "极大值： 77.515998840332 极小值： 66.5719985961914" 
#>  [9] "极大值： 81.4440002441406 极小值： 64.088996887207" 
#> [10] "极大值： 86.4589996337891 极小值： 71.3539962768555"
#> [11] "极大值： 75.1839981079102 极小值： 70.9209976196289"
#> [12] "极大值： 88.802001953125 极小值： 76.8560028076172" 
#> [13] "极大值： 86.1859970092773 极小值： 74.8479995727539"
#> [14] "极大值： 97.7990036010742 极小值： 74.5029983520508"
#> [15] "极大值： 96.3529968261719 极小值： 76.9879989624023"
#> [16] "极大值： 98.1169967651367 极小值： 78.0609970092773"
#> [17] "极大值： 92.5920028686523 极小值： 77.0930023193359"
#> [18] "极大值： 95.9570007324219 极小值： 76.5839996337891"
#> [19] "极大值： 93.8209991455078 极小值： 76.8730010986328"
#> [20] "极大值： 100 极小值： 74.7890014648438"             
#> 
#> [[4]]
#>  [1] "极大值： 2000.28002929688 极小值： -24.2040004730225"
#>  [2] "极大值： 2000.28002929688 极小值： 0"                
#>  [3] "极大值： 2077.79711914062 极小值： 194.378005981445" 
#>  [4] "极大值： 2252.70092773438 极小值： 426.533996582031" 
#>  [5] "极大值： 2231.73999023438 极小值： 704.122009277344" 
#>  [6] "极大值： 1816.54895019531 极小值： 589.960998535156" 
#>  [7] "极大值： 1841.21203613281 极小值： 236.343994140625" 
#>  [8] "极大值： 2229.59399414062 极小值： 513.041015625"    
#>  [9] "极大值： 2006.88793945312 极小值： 399.222991943359" 
#> [10] "极大值： 2186.1708984375 极小值： 284.60400390625"   
#> [11] "极大值： 1873.81298828125 极小值： 461.545013427734" 
#> [12] "极大值： 2140.89501953125 极小值： 328.934997558594" 
#> [13] "极大值： 1845.51696777344 极小值： 662.97900390625"  
#> [14] "极大值： 1928.64697265625 极小值： 774.560974121094" 
#> [15] "极大值： 2143.82690429688 极小值： 1029.24694824219" 
#> [16] "极大值： 2113.68896484375 极小值： 830.060974121094" 
#> [17] "极大值： 1755.46899414062 极小值： 827.135009765625" 
#> [18] "极大值： 2054.876953125 极小值： 611.421997070312"   
#> [19] "极大值： 1919.97204589844 极小值： 594.530029296875" 
#> [20] "极大值： 2012.71899414062 极小值： 709.236999511719" 
#> [21] "极大值： 2097.01708984375 极小值： 1442.44702148438" 
#> 
#> [[5]]
#>  [1] "极大值： 23.6270008087158 极小值： 14.8540000915527"
#>  [2] "极大值： 23.9459991455078 极小值： 14.7880001068115"
#>  [3] "极大值： 23.9169998168945 极小值： 14.8830003738403"
#>  [4] "极大值： 23.5979995727539 极小值： 12.7250003814697"
#>  [5] "极大值： 23.2430000305176 极小值： 14.4060001373291"
#>  [6] "极大值： 23.5219993591309 极小值： 15.003999710083" 
#>  [7] "极大值： 23.7789993286133 极小值： 15.4549999237061"
#>  [8] "极大值： 23.253999710083 极小值： 15.8739995956421" 
#>  [9] "极大值： 23.5230007171631 极小值： 15.9610004425049"
#> [10] "极大值： 23.3980007171631 极小值： 16.1310005187988"
#> [11] "极大值： 23.0470008850098 极小值： 14.798999786377" 
#> [12] "极大值： 23.6070003509521 极小值： 14.6129999160767"
#> [13] "极大值： 23.7479991912842 极小值： 14.2650003433228"
#> [14] "极大值： 23.9669990539551 极小值： 11.5520000457764"
#> [15] "极大值： 24.5900001525879 极小值： 12.1940002441406"
#> [16] "极大值： 23.9729995727539 极小值： 10.8900003433228"
#> [17] "极大值： 24.19700050354 极小值： 11.7580003738403"  
#> [18] "极大值： 24.0590000152588 极小值： 11.789999961853" 
#> [19] "极大值： 24.7019996643066 极小值： 12.201000213623" 
#> [20] "极大值： 24.4689998626709 极小值： 11.7779998779297"
#> 
#> [[6]]
#>  [1] "极大值： 5.83599996566772 极小值： -1.61600005626678"   
#>  [2] "极大值： 5.83599996566772 极小值： 0"                   
#>  [3] "极大值： 6.48600006103516 极小值： -1.15299999713898"   
#>  [4] "极大值： 6.48600006103516 极小值： 0"                   
#>  [5] "极大值： 5.91900014877319 极小值： -1.07099997997284"   
#>  [6] "极大值： 5.91900014877319 极小值： 0"                   
#>  [7] "极大值： 5.34299993515015 极小值： 0.91100001335144"    
#>  [8] "极大值： 5.11199998855591 极小值： -0.0260000005364418" 
#>  [9] "极大值： 5.11199998855591 极小值： 0"                   
#> [10] "极大值： 5.61399984359741 极小值： -0.00700000021606684"
#> [11] "极大值： 5.61399984359741 极小值： 0"                   
#> [12] "极大值： 5.55600023269653 极小值： -0.361999988555908"  
#> [13] "极大值： 5.55600023269653 极小值： 0"                   
#> [14] "极大值： 5.15999984741211 极小值： -0.236000001430511"  
#> [15] "极大值： 5.15999984741211 极小值： 0"                   
#> [16] "极大值： 5.35599994659424 极小值： -0.920000016689301"  
#> [17] "极大值： 5.35599994659424 极小值： 0"                   
#> [18] "极大值： 5.30299997329712 极小值： -0.97299998998642"   
#> [19] "极大值： 5.30299997329712 极小值： 0"                   
#> [20] "极大值： 5.39499998092651 极小值： 0.19200000166893"    
#> [21] "极大值： 5.67799997329712 极小值： 0.310999989509583"   
#> [22] "极大值： 5.4850001335144 极小值： 0.35699999332428"     
#> [23] "极大值： 5.16499996185303 极小值： 1.43599998950958"    
#> [24] "极大值： 4.90199995040894 极小值： 1.48300004005432"    
#> [25] "极大值： 5.20599985122681 极小值： 1.45200002193451"    
#> [26] "极大值： 5.30399990081787 极小值： 1.45700001716614"    
#> [27] "极大值： 5.21099996566772 极小值： 1.4559999704361"     
#> [28] "极大值： 4.61700010299683 极小值： 1.57700002193451"    
#> [29] "极大值： 5.84600019454956 极小值： 2.61700010299683"
```

6个因子的数值范围正常，FVC因子和其他5个变量的范围不一致，因此需要后期掩膜提取


## 2.数据处理

### 2.1 矢量数据生成


```r
yga <- sf::read_sf("D:/post/geography/raster/raster_regression/data/粤港澳2020/县.shp")
head(yga)
```

```
#> Simple feature collection with 6 features and 8 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 113.1437 ymin: 23.02903 xmax: 113.6039 ymax: 23.43116
#> Geodetic CRS:  CGCS_2000
#> # A tibble: 6 × 9
#>      PAC NAME   省代码 省     市代码 市    类型  DEN19                  geometry
#>    <dbl> <chr>   <dbl> <chr>   <dbl> <chr> <chr> <int>        <MULTIPOLYGON [°]>
#> 1 440103 荔湾区 440000 广东省 440100 广州… 市辖…  1508 (((113.2406 23.15083, 11…
#> 2 440104 越秀区 440000 广东省 440100 广州… 市辖…  1508 (((113.2498 23.15441, 11…
#> 3 440105 海珠区 440000 广东省 440100 广州… 市辖…  1508 (((113.29 23.1098, 113.2…
#> 4 440106 天河区 440000 广东省 440100 广州… 市辖…  1508 (((113.4001 23.23404, 11…
#> 5 440111 白云区 440000 广东省 440100 广州… 市辖…  1508 (((113.4741 23.42756, 11…
#> 6 440112 黄埔区 440000 广东省 440100 广州… 市辖…  1508 (((113.4919 23.41449, 11…
```



```r
ggplot(yga) +
  geom_sf(color = "black", size = 0.1) +
  theme_light() +
  theme(
    plot.title = element_text(size = 20, hjust = 0.5, vjust = 0.5, face = "bold", family = "KaiTi"),
    panel.border = element_rect(color = "black", size = 3),
    axis.text.x = element_text(size = 14, hjust = 0.5, vjust = 0.5, face = "bold", family = "Times"),
    axis.text.y = element_text(size = 14, hjust = 0.5, vjust = 0.5, face = "bold", family = "Times"),
    axis.title.x = element_text(size = 14, hjust = 0.5, vjust = 0.5, face = "bold", family = "Times"),
    axis.title.y = element_text(size = 14, hjust = 0.5, vjust = 0.5, face = "bold", family = "Times"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  ) +
  labs(title = "粤港澳大湾区地图") +
  annotation_scale(location = "bl", width_hint = 0.3, text_family = "Times", text_cex = 1.5) +
  annotation_north_arrow(
    location = "tr", which_north = "false",
    pad_x = unit(0.4, "cm"),
    pad_y = unit(0.4, "cm"),
    style = north_arrow_fancy_orienteering(
      text_family = "Times"
    )
  )
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-5-1.png" width="672" style="display: block; margin: auto;" />

### 2.2 栅格数据掩膜提取


```r
library(tictoc)
tic()
lapply(X = list.files("D:/post/geography/raster/raster_regression/rawdata", full.names = TRUE), FUN = function(x) {
  paste0(x, "/", str_sub(string = x, start = nchar(x) - 2, end = nchar(x))) %>%
    paste0(., 2001:2020, ".tif") %>%
    as_tibble() %>%
    set_names("new_file") %>%
    mutate(import_file = purrr::map(.x = new_file, .f = function(x) {
      ifelse(file.exists(x), x, str_remove(x, "new"))
    })) %>%
    unnest(cols = c(import_file)) %>%
    dplyr::select(import_file) %>%
    group_by(import_file) %>%
    nest() %>%
    mutate(new_raster = purrr::map(.x = import_file, .f = function(x) {
      dir.create(paste0("D:/post/geography/raster/raster_regression/data/", str_sub(x, nchar(x) - 10, nchar(x) - 8)))
      raster::brick(x) %>%
        raster::crop(st_transform(yga, "+proj=aea +lat_0=0 +lon_0=105 +lat_1=25 +lat_2=47 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs")) %>%
        mask(st_transform(yga, "+proj=aea +lat_0=0 +lon_0=105 +lat_1=25 +lat_2=47 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs")) %>%
        projectRaster(crs = "+proj=longlat +datum=WGS84 +no_defs +type=crs") %>%
        writeRaster(x = ., filename = str_remove(x, "raw") %>%
          str_remove(., "new"), format = "GTiff", overwrite = TRUE)
    }))
})
```

```
#> [[1]]
#> # A tibble: 20 × 3
#> # Groups:   import_file [20]
#>    import_file                                      data     new_raster         
#>    <chr>                                            <list>   <list>             
#>  1 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  2 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  3 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  4 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  5 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  6 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  7 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  8 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  9 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 10 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 11 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 12 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 13 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 14 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 15 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 16 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 17 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 18 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 19 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 20 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 
#> [[2]]
#> # A tibble: 20 × 3
#> # Groups:   import_file [20]
#>    import_file                                      data     new_raster         
#>    <chr>                                            <list>   <list>             
#>  1 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  2 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  3 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  4 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  5 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  6 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  7 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  8 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  9 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 10 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 11 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 12 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 13 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 14 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 15 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 16 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 17 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 18 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 19 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 20 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 
#> [[3]]
#> # A tibble: 20 × 3
#> # Groups:   import_file [20]
#>    import_file                                      data     new_raster         
#>    <chr>                                            <list>   <list>             
#>  1 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  2 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  3 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  4 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  5 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  6 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  7 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  8 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  9 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 10 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 11 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 12 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 13 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 14 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 15 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 16 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 17 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 18 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 19 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 20 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 
#> [[4]]
#> # A tibble: 20 × 3
#> # Groups:   import_file [20]
#>    import_file                                      data     new_raster         
#>    <chr>                                            <list>   <list>             
#>  1 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  2 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  3 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  4 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  5 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  6 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  7 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  8 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  9 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 10 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 11 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 12 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 13 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 14 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 15 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 16 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 17 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 18 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 19 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 20 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 
#> [[5]]
#> # A tibble: 20 × 3
#> # Groups:   import_file [20]
#>    import_file                                      data     new_raster         
#>    <chr>                                            <list>   <list>             
#>  1 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  2 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  3 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  4 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  5 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  6 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  7 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  8 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  9 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 10 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 11 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 12 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 13 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 14 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 15 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 16 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 17 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 18 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 19 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 20 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 
#> [[6]]
#> # A tibble: 20 × 3
#> # Groups:   import_file [20]
#>    import_file                                      data     new_raster         
#>    <chr>                                            <list>   <list>             
#>  1 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  2 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  3 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  4 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  5 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  6 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  7 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  8 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#>  9 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 10 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 11 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 12 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 13 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 14 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 15 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 16 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 17 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 18 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 19 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
#> 20 D:/post/geography/raster/raster_regression/rawd… <tibble> <RastrLyr[,1785,1]>
```

```r
toc()
```

```
#> 429.59 sec elapsed
```


### 2.3 栅格数据重采样

- 以SSD数据为基准进行重采样


```r
resample_temp <- list.files(path = "D:/post/geography/raster/raster_regression/data/SSD", pattern = ".tif$", full.names = TRUE)[1] %>%
  raster::brick()
resample_temp
```

```
#> class      : RasterBrick 
#> dimensions : 1377, 1785, 2457945, 1  (nrow, ncol, ncell, nlayers)
#> resolution : 0.00241, 0.00226  (x, y)
#> extent     : 111.2331, 115.5349, 21.34572, 24.45774  (xmin, xmax, ymin, ymax)
#> crs        : +proj=longlat +datum=WGS84 +no_defs 
#> source     : SSD2001.tif 
#> names      :  SSD2001 
#> min values : 17.21836 
#> max values : 1998.788
```

- fvc全部数据重采样


```r
list.files(path = "D:/post/geography/raster/raster_regression/data/FVC", pattern = ".tif$", full.names = TRUE) %>%
  as_tibble() %>%
  set_names("new_file") %>%
  group_by(new_file) %>%
  nest() %>%
  mutate(new_raster = purrr::map(.x = new_file, .f = function(x) {
    raster::brick(x) %>%
      resample(x = ., y = resample_temp, "bilinear") %>%
      writeRaster(x = ., filename = x, format = "GTiff", overwrite = TRUE)
  }))
```

```
#> # A tibble: 20 × 3
#> # Groups:   new_file [20]
#>    new_file                                         data     new_raster         
#>    <chr>                                            <list>   <list>             
#>  1 D:/post/geography/raster/raster_regression/data… <tibble> <RastrLyr[,1785,1]>
#>  2 D:/post/geography/raster/raster_regression/data… <tibble> <RastrLyr[,1785,1]>
#>  3 D:/post/geography/raster/raster_regression/data… <tibble> <RastrLyr[,1785,1]>
#>  4 D:/post/geography/raster/raster_regression/data… <tibble> <RastrLyr[,1785,1]>
#>  5 D:/post/geography/raster/raster_regression/data… <tibble> <RastrLyr[,1785,1]>
#>  6 D:/post/geography/raster/raster_regression/data… <tibble> <RastrLyr[,1785,1]>
#>  7 D:/post/geography/raster/raster_regression/data… <tibble> <RastrLyr[,1785,1]>
#>  8 D:/post/geography/raster/raster_regression/data… <tibble> <RastrLyr[,1785,1]>
#>  9 D:/post/geography/raster/raster_regression/data… <tibble> <RastrLyr[,1785,1]>
#> 10 D:/post/geography/raster/raster_regression/data… <tibble> <RastrLyr[,1785,1]>
#> 11 D:/post/geography/raster/raster_regression/data… <tibble> <RastrLyr[,1785,1]>
#> 12 D:/post/geography/raster/raster_regression/data… <tibble> <RastrLyr[,1785,1]>
#> 13 D:/post/geography/raster/raster_regression/data… <tibble> <RastrLyr[,1785,1]>
#> 14 D:/post/geography/raster/raster_regression/data… <tibble> <RastrLyr[,1785,1]>
#> 15 D:/post/geography/raster/raster_regression/data… <tibble> <RastrLyr[,1785,1]>
#> 16 D:/post/geography/raster/raster_regression/data… <tibble> <RastrLyr[,1785,1]>
#> 17 D:/post/geography/raster/raster_regression/data… <tibble> <RastrLyr[,1785,1]>
#> 18 D:/post/geography/raster/raster_regression/data… <tibble> <RastrLyr[,1785,1]>
#> 19 D:/post/geography/raster/raster_regression/data… <tibble> <RastrLyr[,1785,1]>
#> 20 D:/post/geography/raster/raster_regression/data… <tibble> <RastrLyr[,1785,1]>
```


## 3.趋势分析

- 读取fvc栅格数据


```r
fvc_raster <- list.files(path = "D:/post/geography/raster/raster_regression/data/FVC", pattern = ".tif$", full.names = TRUE) %>%
  raster::stack()
fvc_raster
```

```
#> class      : RasterStack 
#> dimensions : 1377, 1785, 2457945, 20  (nrow, ncol, ncell, nlayers)
#> resolution : 0.00241, 0.00226  (x, y)
#> extent     : 111.2331, 115.5349, 21.34572, 24.45774  (xmin, xmax, ymin, ymax)
#> crs        : +proj=longlat +datum=WGS84 +no_defs 
#> names      :  FVC2001,  FVC2002,  FVC2003,  FVC2004,  FVC2005,  FVC2006,  FVC2007,  FVC2008,  FVC2009,  FVC2010,  FVC2011,  FVC2012,  FVC2013,  FVC2014,  FVC2015, ... 
#> min values :        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0,        0, ... 
#> max values : 1.000000, 1.000000, 1.000000, 1.000000, 1.000000, 1.000000, 1.000000, 1.000000, 1.000000, 1.000000, 1.000000, 1.000000, 1.000000, 1.000000, 1.000000, ...
```

- 获取时间


```r
time <- 1:nlayers(fvc_raster)
time
```

```
#>  [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20
```

- 编写函数


```r
lm_wrapper <- function(x) {
  # In case of any NA return four NA values for coefficient estimates
  if (any(is.na(x))) {
    return(rep(NA, 6))
  }
  # 建立模型
  mod <- lm(x ~ time, na.action = na.omit)
  # 获取系数值
  coef <- summary(mod)$coefficients[1:2]
  names(coef) <- c("Intercept", "X1")
  # 获取p值
  p_value <- summary(mod)$coefficients[, "Pr(>|t|)"]
  names(p_value) <- c("Intercept_p", "X1_p")
  # 获取拟合优度系数
  r_squared <- summary(mod)$r.squared
  names(r_squared) <- c("r_squared")
  # 获取调整拟合优度系数
  adj_r_squared <- summary(mod)$adj.r.squared
  names(adj_r_squared) <- c("adj_r_squared")
  # 获取残差
  # resid <- summary(mod)$residuals
  c(coef, p_value, r_squared, adj_r_squared)
}
```

- 计算结果


```r
lm_terra <- terra::app(rast(fvc_raster), lm_wrapper)
lm_terra
```

```
#> class       : SpatRaster 
#> dimensions  : 1377, 1785, 6  (nrow, ncol, nlyr)
#> resolution  : 0.00241, 0.00226  (x, y)
#> extent      : 111.2331, 115.5349, 21.34572, 24.45774  (xmin, xmax, ymin, ymax)
#> coord. ref. : +proj=longlat +datum=WGS84 +no_defs 
#> source(s)   : memory
#> names       :  Intercept,          X1,  Intercept_p,         X1_p,    r_squared, adj_r~uared 
#> min values  : -0.2333075, -0.07089115, 9.779676e-32, 2.873495e-13, 3.455547e-13, -0.05555556 
#> max values  :  1.1854695,  0.06941110, 9.998743e-01, 9.999980e-01, 9.513914e-01,  0.94869092
```

- 绘制四个变量图形


```r
ggplot() +
  geom_spatraster(data = terra::subset(lm_terra, c("X1", "X1_p", "r_squared", "adj_r_squared"))) +
  scale_fill_whitebox_c(
    palette = "muted",
    na.value = "white"
  ) +
  facet_wrap(~lyr) +
  theme_light() +
  theme(
    plot.title = element_text(size = 20, hjust = 0.5, vjust = 0.5, face = "bold", family = "Times"),
    plot.subtitle = element_text(size = 18, hjust = 0.5, vjust = 0.5, face = "bold", family = "Times"),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    axis.ticks = element_blank(),
    legend.position = "bottom",
    legend.text = element_text(family = "Times"),
    legend.key.width = unit(2.5, "cm"),
    legend.title = element_text(family = "Times")
  ) +
  labs(
    fill = "value"
  )
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-13-1.png" width="672" style="display: block; margin: auto;" />


- 单独绘制slope


```r
ggplot() +
  geom_spatraster(data = terra::subset(lm_terra, c("X1"))) +
  scale_fill_whitebox_c(
    palette = "muted",
    na.value = "white"
  )+
  hrbrthemes::theme_modern_rc()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-14-1.png" width="672" style="display: block; margin: auto;" />


## 4.多元回归

- 读取多个环境数据


```r
ef_terra <- list.files(path = "D:/post/geography/raster/raster_regression/data", full.names = TRUE) %>%
  list.files(path = ., pattern = "tif$", full.names = TRUE) %>%
  terra::rast()
ef_terra
```

```
#> class       : SpatRaster 
#> dimensions  : 1377, 1785, 120  (nrow, ncol, nlyr)
#> resolution  : 0.00241, 0.00226  (x, y)
#> extent      : 111.2331, 115.5349, 21.34572, 24.45774  (xmin, xmax, ymin, ymax)
#> coord. ref. : lon/lat WGS 84 (EPSG:4326) 
#> sources     : FVC2001.tif  
#>               FVC2002.tif  
#>               FVC2003.tif  
#>               ... and 117 more source(s)
#> names       : FVC2001, FVC2002, FVC2003, FVC2004, FVC2005, FVC2006, ... 
#> min values  :       0,       0,       0,       0,       0,       0, ... 
#> max values  :       1,       1,       1,       1,       1,       1, ...
```

- 编写函数


```r
mlr_wrapper <- function(x) {
  # In case of any NA return four NA values for coefficient estimates
  if (any(is.na(x))) {
    return(rep(NA, 14))
  }
  # 建立模型
  mod <- lm(x[1:20] ~ x[21:40]+x[41:60]+x[61:80]+x[81:100]+x[101:120], na.action = na.omit)
  # 获取系数值
  coef <- summary(mod)$coefficients[1:6]
  names(coef) <- c("Intercept", "PRE","RHU","SSD","TEM","WIN")
  # 获取p值
  p_value <- summary(mod)$coefficients[, "Pr(>|t|)"]
  names(p_value) <- paste0(c("Intercept", "PRE","RHU","SSD","TEM","WIN"),"_p")
  # 获取拟合优度系数
  r_squared <- summary(mod)$r.squared
  names(r_squared) <- c("r_squared")
  # 获取调整拟合优度系数
  adj_r_squared <- summary(mod)$adj.r.squared
  names(adj_r_squared) <- c("adj_r_squared")
  # 获取残差
  # resid <- summary(mod)$residuals
  c(coef, p_value, r_squared, adj_r_squared)
}
```

- 计算结果


```r
tic()
mlr_terra <- terra::app(ef_terra, mlr_wrapper,cores = 8)
toc()
```

```
#> 293.76 sec elapsed
```



```r
mlr_terra
```

```
#> class       : SpatRaster 
#> dimensions  : 1377, 1785, 14  (nrow, ncol, nlyr)
#> resolution  : 0.00241, 0.00226  (x, y)
#> extent      : 111.2331, 115.5349, 21.34572, 24.45774  (xmin, xmax, ymin, ymax)
#> coord. ref. : lon/lat WGS 84 (EPSG:4326) 
#> source(s)   : memory
#> names       : Intercept,           PRE,        RHU,          SSD,        TEM,       WIN, ... 
#> min values  : -12.67698, -0.0006687561, -0.1961356, -0.001935750, -0.7863918, -1.073620, ... 
#> max values  :  13.42410,  0.0007047392,  0.1675242,  0.002309925,  0.6121979,  1.478366, ...
```

- 绘制系数图


```r
ggplot() +
  geom_spatraster(data = terra::subset(mlr_terra, 2:6)) +
  scale_fill_whitebox_c(
    palette = "muted",
    na.value = "white"
  ) +
  facet_wrap(~lyr) +
  theme_light() +
  theme(
    plot.title = element_text(size = 20, hjust = 0.5, vjust = 0.5, face = "bold", family = "Times"),
    plot.subtitle = element_text(size = 18, hjust = 0.5, vjust = 0.5, face = "bold", family = "Times"),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    axis.ticks = element_blank(),
    legend.position = "bottom",
    legend.text = element_text(family = "Times"),
    legend.key.width = unit(2.5, "cm"),
    legend.title = element_text(family = "Times")
  ) +
  labs(
    fill = "coefficients"
  )
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-19-1.png" width="672" style="display: block; margin: auto;" />

- 绘制系数P值图


```r
ggplot() +
  geom_spatraster(data = terra::subset(mlr_terra, 8:12)) +
  scale_fill_whitebox_c(
    palette = "muted",
    na.value = "white"
  ) +
  facet_wrap(~lyr) +
  theme_light() +
  theme(
    plot.title = element_text(size = 20, hjust = 0.5, vjust = 0.5, face = "bold", family = "Times"),
    plot.subtitle = element_text(size = 18, hjust = 0.5, vjust = 0.5, face = "bold", family = "Times"),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    axis.ticks = element_blank(),
    legend.position = "bottom",
    legend.text = element_text(family = "Times"),
    legend.key.width = unit(2.5, "cm"),
    legend.title = element_text(family = "Times")
  ) +
  labs(
    fill = "P value"
  )
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-20-1.png" width="672" style="display: block; margin: auto;" />

- 绘制拟合优度


```r
ggplot() +
  geom_spatraster(data = terra::subset(mlr_terra,13:14)) +
  scale_fill_whitebox_c(
    palette = "muted",
    na.value = "white"
  ) +
  facet_wrap(~lyr) +
  theme_light() +
  theme(
    plot.title = element_text(size = 20, hjust = 0.5, vjust = 0.5, face = "bold", family = "Times"),
    plot.subtitle = element_text(size = 18, hjust = 0.5, vjust = 0.5, face = "bold", family = "Times"),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    axis.ticks = element_blank(),
    legend.position = "bottom",
    legend.text = element_text(family = "Times"),
    legend.key.width = unit(2.5, "cm"),
    legend.title = element_text(family = "Times")
  ) +
  labs(
    fill = "value"
  )
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-21-1.png" width="672" style="display: block; margin: auto;" />

- 残差分析准备在下一篇推送写，思路同理。先得到每年的逐像元残差，然后拟合残差回归方程判断人类活动的影响

----
