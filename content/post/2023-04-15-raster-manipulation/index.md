---
title: "栅格数据批量处理"
author: "学R不思则罔"
date: '2023-04-15'
output:
  prettydoc::html_pretty:
    theme: cayman
    highlight: github
categories: ["R"]
tags: ["dplyr", "sf","raster"]
thumbnail: "thumbnail.png"
description: "以获取上海市高程、植被指数等诸多环境变量栅格数据为目标，解决一般情境下的栅格数据区域不一致、坐标系不一致、分辨率不一致等诸多问题"
toc: true
---





本文以获取上海市高程、植被指数等诸多环境变量栅格数据为目标，解决一般情境下的栅格数据区域不一致、坐标系不一致、分辨率不一致等诸多问题。

加载处理栅格数据的常用**R**包。


```r
if (! require(mapchina)) install.packages("mapchina")
if (! require(sf)) install.packages("sf")
if (! require(tidyverse)) install.packages("tidyverse")
if (! require(raster)) install.packages("raster")
```

获取上海市矢量边界数据。


```r
sh_sf <- mapchina::china %>% 
  dplyr::filter(Name_Province == "上海市") %>% 
  group_by(Name_Province) %>% 
  dplyr::summarise(geometry = st_union(geometry)) %>%
  ungroup()
ggplot(sh_sf)+
  geom_sf()+
  theme_light()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-2-1.png" width="2800" style="display: block; margin: auto;" />



```r
folders_name <- list.files("D:/biomod2/ZT2/专题二延伸栅格数据处理/rawdata",full.names = T)
folders_name
```

```
#>  [1] "D:/biomod2/ZT2/专题二延伸栅格数据处理/rawdata/aat0"             
#>  [2] "D:/biomod2/ZT2/专题二延伸栅格数据处理/rawdata/aat10"            
#>  [3] "D:/biomod2/ZT2/专题二延伸栅格数据处理/rawdata/aridity"          
#>  [4] "D:/biomod2/ZT2/专题二延伸栅格数据处理/rawdata/dem"              
#>  [5] "D:/biomod2/ZT2/专题二延伸栅格数据处理/rawdata/dst_waterway"     
#>  [6] "D:/biomod2/ZT2/专题二延伸栅格数据处理/rawdata/hfp"              
#>  [7] "D:/biomod2/ZT2/专题二延伸栅格数据处理/rawdata/hii"              
#>  [8] "D:/biomod2/ZT2/专题二延伸栅格数据处理/rawdata/im"               
#>  [9] "D:/biomod2/ZT2/专题二延伸栅格数据处理/rawdata/landcover"        
#> [10] "D:/biomod2/ZT2/专题二延伸栅格数据处理/rawdata/landform"         
#> [11] "D:/biomod2/ZT2/专题二延伸栅格数据处理/rawdata/ndvi20161"        
#> [12] "D:/biomod2/ZT2/专题二延伸栅格数据处理/rawdata/ndvi20162"        
#> [13] "D:/biomod2/ZT2/专题二延伸栅格数据处理/rawdata/ndvi20163"        
#> [14] "D:/biomod2/ZT2/专题二延伸栅格数据处理/rawdata/ndvi20164"        
#> [15] "D:/biomod2/ZT2/专题二延伸栅格数据处理/rawdata/night_time_lights"
#> [16] "D:/biomod2/ZT2/专题二延伸栅格数据处理/rawdata/pa"               
#> [17] "D:/biomod2/ZT2/专题二延伸栅格数据处理/rawdata/slope"            
#> [18] "D:/biomod2/ZT2/专题二延伸栅格数据处理/rawdata/tadem"
```

展示像元距水道距离栅格数据图。


```r
dst_waterway <- folders_name[5] %>% 
  list.files(pattern = "tif$",full.names = T) %>% 
  raster()
plot(dst_waterway)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-4-1.png" width="2800" style="display: block; margin: auto;" />

裁剪出上海市范围数据并且绘图。


```r
sh_dst_waterway <- dst_waterway %>%
  crop(sh_sf) %>% 
  mask(sh_sf)
plot(sh_dst_waterway)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-5-1.png" width="2800" style="display: block; margin: auto;" />

使用**purrr**包的`map`族函数一步到位解决同一文件夹下的分辨率不同、坐标系不同、区域不同问题。


```r
# 索引出tif和adf格式文件
folders_name %>% 
  list.files(pattern = ".tif$|w001001.adf$",full.names = T) %>% 
  as_tibble() %>% 
  group_by(value) %>% 
  nest() %>% 
  # 读取栅格数据
  mutate(data = map(.x = value,.f = function(x) raster(x))) %>% 
  # 获取crs
  mutate(raster_crs = map(.x = data,.f = function(x) crs(x))) %>% 
  # 统一矢量边界数据和栅格数据的投影
  mutate(sh_crs = map(.x = raster_crs,.f = function(x) {
    st_transform(sh_sf,
                 crs = as.character(crs(x)))
  })) %>% 
  # 裁剪、提取、变换坐标系、对栅格数据进行重采样
  mutate(temp_raster = map2(.x = data,.y = sh_crs,.f = function(x,y) {
    crop(x,y) %>% 
      mask(y) %>% 
      projectRaster(crs = "+proj=longlat +datum=WGS84 +no_defs") %>% 
      resample(sh_dst_waterway,"bilinear")
  })) %>% 
  # 重命名栅格数据的变量名称
  mutate(temp_sh = map2(.x = temp_raster,.y = value,.f = function(x,y) {
    names(x) <- str_match(y,"D:/biomod2/ZT2/专题二延伸栅格数据处理/rawdata/(.*)/")[,2]
    x
  })) %>% 
  # 保存栅格数据到同一文件夹
  mutate(x = map(.x = temp_sh,.f = function(x) {
    writeRaster(x,
                paste0("D:/biomod2/ZT2/专题二延伸栅格数据处理/data/",names(x),".asc"),overwrite=TRUE)
  }))
```

展示裁剪之后的结果。


```r
list.files("D:/biomod2/ZT2/专题二延伸栅格数据处理/data",full.names = T)
```

```
#>  [1] "D:/biomod2/ZT2/专题二延伸栅格数据处理/data/aat0.asc"             
#>  [2] "D:/biomod2/ZT2/专题二延伸栅格数据处理/data/aat10.asc"            
#>  [3] "D:/biomod2/ZT2/专题二延伸栅格数据处理/data/aridity.asc"          
#>  [4] "D:/biomod2/ZT2/专题二延伸栅格数据处理/data/dem.asc"              
#>  [5] "D:/biomod2/ZT2/专题二延伸栅格数据处理/data/dst_waterway.asc"     
#>  [6] "D:/biomod2/ZT2/专题二延伸栅格数据处理/data/hfp.asc"              
#>  [7] "D:/biomod2/ZT2/专题二延伸栅格数据处理/data/hii.asc"              
#>  [8] "D:/biomod2/ZT2/专题二延伸栅格数据处理/data/im.asc"               
#>  [9] "D:/biomod2/ZT2/专题二延伸栅格数据处理/data/landcover.asc"        
#> [10] "D:/biomod2/ZT2/专题二延伸栅格数据处理/data/landform.asc"         
#> [11] "D:/biomod2/ZT2/专题二延伸栅格数据处理/data/ndvi20161.asc"        
#> [12] "D:/biomod2/ZT2/专题二延伸栅格数据处理/data/ndvi20162.asc"        
#> [13] "D:/biomod2/ZT2/专题二延伸栅格数据处理/data/ndvi20163.asc"        
#> [14] "D:/biomod2/ZT2/专题二延伸栅格数据处理/data/ndvi20164.asc"        
#> [15] "D:/biomod2/ZT2/专题二延伸栅格数据处理/data/night_time_lights.asc"
#> [16] "D:/biomod2/ZT2/专题二延伸栅格数据处理/data/pa.asc"               
#> [17] "D:/biomod2/ZT2/专题二延伸栅格数据处理/data/slope.asc"            
#> [18] "D:/biomod2/ZT2/专题二延伸栅格数据处理/data/tadem.asc"
```


---


