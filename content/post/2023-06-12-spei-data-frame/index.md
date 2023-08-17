---
title: "使用数据框数据计算SPEI"
author: "学R不思则罔"
date: '2023-06-12'
output:
  prettydoc::html_pretty:
    theme: cayman
    highlight: github
thumbnail: "station_time_series.jpg"
categories: ["R"]
tags: ["spei","ggplot2"]
description: "基于降水和气温等数据框格式数据，使用**spei**扩展包计算潜在蒸散量、水平衡数据，最终计算**spei**数据，对结果可视化"
toc: yes
---




## 1.准备工作

### 1.1加载扩展包


```r
library(ncdf4)
library(raster)
library(terra)
library(SPEI)
library(extrafont)
library(showtext)
library(tidyverse)
library(tidyterra)
library(ggspatial)
library(readxl)
```

### 1.2生成站点

- 模拟生成90个观测站点经纬度信息


```r
pts_df <- tibble::tribble(
  ~lon, ~lat,
  26.25, 50.75,
  155.75, 56.25,
  -24.25, 74.25,
  21.75, -30.25,
  89.75, 42.75,
  126.75, -27.75,
  135.25, -1.75,
  77.25, 67.25,
  144.25, -4.25,
  53.25, 61.25,
  26.75, 26.75,
  -61.25, -37.75,
  74.75, 56.75,
  145.75, 68.75,
  7.75, 4.75,
  136.25, 51.75,
  -2.25, 39.25,
  103.75, -5.25,
  2.25, 23.75,
  -120.75, 55.75,
  -71.75, -2.75,
  142.75, -13.75,
  122.75, 13.75,
  36.25, 0.25,
  -126.25, 63.25,
  108.25, 67.75,
  100.75, 74.75,
  77.25, 79.25,
  26.25, 69.25,
  -65.75, -36.25,
  118.75, -22.25,
  31.25, 20.75,
  38.25, 35.25,
  41.75, 31.75,
  56.25, 80.25,
  16.25, 69.25,
  81.75, 68.75,
  14.25, 36.25,
  22.25, 8.75,
  46.25, 42.75,
  4.75, 16.75,
  -70.25, 53.25,
  -112.25, 37.25,
  -83.75, 41.25,
  -115.75, 34.75,
  49.75, 11.25,
  119.25, 67.75,
  -67.75, 63.25,
  -93.25, 62.25,
  73.25, 65.75,
  -25.25, 74.75,
  -66.25, -21.75,
  -108.25, 75.75,
  -68.25, 67.25,
  34.75, 45.25,
  28.75, -16.75,
  95.75, 44.25,
  -59.75, -16.75,
  94.75, 51.75,
  19.75, 46.25,
  9.25, 56.25,
  -63.25, -15.75,
  49.25, 47.25,
  -106.25, 70.75,
  147.25, -5.75,
  -56.75, -14.75,
  -89.25, 49.75,
  -161.75, 68.25,
  128.25, 48.25,
  55.75, 74.25,
  132.25, -3.25,
  -115.25, 67.25,
  36.75, 12.75,
  17.25, -6.75,
  33.75, 47.25,
  -6.75, 53.75,
  118.25, 37.25,
  -100.75, 50.25,
  -84.75, 45.75,
  -110.25, 38.25,
  179.25, 65.75,
  93.25, 67.25,
  145.25, -7.25,
  161.75, 58.75,
  -67.75, 66.25,
  -81.25, 34.25,
  -37.75, 82.25,
  -72.75, 53.75,
  37.75, -1.25,
  97.25, 31.75
)
head(pts_df)
```

```
#> # A tibble: 6 × 2
#>     lon   lat
#>   <dbl> <dbl>
#> 1  26.2  50.8
#> 2 156.   56.2
#> 3 -24.2  74.2
#> 4  21.8 -30.2
#> 5  89.8  42.8
#> 6 127.  -27.8
```


### 1.3提取数据

- 提取温度数据得到**tmp_df**




```r
tmp_terra <- rast("./inputData/cru_ts4.07.1901.2022.tmp.dat.nc")
```


```r
tmp_terra
```

```
#> class       : SpatRaster 
#> dimensions  : 360, 720, 1464  (nrow, ncol, nlyr)
#> resolution  : 0.5, 0.5  (x, y)
#> extent      : -180, 180, -90, 90  (xmin, xmax, ymin, ymax)
#> coord. ref. : lon/lat WGS 84 
#> source      : cru_ts4.07.1901.2022.tmp.dat.nc:tmp 
#> varname     : tmp (near-surface temperature) 
#> names       :           tmp_1,           tmp_2,           tmp_3,           tmp_4,           tmp_5,           tmp_6, ... 
#> unit        : degrees Celsius, degrees Celsius, degrees Celsius, degrees Celsius, degrees Celsius, degrees Celsius, ... 
#> time (days) : 1901-01-16 to 2022-12-16
```


```r
tmp_df <- terra::extract(x = tmp_terra, y = pts_df, df = T) %>%
  dplyr::select(-ID) %>%
  t() %>%
  as_tibble() %>%
  setNames(paste0("station", 1:90)) %>%
  mutate(
    date = time(tmp_terra),
    year = lubridate::year(date),
    month = lubridate::month(date)
  ) %>%
  dplyr::select(date, year, month, everything())
kableExtra::kable(head(tmp_df)[, 1:6])
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> date </th>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> month </th>
   <th style="text-align:right;"> station1 </th>
   <th style="text-align:right;"> station2 </th>
   <th style="text-align:right;"> station3 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1901-01-16 </td>
   <td style="text-align:right;"> 1901 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> -6.4 </td>
   <td style="text-align:right;"> -14.6 </td>
   <td style="text-align:right;"> -26.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1901-02-15 </td>
   <td style="text-align:right;"> 1901 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> -5.8 </td>
   <td style="text-align:right;"> -12.6 </td>
   <td style="text-align:right;"> -27.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1901-03-16 </td>
   <td style="text-align:right;"> 1901 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 1.2 </td>
   <td style="text-align:right;"> -8.1 </td>
   <td style="text-align:right;"> -26.9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1901-04-16 </td>
   <td style="text-align:right;"> 1901 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 7.9 </td>
   <td style="text-align:right;"> -2.4 </td>
   <td style="text-align:right;"> -21.9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1901-05-16 </td>
   <td style="text-align:right;"> 1901 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 14.8 </td>
   <td style="text-align:right;"> 2.8 </td>
   <td style="text-align:right;"> -10.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1901-06-16 </td>
   <td style="text-align:right;"> 1901 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 19.9 </td>
   <td style="text-align:right;"> 6.6 </td>
   <td style="text-align:right;"> -3.4 </td>
  </tr>
</tbody>
</table>

- 提取温度数据得到**pre_df**




```r
pre_terra <- rast("./inputData/cru_ts4.07.1901.2022.pre.dat.nc")
```


```r
pre_terra
```

```
#> class       : SpatRaster 
#> dimensions  : 360, 720, 1464  (nrow, ncol, nlyr)
#> resolution  : 0.5, 0.5  (x, y)
#> extent      : -180, 180, -90, 90  (xmin, xmax, ymin, ymax)
#> coord. ref. : lon/lat WGS 84 
#> source      : cru_ts4.07.1901.2022.pre.dat.nc:pre 
#> varname     : pre (precipitation) 
#> names       :    pre_1,    pre_2,    pre_3,    pre_4,    pre_5,    pre_6, ... 
#> unit        : mm/month, mm/month, mm/month, mm/month, mm/month, mm/month, ... 
#> time (days) : 1901-01-16 to 2022-12-16
```


```r
pre_df <- terra::extract(x = pre_terra, y = pts_df, df = T) %>%
  dplyr::select(-ID) %>%
  t() %>%
  as_tibble() %>%
  setNames(paste0("station", 1:90)) %>%
  mutate(
    date = time(pre_terra),
    year = lubridate::year(date),
    month = lubridate::month(date)
  ) %>%
  dplyr::select(date, year, month, everything())
kableExtra::kable(head(pre_df)[, 1:6])
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> date </th>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> month </th>
   <th style="text-align:right;"> station1 </th>
   <th style="text-align:right;"> station2 </th>
   <th style="text-align:right;"> station3 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1901-01-16 </td>
   <td style="text-align:right;"> 1901 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 25.2 </td>
   <td style="text-align:right;"> 35.1 </td>
   <td style="text-align:right;"> 39.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1901-02-15 </td>
   <td style="text-align:right;"> 1901 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 18.0 </td>
   <td style="text-align:right;"> 26.4 </td>
   <td style="text-align:right;"> 30.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1901-03-16 </td>
   <td style="text-align:right;"> 1901 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 29.6 </td>
   <td style="text-align:right;"> 24.3 </td>
   <td style="text-align:right;"> 29.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1901-04-16 </td>
   <td style="text-align:right;"> 1901 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 45.1 </td>
   <td style="text-align:right;"> 33.3 </td>
   <td style="text-align:right;"> 22.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1901-05-16 </td>
   <td style="text-align:right;"> 1901 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 25.4 </td>
   <td style="text-align:right;"> 37.3 </td>
   <td style="text-align:right;"> 14.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1901-06-16 </td>
   <td style="text-align:right;"> 1901 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 109.4 </td>
   <td style="text-align:right;"> 42.8 </td>
   <td style="text-align:right;"> 17.6 </td>
  </tr>
</tbody>
</table>

- 观测站点保留纬度数据


```r
lat_df <- pts_df %>%
  dplyr::select(-lon, lat) %>%
  t() %>%
  as.data.frame() %>%
  setNames(paste0("station", 1:90))
kableExtra::kable(head(lat_df[, 1:6]))
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> station1 </th>
   <th style="text-align:right;"> station2 </th>
   <th style="text-align:right;"> station3 </th>
   <th style="text-align:right;"> station4 </th>
   <th style="text-align:right;"> station5 </th>
   <th style="text-align:right;"> station6 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> lat </td>
   <td style="text-align:right;"> 50.75 </td>
   <td style="text-align:right;"> 56.25 </td>
   <td style="text-align:right;"> 74.25 </td>
   <td style="text-align:right;"> -30.25 </td>
   <td style="text-align:right;"> 42.75 </td>
   <td style="text-align:right;"> -27.75 </td>
  </tr>
</tbody>
</table>


### 1.4 读取字体


```r
showtext_auto(enable = TRUE)
font_add("Times", "./font/Times New Roman.ttf")
font_add("KaiTi", "./font/KaiTi.ttf")
```


## 2.计算SPEI

### 2.1 计算pet

- 采用thornthwaite方法计算pet


```r
th_apply <- lapply(X = 1:90, FUN = function(x) {
  # 加3是因为要跳过dateyearmonth等时间变量
  thornthwaite(tmp_df[, x + 3], lat_df[, x]) %>%
    as.data.frame.array() %>%
    as_tibble() %>%
    setNames(colnames(lat_df)[x])
})
```

```
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
#> [1] "Checking for missing values (`NA`): all the data must be complete. Input type is array. Assuming the data are monthly time series starting in January, all regular (non-leap) years."
```

```r
head(th_apply)
```

```
#> [[1]]
#> # A tibble: 1,464 × 1
#>    station1
#>       <dbl>
#>  1     0   
#>  2     0   
#>  3     4.99
#>  4    42.1 
#>  5    95.6 
#>  6   135.  
#>  7   135.  
#>  8   118.  
#>  9    67.7 
#> 10    38.6 
#> # ℹ 1,454 more rows
#> 
#> [[2]]
#> # A tibble: 1,464 × 1
#>    station2
#>       <dbl>
#>  1      0  
#>  2      0  
#>  3      0  
#>  4      0  
#>  5     40.3
#>  6     76.5
#>  7    107. 
#>  8    109. 
#>  9     66.2
#> 10     27.2
#> # ℹ 1,454 more rows
#> 
#> [[3]]
#> # A tibble: 1,464 × 1
#>    station3
#>       <dbl>
#>  1        0
#>  2        0
#>  3        0
#>  4        0
#>  5        0
#>  6        0
#>  7        0
#>  8        0
#>  9        0
#> 10        0
#> # ℹ 1,454 more rows
#> 
#> [[4]]
#> # A tibble: 1,464 × 1
#>    station4
#>       <dbl>
#>  1    139. 
#>  2    122. 
#>  3     92.0
#>  4     61.6
#>  5     28.7
#>  6     17.3
#>  7     14.8
#>  8     27.5
#>  9     40.5
#> 10     69.6
#> # ℹ 1,454 more rows
#> 
#> [[5]]
#> # A tibble: 1,464 × 1
#>    station5
#>       <dbl>
#>  1      0  
#>  2      0  
#>  3     18.7
#>  4     73.9
#>  5    152. 
#>  6    210. 
#>  7    238. 
#>  8    199. 
#>  9    108. 
#> 10     36.7
#> # ℹ 1,454 more rows
#> 
#> [[6]]
#> # A tibble: 1,464 × 1
#>    station6
#>       <dbl>
#>  1    181. 
#>  2    126. 
#>  3    109. 
#>  4     72.3
#>  5     39.5
#>  6     20.3
#>  7     16.2
#>  8     27.8
#>  9     52.1
#> 10     87.0
#> # ℹ 1,454 more rows
```


```r
pet_res <- rlist::list.cbind(th_apply)
head(pet_res)
```

```
#>     station1 station2 station3  station4  station5  station6 station7 station8
#> 1   0.000000  0.00000        0 139.15898   0.00000 180.50336 131.8562  0.00000
#> 2   0.000000  0.00000        0 122.25722   0.00000 126.03912 120.4018  0.00000
#> 3   4.986513  0.00000        0  91.96458  18.74049 109.35037 130.9964  0.00000
#> 4  42.073691  0.00000        0  61.61323  73.94622  72.27946 129.7747  0.00000
#> 5  95.576543 40.31958        0  28.65282 152.21669  39.51219 135.4881  0.00000
#> 6 134.908698 76.48210        0  17.30542 209.86162  20.32969 123.8468 85.13545
#>   station9 station10 station11 station12 station13 station14 station15
#> 1 160.2289   0.00000  13.12795 116.54565   0.00000    0.0000  121.7574
#> 2 141.6360   0.00000  26.60763  93.69007   0.00000    0.0000  130.3665
#> 3 150.9764   0.00000  47.31870  82.97214   0.00000    0.0000  134.5610
#> 4 146.7499  28.11435  93.07909  43.66888  18.42989    0.0000  138.9555
#> 5 152.5760  74.29213 132.62258  29.42152  78.65873    0.0000  121.3860
#> 6 144.8696 131.94629 184.14781  24.22174 114.76376  143.3688  111.5731
#>   station16  station17 station18 station19 station20 station21 station22
#> 1   0.00000   8.694887 105.09841  16.14815   0.00000  141.4231 169.91702
#> 2   0.00000   5.762519  89.13277  33.09830   0.00000  128.9268 144.35619
#> 3   0.00000  22.266751 113.09813  70.15293   0.00000  143.9056 149.38564
#> 4  20.33424  44.883919 108.07566 141.10185  12.99658  132.7147 123.94957
#> 5  62.01409  69.955940 117.91176 264.59787  71.05330  128.9484 106.87706
#> 6  99.08003 120.161841  93.06785 440.46426  88.78194  115.8518  79.36531
#>   station23 station24 station25 station26 station27 station28 station29
#> 1 125.45168  68.58997   0.00000    0.0000   0.00000         0   0.00000
#> 2  96.05627  63.21886   0.00000    0.0000   0.00000         0   0.00000
#> 3 125.09548  74.22221   0.00000    0.0000   0.00000         0   0.00000
#> 4 158.84645  69.82765   0.00000    0.0000   0.00000         0   0.00000
#> 5 185.12563  68.04559  32.86398    0.0000   0.00000         0  30.78768
#> 6 174.51652  59.41187 110.78207  125.5748  69.40855         0 146.87728
#>   station30 station31 station32  station33  station34 station35 station36
#> 1 136.47361 298.68265  23.65977   3.535704   4.173274         0   0.00000
#> 2 107.55703 187.48568  41.34192  14.383396  15.334083         0   0.00000
#> 3  90.02750 174.19896  83.21259  39.417921  43.449436         0   0.00000
#> 4  46.91503 122.82600 160.77131  61.920899  90.086304         0  18.78382
#> 5  29.27893  57.32096 281.66148  95.178350 154.201947         0  61.69600
#> 6  20.89657  22.95806 321.99882 156.447179 233.678852         0 136.02964
#>   station37 station38 station39  station40 station41 station42  station43
#> 1     0.000  18.82683  91.96631   0.000000  32.37853   0.00000  0.0000000
#> 2     0.000  18.18094 110.85727   0.000000  69.52249   0.00000  0.2418913
#> 3     0.000  38.90870 162.96014   8.039898 160.60281   0.00000  4.1214145
#> 4     0.000  55.35558 166.98567  41.662746 329.16660   0.00000 29.5475909
#> 5     0.000  66.99048 157.22959  68.136571 484.11766  33.36551 76.9566655
#> 6    73.056 117.33893 121.84734 107.449474 483.49230  95.68644 92.2225803
#>    station44 station45 station46 station47 station48 station49 station50
#> 1   0.000000   7.09049  58.46196    0.0000   0.00000   0.00000   0.00000
#> 2   0.000000  17.82306  63.90057    0.0000   0.00000   0.00000   0.00000
#> 3   7.532748  40.07326  90.84700    0.0000   0.00000   0.00000   0.00000
#> 4  35.294571  52.49131 114.09184    0.0000   0.00000   0.00000   0.00000
#> 5  78.609511 106.64570 143.08555    0.0000   0.00000   0.00000   0.00000
#> 6 130.741780 178.13874 143.18224  148.8932  60.12745  67.52699  85.96663
#>   station51 station52 station53 station54  station55 station56 station57
#> 1         0  67.29750         0         0   0.000000 152.40782   0.00000
#> 2         0  61.11144         0         0   4.426213 126.27102   0.00000
#> 3         0  63.59164         0         0  20.640576 141.54477   0.00000
#> 4         0  44.06353         0         0  46.858622 104.30566  31.45074
#> 5         0  36.92343         0         0  88.120157  72.52987  84.31258
#> 6         0  29.00380         0         0 145.137683  41.47793 117.68336
#>   station58 station59 station60  station61 station62  station63 station64
#> 1 167.78221   0.00000   0.00000   0.000000 151.28242   0.000000   0.00000
#> 2 167.57148   0.00000   0.00000   0.000000 139.91738   0.000000   0.00000
#> 3 170.33377   0.00000  21.63167   4.682529 142.69029   6.429204   0.00000
#> 4 121.34430   0.00000  50.62230  38.364774 115.43781  57.964251   0.00000
#> 5 122.69185  70.14126  92.53606  82.610266  99.69661 106.498053   0.00000
#> 6  85.03477 117.70900 125.72525 100.989580  74.56780 164.785017  64.80284
#>   station65 station66  station67 station68 station69 station70 station71
#> 1  147.9257  159.7438   0.000000   0.00000   0.00000         0 106.58623
#> 2  132.3446  156.5171   0.000000   0.00000   0.00000         0  94.59316
#> 3  141.0112  165.9022   0.000000   0.00000   0.00000         0 102.76444
#> 4  129.2895  144.9411   9.327027   0.00000  23.87188         0 101.11423
#> 5  125.1048  145.2301  69.484653   0.00000  74.19442         0 102.56106
#> 6  112.3079  107.9084 103.728156  93.98158 104.48198         0  96.52043
#>   station72 station73 station74 station75 station76 station77 station78
#> 1     0.000  90.96043 103.60980   0.00000  14.41717   0.00000   0.00000
#> 2     0.000 127.91289  98.28030   0.00000  10.83048   0.00000   0.00000
#> 3     0.000 160.40819 109.88269  13.00858  20.93112  12.52559   0.00000
#> 4     0.000 171.87081  86.05614  46.39491  43.86444  51.12596  25.49367
#> 5     0.000 184.13881  92.23963  95.68135  74.43962  95.13185  95.46554
#> 6    85.943 127.94554  82.17887 152.11586  89.44932 143.11737  98.25247
#>   station79 station80 station81 station82 station83 station84 station85
#> 1   0.00000   0.00000   0.00000   0.00000  146.7653   0.00000   0.00000
#> 2   0.00000   1.07461   0.00000   0.00000  130.9854   0.00000   0.00000
#> 3   0.00000  10.64860   0.00000   0.00000  140.9671   0.00000   0.00000
#> 4  33.23971  39.50542   0.00000   0.00000  130.4814   0.00000   0.00000
#> 5  68.41412  95.02038   0.00000   0.00000  131.0949   0.00000   0.00000
#> 6 111.07287 111.61462  97.51131  81.92454  112.7156  85.83379  57.40771
#>    station86 station87 station88 station89 station90
#> 1   9.088423         0   0.00000  87.40214   0.00000
#> 2   7.008977         0   0.00000  84.06052   0.00000
#> 3  29.091556         0   0.00000 100.94703   0.00000
#> 4  38.663157         0   0.00000  90.52249  13.97543
#> 5 110.788637         0  38.63043  82.77558  53.15368
#> 6 144.971676         0  95.19459  67.24182  74.26843
```

### 2.2 计算水平衡


```r
waterbalance_res <- as.matrix(as.matrix(dplyr::select(pre_df, -date, -year, -month) - pet_res))
head(waterbalance_res)
```

```
#>        station1   station2 station3   station4   station5    station6  station7
#> [1,]  25.200001  35.100002     39.7 -136.05898    1.00000 -164.003364 124.14380
#> [2,]  18.000000  26.400000     30.1  -70.35722    0.30000 -100.439117  81.49818
#> [3,]  24.613487  24.300001     29.0  -48.26458  -17.54049  -85.050367 135.00363
#> [4,]   3.026312  33.299999     22.0  -39.81323  -72.94622  -55.879463 -71.67470
#> [5,] -70.176544  -3.019577     14.4  -27.35282 -150.61669  -24.612191 162.51191
#> [6,] -25.508696 -33.682101     17.6  -16.10542 -205.36162   -7.229693 225.35318
#>       station8  station9  station10  station11  station12 station13   station14
#> [1,]  26.80000 113.07112  28.700001  -12.32795 -51.645652  24.50000   12.900001
#> [2,]  20.30000 142.66399  33.200001  -26.00763 -65.190066   8.60000    9.900001
#> [3,]  23.90000 143.72361  32.600002  -46.51870  -8.372145  16.50000    6.800000
#> [4,]  23.60000 144.85015  -8.414348  -91.77909 -12.068879  -1.22989    8.200000
#> [5,]  30.90000  52.22404 -34.792127 -132.12258   5.278479 -61.05873   15.800000
#> [6,] -42.03545 -12.16957 -77.446288 -183.84781  17.178265 -57.26376 -113.968769
#>      station15 station16  station17 station18  station19 station20 station21
#> [1,] -88.65735   7.90000  37.405115  105.2016  -14.84815  36.10000  137.4769
#> [2,] -59.66646  10.50000  66.637483  148.7672  -32.39830  19.10000  109.2732
#> [3,]  43.33899  11.30000  43.833247  173.6019  -69.55293  30.40000  179.4944
#> [4,] 113.94452  11.16576   0.816082  130.5243 -140.30185  15.90342  200.2853
#> [5,] 168.91403  -8.11409  -4.055938  110.7882 -263.39787 -23.45330  166.5516
#> [6,] 305.82694 -26.08003 -82.961841  145.8322 -439.46426  -9.08194  125.5482
#>      station22 station23 station24  station25 station26 station27 station28
#> [1,] 120.38300 -88.45168 -55.28997  24.500000  13.10000  10.90000        14
#> [2,] 427.84382 144.94373  23.18114  25.300001  11.60000  11.10000        12
#> [3,] 150.71437  64.40452 -10.62221  22.600000  13.60000  12.40000        11
#> [4,] -33.44957 -87.14644  85.47236  23.000000  16.30000  12.10000         7
#> [5,] -73.87706 -89.42562 -10.44559  -1.163977  24.70000  13.40000        10
#> [6,] -71.36531 -55.31651 -30.81187 -60.082071 -84.47482 -43.50855        11
#>       station29 station30   station31  station32   station33   station34
#> [1,]   24.10000 -87.97361 -277.282654  -23.45977   32.864297    8.826726
#> [2,]   23.60000 -87.05703  -99.685676  -41.24192   -4.583396   -5.534083
#> [3,]   17.60000 -19.42750  -81.898959  -83.01259  -25.517920  -26.249435
#> [4,]   18.60000 -21.01503 -121.925996 -160.57131  -49.020899  -72.186304
#> [5,]   -2.98768 -14.77893  -53.120962 -281.26148  -66.378349 -147.701947
#> [6,] -110.67727 -11.59657    5.441936 -321.79882 -154.347179 -233.678852
#>      station35  station36 station37  station38  station39  station40  station41
#> [1,]      27.1 166.199997    30.800   79.07318  -90.96631  35.700001  -32.37853
#> [2,]      26.6  83.400002    24.600   76.31906 -107.55727  40.299999  -69.52249
#> [3,]      22.8 100.500000    28.500  -25.40870 -136.56014  39.360104 -160.40281
#> [4,]      15.9  20.216178    27.500  -44.55558 -109.68567  12.037255 -327.56660
#> [5,]      18.0   1.004006    30.000  -48.19048  -43.12959 158.563426 -478.01766
#> [6,]      16.9 -80.029641   -31.356 -115.23893   27.55267   4.650524 -459.49230
#>      station42  station43 station44  station45  station46 station47 station48
#> [1,] 44.100002  24.800001  42.10000    5.60951  -52.16196    9.5000  20.00000
#> [2,] 36.299999  76.558112  31.10000   16.87694  -55.20057    8.5000  18.40000
#> [3,] 49.700001   8.978586  56.66726  -37.07326  -74.84700   11.9000  17.20000
#> [4,] 47.299999 -13.447591  20.10543  -51.69131  -84.69184   14.2000  21.30000
#> [5,] 27.134488 -66.056665  15.89049  -99.74570 -116.08555   22.0000  24.10000
#> [6,] -5.286437 -88.322580 -35.04178 -177.73874 -133.18224 -111.1932 -25.52745
#>      station49 station50 station51  station52 station53 station54   station55
#> [1,]  10.50000  22.00000      45.6 -15.297500       2.4      12.8  35.1000023
#> [2,]   7.10000  20.50000      36.4  -8.911436       1.5      12.3  57.9737890
#> [3,]  11.40000  16.00000      36.7 -39.991636       2.1      12.1   0.8594244
#> [4,]  15.80000  16.30000      28.8 -41.863526       2.3      20.7 -21.7586219
#> [5,]  19.10000  27.70000      19.7 -36.423427       3.3      28.1 -52.7201559
#> [6,] -39.42699 -46.26662      22.2 -27.803802       4.8      26.7 -80.8376802
#>       station56  station57 station58  station59 station60 station61  station62
#> [1,]  27.392184    0.80000  44.81779  23.300001  31.00000  36.00000  57.917577
#> [2,]  83.828985    0.80000  19.02853  19.200001  23.50000  19.90000  42.582625
#> [3,]   8.755237    1.70000 -24.33377  27.100000  26.96833  56.11747   9.109717
#> [4,] -77.905664  -27.55074 -34.04429  54.100002 -15.22230  27.53523 -50.737805
#> [5,] -70.429873  -78.91258 -67.89185  -4.441255 -55.43605 -32.31027 -32.696610
#> [6,] -41.277934 -103.88336 -49.53477 -35.708998 -55.42525 -21.08958 -25.967794
#>       station63 station64 station65  station66 station67 station68  station69
#> [1,]   23.50000   3.60000 244.87436  427.35627 34.200001  11.10000   4.300000
#> [2,]    8.60000   3.50000 256.85538  285.18292 28.500000  10.30000   3.100000
#> [3,]   12.67080   3.90000 241.18880  -24.30222 44.200001  10.70000   4.600000
#> [4,]  -37.56425   5.10000 192.41049  -70.64110 29.372974   9.10000   3.428116
#> [5,]  -75.29805   7.10000 111.89521 -144.03014 -9.084652   8.10000 -34.594415
#> [6,] -162.68502 -56.10285  89.69206  -83.00844  0.871842 -73.28158 -13.681972
#>      station70 station71 station72  station73 station74   station75 station76
#> [1,]      30.7  165.4138    13.500  -90.46043  62.79021   20.900000  67.08283
#> [2,]      27.1  150.7068    11.100 -127.31289  54.91970   45.299999  24.86952
#> [3,]      25.6  169.2356    14.200 -158.00819  75.21732    9.391422  42.46888
#> [4,]      20.7  100.7858    12.900 -160.77081 142.34387  -12.794913  20.53556
#> [5,]      22.5  221.4389    14.800 -134.03881 -33.73963  -60.581350 -28.23962
#> [6,]      65.9  251.2796   -66.343  100.55446 -74.47887 -101.815862 -26.24932
#>        station77 station78  station79   station80 station81 station82 station83
#> [1,]   14.500000  25.40000  49.000000    8.900001   3.70000  20.30000  168.4347
#> [2,]    2.300000   8.60000  23.400000   22.825389   4.80000  11.50000  256.3146
#> [3,]   -9.625588  17.80000  68.000000   -2.948600   0.60000  23.70000  216.4329
#> [4,]  -28.125955 -10.69367 -10.639705  -30.305417   6.60000  34.90000  148.4186
#> [5,]  -54.731850 -86.16554  -3.714114  -79.220375   5.00000  31.50000  430.6051
#> [6,] -104.017366  81.24753 -54.272871 -109.114619 -80.71131 -16.02454  240.6844
#>      station84 station85  station86 station87 station88  station89 station90
#> [1,]  30.70000   8.10000  74.811578       0.1  38.20000 -73.002135  3.400000
#> [2,]  30.80000   8.20000  62.391025       0.1  30.70000   9.439483  5.900000
#> [3,]  22.80000   6.20000  90.708447       0.1  38.70000  15.152967 10.300000
#> [4,]  28.60000  17.00000 119.436849       0.1  35.10000 171.077521  6.524573
#> [5,]  30.50000  24.20000  48.811369       0.1  10.86957 -52.975579 -3.353685
#> [6,] -42.33379 -32.50771  -5.971676       0.1 -16.59460 -64.441825 33.031573
```

### 2.3 计算SPEI

- 数据格式转变


```r
spei_apply <- lapply(X = 1:90, FUN = function(x) {
  spei(waterbalance_res[, x], 1) %>%
    .$fitted %>%
    as_tibble() %>%
    setNames(colnames(pet_res)[x])
})
```

```
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
#> [1] "Calculating the Standardized Precipitation Evapotranspiration Index (SPEI) at a time scale of 1. Using kernel type 'rectangular', with 0 shift. Fitting the data to a log-Logistic distribution. Using the ub-pwm parameter fitting method. Checking for missing values (`NA`): all the data must be complete. Using the whole time series as reference period. Input type is vector. No time information provided, assuming a monthly time series."
```

- 合并数据


```r
spei_res <- rlist::list.cbind(spei_apply) %>%
  mutate(
    date = pre_df$date,
    year = pre_df$year,
    month = pre_df$month
  ) %>%
  dplyr::select(date, year, month, everything())
head(spei_res)
```

```
#>         date year month   station1   station2   station3    station4   station5
#> 1 1901-01-16 1901     1 -0.4672073  0.0908376 0.04478734 -0.02607965 0.21425280
#> 2 1901-02-15 1901     2 -0.9651852  0.1915262 0.01092944  1.04819891 0.14738866
#> 3 1901-03-16 1901     3  0.4161609 -0.1914477 0.13738675  0.77919708 0.02243296
#> 4 1901-04-16 1901     4  0.3016853  0.4760756 0.13191116  0.31279602 0.22914620
#> 5 1901-05-16 1901     5 -1.4167558  0.2306580 0.16912337 -0.29468079 0.18960375
#> 6 1901-06-16 1901     6  0.5613253  0.3705567 0.29870223 -0.52676088 0.67737675
#>      station6    station7  station8   station9  station10   station11
#> 1 -0.30886440  0.04093571 0.3143693 0.06931767 -1.0081669  0.76754586
#> 2  0.89867740 -0.34881716 0.2311398 0.03979274  0.6229760 -1.16561175
#> 3  0.90621736  0.09429253 0.2755486 0.06111752  0.2404456 -0.06759885
#> 4  0.09989985 -2.34346708 0.1197632 0.02221630 -1.3230092  0.08804800
#> 5 -0.04577701  0.18820701 0.1295636 0.02859630 -0.5371905  1.33466256
#> 6  0.42368356  0.79238944 0.9144409 0.01806593 -0.5398263  0.48903033
#>    station12   station13   station14 station15   station16    station17
#> 1  0.2051940  0.34789413 -0.07152202 0.2806075 -0.29034049  0.816547619
#> 2 -1.0854908 -1.12860316 -0.16191740 0.6451477  0.60553003  1.778125386
#> 3 -0.3538787 -0.10111427 -0.44062445 1.0946709 -0.30394615  1.131395268
#> 4 -0.8784544 -0.66382119  0.02094999 1.3427709 -1.28982776 -0.004847527
#> 5 -0.4493413 -0.87217111  0.94425171 0.7999461 -0.02222273  0.828411179
#> 6  0.3933996  0.05165974 -0.45753222 1.1767115  0.28277190 -0.164060307
#>     station18  station19   station20    station21  station22  station23
#> 1  0.07309742 0.64823660 -0.07089531 -0.002714485 -0.3421984 -2.2360183
#> 2  1.53235673 0.15254547 -0.95797283  0.012328827  1.7166947  1.1900297
#> 3  0.50134311 0.58625074 -0.30048954 -0.055658523  0.2028413  1.0497467
#> 4 -0.12492214 0.37501581  0.85995938  0.001929072  0.1409728 -0.4961548
#> 5  0.06651204 0.78523900  0.44475269  0.124111397  1.1515812 -0.7084875
#> 6  0.77274082 0.05199936  0.73738445  0.089625015  0.3734457 -1.0034503
#>     station24   station25   station26  station27   station28   station29
#> 1 -0.71468206 -0.42730346 -0.09914553 0.21265051  0.35385611 -0.43177458
#> 2  1.44683270  0.20670417 -0.21393138 0.38340841  0.42878213  0.02240124
#> 3  0.09039892 -0.06288077  0.08871108 0.43942134  0.37757827 -0.84728556
#> 4  0.69214160  0.03232232  0.05040887 0.37911164  0.20768157 -0.87163290
#> 5 -1.43575344  0.96850274  0.13269604 0.07808615  0.16170846  0.47642521
#> 6 -1.68412737  0.42509579  0.44685931 0.45749258 -0.08023431 -1.04188579
#>    station30  station31    station32    station33  station34  station35
#> 1 -0.1363995 -0.9396928 -0.007219904  0.006639873  0.8121684 0.16132364
#> 2 -1.0254283  0.8893710 -1.147177913 -1.760276830 -0.6523347 0.14876184
#> 3  0.4501608  1.0202929 -0.475373530 -1.767579588 -0.9747593 0.24125537
#> 4 -0.2884038 -0.6528501  0.107387963 -0.809849660 -0.1727455 0.16913865
#> 5 -0.2322859 -0.6742409  0.139391843  1.578664889  1.3481232 0.09742092
#> 6 -0.6292845  0.8001897  0.823927749  0.365423826  0.7025429 0.07655370
#>     station36 station37  station38  station39   station40  station41  station42
#> 1  1.22071299 0.4027784  0.8226941 0.33523776 -0.14682525 1.07440386  0.2112245
#> 2 -0.03364321 0.3216864  1.5452742 0.25123117  0.06119343 0.23039033  0.1355941
#> 3  0.52259504 0.4248944 -1.0896013 0.39700487 -1.02129919 0.89115071  0.1718694
#> 4 -1.16989015 0.2375611 -0.7870423 0.35892221 -1.24475631 0.65906212  0.1858730
#> 5  0.31191503 0.1023980  1.7766487 0.08758959  1.85298099 1.26100080 -0.5780747
#> 6 -0.86835900 1.1331270  0.2827841 0.24737263 -0.64483980 0.08976203 -0.1641872
#>    station43  station44   station45 station46    station47 station48 station49
#> 1 -0.4889913 -0.4220118 -0.07790117 0.1270583 -0.116688155 0.2591289 0.1983596
#> 2  1.5210594 -0.7063640  0.97512741 0.1072488 -0.032257743 0.2316185 0.1963884
#> 3 -0.2877440 -0.1908610 -0.97119342 0.1227650  0.157935340 0.2792776 0.2308691
#> 4  0.3006561 -0.8226314  0.10755700 0.1340335 -0.009885101 0.2891282 0.2638179
#> 5 -0.8202296  0.2546478  0.69479433 0.1572996  0.582467610 0.3068841 0.1881698
#> 6  0.2362425 -0.1950699  0.56270932 0.1881059 -0.130367839 0.5897667 0.2749241
#>    station50  station51  station52  station53 station54  station55  station56
#> 1 -0.2102601 0.04711299 -0.1755623 0.10921458 0.1802328 -0.4904215 -0.4571824
#> 2  0.5102729 0.01869545  0.1183460 0.06342992 0.1618547  1.1375328  0.8669741
#> 3 -0.6686862 0.14314562 -0.5849188 0.16756325 0.2926435 -1.1793254  0.3327120
#> 4 -0.8081201 0.13305430  0.6469766 0.04872630 0.2423610 -0.3387699  0.1789232
#> 5 -0.1347704 0.17179388 -1.7889757 0.16725397 0.2440932 -0.1903517 -0.5090443
#> 6  0.3648931 0.29526122 -2.0604301 0.73270423 0.8644825 -0.4146703  0.7512797
#>     station57  station58   station59  station60   station61  station62
#> 1  0.12383305  0.2418682  0.13219324  0.1260753 -0.93357104  0.1355343
#> 2  0.17960045 -0.2493628 -0.09770269 -0.1431055 -1.05323000 -0.1306031
#> 3  0.03814771 -0.6373795 -0.14201285  1.0061158  1.21406916 -0.1835682
#> 4  0.19455602  0.3124735 -0.01512161 -0.2691377  1.05000154  0.1767054
#> 5 -0.01583276 -1.0337411 -0.13754209 -0.6565240 -0.05436819 -0.3365274
#> 6  0.24480568 -0.5572266 -0.21528932 -0.1182341  1.08247450 -0.2500821
#>    station63   station64   station65  station66  station67   station68
#> 1  1.2434834  0.07362895  0.14933159  2.5032791 -0.1436420  0.19814846
#> 2 -0.5830385  0.17456914  0.14279930  1.9231651 -0.2644928 -0.02564823
#> 3  0.1430568 -0.01786910  0.04356031 -1.5901496  0.5453433  0.24224028
#> 4 -0.8246493  0.27883455 -0.14577029 -1.0788368 -0.4464570  0.28878610
#> 5  0.5547952  0.36679948  0.10558705 -2.6000744 -0.5609955  0.06192513
#> 6 -1.5897954  0.07897858  0.04249973 -0.4734717  0.6046234  0.29466309
#>     station69 station70   station71 station72  station73  station74  station75
#> 1  0.06988191 0.6351863  0.01529794 0.1872897 -0.4955097  0.1789222 -0.5870576
#> 2 -0.26121308 0.4958166 -0.24016193 0.1710099 -1.6810820  0.2469854  1.1941218
#> 3 -1.13402328 0.5513122  0.06778825 0.1376718 -0.8159334 -0.1304289 -0.4677223
#> 4 -0.43556361 0.4661948 -1.34207424 0.4608426 -0.2312878  0.3805754  0.1361000
#> 5 -0.94708252 0.5793238  0.06904939 0.2303185 -0.6429916  0.4982199 -0.3089760
#> 6 -0.19965162 2.3669170  0.38882664 0.5182722  1.5734737  0.1872230 -1.1130131
#>    station76  station77  station78   station79   station80  station81
#> 1 -0.1289594  1.5442545  0.6261191  0.03682994 -0.79493255 -1.4453607
#> 2 -0.7837780 -0.7753127 -1.0873410 -0.99261391  0.93172936 -1.2838228
#> 3  0.3463058 -0.5384536 -0.3112890  1.02379417 -0.09470260 -2.0530559
#> 4  0.2585026  0.1829205 -0.8254996 -1.97307543 -0.04730398 -1.1086576
#> 5 -0.7325185  1.0133706 -2.2007048 -0.25331949 -0.84658479 -1.5078036
#> 6  0.2454369 -0.6622713  2.3190431 -0.68557253  0.30552837 -0.6720504
#>    station82 station83   station84 station85  station86  station87  station88
#> 1 -0.5513865 0.9826799 -0.23809898 0.2510168 -0.2081445         NA  0.1140540
#> 2 -1.0879206 1.8897359  0.51474847 0.2402486 -0.4723930 -0.4618714  0.1565496
#> 3  0.2901299 1.1230804 -0.38634803 0.3598732  0.3883434  0.2527182  0.0947227
#> 4  0.9140017 0.3956472  0.10008340 0.3520574  1.7459066 -0.4377933  0.1461572
#> 5 -0.2434106 2.1240777  0.34825112 0.3092031  1.6586925 -0.4377933 -0.6669327
#> 6  0.8946969 0.6409032  0.04921178 0.8796703  0.8994327  0.2527182 -0.2580890
#>     station89   station90
#> 1 -0.83157531 -0.03692816
#> 2  1.76757835  0.03518933
#> 3  0.37090518 -0.08192482
#> 4  1.04152888 -0.03574503
#> 5 -0.97477561 -0.16048133
#> 6  0.09162051  0.08526255
```

## 3.绘图展示


```r
spei_res %>% 
  dplyr::select(date,station1:station6) %>% 
  pivot_longer(-date,names_to = "station",values_to = "spei") %>% 
  ggplot()+
  geom_line(aes(date,spei))+
  facet_wrap(~ station)+
  theme_light() +
  theme(
    plot.title = element_text(size = 14, hjust = 0.5, vjust = 0.5, face = "bold", family = "Times"),
    axis.text.x = element_text(family = "Times"),
    axis.text.y = element_text(family = "Times"),
    axis.title.x = element_text(family = "Times",size = 14),
    axis.title.y = element_text(family = "Times",size = 14),
    axis.ticks = element_blank(),
    legend.position = "bottom",
    legend.text = element_text(family = "Times"),
    legend.key.width = unit(2.5, "cm"),
    legend.title = element_text(family = "Times"),
    strip.text = element_text(face = "bold",family = "Times",size = 12)
  ) +
  labs(
    x = "date",
    title = "Standardized Precipitation Evapotranspiration Index Of Different Stations"
  )
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-18-1.png" width="672" style="display: block; margin: auto;" />

----
