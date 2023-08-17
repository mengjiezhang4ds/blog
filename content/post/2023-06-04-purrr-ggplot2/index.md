---
title: "purrr批量作图"
author: "学R不思则罔"
date: '2023-06-04'
output:
  prettydoc::html_pretty:
    theme: cayman
    highlight: github
thumbnail: "spei.gif"
categories: ["R"]
tags: ["ggplot2","purrr","gif"]
description: "基于标准化降水蒸散指数数据，使用**ggplot2**扩展包展示，使用**purrr**扩展包批量绘制、存储，并且将结果展示为动态图"
toc: yes
---





## 1.加载扩展包


```r
library(ncdf4)
library(raster)
library(terra)
library(extrafont)
library(showtext)
library(tidyverse)
library(tidyterra)
library(ggspatial)
```

## 2.读取字体


```r
showtext_auto(enable = TRUE)
font_add("Times", "./font/Times New Roman.ttf")
font_add("KaiTi", "./font/KaiTi.ttf")
```


## 3.读取数据

### 3.1 ncdf4读取



- 使用ncdf4的nc_open函数读取数据


```r
spei_nc <- ncdf4::nc_open("./outputNcdf/spei01.nc")
```


```r
spei_nc
```

```
#> File D:/post/spei/outputNcdf/spei01.nc (NC_FORMAT_NETCDF4):
#> 
#>      2 variables (excluding dimension variables):
#>         float spei[lon,lat,time]   (Chunking: [720,360,1])  (Compression: level 9)
#>             units: 1
#>             _FillValue: 1.00000001504747e+30
#>             long_name: Standardized Precipitation-Evapotranspiration Index
#>             grid_mapping: crs
#>         int crs[]   (Contiguous storage)  
#>             long_name: CRS definition
#>             grid_mapping_name: latitude_longitude
#>             semi_major_axis: 6378137
#>             inverse_flattening: 298.257223563
#>             crs_wkt: GEODCRS["WGS 84",DATUM["World Geodetic System 1984",ELLIPSOID["WGS 84",6378137,298.257223563,LENGTHUNIT["metre",1.0]]],PRIMEM["Greenwich",0],CS[ellipsoidal,3],AXIS["(lat)",north,ANGLEUNIT["degree",0.0174532925199433]],AXIS["(lon)",east,ANGLEUNIT["degree",0.0174532925199433]],AXIS["ellipsoidal height (h)",up,LENGTHUNIT["metre",1.0]]]
#> 
#>      3 dimensions:
#>         lon  Size:720 
#>             units: degrees_east
#>             standard_name: longitude
#>             axis: X
#>         lat  Size:360 
#>             units: degrees_north
#>             standard_name: latitude
#>             axis: Y
#>         time  Size:1464   *** is unlimited *** 
#>             units: days since 1900-1-1
#>             long_name: time
#>             calendar: gregorian
#>             standard_name: time
#>             axis: T
#> 
#>     15 global attributes:
#>         conventions: CF-1.8
#>         title: Global 1-month SPEI, z-values, 0.5 degree
#>         version: 2.9.0
#>         id: ./outputNcdf/spei01.nc
#>         summary: Global dataset of the Standardized Precipitation-Evapotranspiration Index (SPEI) at the 1-month time scale. Using CRU TS 4.07 precipitation and potential evapotranspiration data
#>         keywords: drought, climatology, SPEI, Standardized Precipitation-Evapotranspiration Index
#>         institution: Consejo Superior de Investigaciones Científicas, CSIC
#>         source: http://sac.csic.es/spei
#>         creators: Santiago Beguería <santiago.begueria@csic.es> and Sergio Vicente-Serrano <svicen@ipe.csic.es>
#>         software: Created in R using the SPEI package (https://cran.r-project.org/web/packages/SPEI/;https://github.com/sbegueria/SPEI)
#>         call: spei.nc(sca=i, inPre=./inputData/cru_ts4.07.1901.2022.pre.dat.nc, outFile=paste)
#>         date: Tue Aug 15 14:21:53 2023
#>         reference: Beguería S., Vicente-Serrano S., Reig F., Latorre B. (2014) Standardized precipitation evapotranspiration index (SPEI) revisited: Parameter fitting, evapotranspiration models, tools, datasets and drought monitoring. International Journal of Climatology 34, 3001-3023.
#>         reference2: Vicente-Serrano S.M., Beguería S., López-Moreno J.I. (2010) A Multiscalar Drought Index Sensitive to Global Warming: The Standardized Precipitation Evapotranspiration Index. Journal of Climate 23, 1696–1718.
#>         reference3: Beguería S., Vicente-Serrano S., Angulo-Martínez M. (2010) A multi-scalar global drought data set: the SPEIbase. Bulletin of the American Meteorological Society 91(10), 1351–1356.
```

- 获取变量名


```r
names(spei_nc$var)
```

```
#> [1] "spei" "crs"
```

### 3.2 raster读取



- 使用raster的stack函数读取数据


```r
spei_stack <- raster::stack("./outputNcdf/spei01.nc", varname = "spei")
```



```r
spei_stack
```

```
#> class      : RasterStack 
#> dimensions : 360, 720, 259200, 1464  (nrow, ncol, ncell, nlayers)
#> resolution : 0.5, 0.5  (x, y)
#> extent     : -180, 180, -90, 90  (xmin, xmax, ymin, ymax)
#> crs        : +proj=longlat +datum=WGS84 +no_defs 
#> names      : X1901.01.16, X1901.02.15, X1901.03.16, X1901.04.16, X1901.05.16, X1901.06.16, X1901.07.16, X1901.08.16, X1901.09.16, X1901.10.16, X1901.11.16, X1901.12.16, X1902.01.16, X1902.02.15, X1902.03.16, ... 
#> Date        : 1901-01-16 - 2022-12-16 (range)
```

结果中的names自行添加了“X”使其成为字符串


```r
length(names(spei_stack)) / 12 == 122
```

```
#> [1] TRUE
```

spei01.nc文件的多个图层恰好是1901年到2022年每个月的数据

- 草图展示


```r
spei_stack %>%
  subset(1) %>%
  plot()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-11-1.png" width="672" style="display: block; margin: auto;" />


```r
spei_stack %>%
  subset(1) %>%
  raster::spplot()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-12-1.png" width="672" style="display: block; margin: auto;" />


### 3.3 terra读取




- 使用terra包的rast函数读取数据


```r
spei_terra <- rast("./outputNcdf/spei01.nc")
```


```r
spei_terra
```

```
#> class       : SpatRaster 
#> dimensions  : 360, 720, 1464  (nrow, ncol, nlyr)
#> resolution  : 0.5, 0.5  (x, y)
#> extent      : -180, 180, -90, 90  (xmin, xmax, ymin, ymax)
#> coord. ref. : lon/lat WGS 84 
#> source      : spei01.nc 
#> varname     : spei (Standardized Precipitation-Evapotranspiration Index) 
#> names       : spei_1, spei_2, spei_3, spei_4, spei_5, spei_6, ... 
#> unit        :      1,      1,      1,      1,      1,      1, ... 
#> time (days) : 1901-01-16 to 2022-12-16
```

- tidyterra绘制草图


```r
ggplot() +
  geom_spatraster(data = terra::subset(spei_terra, 1:4)) +
  facet_wrap(~lyr) +
  scale_fill_whitebox_c(
    palette = "high_relief",
    na.value = "white"
  ) +
  theme_light()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-16-1.png" width="672" style="display: block; margin: auto;" />

- 优化图片


```r
ggplot() +
  geom_spatraster(data = terra::subset(spei_terra, 1)) +
  scale_fill_whitebox_c(
    palette = "muted",
    na.value = "white",
    limits = c(-4, 4)
  ) +
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
    fill = "value",
    caption = "DATA SOURCE:https://climatedataguide.ucar.edu/climate-data/standardized-precipitation-evapotranspiration-index-spei",
    subtitle = lubridate::as_date(unlist(raster(terra::subset(spei_terra, 1))@z)),
    title = "Standardized Precipitation Evapotranspiration Index"
  ) +
  annotation_scale(location = "bl", width_hint = 0.1)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-17-1.png" width="672" style="display: block; margin: auto;" />

## 4.批量绘图

> [!Info]   
> 这里仅仅绘制前12*10个月的数据(全数据跨度过大，不宜展示)


```r
tibble(id = 1:nlyr(spei_terra)) %>%
  head(12*10) %>% 
  group_by(id) %>%
  nest() %>%
  mutate(gg_fig = map(.x = id, .f = function(x) {
    temp_data <- terra::subset(spei_terra, x)
    p <- ggplot() +
      geom_spatraster(data = temp_data) +
      scale_fill_whitebox_c(
        palette = "muted",
        na.value = "white",
        limits = c(-4, 4)
      ) +
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
        fill = "value",
        caption = "DATA SOURCE:https://climatedataguide.ucar.edu/climate-data/standardized-precipitation-evapotranspiration-index-spei",
        subtitle = lubridate::as_date(unlist(raster(terra::subset(spei_terra, x))@z)),
        title = "Standardized Precipitation Evapotranspiration Index"
      ) +
      annotation_scale(location = "bl", width_hint = 0.1)

    Fig_name <- paste0("./outputFig/", lubridate::as_date(unlist(raster(temp_data)@z)), ".jpg")
    ggsave(p, filename = Fig_name, dpi = 100)
    p
  }))
```

```
#> # A tibble: 120 × 3
#> # Groups:   id [120]
#>       id data             gg_fig
#>    <int> <list>           <list>
#>  1     1 <tibble [1 × 0]> <gg>  
#>  2     2 <tibble [1 × 0]> <gg>  
#>  3     3 <tibble [1 × 0]> <gg>  
#>  4     4 <tibble [1 × 0]> <gg>  
#>  5     5 <tibble [1 × 0]> <gg>  
#>  6     6 <tibble [1 × 0]> <gg>  
#>  7     7 <tibble [1 × 0]> <gg>  
#>  8     8 <tibble [1 × 0]> <gg>  
#>  9     9 <tibble [1 × 0]> <gg>  
#> 10    10 <tibble [1 × 0]> <gg>  
#> # ℹ 110 more rows
```

## 5.动态图展示


```r
library(magick)
list.files(path='./outputFig', pattern = '*.jpg', full.names = TRUE) %>%
  image_read() %>%
  image_join() %>% 
  image_animate(fps=10) %>% 
  image_write("spei.gif")
```

- 动态图展示如下

![](spei.gif)

