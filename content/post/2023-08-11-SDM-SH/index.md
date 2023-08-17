---
title: "基于R语言caret包的上海市钉螺分布预测"
author: "学R不思则罔"
date: '2023-04-01'
output:
  html_document: default
  pdf_document: default
categories: ["R"]
tags: ["tidyverse", "caret","SDM"]
thumbnail: "rayshader.png"
description: "使用caret框架实现上海市钉螺物种分布预测，包含数据点位栅格等读取处理绘图、模型建立分析绘图、未来分布预测等环节"
toc: true
---
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />



## 1.准备工作

### 1.1加载扩展包


```r
# 数据操作
library(tidyverse)
library(readxl)
library(purrr)
library(raster)
library(terra)
library(rayshader)
library(sf)
library(mapchina)
library(dismo)
# rmarkdown
library(knitr)
library(kableExtra)
# 建模
library(yardstick)
library(pdp)
library(gbm)
library(xgboost)
library(caret)
library(creditmodel)
# 绘图
library(ggcor)
library(tmap)
library(cartomisc)
library(plotly)
library(gridExtra)
# 设定Java内存
# options(java.parameters = "-Xmx1000m")
```

### 1.2设定字体



```r
library(extrafont)
library(showtext)
showtext_auto(enable = TRUE)
font_add("RMN", "./font/Times New Roman.ttf")
font_add("KaiTi", "./font/KaiTi.ttf")
```


### 1.3导入数据

#### 1.3.1 生成上海地图数据


```r
sh_sf <- mapchina::china %>%
  dplyr::filter(Name_Province == "上海市") %>%
  group_by(Name_Province) %>%
  dplyr::summarise(geometry = st_union(geometry)) %>%
  ungroup()

sh_county_sf <- mapchina::china %>%
  dplyr::filter(Name_Province == "上海市")

p1 <- tm_shape(sh_county_sf) +
  tm_borders()
p2 <- tm_shape(sh_sf) +
  tm_borders()
# tmap::tmap_arrange(p1,p2)
```

#### 1.3.2 导入环境栅格数据


```r
ef_raster <- list.files(path = "./data", pattern = "asc$", full.names = T) %>%
  stack()
ef_terra <- list.files(path = "./data", pattern = "asc$", full.names = T) %>%
  rast()
```



```r
subset(ef_terra, c("ndvi20161", "ndvi20162", "ndvi20163", "ndvi20164")) %>%
  rasterVis::levelplot()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-5-1.png" width="672" style="display: block; margin: auto;" />



```r
# 定义函数并行绘图
map_tmap <- function(value, raster) {
  raster %>%
    subset(value) %>%
    tm_shape() +
    tm_raster() +
    tm_shape(sh_county_sf) +
    tm_borders() +
    tm_layout(
      legend.title.size = .7,
      legend.text.size = 0.5,
      legend.outside = F,
      legend.width = 0.5
    )
}

# 执行并行绘图
ef_tmap <- names(ef_raster) %>%
  as_tibble() %>%
  mutate(raster = list(ef_terra)) %>%
  group_by(value) %>%
  mutate(plot = map2(value, raster, map_tmap))

# 18副图排4列
do.call(tmap_arrange, c(ef_tmap$plot, ncol = 4))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-6-1.png" width="672" style="display: block; margin: auto;" />

其实这里就可以看出来上海市部分环境变量之间的差异非常不显著，毕竟面积大小限制在那里，自然环境多样性较低。这种影响体现在后续建模上有变量方差小，变化小，重要性低，变量`landcover`就是个例子


-   上海环境数据


```r
env_df <- ef_raster %>%
  as.data.frame(xy = T)
kableExtra::kable(head(na.omit(env_df)))
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> x </th>
   <th style="text-align:right;"> y </th>
   <th style="text-align:right;"> aat0 </th>
   <th style="text-align:right;"> aat10 </th>
   <th style="text-align:right;"> aridity </th>
   <th style="text-align:right;"> dem </th>
   <th style="text-align:right;"> dst_waterway </th>
   <th style="text-align:right;"> hfp </th>
   <th style="text-align:right;"> hii </th>
   <th style="text-align:right;"> im </th>
   <th style="text-align:right;"> landcover </th>
   <th style="text-align:right;"> landform </th>
   <th style="text-align:right;"> ndvi20161 </th>
   <th style="text-align:right;"> ndvi20162 </th>
   <th style="text-align:right;"> ndvi20163 </th>
   <th style="text-align:right;"> ndvi20164 </th>
   <th style="text-align:right;"> night_time_lights </th>
   <th style="text-align:right;"> pa </th>
   <th style="text-align:right;"> slope </th>
   <th style="text-align:right;"> tadem </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 80780 </td>
   <td style="text-align:right;"> 121.2542 </td>
   <td style="text-align:right;"> 31.835 </td>
   <td style="text-align:right;"> 54169.06 </td>
   <td style="text-align:right;"> 48595 </td>
   <td style="text-align:right;"> 882 </td>
   <td style="text-align:right;"> 3.818729 </td>
   <td style="text-align:right;"> 0.2429989 </td>
   <td style="text-align:right;"> 34 </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 3045.937 </td>
   <td style="text-align:right;"> 11.91932 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 0.7527465 </td>
   <td style="text-align:right;"> 0.8009197 </td>
   <td style="text-align:right;"> 0.7760156 </td>
   <td style="text-align:right;"> 0.4311277 </td>
   <td style="text-align:right;"> 0.6530336 </td>
   <td style="text-align:right;"> 10786.32 </td>
   <td style="text-align:right;"> 0.0065331 </td>
   <td style="text-align:right;"> 148 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 80781 </td>
   <td style="text-align:right;"> 121.2550 </td>
   <td style="text-align:right;"> 31.835 </td>
   <td style="text-align:right;"> 54170.17 </td>
   <td style="text-align:right;"> 48595 </td>
   <td style="text-align:right;"> 882 </td>
   <td style="text-align:right;"> 3.763675 </td>
   <td style="text-align:right;"> 0.2062404 </td>
   <td style="text-align:right;"> 34 </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 3046.431 </td>
   <td style="text-align:right;"> 12.18322 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 0.7547723 </td>
   <td style="text-align:right;"> 0.8054522 </td>
   <td style="text-align:right;"> 0.7794802 </td>
   <td style="text-align:right;"> 0.4284502 </td>
   <td style="text-align:right;"> 0.6530336 </td>
   <td style="text-align:right;"> 10786.67 </td>
   <td style="text-align:right;"> 0.0353408 </td>
   <td style="text-align:right;"> 148 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 80782 </td>
   <td style="text-align:right;"> 121.2558 </td>
   <td style="text-align:right;"> 31.835 </td>
   <td style="text-align:right;"> 54171.27 </td>
   <td style="text-align:right;"> 48595 </td>
   <td style="text-align:right;"> 882 </td>
   <td style="text-align:right;"> 3.708621 </td>
   <td style="text-align:right;"> 0.1885153 </td>
   <td style="text-align:right;"> 34 </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 3046.924 </td>
   <td style="text-align:right;"> 12.44711 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 0.7567980 </td>
   <td style="text-align:right;"> 0.8099846 </td>
   <td style="text-align:right;"> 0.7829449 </td>
   <td style="text-align:right;"> 0.4257726 </td>
   <td style="text-align:right;"> 0.6573089 </td>
   <td style="text-align:right;"> 10787.02 </td>
   <td style="text-align:right;"> 0.0386075 </td>
   <td style="text-align:right;"> 148 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 80783 </td>
   <td style="text-align:right;"> 121.2567 </td>
   <td style="text-align:right;"> 31.835 </td>
   <td style="text-align:right;"> 54172.00 </td>
   <td style="text-align:right;"> 48595 </td>
   <td style="text-align:right;"> 882 </td>
   <td style="text-align:right;"> 3.698650 </td>
   <td style="text-align:right;"> 0.1859790 </td>
   <td style="text-align:right;"> 34 </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 3047.417 </td>
   <td style="text-align:right;"> 12.71101 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 0.7588238 </td>
   <td style="text-align:right;"> 0.8145171 </td>
   <td style="text-align:right;"> 0.7864096 </td>
   <td style="text-align:right;"> 0.4230951 </td>
   <td style="text-align:right;"> 0.6760752 </td>
   <td style="text-align:right;"> 10787.37 </td>
   <td style="text-align:right;"> 0.1776575 </td>
   <td style="text-align:right;"> 148 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 80784 </td>
   <td style="text-align:right;"> 121.2575 </td>
   <td style="text-align:right;"> 31.835 </td>
   <td style="text-align:right;"> 54172.00 </td>
   <td style="text-align:right;"> 48595 </td>
   <td style="text-align:right;"> 882 </td>
   <td style="text-align:right;"> 3.697019 </td>
   <td style="text-align:right;"> 0.1859790 </td>
   <td style="text-align:right;"> 34 </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 3047.911 </td>
   <td style="text-align:right;"> 12.97491 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 0.7571884 </td>
   <td style="text-align:right;"> 0.8149572 </td>
   <td style="text-align:right;"> 0.7856975 </td>
   <td style="text-align:right;"> 0.4230389 </td>
   <td style="text-align:right;"> 0.6803572 </td>
   <td style="text-align:right;"> 10787.71 </td>
   <td style="text-align:right;"> 0.8430415 </td>
   <td style="text-align:right;"> 148 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 80785 </td>
   <td style="text-align:right;"> 121.2583 </td>
   <td style="text-align:right;"> 31.835 </td>
   <td style="text-align:right;"> 54172.00 </td>
   <td style="text-align:right;"> 48595 </td>
   <td style="text-align:right;"> 882 </td>
   <td style="text-align:right;"> 3.695387 </td>
   <td style="text-align:right;"> 0.1859790 </td>
   <td style="text-align:right;"> 34 </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 3048.404 </td>
   <td style="text-align:right;"> 13.23881 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 0.7543440 </td>
   <td style="text-align:right;"> 0.8140461 </td>
   <td style="text-align:right;"> 0.7836061 </td>
   <td style="text-align:right;"> 0.4238482 </td>
   <td style="text-align:right;"> 0.6803572 </td>
   <td style="text-align:right;"> 10788.06 </td>
   <td style="text-align:right;"> 0.9790576 </td>
   <td style="text-align:right;"> 148 </td>
  </tr>
</tbody>
</table>

#### 1.3.3 导入存在点数据


- 同时提取环境数据


```r
# 添加注释是因为改用terra包重写以加快速度
presence_df <- read_excel("./data/14—17上海某入侵物种调查.xlsx") %>%
  # sf::st_as_sf(coords = c("x", "y"), crs = 4326) %>%
  # raster::extract(x = ef_raster,y = .,df = T) %>%
  dplyr::select(x, y) %>%
  terra::extract(x = ef_terra, y = ., df = T) %>%
  bind_cols(read_excel("./data/14—17上海某入侵物种调查.xlsx")) %>%
  # dplyr::select(-ID) %>%
  mutate(class = 1)
```

-   随机生成不存在点数据


在上海市仅存在阳性点的区按照`1:10`比例使用随机抽样方法生成不存在点，并且同样提取环境数据

> [!Note]   
> <s>曾经尝试按照`1:3`比例使用随机抽样方法生成`270`个不存在点，效果好所以放弃</s>



```r
county_names <- read_excel("./data/14—17上海某入侵物种调查.xlsx") %>%
  dplyr::select(didian) %>%
  mutate(county = str_sub(didian, 5, 7)) %>%
  pull(county) %>%
  table() %>%
  as.data.frame() %>%
  setNames(c("county", "freq")) %>%
  as_tibble()

absence_pts <- sh_county_sf %>%
  dplyr::filter(Name_County %in% county_names$county) %>%
  group_by(Name_County) %>%
  summarise(geometry = st_union(geometry)) %>%
  ungroup() %>%
  group_by(Name_County) %>%
  nest() %>%
  left_join(county_names, by = c("Name_County" = "county")) %>%
  mutate(sample_pts = map2(.x = data, .y = freq, .f = function(x, y) {
    st_sample(x = x, size = 10 * y) %>%
      st_coordinates() %>%
      as.data.frame() %>%
      rename(x = X, y = Y)
  })) %>%
  dplyr::select(-data) %>%
  ungroup() %>%
  unnest(sample_pts) %>%
  dplyr::select(x, y)

absence_df <- absence_pts %>%
  terra::extract(x = ef_terra, y = ., df = T) %>%
  bind_cols(absence_pts) %>%
  mutate(class = 0)
```


-   合并数据


```r
data_obs <- absence_df %>%
  bind_rows(presence_df) %>%
  dplyr::select(-x, -y, -didian) %>%
  mutate(class = paste0("X", class)) %>%
  mutate(across(.cols = class, .fns = as.factor)) %>%
  na.omit() %>%
  dplyr::select(-ID)
kableExtra::kable(head(na.omit(data_obs)))
```

<table>
 <thead>
  <tr>
   <th style="text-align:right;"> aat0 </th>
   <th style="text-align:right;"> aat10 </th>
   <th style="text-align:right;"> aridity </th>
   <th style="text-align:right;"> dem </th>
   <th style="text-align:right;"> dst_waterway </th>
   <th style="text-align:right;"> hfp </th>
   <th style="text-align:right;"> hii </th>
   <th style="text-align:right;"> im </th>
   <th style="text-align:right;"> landcover </th>
   <th style="text-align:right;"> landform </th>
   <th style="text-align:right;"> ndvi20161 </th>
   <th style="text-align:right;"> ndvi20162 </th>
   <th style="text-align:right;"> ndvi20163 </th>
   <th style="text-align:right;"> ndvi20164 </th>
   <th style="text-align:right;"> night_time_lights </th>
   <th style="text-align:right;"> pa </th>
   <th style="text-align:right;"> slope </th>
   <th style="text-align:right;"> tadem </th>
   <th style="text-align:left;"> class </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 57029.00 </td>
   <td style="text-align:right;"> 50302.00 </td>
   <td style="text-align:right;"> 853.0165 </td>
   <td style="text-align:right;"> 5.012285 </td>
   <td style="text-align:right;"> 1.8269490 </td>
   <td style="text-align:right;"> 45.83826 </td>
   <td style="text-align:right;"> 30.08906 </td>
   <td style="text-align:right;"> 4275.474 </td>
   <td style="text-align:right;"> 17.36532 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 0.4211083 </td>
   <td style="text-align:right;"> 0.5740456 </td>
   <td style="text-align:right;"> 0.5895232 </td>
   <td style="text-align:right;"> 0.3188745 </td>
   <td style="text-align:right;"> 3.625817 </td>
   <td style="text-align:right;"> 12162.42 </td>
   <td style="text-align:right;"> 0.4997805 </td>
   <td style="text-align:right;"> 156.0000 </td>
   <td style="text-align:left;"> X0 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 57054.17 </td>
   <td style="text-align:right;"> 50327.17 </td>
   <td style="text-align:right;"> 855.3683 </td>
   <td style="text-align:right;"> 5.879165 </td>
   <td style="text-align:right;"> 0.8177115 </td>
   <td style="text-align:right;"> 54.24532 </td>
   <td style="text-align:right;"> 32.14172 </td>
   <td style="text-align:right;"> 4236.139 </td>
   <td style="text-align:right;"> 29.84930 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 0.4349839 </td>
   <td style="text-align:right;"> 0.5080341 </td>
   <td style="text-align:right;"> 0.4980480 </td>
   <td style="text-align:right;"> 0.3836413 </td>
   <td style="text-align:right;"> 7.303433 </td>
   <td style="text-align:right;"> 12127.06 </td>
   <td style="text-align:right;"> 0.7502741 </td>
   <td style="text-align:right;"> 156.0000 </td>
   <td style="text-align:left;"> X0 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 56783.00 </td>
   <td style="text-align:right;"> 50149.00 </td>
   <td style="text-align:right;"> 874.3167 </td>
   <td style="text-align:right;"> 5.090658 </td>
   <td style="text-align:right;"> 1.1830937 </td>
   <td style="text-align:right;"> 56.69983 </td>
   <td style="text-align:right;"> 33.00000 </td>
   <td style="text-align:right;"> 3861.566 </td>
   <td style="text-align:right;"> 19.21894 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 0.3723125 </td>
   <td style="text-align:right;"> 0.4473402 </td>
   <td style="text-align:right;"> 0.4044511 </td>
   <td style="text-align:right;"> 0.2729233 </td>
   <td style="text-align:right;"> 19.148771 </td>
   <td style="text-align:right;"> 11749.72 </td>
   <td style="text-align:right;"> 0.1497453 </td>
   <td style="text-align:right;"> 156.0000 </td>
   <td style="text-align:left;"> X0 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 57001.08 </td>
   <td style="text-align:right;"> 50278.38 </td>
   <td style="text-align:right;"> 845.1899 </td>
   <td style="text-align:right;"> 4.468236 </td>
   <td style="text-align:right;"> 1.8909993 </td>
   <td style="text-align:right;"> 44.94555 </td>
   <td style="text-align:right;"> 30.00000 </td>
   <td style="text-align:right;"> 4428.347 </td>
   <td style="text-align:right;"> 51.57597 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 0.4235461 </td>
   <td style="text-align:right;"> 0.5177930 </td>
   <td style="text-align:right;"> 0.5254812 </td>
   <td style="text-align:right;"> 0.2944784 </td>
   <td style="text-align:right;"> 34.791492 </td>
   <td style="text-align:right;"> 12302.16 </td>
   <td style="text-align:right;"> 0.0000000 </td>
   <td style="text-align:right;"> 156.0000 </td>
   <td style="text-align:left;"> X0 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 56893.17 </td>
   <td style="text-align:right;"> 50207.77 </td>
   <td style="text-align:right;"> 857.6893 </td>
   <td style="text-align:right;"> 4.874698 </td>
   <td style="text-align:right;"> 0.6943125 </td>
   <td style="text-align:right;"> 46.00000 </td>
   <td style="text-align:right;"> 29.56187 </td>
   <td style="text-align:right;"> 4121.641 </td>
   <td style="text-align:right;"> 11.11653 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 0.4765593 </td>
   <td style="text-align:right;"> 0.6416213 </td>
   <td style="text-align:right;"> 0.6920292 </td>
   <td style="text-align:right;"> 0.3891952 </td>
   <td style="text-align:right;"> 9.470854 </td>
   <td style="text-align:right;"> 11989.18 </td>
   <td style="text-align:right;"> 0.0000000 </td>
   <td style="text-align:right;"> 155.5527 </td>
   <td style="text-align:left;"> X0 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 56969.50 </td>
   <td style="text-align:right;"> 50149.21 </td>
   <td style="text-align:right;"> 888.0480 </td>
   <td style="text-align:right;"> 5.198218 </td>
   <td style="text-align:right;"> 0.4772339 </td>
   <td style="text-align:right;"> 45.77414 </td>
   <td style="text-align:right;"> 30.00000 </td>
   <td style="text-align:right;"> 3737.659 </td>
   <td style="text-align:right;"> 11.00000 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 0.4289203 </td>
   <td style="text-align:right;"> 0.5622838 </td>
   <td style="text-align:right;"> 0.5762438 </td>
   <td style="text-align:right;"> 0.3434257 </td>
   <td style="text-align:right;"> 2.651131 </td>
   <td style="text-align:right;"> 11587.63 </td>
   <td style="text-align:right;"> 0.4449245 </td>
   <td style="text-align:right;"> 156.0000 </td>
   <td style="text-align:left;"> X0 </td>
  </tr>
</tbody>
</table>



```r
ggplot(data = sh_county_sf) +
  geom_sf(fill = NA) +
  geom_sf(
    data = absence_df %>%
      bind_rows(presence_df) %>%
      mutate(class = ifelse(class == 0, "absence", "presence")) %>%
      st_as_sf(coords = c("x", "y"), crs = 4326),
    aes(color = class)
  ) +
  theme_light() +
  labs(color = "") +
  theme(legend.position = "bottom")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-11-1.png" width="672" style="display: block; margin: auto;" />


### 1.4 数据概览

#### 1.4.1 数据摘要


```r
skimr::skim(data_obs)
```


<table style='width: auto;'
      class='table table-condensed'>
<caption><span id="tab:unnamed-chunk-12"></span>Table 1: Data summary</caption>
<tbody>
  <tr>
   <td style="text-align:left;"> Name </td>
   <td style="text-align:left;"> data_obs </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Number of rows </td>
   <td style="text-align:left;"> 967 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Number of columns </td>
   <td style="text-align:left;"> 19 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> _______________________ </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Column type frequency: </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> factor </td>
   <td style="text-align:left;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> numeric </td>
   <td style="text-align:left;"> 18 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ________________________ </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Group variables </td>
   <td style="text-align:left;"> None </td>
  </tr>
</tbody>
</table>


**Variable type: factor**

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> skim_variable </th>
   <th style="text-align:right;"> n_missing </th>
   <th style="text-align:right;"> complete_rate </th>
   <th style="text-align:left;"> ordered </th>
   <th style="text-align:right;"> n_unique </th>
   <th style="text-align:left;"> top_counts </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> class </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> FALSE </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:left;"> X0: 877, X1: 90 </td>
  </tr>
</tbody>
</table>


**Variable type: numeric**

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> skim_variable </th>
   <th style="text-align:right;"> n_missing </th>
   <th style="text-align:right;"> complete_rate </th>
   <th style="text-align:right;"> mean </th>
   <th style="text-align:right;"> sd </th>
   <th style="text-align:right;"> p0 </th>
   <th style="text-align:right;"> p25 </th>
   <th style="text-align:right;"> p50 </th>
   <th style="text-align:right;"> p75 </th>
   <th style="text-align:right;"> p100 </th>
   <th style="text-align:left;"> hist </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> aat0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 56711.31 </td>
   <td style="text-align:right;"> 189.66 </td>
   <td style="text-align:right;"> 55878.44 </td>
   <td style="text-align:right;"> 56602.00 </td>
   <td style="text-align:right;"> 56686.44 </td>
   <td style="text-align:right;"> 56875.90 </td>
   <td style="text-align:right;"> 57502.22 </td>
   <td style="text-align:left;"> ▁▂▇▃▁ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> aat10 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 50118.09 </td>
   <td style="text-align:right;"> 112.08 </td>
   <td style="text-align:right;"> 49661.02 </td>
   <td style="text-align:right;"> 50056.32 </td>
   <td style="text-align:right;"> 50090.27 </td>
   <td style="text-align:right;"> 50219.79 </td>
   <td style="text-align:right;"> 50389.90 </td>
   <td style="text-align:left;"> ▁▁▇▅▃ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> aridity </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 860.49 </td>
   <td style="text-align:right;"> 20.77 </td>
   <td style="text-align:right;"> 824.95 </td>
   <td style="text-align:right;"> 842.19 </td>
   <td style="text-align:right;"> 857.50 </td>
   <td style="text-align:right;"> 878.98 </td>
   <td style="text-align:right;"> 897.82 </td>
   <td style="text-align:left;"> ▇▇▆▆▇ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> dem </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4.55 </td>
   <td style="text-align:right;"> 1.32 </td>
   <td style="text-align:right;"> -2.99 </td>
   <td style="text-align:right;"> 3.81 </td>
   <td style="text-align:right;"> 4.51 </td>
   <td style="text-align:right;"> 5.30 </td>
   <td style="text-align:right;"> 13.28 </td>
   <td style="text-align:left;"> ▁▂▇▁▁ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> dst_waterway </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.57 </td>
   <td style="text-align:right;"> 0.57 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:right;"> 0.16 </td>
   <td style="text-align:right;"> 0.37 </td>
   <td style="text-align:right;"> 0.79 </td>
   <td style="text-align:right;"> 3.99 </td>
   <td style="text-align:left;"> ▇▂▁▁▁ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> hfp </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 47.22 </td>
   <td style="text-align:right;"> 10.68 </td>
   <td style="text-align:right;"> 25.78 </td>
   <td style="text-align:right;"> 40.00 </td>
   <td style="text-align:right;"> 44.71 </td>
   <td style="text-align:right;"> 51.20 </td>
   <td style="text-align:right;"> 86.95 </td>
   <td style="text-align:left;"> ▁▇▂▁▁ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> hii </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 30.61 </td>
   <td style="text-align:right;"> 6.98 </td>
   <td style="text-align:right;"> 14.30 </td>
   <td style="text-align:right;"> 26.00 </td>
   <td style="text-align:right;"> 29.00 </td>
   <td style="text-align:right;"> 33.35 </td>
   <td style="text-align:right;"> 56.00 </td>
   <td style="text-align:left;"> ▁▇▂▁▁ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> im </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4110.94 </td>
   <td style="text-align:right;"> 402.68 </td>
   <td style="text-align:right;"> 3335.69 </td>
   <td style="text-align:right;"> 3744.35 </td>
   <td style="text-align:right;"> 4137.69 </td>
   <td style="text-align:right;"> 4464.23 </td>
   <td style="text-align:right;"> 4835.42 </td>
   <td style="text-align:left;"> ▆▇▇▇▇ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> landcover </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 28.40 </td>
   <td style="text-align:right;"> 14.12 </td>
   <td style="text-align:right;"> 11.00 </td>
   <td style="text-align:right;"> 14.72 </td>
   <td style="text-align:right;"> 26.18 </td>
   <td style="text-align:right;"> 40.82 </td>
   <td style="text-align:right;"> 51.96 </td>
   <td style="text-align:left;"> ▇▃▃▃▅ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> landform </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 11.04 </td>
   <td style="text-align:right;"> 0.66 </td>
   <td style="text-align:right;"> 11.00 </td>
   <td style="text-align:right;"> 11.00 </td>
   <td style="text-align:right;"> 11.00 </td>
   <td style="text-align:right;"> 11.00 </td>
   <td style="text-align:right;"> 28.08 </td>
   <td style="text-align:left;"> ▇▁▁▁▁ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ndvi20161 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.47 </td>
   <td style="text-align:right;"> 0.09 </td>
   <td style="text-align:right;"> 0.07 </td>
   <td style="text-align:right;"> 0.42 </td>
   <td style="text-align:right;"> 0.47 </td>
   <td style="text-align:right;"> 0.53 </td>
   <td style="text-align:right;"> 0.74 </td>
   <td style="text-align:left;"> ▁▁▇▇▁ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ndvi20162 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.63 </td>
   <td style="text-align:right;"> 0.14 </td>
   <td style="text-align:right;"> 0.21 </td>
   <td style="text-align:right;"> 0.52 </td>
   <td style="text-align:right;"> 0.66 </td>
   <td style="text-align:right;"> 0.74 </td>
   <td style="text-align:right;"> 0.86 </td>
   <td style="text-align:left;"> ▁▃▅▇▆ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ndvi20163 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.60 </td>
   <td style="text-align:right;"> 0.14 </td>
   <td style="text-align:right;"> 0.07 </td>
   <td style="text-align:right;"> 0.51 </td>
   <td style="text-align:right;"> 0.63 </td>
   <td style="text-align:right;"> 0.70 </td>
   <td style="text-align:right;"> 0.85 </td>
   <td style="text-align:left;"> ▁▂▃▇▆ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ndvi20164 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.33 </td>
   <td style="text-align:right;"> 0.07 </td>
   <td style="text-align:right;"> 0.02 </td>
   <td style="text-align:right;"> 0.29 </td>
   <td style="text-align:right;"> 0.34 </td>
   <td style="text-align:right;"> 0.38 </td>
   <td style="text-align:right;"> 0.51 </td>
   <td style="text-align:left;"> ▁▁▅▇▂ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> night_time_lights </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 10.96 </td>
   <td style="text-align:right;"> 10.75 </td>
   <td style="text-align:right;"> 1.06 </td>
   <td style="text-align:right;"> 2.47 </td>
   <td style="text-align:right;"> 6.31 </td>
   <td style="text-align:right;"> 16.74 </td>
   <td style="text-align:right;"> 63.46 </td>
   <td style="text-align:left;"> ▇▂▁▁▁ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> pa </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 11977.75 </td>
   <td style="text-align:right;"> 375.75 </td>
   <td style="text-align:right;"> 11229.54 </td>
   <td style="text-align:right;"> 11627.95 </td>
   <td style="text-align:right;"> 11998.46 </td>
   <td style="text-align:right;"> 12326.69 </td>
   <td style="text-align:right;"> 12646.25 </td>
   <td style="text-align:left;"> ▅▇▇▆▇ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> slope </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.51 </td>
   <td style="text-align:right;"> 0.42 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:right;"> 0.24 </td>
   <td style="text-align:right;"> 0.47 </td>
   <td style="text-align:right;"> 0.73 </td>
   <td style="text-align:right;"> 7.27 </td>
   <td style="text-align:left;"> ▇▁▁▁▁ </td>
  </tr>
  <tr>
   <td style="text-align:left;"> tadem </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 155.36 </td>
   <td style="text-align:right;"> 0.56 </td>
   <td style="text-align:right;"> 153.00 </td>
   <td style="text-align:right;"> 155.00 </td>
   <td style="text-align:right;"> 155.00 </td>
   <td style="text-align:right;"> 156.00 </td>
   <td style="text-align:right;"> 157.05 </td>
   <td style="text-align:left;"> ▁▁▇▆▁ </td>
  </tr>
</tbody>
</table>

#### 1.4.2 相关系数图


```r
data_obs %>%
  dplyr::select_if(is.numeric) %>%
  as.matrix() %>%
  quickcor(cor.test = TRUE) +
  geom_square(data = get_data(type = "lower", show.diag = FALSE)) +
  geom_number(aes(num = r), size = 2.5, data = get_data(type = "upper", show.diag = FALSE)) +
  geom_abline(intercept = 19, slope = -1, size = 0.8) +
  scale_fill_gradientn(colours = c("#77C034", "white", "#C388FE"))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-13-1.png" width="672" style="display: block; margin: auto;" />


部分变量的相关性非常强

#### 1.4.3 变量直方图


```r
data_obs %>%
  dplyr::select_if(is.numeric) %>%
  pivot_longer(everything(),
    names_to = "vars",
    values_to = "value"
  ) %>%
  ggplot(aes(value, fill = vars)) +
  geom_histogram(aes(value, fill = vars)) +
  facet_wrap(~vars, scales = "free", nrow = 3) +
  scale_y_continuous(name = "frequency") +
  scale_x_continuous(name = "Continuous variables") +
  labs(title = "Histogram of different variables") +
  guides(fill = "none") +
  scale_fill_viridis_d() +
  theme_bw() +
  theme(
    plot.title = element_text(size = 10, hjust = 0.5, face = "bold"),
    text = element_text(size = 8, face = "bold", hjust = 0.5),
    axis.title.y = element_text(face = "bold", hjust = 0.5),
    axis.text.x = element_text(size = 6, face = "bold", angle = 30, hjust = 0.5, vjust = 0.5)
  )
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-14-1.png" width="672" style="display: block; margin: auto;" />

## 2.切分数据

- 分层抽样(样本非平衡)


```r
set.seed(1111)
train.index <- createDataPartition(data_obs$class, p = .7, list = FALSE)
train <- data_obs[train.index, ]
test <- data_obs[-train.index, ]

whole_prop <- data_obs %>%
  group_by(class) %>%
  summarise(count = n()) %>%
  mutate(prop = count / sum(count)) %>%
  mutate(dataset = "whole_dataset") %>%
  dplyr::select(dataset, everything())

train_prop <- train %>%
  group_by(class) %>%
  summarise(count = n()) %>%
  mutate(prop = count / sum(count)) %>%
  mutate(dataset = "train_dataset") %>%
  dplyr::select(dataset, everything())

test_prop <- test %>%
  group_by(class) %>%
  summarise(count = n()) %>%
  mutate(prop = count / sum(count)) %>%
  mutate(dataset = "test_dataset") %>%
  dplyr::select(dataset, everything())

whole_prop %>%
  bind_rows(train_prop) %>%
  bind_rows(test_prop) %>%
  mutate(across(prop, .fns = function(x) {
    return(round(x, 2))
  })) %>%
  kable()
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> dataset </th>
   <th style="text-align:left;"> class </th>
   <th style="text-align:right;"> count </th>
   <th style="text-align:right;"> prop </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> whole_dataset </td>
   <td style="text-align:left;"> X0 </td>
   <td style="text-align:right;"> 877 </td>
   <td style="text-align:right;"> 0.91 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> whole_dataset </td>
   <td style="text-align:left;"> X1 </td>
   <td style="text-align:right;"> 90 </td>
   <td style="text-align:right;"> 0.09 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> train_dataset </td>
   <td style="text-align:left;"> X0 </td>
   <td style="text-align:right;"> 614 </td>
   <td style="text-align:right;"> 0.91 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> train_dataset </td>
   <td style="text-align:left;"> X1 </td>
   <td style="text-align:right;"> 63 </td>
   <td style="text-align:right;"> 0.09 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> test_dataset </td>
   <td style="text-align:left;"> X0 </td>
   <td style="text-align:right;"> 263 </td>
   <td style="text-align:right;"> 0.91 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> test_dataset </td>
   <td style="text-align:left;"> X1 </td>
   <td style="text-align:right;"> 27 </td>
   <td style="text-align:right;"> 0.09 </td>
  </tr>
</tbody>
</table>


## 3.建立模型

### 3.1SVM

- 10折交叉验证，3次重复


```r
train_control <- trainControl(
  method = "repeatedcv", number = 10,
  repeats = 3, savePredictions = TRUE,
  classProbs = TRUE
)
# metric="ROC"/metric="Kappa"
svm_model <- train(class ~ .,
  data = train, metric = "Kappa",
  method = "svmRadial", trControl = train_control,
  preProcess = c("center", "scale"), tuneLength = 10
)
svm_model
```

```
#> Support Vector Machines with Radial Basis Function Kernel 
#> 
#> 677 samples
#>  18 predictor
#>   2 classes: 'X0', 'X1' 
#> 
#> Pre-processing: centered (18), scaled (18) 
#> Resampling: Cross-Validated (10 fold, repeated 3 times) 
#> Summary of sample sizes: 610, 609, 609, 610, 610, 610, ... 
#> Resampling results across tuning parameters:
#> 
#>   C       Accuracy   Kappa     
#>     0.25  0.9178940  0.24427448
#>     0.50  0.9173457  0.22976575
#>     1.00  0.9183481  0.22581128
#>     2.00  0.9158680  0.22476172
#>     4.00  0.9198408  0.28508210
#>     8.00  0.9227970  0.32051753
#>    16.00  0.9227678  0.30292961
#>    32.00  0.9040517  0.08415297
#>    64.00  0.9001000  0.02701597
#>   128.00  0.9015564  0.01898601
#> 
#> Tuning parameter 'sigma' was held constant at a value of 0.05096945
#> Kappa was used to select the optimal model using the largest value.
#> The final values used for the model were sigma = 0.05096945 and C = 8.
```

-   输出`Kappa`达到最大的模型参数


```r
svm_model$bestTune %>%
  kable()
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> sigma </th>
   <th style="text-align:right;"> C </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:right;"> 0.0509694 </td>
   <td style="text-align:right;"> 8 </td>
  </tr>
</tbody>
</table>

-   输出模型评价指标

> [!info]  
> 输出`acc`、`kappa`、`ROC`、`ppv`等指标


```r
metric_table <- function(model) {
  temp_df <- model$pred %>%
    as_tibble() %>%
    dplyr::select(pred, obs, X0, X1, Resample) %>%
    nest(data = c(pred, obs, X0, X1)) %>%
    mutate(
      acc = map(data, ~ accuracy_vec(.x$obs, .x$pred)),
      kappa = map(data, ~ kap_vec(.x$obs, .x$pred)),
      # ,options = list(smooth = TRUE)
      ROC = map(data, ~ roc_auc_vec(.x$obs, .x$X0)),
      ppv = map(data, ~ ppv_vec(.x$obs, .x$pred))
    ) %>%
    unnest(c(acc, kappa, ROC, ppv)) %>%
    dplyr::select(-data)
  return(temp_df)
}
```

- 自定义cell_spec以强调指标最大值


```r
beautify_metric_table <- function(table) {
  temp_df <- table

  # 美化函数
  my_cell_spec1 <- function(x) {
    cell_spec(x,
      "html",
      color = ifelse(x == max(x),
        "red",
        "black"
      ),
      italic = ifelse(x == max(x),
        TRUE,
        FALSE
      ),
      bold = ifelse(x == max(x),
        TRUE,
        FALSE
      ),
      background = ifelse(x == max(x),
        "grey",
        "white"
      ),
      font_size = ifelse(x == max(x),
        20,
        15
      )
    )
  }

  # 美化表格
  final_df <- temp_df %>%
    mutate(across(where(is.numeric), .fns = function(x) round(x, 2))) %>%
    mutate(across(.cols = where(is.numeric), my_cell_spec1)) %>%
    kable("html", escape = FALSE) %>%
    kable_styling(bootstrap_options = c("striped", "hover")) %>%
    kableExtra::kable_classic()

  return(final_df)
}
metric_table(svm_model) %>%
  beautify_metric_table(table = .)
```

<table class="table table-striped table-hover lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:left;"> Resample </th>
   <th style="text-align:left;"> acc </th>
   <th style="text-align:left;"> kappa </th>
   <th style="text-align:left;"> ROC </th>
   <th style="text-align:left;"> ppv </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Fold01.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.33</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.81</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.12</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.88</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.19</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.79</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.32</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.18</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.77</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.21</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.85</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.29</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.88</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.18</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.85</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.21</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.84</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.09</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.84</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold01.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.24</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.84</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.01</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.75</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.36</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.27</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.8</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.28</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.81</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.24</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.89</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.21</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.87</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.12</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.84</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.36</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.87</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.89</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.14</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.83</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold01.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.2</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.83</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.16</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.77</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.89</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">-0.01</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.75</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.11</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.86</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.19</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.76</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep3 </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.94</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.5</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.99</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.27</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.87</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.06</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.84</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.11</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.85</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.37</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.88</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
</tbody>
</table>

-   混淆矩阵

10折交叉验证并且重复三次的结果如下(因为是平均所以会有非整数)


```r
confusionMatrix.train(svm_model)
```

```
#> Cross-Validated (10 fold, repeated 3 times) Confusion Matrix 
#> 
#> (entries are percentual average cell counts across resamples)
#>  
#>           Reference
#> Prediction   X0   X1
#>         X0 90.1  7.1
#>         X1  0.6  2.2
#>                             
#>  Accuracy (average) : 0.9227
```

-   最优参数预测的混淆矩阵.


```r
confusionMatrix(data = predict(svm_model, train), reference = train$class)
```

```
#> Confusion Matrix and Statistics
#> 
#>           Reference
#> Prediction  X0  X1
#>         X0 613  43
#>         X1   1  20
#>                                           
#>                Accuracy : 0.935           
#>                  95% CI : (0.9137, 0.9524)
#>     No Information Rate : 0.9069          
#>     P-Value [Acc > NIR] : 0.005355        
#>                                           
#>                   Kappa : 0.4506          
#>                                           
#>  Mcnemar's Test P-Value : 6.37e-10        
#>                                           
#>             Sensitivity : 0.9984          
#>             Specificity : 0.3175          
#>          Pos Pred Value : 0.9345          
#>          Neg Pred Value : 0.9524          
#>              Prevalence : 0.9069          
#>          Detection Rate : 0.9055          
#>    Detection Prevalence : 0.9690          
#>       Balanced Accuracy : 0.6579          
#>                                           
#>        'Positive' Class : X0              
#> 
```

-   变量重要性

> [!Note]   
>按照降序排列前若干个重要变量


```r
kable_var <- function(model, num) {
  temp_df <- caret::varImp(model) %>%
    .$importance %>%
    dplyr::select(last_col()) %>%
    rownames_to_column("variables") %>%
    setNames(c("variables", "importance")) %>%
    arrange(desc(importance)) %>%
    rownames_to_column("id")

  importance_threshold <- temp_df %>%
    dplyr::filter(id == num) %>%
    pull(importance)

  # 辅助列上色
  # 美化函数
  my_cell_spec2 <- function(x) {
    cell_spec(x,
      "html",
      color = ifelse(x >= importance_threshold,
        "red",
        "black"
      ),
      italic = ifelse(x >= importance_threshold,
        TRUE,
        FALSE
      ),
      bold = ifelse(x >= importance_threshold,
        TRUE,
        FALSE
      ),
      background = ifelse(x >= importance_threshold,
        "grey",
        "white"
      ),
      font_size = ifelse(x >= importance_threshold,
        20,
        15
      )
    )
  }

  final_df <- temp_df %>%
    mutate(across(where(is.numeric), .fns = function(x) round(x, 4))) %>%
    mutate(across(.cols = where(is.numeric), my_cell_spec2)) %>%
    dplyr::select(-id) %>%
    kable("html", align = "cr", escape = FALSE) %>%
    kable_styling() %>%
    kableExtra::kable_classic()

  return(final_df)
}
kable_var(svm_model, 6)
```

<table class="table lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:center;"> variables </th>
   <th style="text-align:right;"> importance </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> ndvi20162 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">100</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> night_time_lights </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">93.5946</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20164 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">92.5634</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20161 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">88.1718</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aridity </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">79.6676</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> im </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">79.3643</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> pa </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">78.5515</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20163 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">70.5326</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> hfp </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">45.6387</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> dst_waterway </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">41.423</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> hii </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">37.5227</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> landcover </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">28.3695</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> dem </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">16.7779</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aat10 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">10.609</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> tadem </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">8.4739</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> landform </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">1.2435</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> slope </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.8613</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aat0 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0</span> </td>
  </tr>
</tbody>
</table>

这里按照降序绘制前若干个重要变量


```r
ggplot_var <- function(model, num) {
  caret::varImp(model) %>%
    .$importance %>%
    dplyr::select(last_col()) %>%
    rownames_to_column("variables") %>%
    setNames(c("variables", "importance")) %>%
    arrange(desc(importance)) %>%
    rowid_to_column("rowid") %>%
    mutate(group = case_when(
      rowid > num ~ "B",
      TRUE ~ "A"
    )) %>%
    ggplot(aes(x = reorder(variables, importance), importance, fill = group)) +
    geom_col(alpha = 0.7, bins = 30) +
    scale_x_discrete(name = "variables") +
    scale_y_continuous(name = "importance") +
    labs(title = "variable importance plot") +
    guides(fill = "none") +
    ggsci::scale_fill_lancet() +
    theme_bw() +
    coord_flip() +
    theme(
      plot.title = element_text(size = 14, hjust = 0.5, face = "bold"),
      text = element_text(size = 10, hjust = 0.5),
      axis.title.y = element_text(face = "bold", hjust = 0.5),
      axis.text.x = element_text(size = 8, hjust = 0.5, vjust = 0.5),
      axis.text.y = element_text(size = 8, hjust = 0.5, vjust = 0.5)
    )
}
ggplot_var(svm_model, 6)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-23-1.png" width="672" style="display: block; margin: auto;" />


排名前六的变量分别是`im`、`pa`、`aridity`、`ndvi20162`、`ndvi20163`、`ndvi20163`

-   partial dependence plots

> [!info]  
> 二维图形


```r
# 定义函数绘制pdp
# 参数分别是模型、前X重要变量以为绘图时图片排列列数
pdp_2d_one_predictor <- function(model, num, ncol) {
  # 定义函数提取前若干重要变量
  names_var <- function(model, num) {
    des_var <- caret::varImp(model) %>%
      .$importance %>%
      dplyr::select(last_col()) %>%
      rownames_to_column("variables") %>%
      setNames(c("variables", "importance")) %>%
      arrange(desc(importance)) %>%
      rowid_to_column("rowid") %>%
      head(num) %>%
      pull(variables)
    return(des_var)
  }

  # 重要变量名称
  single_var <- names_var(model, num)

  # p <- list()
  # for (i in single_var) {
  #   temp_var <- i
  #   p[[i]] <- model %>%
  #     partial(pred.var = temp_var,parallel = T) %>%
  #     autoplot(smooth = TRUE, ylab = paste0("f(",temp_var,")")) +
  #     theme_bw()+
  #     scale_x_continuous(n.breaks = 8)+
  #     theme(plot.title = element_text(size = 14,hjust = 0.5, face = "bold"),
  #           text = element_text(size = 10,hjust = 0.5),
  #           axis.title.y = element_text(face = "bold",hjust = 0.5),
  #           axis.title.x = element_text(face = "bold",hjust = 0.5,vjust = 0.5))
  # }
  # do.call(grid.arrange, c(p, ncol = ncol))

  # 定义pdp函数以搭配绘图
  my_partial <- function(value, model) {
    model %>%
      partial(pred.var = value, parallel = T) %>%
      autoplot(smooth = TRUE, ylab = paste0("f(", value, ")")) +
      theme_bw() +
      scale_x_continuous(n.breaks = 8) +
      theme(
        plot.title = element_text(size = 14, hjust = 0.5, face = "bold"),
        text = element_text(size = 10, hjust = 0.5),
        axis.title.y = element_text(face = "bold", hjust = 0.5),
        axis.title.x = element_text(face = "bold", hjust = 0.5, vjust = 0.5)
      )
  }

  # 执行pdp绘图函数
  pdp_data <- single_var %>%
    as_tibble() %>%
    mutate(model = list(model)) %>%
    group_by(value) %>%
    mutate(plot = map2(value, model, my_partial))

  # 组合图形
  do.call(grid.arrange, c(pdp_data$plot, ncol = ncol))
}
pdp_2d_one_predictor(model = svm_model, num = 6, ncol = 2)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-24-1.png" width="672" style="display: block; margin: auto;" />

> In the above plot, please do not get confused with Y-axis. It does not show the predicted value instead how the value is changing with the change in the given predictor variable in our case Petal.Width in first plot.

> In the plot if there are more variation for any given predictor variable that means the value of that variable affects the model quite alot but if the line is constant near zero it shows that variable has no affect on the model.

> Single variables shows how there value affect the model, on y-axis having a negative value means for that particular value of predictor variable it is less likely to predict the correct class on that observation and having a positive value means it has positive impact on predicting the correct class. Same applies to two variable plots, color represent the intensity of affect on model.

> [!info]  
> 联合变量二维平面图形

这里最开始是准备用`foreach`包并行计算的，但是其实数据量不大，所以并行计算多个模型即可，因为我们选择的是前六个重要的变量，组合起来是15个，所以并行计算输出`pdp`还是很有必要的！这里主要采用的是<s>lapply</s>purrr::map2，因为后者和ggplot2结合起来真的很方便！



```r
pdp_2d_two_predictor <- function(model, num, ncol) {
  # 定义函数提取前若干重要变量
  names_var <- function(model, num) {
    des_var <- caret::varImp(model) %>%
      .$importance %>%
      dplyr::select(last_col()) %>%
      rownames_to_column("variables") %>%
      setNames(c("variables", "importance")) %>%
      arrange(desc(importance)) %>%
      rowid_to_column("rowid") %>%
      head(num) %>%
      pull(variables)
    return(des_var)
  }

  # 所有排列组合情况
  comb_var <- names_var(model, num = num) %>%
    combn(., 2)

  # 开启多线程
  # library(parallel)
  # no_cores <- detectCores() - 1
  # library(foreach)
  # library(doParallel)
  # cl <- makeCluster(no_cores)
  # registerDoParallel(cl)

  # 绘图
  # p <- list()
  # for (i in 1:ncol(comb_var)) {
  #   temp_var <- comb_var[,i]
  #   p[[i]] <- model %>%
  #     partial(pred.var = temp_var,
  #             parallel = T,
  #             chull = TRUE,
  #             contour = TRUE,
  #             contour.color = "red") %>%
  #     autoplot(smooth = TRUE) +
  #     theme_light() +
  #     scale_x_continuous(n.breaks = 5)+
  #     theme(plot.title = element_text(size = 14,hjust = 0.5, face = "bold"),
  #           text = element_text(size = 8,hjust = 0.5),
  #           axis.title.y = element_text(face = "bold",hjust = 0.5),
  #           axis.title.x = element_text(face = "bold",hjust = 0.5,vjust = 0.5),
  #           legend.position = "none")
  # }

  # 关闭多线程
  # stopCluster(cl)

  # 组合图形
  # do.call(grid.arrange,c(p, ncol = ncol))

  # 组合情况转为数据框
  comb_df <- comb_var %>%
    t() %>%
    as_tibble()

  # 针对map2函数设计pdp函数
  my_partial <- function(V1, V2) {
    model %>%
      partial(
        pred.var = c(V1, V2),
        parallel = T,
        chull = TRUE,
        contour = TRUE,
        contour.color = "red"
      ) %>%
      autoplot(smooth = TRUE) +
      theme_light() +
      scale_x_continuous(n.breaks = 5) +
      theme(
        plot.title = element_text(size = 14, hjust = 0.5, face = "bold"),
        text = element_text(size = 8, hjust = 0.5),
        axis.title.y = element_text(face = "bold", hjust = 0.5),
        axis.title.x = element_text(face = "bold", hjust = 0.5, vjust = 0.5),
        legend.position = "none"
      )
  }

  # 执行pdp计算
  pdp_data <- comb_df %>%
    group_by(V1, V2) %>%
    mutate(plot = map2(V1, V2, my_partial))

  # 组合图形
  do.call(grid.arrange, c(pdp_data$plot, ncol = ncol))
}

# 清除所有多线程任务
# unregister_dopar <- function() {
#   env <- foreach:::.foreachGlobals
#   rm(list=ls(name=env), pos=env)
# }

# pdp_2d_two_predictor(model = svm_model,num = 6,ncol = 3)
```


颜色越浅，数值越大。

> [!info]   
> 联合变量三维立体图形

由于三维立体图形无法使用静态图呈现，若全部使用`rgl`呈现则占用过多篇幅因此仅仅选择性展示`im`以及`ndvi20162`，因为这两个变量的*预测概率*分布范围更广，信息量大。


```r
# 定义函数提取前若干重要变量
# names_var <- function(model,num){
#   des_var <- caret::varImp(model) %>%
#     .$importance %>%
#     rownames_to_column("variables") %>%
#     dplyr::select(variables,importance = X1) %>%
#     setNames(c("variables","importance")) %>%
#     arrange(desc(importance)) %>%
#     rowid_to_column("rowid") %>%
#     head(num) %>%
#     pull(variables)
#   return(des_var)
# }
#
# # 所有排列组合情况
# comb_var <- names_var(svm_model,num = 6) %>%
#   combn(., 2)
# temp_var <- comb_var[,3]
#
# gg_3D <- svm_model %>%
#   partial(pred.var = temp_var,
#           # parallel = T,
#           chull = TRUE,
#           contour = TRUE,
#           contour.color = "red") %>%
#   autoplot(smooth = TRUE) +
#   theme_light() +
#   scale_x_continuous(n.breaks = 5)+
#   theme(plot.title = element_text(size = 14,hjust = 0.5, face = "bold"),
#         text = element_text(size = 12,hjust = 0.5),
#         axis.title.y = element_text(face = "bold",hjust = 0.5),
#         axis.title.x = element_text(face = "bold",hjust = 0.5,vjust = 0.5))
```

-   静态图


```r
# par(mfrow = c(1, 2))
# plot_gg(gg_3D, width = 5, height = 4, scale = 300, raytrace = FALSE, preview = TRUE)
# plot_gg(gg_3D, width = 5, height = 4, scale = 300, multicore = TRUE, windowsize = c(1000, 800))
# render_camera(fov = 70, zoom = 0.5, theta = 130, phi = 35)
# Sys.sleep(2)
# render_snapshot(clear = TRUE)
```

-   动态图


```r
# plot_gg(gg_3D, width = 5, height = 4, scale = 300, multicore = TRUE, windowsize = c(1000, 800))
```

-   预测测试集

*caret*的指标合集函数`metric_set`存在问题，只好中途跳出来再进去


```r
metrics_set <- function(data) {
  metric_row_df <- data %>%
    summarise(
      acc = accuracy_vec(obs, pred),
      kap = kap_vec(obs, pred),
      ppv = ppv_vec(obs, pred),
      precision = precision_vec(obs, pred),
      recall = recall_vec(obs, pred),
      f_meas = f_meas_vec(obs, pred),
      sensitivity = sensitivity_vec(obs, pred),
      detection_prevalence = detection_prevalence_vec(obs, pred),
      j_index = j_index_vec(obs, pred),
      npv = npv_vec(obs, pred),
      specificity = specificity_vec(obs, pred),
      roc = roc_auc_vec(obs, X0),
      mn_log_loss = mn_log_loss_vec(obs, X0),
      pr_auc = pr_auc_vec(obs, X0)
    ) %>%
    mutate(tss = specificity + sensitivity - 1)

  metric_col_df <- metric_row_df %>%
    t() %>%
    as.data.frame() %>%
    rownames_to_column("metric") %>%
    setNames(c("metric", "value"))

  return(metric_col_df)
}
```

> [!info]  
> 使用一套预测指标对模型在测试集上的表现进行评估，其中有的是针对二分类预测结果，有的是针对概率预测结果，有的指标是越大越好，有的反之，具体如上表所示。


```r
extractProb(list(svm_model), testX = test) %>%
  metrics_set(data = .) %>%
  kable("html", align = "cr", escape = FALSE) %>%
  kable_styling() %>%
  kableExtra::kable_classic()
```

<table class="table lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:center;"> metric </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> acc </td>
   <td style="text-align:right;"> 0.9350074 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> kap </td>
   <td style="text-align:right;"> 0.4506289 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ppv </td>
   <td style="text-align:right;"> 0.9344512 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> precision </td>
   <td style="text-align:right;"> 0.9344512 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> recall </td>
   <td style="text-align:right;"> 0.9983713 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> f_meas </td>
   <td style="text-align:right;"> 0.9653543 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> sensitivity </td>
   <td style="text-align:right;"> 0.9983713 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> detection_prevalence </td>
   <td style="text-align:right;"> 0.9689808 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> j_index </td>
   <td style="text-align:right;"> 0.3158317 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> npv </td>
   <td style="text-align:right;"> 0.9523810 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> specificity </td>
   <td style="text-align:right;"> 0.3174603 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> roc </td>
   <td style="text-align:right;"> 0.9839848 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> mn_log_loss </td>
   <td style="text-align:right;"> 0.1722982 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> pr_auc </td>
   <td style="text-align:right;"> 0.9983522 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> tss </td>
   <td style="text-align:right;"> 0.3158317 </td>
  </tr>
</tbody>
</table>


-   预测上海市


```r
# 速度确实快但是少了很多样本
# extractProb(list(svm_model), testX = env_df)
# extractProb(list(svm_model), testX = env_df)
```

这个地方存疑


```r
# svm_pred_bin <- predict(svm_model, newdata = env_df,type = "prob")
#
# svm_pred_prob <- predict(svm_model, newdata = env_df,type = "raw")
#
# svm_pred_df <- env_df %>%
#   na.omit() %>%
#   bind_cols(svm_pred_bin) %>%
#   bind_cols(tibble(pred = svm_pred_prob))

# 定义函数整合输出概率值与分类值
pred_df <- function(model) {
  env_df %>%
    na.omit() %>%
    bind_cols(model %>%
      predict(
        object = .,
        newdata = env_df,
        type = "prob"
      )) %>%
    bind_cols(tibble(pred = model %>%
      predict(
        object = .,
        newdata = env_df,
        type = "raw"
      )))
}

# 定义函数以整合输出多个栅格数据
pred_layer <- function(pred_df_res, model, model.name) {
  # 添加多步判断语句-----主要为后续建模预测结果整合的傻瓜化输出考虑
  if (length(colnames(pred_df_res)) >= 5) {
    print("数据中变量个数符合要求")
  } else {
    stop("数据中变量个数不符合要求")
  }

  if (length(as.character.factor(unique(pred_df_res$pred))) == 2) {
    print("数据中分类变量是二值型")
  } else {
    stop("数据中分类变量不是二值型")
  }

  if (length(unique(pred_df_res$pred)) == 2) {
    print("数据中二分类变量种类符合要求")
  } else {
    stop("数据中二分类变量种类符合要求")
  }

  if (min(pred_df_res$X1) >= 0 & max(pred_df_res$X1) <= 1) {
    print("数据中预测概率值变量范围符合要求")
  } else {
    stop("数据中预测概率值变量范围不符合要求")
  }

  if (is.character(model.name)) {
    print("模型名称符合要求")
  } else {
    stop("你需要提供一个字符串作为栅格数据图层名称！")
  }


  # 二分类数据转换
  temp_pred_bin_layer <-
    pred_df_res %>%
    dplyr::select(x, y, z = pred) %>%
    # 从原来因子型转换为数值型
    mutate(z = ifelse(z == "X0", 0, 1)) %>%
    data.matrix() %>%
    rasterFromXYZ()

  # 重命名
  names(temp_pred_bin_layer) <- paste0(model.name, "_bin")

  # 指定crs
  crs(temp_pred_bin_layer) <- "+proj=longlat +datum=WGS84 +no_defs +type=crs"

  if (dir.exists("./data/pred/caret")) {
    print("Path `./data/pred/caret` already exist!")
  } else {
    dir.create("./data/pred/caret")
    print("Path `./data/pred/caret` newly create!")
  }

  # 保存图层
  temp_pred_bin_layer %>%
    writeRaster(paste0("./data/pred/caret/", names(temp_pred_bin_layer), ".tif"),
      overwrite = TRUE
    )

  # 概率值数据转换
  temp_pred_prob_layer <-
    pred_df_res %>%
    dplyr::select(x, y, z = X1) %>%
    data.matrix() %>%
    rasterFromXYZ()

  # 重命名
  names(temp_pred_prob_layer) <- paste0(model.name, "_prob")

  # 指定crs
  crs(temp_pred_prob_layer) <- "+proj=longlat +datum=WGS84 +no_defs +type=crs"

  # 保存图层
  temp_pred_prob_layer %>%
    writeRaster(paste0("./data/pred/caret/", names(temp_pred_prob_layer), ".tif"),
      overwrite = TRUE
    )

  # 叠加数据并且输出
  res <- temp_pred_bin_layer %>%
    stack(temp_pred_prob_layer)
  return(res)
}

sh_pred_layer <- pred_df(model = svm_model) %>%
  pred_layer(
    pred_df_res = .,
    model = svm_model,
    model.name = "svm"
  )
```

```
#> [1] "数据中变量个数符合要求"
#> [1] "数据中分类变量是二值型"
#> [1] "数据中二分类变量种类符合要求"
#> [1] "数据中预测概率值变量范围符合要求"
#> [1] "模型名称符合要求"
#> [1] "Path `./data/pred/caret` already exist!"
```

```r
sh_pred_layer
```

```
#> class      : RasterStack 
#> dimensions : 1362, 1260, 1716120, 2  (nrow, ncol, ncell, nlayers)
#> resolution : 0.0008333333, 0.0008333333  (x, y)
#> extent     : 120.8529, 121.9029, 30.70042, 31.83542  (xmin, xmax, ymin, ymax)
#> crs        : +proj=longlat +datum=WGS84 +no_defs 
#> names      :    svm_bin,   svm_prob 
#> min values : 0.00000000, 0.00223579 
#> max values :  1.0000000,  0.9458519
```

结果是符合我们要求的

-   上海市结果可视化

主要使用`tmap`、`plotly`、<s>`ggplot2`</s>(速度太慢)等扩展包展示


```r
# 定义函数分开展示二分类和概率值两个栅格图层
sh_tmap <- function(data) {
  # 前期全部是二分类基础上叠加的概率值栅格数据
  names(data) <- c("binary", "probility")
  temp_layer <- subset(data, 2)

  sh_county_sf <- mapchina::china %>%
    dplyr::filter(Name_Province == "上海市")

  t2 <- tm_shape(sh_county_sf) +
    tm_borders("black", alpha = .5) +
    tm_shape(temp_layer) +
    tm_raster(
      breaks = c(0, .33, .66, .9, 1),
      # 给定空字符串以设置为无
      # title = "适宜度 \n Habitat \n suitability",
      title = "",
      # labels = c("Lost", "Pres", "Abs","Gain"),
      palette = c("#FFFFFF", "#A6D186", "#F2AB71", "#B71D20")
    ) +
    tm_facets(free.scales = FALSE, nrow = 1) +
    tm_shape(sh_county_sf) +
    tm_borders("black", alpha = .5) +
    # tm_style(style = "classic") +
    # 添加图例
    tm_legend(legend.position = c("left", "top"), outside = FALSE) +
    # 添加比例尺
    tm_scale_bar(position = c("left", "bottom"), text.size = 0.7) +
    # 添加指南针
    tm_compass(
      position = c("right", "bottom"), size = 2.5,
      type = "rose"
    ) +
    # 静态图形式
    tmap_mode(mode = "plot") +
    # 设定图片边界
    tm_layout(
      title = "",
      title.fontfamily = "RMN",
      legend.title.fontfamily = "RMN",
      legend.text.fontfamily = "RMN",
      bg.color = "white",
      title.size = 1,
      legend.title.size = 1.5,
      legend.text.size = 1.2,
      legend.width = 0.3,
      title.fontface = "bold",
      # legend.title.fontface = "italic",
      title.position = c("center", "top"),
      inner.margins = c(.02, .15, .06, .15),
      panel.labels = names(temp_layer),
      panel.label.size = 1.5,
      panel.label.fontfamily = "RMN"
    )

  temp_layer <- subset(data, 1)

  t1 <- tm_shape(sh_county_sf) +
    tm_borders("black", alpha = .5) +
    tm_shape(temp_layer) +
    tm_raster(
      breaks = c(0, 0.5, 1),
      # 给定空字符串以设置为无
      # title = "适宜度 \n Habitat \n suitability",
      title = "",
      labels = c("absence", "presence"),
      palette = c("#FFFFFF", "#B71D20")
    ) +
    tm_facets(free.scales = FALSE, nrow = 1) +
    tm_shape(sh_county_sf) +
    tm_borders("black", alpha = .5) +
    # tm_style(style = "classic") +
    # 添加图例
    tm_legend(legend.position = c("left", "top"), outside = FALSE) +
    # 添加比例尺
    tm_scale_bar(position = c("left", "bottom"), text.size = 0.7) +
    # 添加指南针
    tm_compass(
      position = c("right", "bottom"), size = 2.5,
      type = "rose"
    ) +
    # 静态图形式
    tmap_mode(mode = "plot") +
    # 设定图片边界
    tm_layout(
      title = "",
      title.fontfamily = "RMN",
      legend.title.fontfamily = "RMN",
      legend.text.fontfamily = "RMN",
      bg.color = "white",
      title.size = 1,
      legend.title.size = 1.5,
      legend.text.size = 1.2,
      legend.width = 0.3,
      title.fontface = "bold",
      # legend.title.fontface = "italic",
      title.position = c("center", "top"),
      inner.margins = c(.02, .15, .06, .15),
      panel.labels = names(temp_layer),
      panel.label.size = 1.5,
      panel.label.fontfamily = "RMN"
    )

  # 组合图形
  res <- tmap::tmap_arrange(t1, t2)
  return(res)
}

sh_tmap(sh_pred_layer)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-33-1.png" width="672" style="display: block; margin: auto;" />

-   展示3D图尝试1

花了一下午时间，真心累啊，<s>来不及发邮件了</s>，只想问问`plotly`开发团队，为什么*z*必须是个矩阵，太不人性！


```r
# axi_lv <- function(data,breaks){
#   # 判断数据类型
#   if (nlayers(data) == 1) {
#     print("数据格式符合要求")
#   }else{
#     stop("你需要提供栅格数据以进行下一步操作！")
#   }
#
#   # 转换为矩阵数据
#   temp_mat <- data %>%
#     as.data.frame(xy = T) %>%
#     setNames(c("x","y","z")) %>%
#     mutate(z = z*100) %>%
#     pivot_wider(names_from = y,values_from = z) %>%
#     as.matrix.data.frame()
#
#   # 切分坐标轴并且赋予标签
#
#   # 纬度范围
#   lat_range <- raster::bbox(data)[2,]
#   # 感性理解----多少条纬线
#   x.value <- seq(1,ncol(temp_mat),length.out = breaks)
#   # 标签个数
#   x.label <- rev(seq(min(lat_range),max(lat_range),length.out = breaks)) %>%
#     round(2) %>%
#     paste0(.,"\u00B0E")
#
#   # 经度范围
#   long_range <- raster::bbox(data)[1,]
#   # 感性理解----多少条经线
#   y.value <- seq(1,nrow(temp_mat),length.out = breaks)
#   # 标签个数
#   y.label <- rev(seq(min(long_range),max(long_range),length.out = breaks)) %>%
#     round(2) %>%
#     paste0(.,"\u00B0N")
#
#   return(list(mat.data = temp_mat,
#               x.value = x.value,
#               x.label = x.label,
#               y.value = y.value,
#               y.label = y.label))
# }
#
# plotly.detail <- axi_lv(sh_pred_layer$svm_prob,5)
#
# plot_ly(z = ~plotly.detail$mat.data) %>%
#   add_surface(contours = list(
#     z = list(
#       show=TRUE,
#       usecolormap=TRUE,
#       highlightcolor="#ff0000",
#       project=list(z=TRUE)
#       )
#     )) %>%
#   layout(
#     title = "3D map of snail infection risk in Shanghai",
#     scene = list(
#       xaxis = list(title = "latitude",
#                    tickvals = plotly.detail$x.value,
#                    ticktext = plotly.detail$x.label),
#       yaxis = list(title = "longitude",
#                    tickvals = plotly.detail$y.value,
#                    ticktext = plotly.detail$y.label),
#       zaxis = list(title = "probability"),
#       camera=list(
#         # eye = list(x=1.87, y=0.88, z=-0.64)
#         )
#     ))
```

经纬度看着还行，其实一点用没有，交互式展现的全是栅格数据转成矩阵时候，矩阵的行列数<s>属实有点尴尬</s>
  
  -   展示3D图尝试2


```r
# cartomisc::gplot_data(sh_pred_layer$svm_prob) %>%
#   dplyr::select(x,y,z = value) %>%
#   mutate(probability = z) %>%
#   plot_ly(
#     x = ~x,
#     y = ~y,
#     z = ~z,
#     size = ~z,
#     color = ~probability
#   ) %>%
#   layout(
#     title = "3D map of snail infection risk in Shanghai",
#     scene = list(
#       xaxis = list(title = "longitude"),
#       yaxis = list(title = "latitude"),
#       zaxis = list(title = "probability"),
#       # camera = list(eye = list(x = 0, y = -1, z = 0.5)),
#       aspectratio = list(x = 0.9, y = 0.8, z = 1)
#     ))
```


这图看起来虽然不是很平滑，但是起码还能结合经纬度理解理解，半斤八俩吧，这个是真*八俩*<s>十六进制</s>十进制的八俩！

-   展示3D图尝试3

抓住`plotly`绘制`3D`图的核心思想是建立矩阵数据


```r
# # 从小到大
# y <- sh_pred_layer$svm_prob %>%
#   as.data.frame(xy = T) %>%
#   pull(x) %>%
#   unique()
# # 从大到小
# x <- sh_pred_layer$svm_prob %>%
#   as.data.frame(xy = T) %>%
#   pull(y) %>%
#   unique()
# # 按照行顺序从左到右取值
# z <- sh_pred_layer$svm_prob %>%
#   getValues()
# dim(z) <- c(length(y),length(x))
# probability <- z
#
# # 元素凑齐
# plot_ly(
#   type = 'surface',
#   contours = list(
#     x = list(show = TRUE,
#              # start = 1.5,
#              # end = 2,
#              size = 0.04, color = 'white'),
#     z = list(show = TRUE,
#              # start = 0.5,
#              # end = 0.8,
#              size = 0.05,
#              show=TRUE,
#              usecolormap=TRUE,
#              highlightcolor="#ff0000",
#              project=list(z=TRUE))),
#   x = ~x,
#   y = ~y,
#   z = ~z,
#   color = ~probability) %>%
#   layout(
#     title = "3D map of snail infection risk in Shanghai",
#     scene = list(
#       xaxis = list(title = "latitude",autorange = "reversed"),
#       yaxis = list(title = "longitude"),
#       zaxis = list(title = "probability"),
#       aspectratio = list(x = .9, y = .8, z = 0.8)
#       # camera=list(
#       #   # eye = list(x=1.87, y=0.88, z=-0.64)
#       #   )
#   ))

# 打包函数
sh_plotly <- function(data, model.name) {
  # 判断数据类型
  if (nlayers(data) == 1) {
    print("数据格式符合要求")
  } else {
    stop("你需要提供栅格概率预测值数据以进行下一步操作！")
  }

  # 判断数据类型
  if (is.character(model.name)) {
    print("模型名称符合要求")
  } else {
    stop("你需要提供模型名称以搭配显示图表题！")
  }

  # 从小到大
  y <- data %>%
    as.data.frame(xy = T) %>%
    pull(x) %>%
    unique()
  # 从大到小
  x <- data %>%
    as.data.frame(xy = T) %>%
    pull(y) %>%
    unique()
  # 按照行顺序从左到右取值
  z <- data %>%
    getValues()
  dim(z) <- c(length(y), length(x))
  probability <- z

  # 元素凑齐
  plot_ly(
    type = "surface",
    contours = list(
      x = list(
        show = TRUE,
        # start = 1.5,
        # end = 2,
        size = 0.04, color = "white"
      ),
      z = list(
        show = TRUE,
        # start = 0.5,
        # end = 0.8,
        size = 0.05,
        show = TRUE,
        usecolormap = TRUE,
        highlightcolor = "#ff0000",
        project = list(z = TRUE)
      )
    ),
    x = ~x,
    y = ~y,
    z = ~z,
    color = ~probability
  ) %>%
    layout(
      title = paste0(toupper(model.name), ":3D map of snail infection risk in Shanghai"),
      scene = list(
        xaxis = list(title = "latitude", autorange = "reversed"),
        yaxis = list(title = "longitude"),
        zaxis = list(title = "probability"),
        aspectratio = list(x = .9, y = .8, z = 0.8)
        # camera=list(
        #   # eye = list(x=1.87, y=0.88, z=-0.64)
        #   )
      )
    )
}
# sh_plotly(data = sh_pred_layer$svm_prob,model.name = "svm")
```


尝试十几次，尝试方向主要集中在调整`x`、`y`、`z`三个坐标轴的顺序(利用`rev`函数实现)，然后在[stackoverflow](whttps://stackoverflow.com/questions/40643288/how-to-reverse-axis-values-when-using-plotly)检索到参数`autorange = "reversed"`，<s>耐心调试几次</s>竟然误打误撞实现了！

-   展示3D图尝试4


```r
library(rayshader)
sh_rayshader <- function(data) {
  
  ggvolcano <- data %>%
    as.data.frame(xy = T) %>%
    setNames(c("x", "y", "value")) %>%
    ggplot() +
    geom_tile(aes(x = x, y = y, fill = value)) +
    scale_x_continuous("longitude") +
    scale_y_continuous("latitude") +
    scale_fill_gradientn("probability", colours = terrain.colors(10)) +
    coord_fixed()

  plot_gg(ggvolcano,
    multicore = FALSE, raytrace = TRUE, width = 7, height = 4,
    scale = 300, windowsize = c(1400, 866), zoom = 0.6, phi = 30, theta = 30
  )
  
  Sys.sleep(0.2)

  render_snapshot(clear = TRUE)
}
sh_rayshader(data = sh_pred_layer$svm_prob)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-37-1.png" width="672" style="display: block; margin: auto;" />



对比上述几张图，明显最后一张图效果最好，因此接下来的模型预测都是在此基础上用打包好的函数绘图。


### 3.2 RF

-   10折交叉验证，3次重复


```r
# library(doParallel)
# cores <- makeCluster(detectCores() - 1)
# registerDoParallel(cores = cores)
# set.seed(1111)
```

Create control function for training with 10 folds and keep 3 folds for training. search method is grid.


```r
control <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 3,
  search = "grid",
  savePredictions = TRUE,
  classProbs = TRUE
)
```

Create tunegrid with 15 values from 1:15 for mtry to tunning model. Our train function will change number of entry variable at each split according to tunegrid.


```r
tunegrid <- expand.grid(.mtry = (1:15))

rf_model <- train(class ~ .,
  data = train,
  method = "rf",
  metric = "Kappa",
  trControl = control,
  tuneGrid = tunegrid
)
rf_model
```

```
#> Random Forest 
#> 
#> 677 samples
#>  18 predictor
#>   2 classes: 'X0', 'X1' 
#> 
#> No pre-processing
#> Resampling: Cross-Validated (10 fold, repeated 3 times) 
#> Summary of sample sizes: 609, 608, 609, 610, 610, 610, ... 
#> Resampling results across tuning parameters:
#> 
#>   mtry  Accuracy   Kappa    
#>    1    0.9468307  0.5501027
#>    2    0.9556909  0.6676583
#>    3    0.9542276  0.6660026
#>    4    0.9537374  0.6636755
#>    5    0.9542276  0.6699295
#>    6    0.9532472  0.6608422
#>    7    0.9532472  0.6608422
#>    8    0.9522595  0.6564429
#>    9    0.9527570  0.6631692
#>   10    0.9517693  0.6514860
#>   11    0.9512864  0.6524940
#>   12    0.9522668  0.6603706
#>   13    0.9517693  0.6582386
#>   14    0.9517693  0.6557343
#>   15    0.9517693  0.6592392
#> 
#> Kappa was used to select the optimal model using the largest value.
#> The final value used for the model was mtry = 5.
```

-   输出`Kappa`达到最大的模型参数


```r
rf_model$bestTune %>%
  kable()
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> mtry </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
</tbody>
</table>

-   输出模型评价指标

> [!Info]
> 输出`acc`、`kappa`、`ROC`、`ppv`等指标


```r
metric_table(rf_model) %>%
  beautify_metric_table(table = .)
```

<table class="table table-striped table-hover lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:left;"> Resample </th>
   <th style="text-align:left;"> acc </th>
   <th style="text-align:left;"> kappa </th>
   <th style="text-align:left;"> ROC </th>
   <th style="text-align:left;"> ppv </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Fold01.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.77</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.86</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.82</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.64</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.7</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.78</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.56</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.85</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.48</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.89</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.57</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.66</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.75</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.89</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold01.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.69</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.71</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.42</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.85</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.89</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.61</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.88</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.71</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.63</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.63</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.86</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.87</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.35</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.74</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold01.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.78</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.86</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.28</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.74</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.89</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.65</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.86</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.65</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep3 </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.99</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.92</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">1</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">1</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.69</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.42</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.57</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.54</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.89</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
</tbody>
</table>

-   混淆矩阵

10折交叉验证并且重复三次的结果如下(因为是平均所以会有非整数)


```r
confusionMatrix.train(rf_model)
```

```
#> Cross-Validated (10 fold, repeated 3 times) Confusion Matrix 
#> 
#> (entries are percentual average cell counts across resamples)
#>  
#>           Reference
#> Prediction   X0   X1
#>         X0 90.0  3.9
#>         X1  0.7  5.4
#>                             
#>  Accuracy (average) : 0.9542
```

-   最优参数预测的混淆矩阵.


```r
confusionMatrix(data = predict(rf_model, train), reference = train$class)
```

```
#> Confusion Matrix and Statistics
#> 
#>           Reference
#> Prediction  X0  X1
#>         X0 614   1
#>         X1   0  62
#>                                      
#>                Accuracy : 0.9985     
#>                  95% CI : (0.9918, 1)
#>     No Information Rate : 0.9069     
#>     P-Value [Acc > NIR] : <2e-16     
#>                                      
#>                   Kappa : 0.9912     
#>                                      
#>  Mcnemar's Test P-Value : 1          
#>                                      
#>             Sensitivity : 1.0000     
#>             Specificity : 0.9841     
#>          Pos Pred Value : 0.9984     
#>          Neg Pred Value : 1.0000     
#>              Prevalence : 0.9069     
#>          Detection Rate : 0.9069     
#>    Detection Prevalence : 0.9084     
#>       Balanced Accuracy : 0.9921     
#>                                      
#>        'Positive' Class : X0         
#> 
```

-   变量重要性

这里按照降序排列前若干个重要变量


```r
kable_var(rf_model, 6)
```

<table class="table lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:center;"> variables </th>
   <th style="text-align:right;"> importance </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> dst_waterway </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">100</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20164 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">90.2748</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aat0 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">87.6115</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aridity </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">82.4718</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20163 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">78.9473</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> pa </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">78.4767</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> landcover </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">74.8973</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20161 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">72.3714</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> im </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">71.954</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aat10 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">66.4832</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> night_time_lights </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">62.415</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20162 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">60.3525</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> slope </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">52.0924</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> dem </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">47.3467</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> hfp </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">44.9704</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> hii </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">36.8516</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> tadem </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">9.8137</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> landform </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0</span> </td>
  </tr>
</tbody>
</table>

这里按照降序绘制前若干个重要变量


```r
ggplot_var(rf_model, 6)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-46-1.png" width="672" style="display: block; margin: auto;" />

排名前六的变量分别是`aridity`、`im`、`aat0`、`pa`、`slope`、`aat10`

-   partial dependence plots

> [!Info]  
> 二维图形


```r
pdp_2d_one_predictor(model = rf_model, num = 6, ncol = 2)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-47-1.png" width="672" style="display: block; margin: auto;" />

> [!Info]
> 联合变量二维平面图形


```r
# pdp_2d_two_predictor(model = rf_model,num = 6,ncol = 3)
```

颜色越浅，数值越大。

-   预测测试集


```r
extractProb(list(rf_model), testX = test) %>%
  metrics_set(data = .) %>%
  kable("html", align = "cr", escape = FALSE) %>%
  kable_styling() %>%
  kableExtra::kable_classic()
```

<table class="table lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:center;"> metric </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> acc </td>
   <td style="text-align:right;"> 0.9985229 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> kap </td>
   <td style="text-align:right;"> 0.9911864 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ppv </td>
   <td style="text-align:right;"> 0.9983740 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> precision </td>
   <td style="text-align:right;"> 0.9983740 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> recall </td>
   <td style="text-align:right;"> 1.0000000 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> f_meas </td>
   <td style="text-align:right;"> 0.9991863 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> sensitivity </td>
   <td style="text-align:right;"> 1.0000000 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> detection_prevalence </td>
   <td style="text-align:right;"> 0.9084195 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> j_index </td>
   <td style="text-align:right;"> 0.9841270 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> npv </td>
   <td style="text-align:right;"> 1.0000000 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> specificity </td>
   <td style="text-align:right;"> 0.9841270 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> roc </td>
   <td style="text-align:right;"> 0.9999871 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> mn_log_loss </td>
   <td style="text-align:right;"> 0.0401361 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> pr_auc </td>
   <td style="text-align:right;"> 0.9999987 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> tss </td>
   <td style="text-align:right;"> 0.9841270 </td>
  </tr>
</tbody>
</table>

-   预测上海市


```r
sh_pred_layer <- pred_df(model = rf_model) %>%
  pred_layer(
    pred_df = .,
    model = rf_model,
    model.name = "rf"
  )
```

```
#> [1] "数据中变量个数符合要求"
#> [1] "数据中分类变量是二值型"
#> [1] "数据中二分类变量种类符合要求"
#> [1] "数据中预测概率值变量范围符合要求"
#> [1] "模型名称符合要求"
#> [1] "Path `./data/pred/caret` already exist!"
```

```r
sh_pred_layer
```

```
#> class      : RasterStack 
#> dimensions : 1362, 1260, 1716120, 2  (nrow, ncol, ncell, nlayers)
#> resolution : 0.0008333333, 0.0008333333  (x, y)
#> extent     : 120.8529, 121.9029, 30.70042, 31.83542  (xmin, xmax, ymin, ymax)
#> crs        : +proj=longlat +datum=WGS84 +no_defs 
#> names      : rf_bin, rf_prob 
#> min values :      0,       0 
#> max values :      1,       1
```

结果是符合我们要求的

-   上海市预测结果平面图


```r
sh_tmap(sh_pred_layer)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-51-1.png" width="672" style="display: block; margin: auto;" />

-   上海市预测结果立体图


```r
sh_rayshader(data = sh_pred_layer$rf_prob)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-52-1.png" width="672" style="display: block; margin: auto;" />


### 3.3 GBM

-   10折交叉验证，3次重复

Create control function for training with 10 folds and keep 3 folds for training. search method is grid.


```r
control <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 3,
  search = "grid",
  savePredictions = TRUE,
  classProbs = TRUE
)
set.seed(1111)

grid <- expand.grid(
  interaction.depth = c(1, 3, 5),
  n.trees = (0:50) * 50,
  shrinkage = c(0.01, 0.001),
  n.minobsinnode = 10
)

gbm_model <- train(class ~ .,
  data = train,
  # distribution = "binomial",
  # family = "binomial",
  method = "gbm",
  trControl = control,
  verbose = FALSE,
  tuneGrid = grid,
  metric = "Kappa",
  bag.fraction = 0.75
)
gbm_model %>% summary()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-53-1.png" width="672" style="display: block; margin: auto;" />

```
#>                                 var   rel.inf
#> ndvi20164                 ndvi20164 10.996897
#> dst_waterway           dst_waterway 10.828359
#> aat0                           aat0 10.423246
#> landcover                 landcover  9.476463
#> ndvi20163                 ndvi20163  8.464969
#> aridity                     aridity  7.434573
#> ndvi20161                 ndvi20161  7.371220
#> night_time_lights night_time_lights  6.661192
#> im                               im  6.118257
#> slope                         slope  4.882008
#> ndvi20162                 ndvi20162  4.708245
#> dem                             dem  2.841656
#> hii                             hii  2.689811
#> pa                               pa  2.601323
#> hfp                             hfp  2.373590
#> aat10                         aat10  2.128190
#> landform                   landform  0.000000
#> tadem                         tadem  0.000000
```

-   输出`Kappa`达到最大的模型参数


```r
gbm_model$bestTune %>%
  kable()
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> n.trees </th>
   <th style="text-align:right;"> interaction.depth </th>
   <th style="text-align:right;"> shrinkage </th>
   <th style="text-align:right;"> n.minobsinnode </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 284 </td>
   <td style="text-align:right;"> 1400 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 0.01 </td>
   <td style="text-align:right;"> 10 </td>
  </tr>
</tbody>
</table>

-   输出模型评价指标

> [!Info]
> 输出`acc`、`kappa`、`ROC`、`ppv`等指标


```r
metric_table(gbm_model) %>%
  beautify_metric_table(table = .)
```

<table class="table table-striped table-hover lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:left;"> Resample </th>
   <th style="text-align:left;"> acc </th>
   <th style="text-align:left;"> kappa </th>
   <th style="text-align:left;"> ROC </th>
   <th style="text-align:left;"> ppv </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Fold01.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.29</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.83</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.43</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.8</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.43</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.84</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.4</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.89</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.24</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.82</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.35</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.84</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.27</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.57</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.16</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.76</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.24</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.81</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold01.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.3</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.29</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.37</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.89</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.18</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.75</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.19</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.75</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.49</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep2 </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.95</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.55</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.97</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.48</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.32</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.77</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.22</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.76</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold01.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.44</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.87</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.25</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.83</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.43</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.88</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.38</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.86</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.3</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.83</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.42</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.2</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.78</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.36</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.84</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.39</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.24</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.82</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
</tbody>
</table>

-   混淆矩阵

10折交叉验证并且重复三次的结果如下(因为是平均所以会有非整数)


```r
confusionMatrix.train(gbm_model)
```

```
#> Cross-Validated (10 fold, repeated 3 times) Confusion Matrix 
#> 
#> (entries are percentual average cell counts across resamples)
#>  
#>           Reference
#> Prediction   X0   X1
#>         X0 89.9  3.4
#>         X1  0.8  5.9
#>                             
#>  Accuracy (average) : 0.9572
```

-   最优参数预测的混淆矩阵.


```r
confusionMatrix(data = predict(gbm_model, train), reference = train$class)
```

```
#> Confusion Matrix and Statistics
#> 
#>           Reference
#> Prediction  X0  X1
#>         X0 614   1
#>         X1   0  62
#>                                      
#>                Accuracy : 0.9985     
#>                  95% CI : (0.9918, 1)
#>     No Information Rate : 0.9069     
#>     P-Value [Acc > NIR] : <2e-16     
#>                                      
#>                   Kappa : 0.9912     
#>                                      
#>  Mcnemar's Test P-Value : 1          
#>                                      
#>             Sensitivity : 1.0000     
#>             Specificity : 0.9841     
#>          Pos Pred Value : 0.9984     
#>          Neg Pred Value : 1.0000     
#>              Prevalence : 0.9069     
#>          Detection Rate : 0.9069     
#>    Detection Prevalence : 0.9084     
#>       Balanced Accuracy : 0.9921     
#>                                      
#>        'Positive' Class : X0         
#> 
```

-   变量重要性

这里按照降序排列前若干个重要变量


```r
kable_var(gbm_model, 6)
```

<table class="table lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:center;"> variables </th>
   <th style="text-align:right;"> importance </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> ndvi20164 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">100</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> dst_waterway </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">98.4674</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aat0 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">94.7835</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> landcover </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">86.174</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20163 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">76.976</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aridity </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">67.6061</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20161 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">67.03</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> night_time_lights </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">60.5734</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> im </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">55.6362</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> slope </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">44.3944</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20162 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">42.8143</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> dem </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">25.8405</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> hii </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">24.4597</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> pa </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">23.6551</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> hfp </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">21.5842</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aat10 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">19.3526</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> landform </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> tadem </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0</span> </td>
  </tr>
</tbody>
</table>

这里按照降序绘制前若干个重要变量


```r
ggplot_var(gbm_model, 6)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-59-1.png" width="672" style="display: block; margin: auto;" />

排名前六的变量分别是`aridity`、`im`、`aat0`、`pa`、`slope`、`aat10`

-   partial dependence plots

> [!Info]
> 二维图形


```r
pdp_2d_one_predictor(model = gbm_model, num = 6, ncol = 2)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-60-1.png" width="672" style="display: block; margin: auto;" />

> [!Info]
> 联合变量二维平面图形


```r
# pdp_2d_two_predictor(model = gbm_model,num = 6,ncol = 3)
```

颜色越浅，数值越大。

-   预测测试集


```r
extractProb(list(gbm_model), testX = test) %>%
  metrics_set(data = .) %>%
  kable("html", align = "cr", escape = FALSE) %>%
  kable_styling() %>%
  kableExtra::kable_classic()
```

<table class="table lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:center;"> metric </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> acc </td>
   <td style="text-align:right;"> 0.9985229 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> kap </td>
   <td style="text-align:right;"> 0.9911864 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ppv </td>
   <td style="text-align:right;"> 0.9983740 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> precision </td>
   <td style="text-align:right;"> 0.9983740 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> recall </td>
   <td style="text-align:right;"> 1.0000000 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> f_meas </td>
   <td style="text-align:right;"> 0.9991863 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> sensitivity </td>
   <td style="text-align:right;"> 1.0000000 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> detection_prevalence </td>
   <td style="text-align:right;"> 0.9084195 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> j_index </td>
   <td style="text-align:right;"> 0.9841270 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> npv </td>
   <td style="text-align:right;"> 1.0000000 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> specificity </td>
   <td style="text-align:right;"> 0.9841270 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> roc </td>
   <td style="text-align:right;"> 0.9999871 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> mn_log_loss </td>
   <td style="text-align:right;"> 0.0221276 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> pr_auc </td>
   <td style="text-align:right;"> 0.9999987 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> tss </td>
   <td style="text-align:right;"> 0.9841270 </td>
  </tr>
</tbody>
</table>

-   预测上海市


```r
sh_pred_layer <- pred_df(model = gbm_model) %>%
  pred_layer(
    pred_df = .,
    model = gbm_model,
    model.name = "gbm"
  )
```

```
#> [1] "数据中变量个数符合要求"
#> [1] "数据中分类变量是二值型"
#> [1] "数据中二分类变量种类符合要求"
#> [1] "数据中预测概率值变量范围符合要求"
#> [1] "模型名称符合要求"
#> [1] "Path `./data/pred/caret` already exist!"
```

```r
sh_pred_layer
```

```
#> class      : RasterStack 
#> dimensions : 1362, 1260, 1716120, 2  (nrow, ncol, ncell, nlayers)
#> resolution : 0.0008333333, 0.0008333333  (x, y)
#> extent     : 120.8529, 121.9029, 30.70042, 31.83542  (xmin, xmax, ymin, ymax)
#> crs        : +proj=longlat +datum=WGS84 +no_defs 
#> names      :      gbm_bin,     gbm_prob 
#> min values : 0.0000000000, 0.0003167383 
#> max values :    1.0000000,    0.9866382
```


-   上海市预测结果平面图


```r
sh_tmap(sh_pred_layer)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-64-1.png" width="672" style="display: block; margin: auto;" />

-   上海市预测结果立体图


```r
sh_rayshader(data = sh_pred_layer$gbm_prob)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-65-1.png" width="672" style="display: block; margin: auto;" />

### 3.4 GLM

使用`binomial`分布

-   10折交叉验证，3次重复


```r
set.seed(1111)

glm_model <- train(class ~ .,
  data = train,
  # family = "binomial",
  method = "glm",
  trControl = control,
  # verbose=FALSE,
  metric = "Kappa"
)
glm_model
```

```
#> Generalized Linear Model 
#> 
#> 677 samples
#>  18 predictor
#>   2 classes: 'X0', 'X1' 
#> 
#> No pre-processing
#> Resampling: Cross-Validated (10 fold, repeated 3 times) 
#> Summary of sample sizes: 610, 609, 609, 609, 610, 610, ... 
#> Resampling results:
#> 
#>   Accuracy  Kappa    
#>   0.900563  0.1029995
```

-   输出`Kappa`达到最大的模型参数


```r
glm_model$bestTune %>%
  kable()
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> parameter </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> none </td>
  </tr>
</tbody>
</table>

-   输出模型评价指标

> [!Info]
> 输出`acc`、`kappa`、`ROC`、`ppv`等指标


```r
metric_table(glm_model) %>%
  beautify_metric_table(table = .)
```

<table class="table table-striped table-hover lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:left;"> Resample </th>
   <th style="text-align:left;"> acc </th>
   <th style="text-align:left;"> kappa </th>
   <th style="text-align:left;"> ROC </th>
   <th style="text-align:left;"> ppv </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Fold01.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">-0.03</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.77</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep1 </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.94</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.57</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.79</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.22</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.85</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.88</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">-0.03</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.85</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">-0.03</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.78</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.21</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.8</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">-0.03</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.69</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.17</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.85</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.85</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">-0.08</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.81</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.81</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold01.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.78</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">-0.03</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.85</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.27</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.72</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.88</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.14</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.77</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.21</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.81</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.17</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.27</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.79</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.88</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">-0.03</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.75</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.31</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.71</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold01.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.74</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.79</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.27</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.83</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.88</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.14</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.7</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.27</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.88</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.17</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.84</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.88</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">-0.05</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.69</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.88</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">-0.03</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.87</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.81</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
  </tr>
</tbody>
</table>

-   混淆矩阵

10折交叉验证并且重复三次的结果如下(因为是平均所以会有非整数)


```r
confusionMatrix.train(glm_model)
```

```
#> Cross-Validated (10 fold, repeated 3 times) Confusion Matrix 
#> 
#> (entries are percentual average cell counts across resamples)
#>  
#>           Reference
#> Prediction   X0   X1
#>         X0 89.2  8.5
#>         X1  1.5  0.8
#>                             
#>  Accuracy (average) : 0.9005
```

-   最优参数预测的混淆矩阵.


```r
confusionMatrix(data = predict(glm_model, train), reference = train$class)
```

```
#> Confusion Matrix and Statistics
#> 
#>           Reference
#> Prediction  X0  X1
#>         X0 608  54
#>         X1   6   9
#>                                           
#>                Accuracy : 0.9114          
#>                  95% CI : (0.8874, 0.9317)
#>     No Information Rate : 0.9069          
#>     P-Value [Acc > NIR] : 0.3765          
#>                                           
#>                   Kappa : 0.2022          
#>                                           
#>  Mcnemar's Test P-Value : 1.298e-09       
#>                                           
#>             Sensitivity : 0.9902          
#>             Specificity : 0.1429          
#>          Pos Pred Value : 0.9184          
#>          Neg Pred Value : 0.6000          
#>              Prevalence : 0.9069          
#>          Detection Rate : 0.8981          
#>    Detection Prevalence : 0.9778          
#>       Balanced Accuracy : 0.5665          
#>                                           
#>        'Positive' Class : X0              
#> 
```

-   变量重要性

这里按照降序排列前若干个重要变量


```r
kable_var(glm_model, 6)
```

<table class="table lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:center;"> variables </th>
   <th style="text-align:right;"> importance </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> landcover </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">100</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> night_time_lights </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">69.2329</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> dst_waterway </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">67.4276</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aat0 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">59.6127</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aat10 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">50.6494</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20161 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">45.8947</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20163 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">41.7176</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20162 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">41.66</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> pa </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">41.4997</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aridity </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">35.375</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> im </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">33.0874</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> hfp </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">23.0317</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> hii </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">13.5654</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20164 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">10.017</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> slope </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">6.0015</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> dem </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">2.5212</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> tadem </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">1.3197</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> landform </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0</span> </td>
  </tr>
</tbody>
</table>

这里按照降序绘制前若干个重要变量


```r
ggplot_var(glm_model, 6)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-72-1.png" width="672" style="display: block; margin: auto;" />

排名前六的变量分别是`aridity`、`im`、`aat0`、`pa`、`slope`、`aat10`

-   partial dependence plots

> [!Info]
> 二维图形


```r
pdp_2d_one_predictor(model = glm_model, num = 6, ncol = 2)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-73-1.png" width="672" style="display: block; margin: auto;" />

> [!Info]
> 联合变量二维平面图形


```r
# pdp_2d_two_predictor(model = glm_model,num = 6,ncol = 3)
```

颜色越浅，数值越大。

-   预测测试集


```r
extractProb(list(glm_model), testX = test) %>%
  metrics_set(data = .) %>%
  kable("html", align = "cr", escape = FALSE) %>%
  kable_styling() %>%
  kableExtra::kable_classic()
```

<table class="table lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:center;"> metric </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> acc </td>
   <td style="text-align:right;"> 0.9113737 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> kap </td>
   <td style="text-align:right;"> 0.2022154 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ppv </td>
   <td style="text-align:right;"> 0.9184290 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> precision </td>
   <td style="text-align:right;"> 0.9184290 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> recall </td>
   <td style="text-align:right;"> 0.9902280 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> f_meas </td>
   <td style="text-align:right;"> 0.9529781 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> sensitivity </td>
   <td style="text-align:right;"> 0.9902280 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> detection_prevalence </td>
   <td style="text-align:right;"> 0.9778434 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> j_index </td>
   <td style="text-align:right;"> 0.1330852 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> npv </td>
   <td style="text-align:right;"> 0.6000000 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> specificity </td>
   <td style="text-align:right;"> 0.1428571 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> roc </td>
   <td style="text-align:right;"> 0.8470477 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> mn_log_loss </td>
   <td style="text-align:right;"> 0.2345523 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> pr_auc </td>
   <td style="text-align:right;"> 0.9807124 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> tss </td>
   <td style="text-align:right;"> 0.1330852 </td>
  </tr>
</tbody>
</table>

-   预测上海市


```r
sh_pred_layer <- pred_df(model = glm_model) %>%
  pred_layer(
    pred_df = .,
    model = glm_model,
    model.name = "glm"
  )
```

```
#> [1] "数据中变量个数符合要求"
#> [1] "数据中分类变量是二值型"
#> [1] "数据中二分类变量种类符合要求"
#> [1] "数据中预测概率值变量范围符合要求"
#> [1] "模型名称符合要求"
#> [1] "Path `./data/pred/caret` already exist!"
```

```r
sh_pred_layer
```

```
#> class      : RasterStack 
#> dimensions : 1362, 1260, 1716120, 2  (nrow, ncol, ncell, nlayers)
#> resolution : 0.0008333333, 0.0008333333  (x, y)
#> extent     : 120.8529, 121.9029, 30.70042, 31.83542  (xmin, xmax, ymin, ymax)
#> crs        : +proj=longlat +datum=WGS84 +no_defs 
#> names      :      glm_bin,     glm_prob 
#> min values : 0.000000e+00, 2.220446e-16 
#> max values :            1,            1
```


-   上海市预测结果平面图


```r
sh_tmap(sh_pred_layer)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-77-1.png" width="672" style="display: block; margin: auto;" />

-   上海市预测结果立体图


```r
sh_rayshader(data = sh_pred_layer$glm_prob)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-78-1.png" width="672" style="display: block; margin: auto;" />


### 3.5 NB

-   10折交叉验证，3次重复


```r
set.seed(1111)

nb_model <- train(class ~ .,
  data = train,
  # family = "binomial",
  method = "naive_bayes",
  trControl = control,
  # verbose=FALSE,
  metric = "Kappa"
)
nb_model
```

```
#> Naive Bayes 
#> 
#> 677 samples
#>  18 predictor
#>   2 classes: 'X0', 'X1' 
#> 
#> No pre-processing
#> Resampling: Cross-Validated (10 fold, repeated 3 times) 
#> Summary of sample sizes: 610, 609, 609, 609, 610, 610, ... 
#> Resampling results across tuning parameters:
#> 
#>   usekernel  Accuracy   Kappa    
#>   FALSE      0.5064561  0.1336051
#>    TRUE      0.8686446  0.2973453
#> 
#> Tuning parameter 'laplace' was held constant at a value of 0
#> Tuning
#>  parameter 'adjust' was held constant at a value of 1
#> Kappa was used to select the optimal model using the largest value.
#> The final values used for the model were laplace = 0, usekernel = TRUE
#>  and adjust = 1.
```

-   输出`Kappa`达到最大的模型参数


```r
nb_model$bestTune %>%
  kable()
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> laplace </th>
   <th style="text-align:left;"> usekernel </th>
   <th style="text-align:right;"> adjust </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:left;"> TRUE </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
</tbody>
</table>

-   输出模型评价指标

> [!Info]
> 输出`acc`、`kappa`、`ROC`、`ppv`等指标


```r
metric_table(nb_model) %>%
  beautify_metric_table(table = .)
```

<table class="table table-striped table-hover lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:left;"> Resample </th>
   <th style="text-align:left;"> acc </th>
   <th style="text-align:left;"> kappa </th>
   <th style="text-align:left;"> ROC </th>
   <th style="text-align:left;"> ppv </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Fold01.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.65</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.13</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.72</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.76</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.27</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.77</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.66</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.16</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.73</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.73</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.26</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.79</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.72</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.18</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.73</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.7</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.25</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.8</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.99</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.72</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.18</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.81</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.69</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.21</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.78</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.62</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.08</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.69</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.68</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.13</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.76</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold01.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.69</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.13</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.74</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.65</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.13</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.75</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.68</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.21</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.79</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.68</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.12</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.72</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.66</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.13</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.71</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.69</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.23</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.79</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.99</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.72</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.24</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.8</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.72</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.21</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.76</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.63</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.14</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.72</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.72</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.16</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.77</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold01.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.69</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.18</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.77</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep3 </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.78</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.26</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.79</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.66</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.18</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.74</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.68</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.15</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.76</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.74</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.2</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.79</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.68</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.15</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.75</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.66</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.11</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.69</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.68</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.16</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.72</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.67</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.14</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.8</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.64</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.12</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.74</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
</tbody>
</table>

-   混淆矩阵

10折交叉验证并且重复三次的结果如下(因为是平均所以会有非整数)


```r
confusionMatrix.train(nb_model)
```

```
#> Cross-Validated (10 fold, repeated 3 times) Confusion Matrix 
#> 
#> (entries are percentual average cell counts across resamples)
#>  
#>           Reference
#> Prediction   X0   X1
#>         X0 83.0  5.5
#>         X1  7.7  3.8
#>                             
#>  Accuracy (average) : 0.8685
```

-   最优参数预测的混淆矩阵.


```r
confusionMatrix(data = predict(nb_model, train), reference = train$class)
```

```
#> Confusion Matrix and Statistics
#> 
#>           Reference
#> Prediction  X0  X1
#>         X0 565  28
#>         X1  49  35
#>                                           
#>                Accuracy : 0.8863          
#>                  95% CI : (0.8599, 0.9092)
#>     No Information Rate : 0.9069          
#>     P-Value [Acc > NIR] : 0.96962         
#>                                           
#>                   Kappa : 0.4139          
#>                                           
#>  Mcnemar's Test P-Value : 0.02265         
#>                                           
#>             Sensitivity : 0.9202          
#>             Specificity : 0.5556          
#>          Pos Pred Value : 0.9528          
#>          Neg Pred Value : 0.4167          
#>              Prevalence : 0.9069          
#>          Detection Rate : 0.8346          
#>    Detection Prevalence : 0.8759          
#>       Balanced Accuracy : 0.7379          
#>                                           
#>        'Positive' Class : X0              
#> 
```

-   变量重要性

这里按照降序排列前若干个重要变量


```r
kable_var(nb_model, 6)
```

<table class="table lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:center;"> variables </th>
   <th style="text-align:right;"> importance </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> ndvi20162 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">100</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> night_time_lights </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">93.5946</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20164 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">92.5634</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20161 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">88.1718</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aridity </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">79.6676</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> im </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">79.3643</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> pa </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">78.5515</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20163 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">70.5326</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> hfp </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">45.6387</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> dst_waterway </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">41.423</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> hii </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">37.5227</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> landcover </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">28.3695</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> dem </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">16.7779</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aat10 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">10.609</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> tadem </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">8.4739</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> landform </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">1.2435</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> slope </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.8613</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aat0 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0</span> </td>
  </tr>
</tbody>
</table>

这里按照降序绘制前若干个重要变量


```r
ggplot_var(nb_model, 6)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-85-1.png" width="672" style="display: block; margin: auto;" />

排名前六的变量分别是`aridity`、`im`、`aat0`、`pa`、`slope`、`aat10`

-   partial dependence plots

> [!Info]
> 二维图形


```r
pdp_2d_one_predictor(model = nb_model, num = 6, ncol = 2)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-86-1.png" width="672" style="display: block; margin: auto;" />

> [!Info]
> 联合变量二维平面图形


```r
# pdp_2d_two_predictor(model = nb_model,num = 6,ncol = 3)
```

颜色越浅，数值越大。

-   预测测试集


```r
extractProb(list(nb_model), testX = test) %>%
  metrics_set(data = .) %>%
  kable("html", align = "cr", escape = FALSE) %>%
  kable_styling() %>%
  kableExtra::kable_classic()
```

<table class="table lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:center;"> metric </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> acc </td>
   <td style="text-align:right;"> 0.8862629 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> kap </td>
   <td style="text-align:right;"> 0.4138528 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ppv </td>
   <td style="text-align:right;"> 0.9527825 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> precision </td>
   <td style="text-align:right;"> 0.9527825 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> recall </td>
   <td style="text-align:right;"> 0.9201954 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> f_meas </td>
   <td style="text-align:right;"> 0.9362055 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> sensitivity </td>
   <td style="text-align:right;"> 0.9201954 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> detection_prevalence </td>
   <td style="text-align:right;"> 0.8759232 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> j_index </td>
   <td style="text-align:right;"> 0.4757510 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> npv </td>
   <td style="text-align:right;"> 0.4166667 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> specificity </td>
   <td style="text-align:right;"> 0.5555556 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> roc </td>
   <td style="text-align:right;"> 0.8950804 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> mn_log_loss </td>
   <td style="text-align:right;"> 0.2671428 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> pr_auc </td>
   <td style="text-align:right;"> 0.9879440 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> tss </td>
   <td style="text-align:right;"> 0.4757510 </td>
  </tr>
</tbody>
</table>

-   预测上海市


```r
sh_pred_layer <- pred_df(model = nb_model) %>%
  pred_layer(
    pred_df = .,
    model = nb_model,
    model.name = "nb"
  )
```

```
#> [1] "数据中变量个数符合要求"
#> [1] "数据中分类变量是二值型"
#> [1] "数据中二分类变量种类符合要求"
#> [1] "数据中预测概率值变量范围符合要求"
#> [1] "模型名称符合要求"
#> [1] "Path `./data/pred/caret` already exist!"
```

```r
sh_pred_layer
```

```
#> class      : RasterStack 
#> dimensions : 1362, 1260, 1716120, 2  (nrow, ncol, ncell, nlayers)
#> resolution : 0.0008333333, 0.0008333333  (x, y)
#> extent     : 120.8529, 121.9029, 30.70042, 31.83542  (xmin, xmax, ymin, ymax)
#> crs        : +proj=longlat +datum=WGS84 +no_defs 
#> names      :       nb_bin,      nb_prob 
#> min values : 0.000000e+00, 2.030353e-28 
#> max values :            1,            1
```


-   上海市预测结果平面图


```r
sh_tmap(sh_pred_layer)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-90-1.png" width="672" style="display: block; margin: auto;" />

-   上海市预测结果立体图


```r
sh_rayshader(data = sh_pred_layer$nb_prob)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-91-1.png" width="672" style="display: block; margin: auto;" />



### 3.6 KNN

-   10折交叉验证，3次重复


```r
set.seed(1111)

knn_model <- train(class ~ .,
  data = train,
  method = "knn",
  trControl = control,
  metric = "Kappa"
)
knn_model
```

```
#> k-Nearest Neighbors 
#> 
#> 677 samples
#>  18 predictor
#>   2 classes: 'X0', 'X1' 
#> 
#> No pre-processing
#> Resampling: Cross-Validated (10 fold, repeated 3 times) 
#> Summary of sample sizes: 610, 609, 609, 609, 610, 610, ... 
#> Resampling results across tuning parameters:
#> 
#>   k  Accuracy   Kappa    
#>   5  0.9099859  0.4481234
#>   7  0.9025673  0.3478303
#>   9  0.8976862  0.2622336
#> 
#> Kappa was used to select the optimal model using the largest value.
#> The final value used for the model was k = 5.
```

-   输出`Kappa`达到最大的模型参数


```r
knn_model$bestTune %>%
  kable()
```

<table>
 <thead>
  <tr>
   <th style="text-align:right;"> k </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 5 </td>
  </tr>
</tbody>
</table>

-   输出模型评价指标

> [!Info]
> 输出`acc`、`kappa`、`ROC`、`ppv`等指标


```r
metric_table(knn_model) %>%
  beautify_metric_table(table = .)
```

<table class="table table-striped table-hover lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:left;"> Resample </th>
   <th style="text-align:left;"> acc </th>
   <th style="text-align:left;"> kappa </th>
   <th style="text-align:left;"> ROC </th>
   <th style="text-align:left;"> ppv </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Fold01.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.39</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.87</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.88</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.36</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.71</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.51</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.86</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.48</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.08</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.84</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.88</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.23</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.86</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.37</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.86</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.57</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.88</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.39</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.76</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.89</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.3</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.77</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold01.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.45</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.41</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.87</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.38</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.32</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.83</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.89</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.15</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.69</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.41</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep2 </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.96</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.7</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.97</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.97</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.47</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.87</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.34</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.8</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.86</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.11</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.74</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold01.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.42</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.89</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.17</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.83</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.31</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.88</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.08</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.79</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.89</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.42</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.87</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.57</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.22</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.84</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.87</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.25</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.83</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.45</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.89</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.44</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.74</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
</tbody>
</table>

-   混淆矩阵

10折交叉验证并且重复三次的结果如下(因为是平均所以会有非整数)


```r
confusionMatrix.train(knn_model)
```

```
#> Cross-Validated (10 fold, repeated 3 times) Confusion Matrix 
#> 
#> (entries are percentual average cell counts across resamples)
#>  
#>           Reference
#> Prediction   X0   X1
#>         X0 86.5  4.8
#>         X1  4.2  4.5
#>                             
#>  Accuracy (average) : 0.9099
```

-   最优参数预测的混淆矩阵.


```r
# confusionMatrix(data = predict(knn_model,train),reference = train$class)
```

-   变量重要性

这里按照降序排列前若干个重要变量


```r
kable_var(knn_model, 6)
```

<table class="table lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:center;"> variables </th>
   <th style="text-align:right;"> importance </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> ndvi20162 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">100</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> night_time_lights </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">93.5946</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20164 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">92.5634</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20161 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">88.1718</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aridity </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">79.6676</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> im </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">79.3643</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> pa </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">78.5515</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20163 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">70.5326</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> hfp </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">45.6387</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> dst_waterway </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">41.423</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> hii </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">37.5227</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> landcover </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">28.3695</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> dem </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">16.7779</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aat10 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">10.609</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> tadem </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">8.4739</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> landform </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">1.2435</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> slope </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.8613</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aat0 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0</span> </td>
  </tr>
</tbody>
</table>

这里按照降序绘制前若干个重要变量


```r
ggplot_var(knn_model, 6)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-98-1.png" width="672" style="display: block; margin: auto;" />

排名前六的变量分别是`im`、`pa`、`aridity`、`ndvi20162`、`ndvi20163`、`ndvi20164`

-   partial dependence plots

> [!Info]
> 二维图形


```r
pdp_2d_one_predictor(model = knn_model, num = 6, ncol = 2)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-99-1.png" width="672" style="display: block; margin: auto;" />

> [!Info]
> 联合变量二维平面图形


```r
# pdp_2d_two_predictor(model = knn_model,num = 6,ncol = 3)
```

颜色越浅，数值越大。

-   预测测试集


```r
extractProb(list(knn_model), testX = test) %>%
  metrics_set(data = .) %>%
  kable("html", align = "cr", escape = FALSE) %>%
  kable_styling() %>%
  kableExtra::kable_classic()
```

<table class="table lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:center;"> metric </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> acc </td>
   <td style="text-align:right;"> 0.9394387 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> kap </td>
   <td style="text-align:right;"> 0.6333822 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ppv </td>
   <td style="text-align:right;"> 0.9643436 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> precision </td>
   <td style="text-align:right;"> 0.9643436 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> recall </td>
   <td style="text-align:right;"> 0.9690554 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> f_meas </td>
   <td style="text-align:right;"> 0.9666937 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> sensitivity </td>
   <td style="text-align:right;"> 0.9690554 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> detection_prevalence </td>
   <td style="text-align:right;"> 0.9113737 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> j_index </td>
   <td style="text-align:right;"> 0.6198490 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> npv </td>
   <td style="text-align:right;"> 0.6833333 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> specificity </td>
   <td style="text-align:right;"> 0.6507937 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> roc </td>
   <td style="text-align:right;"> 0.9632387 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> mn_log_loss </td>
   <td style="text-align:right;"> 0.1262588 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> pr_auc </td>
   <td style="text-align:right;"> 0.9962119 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> tss </td>
   <td style="text-align:right;"> 0.6198490 </td>
  </tr>
</tbody>
</table>

-   预测上海市


```r
sh_pred_layer <- pred_df(model = knn_model) %>%
  pred_layer(
    pred_df = .,
    model = knn_model,
    model.name = "knn"
  )
```

```
#> [1] "数据中变量个数符合要求"
#> [1] "数据中分类变量是二值型"
#> [1] "数据中二分类变量种类符合要求"
#> [1] "数据中预测概率值变量范围符合要求"
#> [1] "模型名称符合要求"
#> [1] "Path `./data/pred/caret` already exist!"
```

```r
sh_pred_layer
```

```
#> class      : RasterStack 
#> dimensions : 1362, 1260, 1716120, 2  (nrow, ncol, ncell, nlayers)
#> resolution : 0.0008333333, 0.0008333333  (x, y)
#> extent     : 120.8529, 121.9029, 30.70042, 31.83542  (xmin, xmax, ymin, ymax)
#> crs        : +proj=longlat +datum=WGS84 +no_defs 
#> names      : knn_bin, knn_prob 
#> min values :       0,        0 
#> max values :       1,        1
```

-   上海市预测结果平面图


```r
sh_tmap(sh_pred_layer)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-103-1.png" width="672" style="display: block; margin: auto;" />

-   上海市预测结果立体图


```r
sh_rayshader(data = sh_pred_layer$knn_prob)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-104-1.png" width="672" style="display: block; margin: auto;" />



### 3.7 C5.0

-   10折交叉验证，3次重复


```r
set.seed(1111)

grid <- expand.grid(.winnow = c(TRUE, FALSE), .trials = c(1, 5, 10, 15, 20), .model = "tree")

C5.0_model <- train(class ~ .,
  data = train,
  tuneGrid = grid,
  method = "C5.0",
  trControl = control,
  metric = "Kappa"
)
# C5.0_model %>% summary()
```

-   输出`Kappa`达到最大的模型参数


```r
C5.0_model$bestTune %>%
  kable()
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> trials </th>
   <th style="text-align:left;"> model </th>
   <th style="text-align:left;"> winnow </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:left;"> tree </td>
   <td style="text-align:left;"> FALSE </td>
  </tr>
</tbody>
</table>

-   输出模型评价指标

> [!Info]
> 输出`acc`、`kappa`、`ROC`、`ppv`等指标


```r
metric_table(C5.0_model) %>%
  beautify_metric_table(table = .)
```

<table class="table table-striped table-hover lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:left;"> Resample </th>
   <th style="text-align:left;"> acc </th>
   <th style="text-align:left;"> kappa </th>
   <th style="text-align:left;"> ROC </th>
   <th style="text-align:left;"> ppv </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Fold01.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.45</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.56</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.73</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.66</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.89</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.73</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.51</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.81</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.56</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.64</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.7</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.26</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.72</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.4</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.82</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold01.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.45</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.56</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.59</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.89</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.35</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.79</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.34</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.72</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.85</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.99</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.72</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep2 </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.99</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.95</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.99</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.99</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.53</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.83</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.29</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.7</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold01.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.72</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.62</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.67</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.47</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.63</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.88</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.45</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.76</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.29</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.72</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.69</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.89</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.77</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.48</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.86</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
</tbody>
</table>

-   混淆矩阵

10折交叉验证并且重复三次的结果如下(因为是平均所以会有非整数)


```r
confusionMatrix.train(C5.0_model)
```

```
#> Cross-Validated (10 fold, repeated 3 times) Confusion Matrix 
#> 
#> (entries are percentual average cell counts across resamples)
#>  
#>           Reference
#> Prediction   X0   X1
#>         X0 89.9  3.6
#>         X1  0.8  5.7
#>                             
#>  Accuracy (average) : 0.9562
```

-   最优参数预测的混淆矩阵.


```r
# confusionMatrix(data = predict(C5.0_model,train),reference = train$class)
```

-   变量重要性

这里按照降序排列前若干个重要变量


```r
kable_var(C5.0_model, 6)
```

<table class="table lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:center;"> variables </th>
   <th style="text-align:right;"> importance </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> aat0 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">100</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aridity </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">100</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> dem </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">100</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> im </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">100</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> night_time_lights </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">100</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> slope </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">100</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20162 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">96.6</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> landcover </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">79.17</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aat10 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">78.14</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> pa </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">77.4</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20164 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">75.63</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20161 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">75.04</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20163 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">74.3</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> dst_waterway </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">73.41</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> hfp </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">63.37</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> hii </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">59.08</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> tadem </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">18.32</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> landform </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0</span> </td>
  </tr>
</tbody>
</table>

这里按照降序绘制前若干个重要变量


```r
ggplot_var(C5.0_model, 6)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-111-1.png" width="672" style="display: block; margin: auto;" />

排名前六的变量分别是`ndvi20163`、`ndvi20162`、`im`、`dst_waterway`、`aridity`、`aat10`

-   partial dependence plots

> [!Info]
> 二维图形


```r
pdp_2d_one_predictor(model = C5.0_model, num = 6, ncol = 2)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-112-1.png" width="672" style="display: block; margin: auto;" />

> [!Info]
> 联合变量二维平面图形


```r
# pdp_2d_two_predictor(model = C5.0_model,num = 6,ncol = 3)
```

颜色越浅，数值越大。

-   预测测试集


```r
extractProb(list(C5.0_model), testX = test) %>%
  metrics_set(data = .) %>%
  kable("html", align = "cr", escape = FALSE) %>%
  kable_styling() %>%
  kableExtra::kable_classic()
```

<table class="table lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:center;"> metric </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> acc </td>
   <td style="text-align:right;"> 0.9985229 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> kap </td>
   <td style="text-align:right;"> 0.9911864 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ppv </td>
   <td style="text-align:right;"> 0.9983740 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> precision </td>
   <td style="text-align:right;"> 0.9983740 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> recall </td>
   <td style="text-align:right;"> 1.0000000 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> f_meas </td>
   <td style="text-align:right;"> 0.9991863 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> sensitivity </td>
   <td style="text-align:right;"> 1.0000000 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> detection_prevalence </td>
   <td style="text-align:right;"> 0.9084195 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> j_index </td>
   <td style="text-align:right;"> 0.9841270 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> npv </td>
   <td style="text-align:right;"> 1.0000000 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> specificity </td>
   <td style="text-align:right;"> 0.9841270 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> roc </td>
   <td style="text-align:right;"> 0.9999871 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> mn_log_loss </td>
   <td style="text-align:right;"> 0.0654234 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> pr_auc </td>
   <td style="text-align:right;"> 0.9999987 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> tss </td>
   <td style="text-align:right;"> 0.9841270 </td>
  </tr>
</tbody>
</table>

-   预测上海市


```r
sh_pred_layer <- pred_df(model = C5.0_model) %>%
  pred_layer(
    pred_df = .,
    model = C5.0_model,
    model.name = "C5.0"
  )
```

```
#> [1] "数据中变量个数符合要求"
#> [1] "数据中分类变量是二值型"
#> [1] "数据中二分类变量种类符合要求"
#> [1] "数据中预测概率值变量范围符合要求"
#> [1] "模型名称符合要求"
#> [1] "Path `./data/pred/caret` already exist!"
```

```r
sh_pred_layer
```

```
#> class      : RasterStack 
#> dimensions : 1362, 1260, 1716120, 2  (nrow, ncol, ncell, nlayers)
#> resolution : 0.0008333333, 0.0008333333  (x, y)
#> extent     : 120.8529, 121.9029, 30.70042, 31.83542  (xmin, xmax, ymin, ymax)
#> crs        : +proj=longlat +datum=WGS84 +no_defs 
#> names      :  C5.0_bin, C5.0_prob 
#> min values :         0,         0 
#> max values : 1.0000000, 0.9124891
```


-   上海市预测结果平面图


```r
sh_tmap(sh_pred_layer)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-116-1.png" width="672" style="display: block; margin: auto;" />

-   上海市预测结果立体图


```r
sh_rayshader(data = sh_pred_layer$C5.0_prob)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-117-1.png" width="672" style="display: block; margin: auto;" />


### 3.8 AdaBoost.M1

-   10折交叉验证，3次重复


```r
set.seed(1111)
grid <- expand.grid(
  mfinal = (1:3) * 3,
  maxdepth = c(1, 3),
  coeflearn = c("Breiman", "Freund", "Zhu")
)
AdaBoost.M1_model <- train(class ~ .,
  data = train,
  tuneGrid = grid,
  method = "AdaBoost.M1",
  trControl = control,
  preProc = c("center", "scale"),
  metric = "Kappa"
)
# AdaBoost.M1_model %>% summary()
```

-   输出`Kappa`达到最大的模型参数


```r
AdaBoost.M1_model$bestTune %>%
  kable()
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> mfinal </th>
   <th style="text-align:right;"> maxdepth </th>
   <th style="text-align:left;"> coeflearn </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> Freund </td>
  </tr>
</tbody>
</table>

-   输出模型评价指标

> [!Info]
> 输出`acc`、`kappa`、`ROC`、`ppv`等指标


```r
metric_table(AdaBoost.M1_model) %>%
  beautify_metric_table(table = .)
```

<table class="table table-striped table-hover lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:left;"> Resample </th>
   <th style="text-align:left;"> acc </th>
   <th style="text-align:left;"> kappa </th>
   <th style="text-align:left;"> ROC </th>
   <th style="text-align:left;"> ppv </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Fold01.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.14</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.73</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.35</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.76</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.28</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.8</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.3</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.82</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.24</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.76</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.24</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.8</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.2</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.82</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.37</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.84</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.15</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.63</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.89</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.19</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.77</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold01.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.27</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.8</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.22</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.8</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.25</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.82</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.11</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.72</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.89</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.17</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.72</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.35</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.83</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep2 </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.93</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.47</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.86</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep2 </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.38</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.87</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.89</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.23</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.73</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.88</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.2</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.76</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold01.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.37</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.84</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.18</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.77</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.31</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.82</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.21</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.81</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.28</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.8</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.35</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.83</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.19</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.73</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.29</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.77</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.24</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.87</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.89</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.24</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.74</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
</tbody>
</table>

-   混淆矩阵

10折交叉验证并且重复三次的结果如下(因为是平均所以会有非整数)


```r
confusionMatrix.train(AdaBoost.M1_model)
```

```
#> Cross-Validated (10 fold, repeated 3 times) Confusion Matrix 
#> 
#> (entries are percentual average cell counts across resamples)
#>  
#>           Reference
#> Prediction   X0   X1
#>         X0 87.0  4.1
#>         X1  3.7  5.2
#>                             
#>  Accuracy (average) : 0.9217
```

-   最优参数预测的混淆矩阵.


```r
confusionMatrix(data = predict(AdaBoost.M1_model, train), reference = train$class)
```

```
#> Confusion Matrix and Statistics
#> 
#>           Reference
#> Prediction  X0  X1
#>         X0 610  10
#>         X1   4  53
#>                                           
#>                Accuracy : 0.9793          
#>                  95% CI : (0.9655, 0.9886)
#>     No Information Rate : 0.9069          
#>     P-Value [Acc > NIR] : 1.462e-14       
#>                                           
#>                   Kappa : 0.872           
#>                                           
#>  Mcnemar's Test P-Value : 0.1814          
#>                                           
#>             Sensitivity : 0.9935          
#>             Specificity : 0.8413          
#>          Pos Pred Value : 0.9839          
#>          Neg Pred Value : 0.9298          
#>              Prevalence : 0.9069          
#>          Detection Rate : 0.9010          
#>    Detection Prevalence : 0.9158          
#>       Balanced Accuracy : 0.9174          
#>                                           
#>        'Positive' Class : X0              
#> 
```

-   变量重要性

这里按照降序排列前若干个重要变量


```r
kable_var(AdaBoost.M1_model, 6)
```

<table class="table lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:center;"> variables </th>
   <th style="text-align:right;"> importance </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> aridity </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">100</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20163 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">75.6111</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> dst_waterway </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">71.2427</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> landcover </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">61.0744</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20164 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">40.6913</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aat0 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">36.5557</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> pa </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">34.4948</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20161 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">31.0547</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20162 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">27.2079</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> night_time_lights </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">27.1753</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> im </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">25.9508</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> hfp </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">19.1934</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> slope </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">15.4263</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aat10 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">7.5408</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> dem </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">6.7241</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> hii </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> landform </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> tadem </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0</span> </td>
  </tr>
</tbody>
</table>

这里按照降序绘制前若干个重要变量


```r
ggplot_var(AdaBoost.M1_model, 6)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-124-1.png" width="672" style="display: block; margin: auto;" />

排名前六的变量分别是`aridity`、`im`、`aat0`、`pa`、`slope`、`aat10`

-   partial dependence plots

> [!Info]
> 二维图形


```r
pdp_2d_one_predictor(model = AdaBoost.M1_model, num = 6, ncol = 2)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-125-1.png" width="672" style="display: block; margin: auto;" />

> [!Info]
> 联合变量二维平面图形


```r
# pdp_2d_two_predictor(model = AdaBoost.M1_model,num = 6,ncol = 3)
```

颜色越浅，数值越大。

-   预测测试集


```r
extractProb(list(AdaBoost.M1_model), testX = test) %>%
  metrics_set(data = .) %>%
  kable("html", align = "cr", escape = FALSE) %>%
  kable_styling() %>%
  kableExtra::kable_classic()
```

<table class="table lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:center;"> metric </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> acc </td>
   <td style="text-align:right;"> 0.9793205 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> kap </td>
   <td style="text-align:right;"> 0.8720192 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ppv </td>
   <td style="text-align:right;"> 0.9838710 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> precision </td>
   <td style="text-align:right;"> 0.9838710 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> recall </td>
   <td style="text-align:right;"> 0.9934853 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> f_meas </td>
   <td style="text-align:right;"> 0.9886548 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> sensitivity </td>
   <td style="text-align:right;"> 0.9934853 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> detection_prevalence </td>
   <td style="text-align:right;"> 0.9158050 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> j_index </td>
   <td style="text-align:right;"> 0.8347552 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> npv </td>
   <td style="text-align:right;"> 0.9298246 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> specificity </td>
   <td style="text-align:right;"> 0.8412698 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> roc </td>
   <td style="text-align:right;"> 0.9976475 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> mn_log_loss </td>
   <td style="text-align:right;"> 0.2541667 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> pr_auc </td>
   <td style="text-align:right;"> 0.9997612 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> tss </td>
   <td style="text-align:right;"> 0.8347552 </td>
  </tr>
</tbody>
</table>

-   预测上海市


```r
sh_pred_layer <- pred_df(model = AdaBoost.M1_model) %>%
  pred_layer(
    pred_df = .,
    model = AdaBoost.M1_model,
    model.name = "AdaBoost.M1"
  )
```

```
#> [1] "数据中变量个数符合要求"
#> [1] "数据中分类变量是二值型"
#> [1] "数据中二分类变量种类符合要求"
#> [1] "数据中预测概率值变量范围符合要求"
#> [1] "模型名称符合要求"
#> [1] "Path `./data/pred/caret` already exist!"
```

```r
sh_pred_layer
```

```
#> class      : RasterStack 
#> dimensions : 1362, 1260, 1716120, 2  (nrow, ncol, ncell, nlayers)
#> resolution : 0.0008333333, 0.0008333333  (x, y)
#> extent     : 120.8529, 121.9029, 30.70042, 31.83542  (xmin, xmax, ymin, ymax)
#> crs        : +proj=longlat +datum=WGS84 +no_defs 
#> names      : AdaBoost.M1_bin, AdaBoost.M1_prob 
#> min values :               0,                0 
#> max values :       1.0000000,        0.8411152
```

-   上海市预测结果平面图


```r
sh_tmap(sh_pred_layer)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-129-1.png" width="672" style="display: block; margin: auto;" />

-   上海市预测结果立体图


```r
sh_rayshader(data = sh_pred_layer$AdaBoost.M1_prob)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-130-1.png" width="672" style="display: block; margin: auto;" />



### 3.9 XGB

-   10折交叉验证，3次重复


```r
library(doParallel)
cores <- makeCluster(detectCores() - 1)
registerDoParallel(cores = cores)

set.seed(123)

grid_default <- expand.grid(
  nrounds = 100,
  max_depth = 6,
  eta = 0.3,
  gamma = 0,
  colsample_bytree = 1,
  min_child_weight = 1,
  subsample = 1
)

# Create control function for training with 10 folds and keep 3 folds for training. search method is grid.
control <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 3,
  savePredictions = TRUE,
  classProbs = TRUE,
  allowParallel = TRUE
)

xgb_model <- train(class ~ .,
  data = train,
  method = "xgbTree",
  trControl = control,
  tuneGrid = grid_default
)
xgb_model
```

```
#> eXtreme Gradient Boosting 
#> 
#> 677 samples
#>  18 predictor
#>   2 classes: 'X0', 'X1' 
#> 
#> No pre-processing
#> Resampling: Cross-Validated (10 fold, repeated 3 times) 
#> Summary of sample sizes: 609, 608, 609, 610, 610, 610, ... 
#> Resampling results:
#> 
#>   Accuracy   Kappa    
#>   0.9487541  0.6482611
#> 
#> Tuning parameter 'nrounds' was held constant at a value of 100
#> Tuning
#>  held constant at a value of 1
#> Tuning parameter 'subsample' was held
#>  constant at a value of 1
```

-   输出`Kappa`达到最大的模型参数


```r
xgb_model$bestTune %>%
  kable()
```

<table>
 <thead>
  <tr>
   <th style="text-align:right;"> nrounds </th>
   <th style="text-align:right;"> max_depth </th>
   <th style="text-align:right;"> eta </th>
   <th style="text-align:right;"> gamma </th>
   <th style="text-align:right;"> colsample_bytree </th>
   <th style="text-align:right;"> min_child_weight </th>
   <th style="text-align:right;"> subsample </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 0.3 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
</tbody>
</table>

-   输出模型评价指标

> [!Info]
> 输出`acc`、`kappa`、`ROC`、`ppv`等指标


```r
metric_table(xgb_model) %>%
  beautify_metric_table(table = .)
```

<table class="table table-striped table-hover lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:left;"> Resample </th>
   <th style="text-align:left;"> acc </th>
   <th style="text-align:left;"> kappa </th>
   <th style="text-align:left;"> ROC </th>
   <th style="text-align:left;"> ppv </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Fold01.Rep1 </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.99</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.72</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.82</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.84</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">1</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.51</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.45</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.78</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.78</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.31</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.57</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.8</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep1 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.41</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.86</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold01.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.82</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.71</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.82</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.7</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.27</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.67</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.58</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.81</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.71</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.78</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.84</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">1</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.82</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep2 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.51</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.88</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold01.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.7</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.84</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold02.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.78</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold03.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.35</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold04.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.27</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.69</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.92</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold05.Rep3 </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.99</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.9</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.91</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold06.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.84</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">0.99</span> </td>
   <td style="text-align:left;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">1</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold07.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.75</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.97</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold08.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.78</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.98</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold09.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.96</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.65</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.95</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fold10.Rep3 </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.93</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.41</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.84</span> </td>
   <td style="text-align:left;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0.94</span> </td>
  </tr>
</tbody>
</table>

-   混淆矩阵

10折交叉验证并且重复三次的结果如下(因为是平均所以会有非整数)


```r
confusionMatrix.train(xgb_model)
```

```
#> Cross-Validated (10 fold, repeated 3 times) Confusion Matrix 
#> 
#> (entries are percentual average cell counts across resamples)
#>  
#>           Reference
#> Prediction   X0   X1
#>         X0 89.0  3.4
#>         X1  1.7  5.9
#>                             
#>  Accuracy (average) : 0.9488
```

-   最优参数预测的混淆矩阵.


```r
confusionMatrix(data = predict(xgb_model, train), reference = train$class)
```

```
#> Confusion Matrix and Statistics
#> 
#>           Reference
#> Prediction  X0  X1
#>         X0 614   1
#>         X1   0  62
#>                                      
#>                Accuracy : 0.9985     
#>                  95% CI : (0.9918, 1)
#>     No Information Rate : 0.9069     
#>     P-Value [Acc > NIR] : <2e-16     
#>                                      
#>                   Kappa : 0.9912     
#>                                      
#>  Mcnemar's Test P-Value : 1          
#>                                      
#>             Sensitivity : 1.0000     
#>             Specificity : 0.9841     
#>          Pos Pred Value : 0.9984     
#>          Neg Pred Value : 1.0000     
#>              Prevalence : 0.9069     
#>          Detection Rate : 0.9069     
#>    Detection Prevalence : 0.9084     
#>       Balanced Accuracy : 0.9921     
#>                                      
#>        'Positive' Class : X0         
#> 
```

-   变量重要性

这里按照降序排列前若干个重要变量


```r
kable_var(xgb_model, 6)
```

<table class="table lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:center;"> variables </th>
   <th style="text-align:right;"> importance </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> aat0 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">100</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20161 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">95.8405</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20164 </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">76.3484</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aridity </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">67.2478</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> dst_waterway </td>
   <td style="text-align:right;"> <span style=" font-weight: bold; font-style: italic;   color: red !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: grey !important;font-size: 20px;">58.8301</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> landcover </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">58.386</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20163 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">49.3717</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> night_time_lights </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">39.7395</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> slope </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">38.4947</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> dem </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">29.2234</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> hfp </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">28.1723</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ndvi20162 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">25.1478</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> im </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">21.3454</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> pa </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">20.7812</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> aat10 </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">13.8595</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> hii </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">1.9197</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> landform </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> tadem </td>
   <td style="text-align:right;"> <span style="     color: black !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: white !important;font-size: 15px;">0</span> </td>
  </tr>
</tbody>
</table>



```r
ggplot_var(xgb_model, 6)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-137-1.png" width="672" style="display: block; margin: auto;" />

排名前六的变量分别是`aridity`、`im`、`aat0`、`pa`、`slope`、`aat10`

-   partial dependence plots

> [!Info]
> 二维图形


```r
pdp_2d_one_predictor(model = xgb_model, num = 6, ncol = 2)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-138-1.png" width="672" style="display: block; margin: auto;" />

> [!Info]
> 联合变量二维平面图形


```r
pdp_2d_two_predictor(model = xgb_model, num = 6, ncol = 3)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-139-1.png" width="672" style="display: block; margin: auto;" />

颜色越浅，数值越大。

-   预测测试集


```r
extractProb(list(xgb_model), testX = test) %>%
  metrics_set(data = .) %>%
  kable("html", align = "cr", escape = FALSE) %>%
  kable_styling() %>%
  kableExtra::kable_classic()
```

<table class="table lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:center;"> metric </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> acc </td>
   <td style="text-align:right;"> 0.9985229 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> kap </td>
   <td style="text-align:right;"> 0.9911864 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> ppv </td>
   <td style="text-align:right;"> 0.9983740 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> precision </td>
   <td style="text-align:right;"> 0.9983740 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> recall </td>
   <td style="text-align:right;"> 1.0000000 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> f_meas </td>
   <td style="text-align:right;"> 0.9991863 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> sensitivity </td>
   <td style="text-align:right;"> 1.0000000 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> detection_prevalence </td>
   <td style="text-align:right;"> 0.9084195 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> j_index </td>
   <td style="text-align:right;"> 0.9841270 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> npv </td>
   <td style="text-align:right;"> 1.0000000 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> specificity </td>
   <td style="text-align:right;"> 0.9841270 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> roc </td>
   <td style="text-align:right;"> 0.9999871 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> mn_log_loss </td>
   <td style="text-align:right;"> 0.0093704 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> pr_auc </td>
   <td style="text-align:right;"> 0.9999987 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> tss </td>
   <td style="text-align:right;"> 0.9841270 </td>
  </tr>
</tbody>
</table>


-   预测上海市


```r
sh_pred_layer <- pred_df(model = xgb_model) %>%
  pred_layer(
    pred_df = .,
    model = xgb_model,
    model.name = "xgb"
  )
```

```
#> [1] "数据中变量个数符合要求"
#> [1] "数据中分类变量是二值型"
#> [1] "数据中二分类变量种类符合要求"
#> [1] "数据中预测概率值变量范围符合要求"
#> [1] "模型名称符合要求"
#> [1] "Path `./data/pred/caret` already exist!"
```

```r
sh_pred_layer
```

```
#> class      : RasterStack 
#> dimensions : 1362, 1260, 1716120, 2  (nrow, ncol, ncell, nlayers)
#> resolution : 0.0008333333, 0.0008333333  (x, y)
#> extent     : 120.8529, 121.9029, 30.70042, 31.83542  (xmin, xmax, ymin, ymax)
#> crs        : +proj=longlat +datum=WGS84 +no_defs 
#> names      :      xgb_bin,     xgb_prob 
#> min values : 0.000000e+00, 2.038479e-05 
#> max values :    1.0000000,    0.9964086
```


-   上海市预测结果平面图


```r
sh_tmap(sh_pred_layer)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-142-1.png" width="672" style="display: block; margin: auto;" />

-   上海市预测结果立体图


```r
sh_rayshader(data = sh_pred_layer$xgb_prob)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-143-1.png" width="672" style="display: block; margin: auto;" />


## 4. 结果汇总



```r
metrics_summary_test <- ls() %>%
  as_tibble() %>%
  setNames("model.name") %>%
  dplyr::filter(str_detect(model.name, "_model")) %>%
  # dplyr::filter(! model.name %in% c("J48_model","nb_model")) %>%
  group_by(model.name) %>%
  mutate(model = list(get(model.name))) %>%
  mutate(metric = map(model, ~ extractProb(list(.x), testX = test) %>%
    metrics_set(data = .))) %>%
  dplyr::select(-model) %>%
  unnest(metric) %>%
  ungroup()
```

由于表格限制，只展示广义线性模型指标结果


```r
metrics_summary_test %>%
  dplyr::filter(model.name == "glm_model") %>%
  kable("html", align = "cr", escape = FALSE) %>%
  kable_styling() %>%
  kableExtra::kable_classic()
```

<table class="table lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:center;"> model.name </th>
   <th style="text-align:right;"> metric </th>
   <th style="text-align:center;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> glm_model </td>
   <td style="text-align:right;"> acc </td>
   <td style="text-align:center;"> 0.9113737 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> glm_model </td>
   <td style="text-align:right;"> kap </td>
   <td style="text-align:center;"> 0.2022154 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> glm_model </td>
   <td style="text-align:right;"> ppv </td>
   <td style="text-align:center;"> 0.9184290 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> glm_model </td>
   <td style="text-align:right;"> precision </td>
   <td style="text-align:center;"> 0.9184290 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> glm_model </td>
   <td style="text-align:right;"> recall </td>
   <td style="text-align:center;"> 0.9902280 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> glm_model </td>
   <td style="text-align:right;"> f_meas </td>
   <td style="text-align:center;"> 0.9529781 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> glm_model </td>
   <td style="text-align:right;"> sensitivity </td>
   <td style="text-align:center;"> 0.9902280 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> glm_model </td>
   <td style="text-align:right;"> detection_prevalence </td>
   <td style="text-align:center;"> 0.9778434 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> glm_model </td>
   <td style="text-align:right;"> j_index </td>
   <td style="text-align:center;"> 0.1330852 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> glm_model </td>
   <td style="text-align:right;"> npv </td>
   <td style="text-align:center;"> 0.6000000 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> glm_model </td>
   <td style="text-align:right;"> specificity </td>
   <td style="text-align:center;"> 0.1428571 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> glm_model </td>
   <td style="text-align:right;"> roc </td>
   <td style="text-align:center;"> 0.8470477 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> glm_model </td>
   <td style="text-align:right;"> mn_log_loss </td>
   <td style="text-align:center;"> 0.2345523 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> glm_model </td>
   <td style="text-align:right;"> pr_auc </td>
   <td style="text-align:center;"> 0.9807124 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> glm_model </td>
   <td style="text-align:right;"> tss </td>
   <td style="text-align:center;"> 0.1330852 </td>
  </tr>
</tbody>
</table>



```r
metrics_summary_test %>%
  dplyr::filter(metric %in% c("kap", "roc", "tss")) %>%
  group_by(metric) %>%
  slice_max(value) %>%
  ungroup()
```

```
#> # A tibble: 12 × 3
#>    model.name metric value
#>    <chr>      <chr>  <dbl>
#>  1 C5.0_model kap    0.991
#>  2 gbm_model  kap    0.991
#>  3 rf_model   kap    0.991
#>  4 xgb_model  kap    0.991
#>  5 C5.0_model roc    1.00 
#>  6 gbm_model  roc    1.00 
#>  7 rf_model   roc    1.00 
#>  8 xgb_model  roc    1.00 
#>  9 C5.0_model tss    0.984
#> 10 gbm_model  tss    0.984
#> 11 rf_model   tss    0.984
#> 12 xgb_model  tss    0.984
```

- 同时汇总模型在训练集上的指标


```r
metrics_summary_train <- ls() %>%
  as_tibble() %>%
  setNames("model.name") %>%
  dplyr::filter(str_detect(model.name, "_model")) %>%
  group_by(model.name) %>%
  mutate(model = list(get(model.name))) %>%
  mutate(metric = map(model, ~ extractProb(list(.x), testX = train) %>%
    metrics_set(data = .))) %>%
  dplyr::select(-model) %>%
  unnest(metric) %>%
  ungroup()
metrics_summary_train %>%
  dplyr::filter(metric %in% c("kap", "roc", "tss")) %>%
  group_by(metric) %>%
  slice_max(value)
```

```
#> # A tibble: 12 × 3
#> # Groups:   metric [3]
#>    model.name metric value
#>    <chr>      <chr>  <dbl>
#>  1 C5.0_model kap    0.991
#>  2 gbm_model  kap    0.991
#>  3 rf_model   kap    0.991
#>  4 xgb_model  kap    0.991
#>  5 C5.0_model roc    1.00 
#>  6 gbm_model  roc    1.00 
#>  7 rf_model   roc    1.00 
#>  8 xgb_model  roc    1.00 
#>  9 C5.0_model tss    0.984
#> 10 gbm_model  tss    0.984
#> 11 rf_model   tss    0.984
#> 12 xgb_model  tss    0.984
```

一时间竟然无法取舍

### 4.1  最优模型变量重要性


```r
metrics_summary_test %>%
  dplyr::filter(metric %in% c("kap", "roc", "tss")) %>%
  group_by(metric) %>%
  slice_max(value) %>%
  ungroup() %>%
  dplyr::distinct(.keep_all = T, model.name) %>%
  dplyr::select(model.name) %>%
  group_by(model.name) %>%
  mutate(vip = map(model.name, ~ caret::varImp(get(model.name)) %>%
    .$importance %>%
    dplyr::select(last_col()) %>%
    rownames_to_column("variables") %>%
    setNames(c("variables", "importance")) %>%
    arrange(desc(importance)))) %>%
  unnest(vip) %>%
  ungroup() %>%
  kable("html", escape = FALSE) %>%
  kable_styling(bootstrap_options = c("striped", "hover")) %>%
  kableExtra::kable_classic()
```

<table class="table table-striped table-hover lightable-classic" style='margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:left;"> model.name </th>
   <th style="text-align:left;"> variables </th>
   <th style="text-align:right;"> importance </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> C5.0_model </td>
   <td style="text-align:left;"> aat0 </td>
   <td style="text-align:right;"> 100.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C5.0_model </td>
   <td style="text-align:left;"> aridity </td>
   <td style="text-align:right;"> 100.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C5.0_model </td>
   <td style="text-align:left;"> dem </td>
   <td style="text-align:right;"> 100.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C5.0_model </td>
   <td style="text-align:left;"> im </td>
   <td style="text-align:right;"> 100.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C5.0_model </td>
   <td style="text-align:left;"> night_time_lights </td>
   <td style="text-align:right;"> 100.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C5.0_model </td>
   <td style="text-align:left;"> slope </td>
   <td style="text-align:right;"> 100.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C5.0_model </td>
   <td style="text-align:left;"> ndvi20162 </td>
   <td style="text-align:right;"> 96.600000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C5.0_model </td>
   <td style="text-align:left;"> landcover </td>
   <td style="text-align:right;"> 79.170000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C5.0_model </td>
   <td style="text-align:left;"> aat10 </td>
   <td style="text-align:right;"> 78.140000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C5.0_model </td>
   <td style="text-align:left;"> pa </td>
   <td style="text-align:right;"> 77.400000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C5.0_model </td>
   <td style="text-align:left;"> ndvi20164 </td>
   <td style="text-align:right;"> 75.630000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C5.0_model </td>
   <td style="text-align:left;"> ndvi20161 </td>
   <td style="text-align:right;"> 75.040000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C5.0_model </td>
   <td style="text-align:left;"> ndvi20163 </td>
   <td style="text-align:right;"> 74.300000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C5.0_model </td>
   <td style="text-align:left;"> dst_waterway </td>
   <td style="text-align:right;"> 73.410000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C5.0_model </td>
   <td style="text-align:left;"> hfp </td>
   <td style="text-align:right;"> 63.370000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C5.0_model </td>
   <td style="text-align:left;"> hii </td>
   <td style="text-align:right;"> 59.080000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C5.0_model </td>
   <td style="text-align:left;"> tadem </td>
   <td style="text-align:right;"> 18.320000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C5.0_model </td>
   <td style="text-align:left;"> landform </td>
   <td style="text-align:right;"> 0.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gbm_model </td>
   <td style="text-align:left;"> ndvi20164 </td>
   <td style="text-align:right;"> 100.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gbm_model </td>
   <td style="text-align:left;"> dst_waterway </td>
   <td style="text-align:right;"> 98.467407 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gbm_model </td>
   <td style="text-align:left;"> aat0 </td>
   <td style="text-align:right;"> 94.783525 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gbm_model </td>
   <td style="text-align:left;"> landcover </td>
   <td style="text-align:right;"> 86.173977 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gbm_model </td>
   <td style="text-align:left;"> ndvi20163 </td>
   <td style="text-align:right;"> 76.975975 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gbm_model </td>
   <td style="text-align:left;"> aridity </td>
   <td style="text-align:right;"> 67.606102 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gbm_model </td>
   <td style="text-align:left;"> ndvi20161 </td>
   <td style="text-align:right;"> 67.030005 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gbm_model </td>
   <td style="text-align:left;"> night_time_lights </td>
   <td style="text-align:right;"> 60.573375 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gbm_model </td>
   <td style="text-align:left;"> im </td>
   <td style="text-align:right;"> 55.636217 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gbm_model </td>
   <td style="text-align:left;"> slope </td>
   <td style="text-align:right;"> 44.394414 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gbm_model </td>
   <td style="text-align:left;"> ndvi20162 </td>
   <td style="text-align:right;"> 42.814303 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gbm_model </td>
   <td style="text-align:left;"> dem </td>
   <td style="text-align:right;"> 25.840530 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gbm_model </td>
   <td style="text-align:left;"> hii </td>
   <td style="text-align:right;"> 24.459723 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gbm_model </td>
   <td style="text-align:left;"> pa </td>
   <td style="text-align:right;"> 23.655065 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gbm_model </td>
   <td style="text-align:left;"> hfp </td>
   <td style="text-align:right;"> 21.584182 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gbm_model </td>
   <td style="text-align:left;"> aat10 </td>
   <td style="text-align:right;"> 19.352641 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gbm_model </td>
   <td style="text-align:left;"> landform </td>
   <td style="text-align:right;"> 0.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gbm_model </td>
   <td style="text-align:left;"> tadem </td>
   <td style="text-align:right;"> 0.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rf_model </td>
   <td style="text-align:left;"> dst_waterway </td>
   <td style="text-align:right;"> 100.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rf_model </td>
   <td style="text-align:left;"> ndvi20164 </td>
   <td style="text-align:right;"> 90.274778 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rf_model </td>
   <td style="text-align:left;"> aat0 </td>
   <td style="text-align:right;"> 87.611504 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rf_model </td>
   <td style="text-align:left;"> aridity </td>
   <td style="text-align:right;"> 82.471755 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rf_model </td>
   <td style="text-align:left;"> ndvi20163 </td>
   <td style="text-align:right;"> 78.947308 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rf_model </td>
   <td style="text-align:left;"> pa </td>
   <td style="text-align:right;"> 78.476719 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rf_model </td>
   <td style="text-align:left;"> landcover </td>
   <td style="text-align:right;"> 74.897327 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rf_model </td>
   <td style="text-align:left;"> ndvi20161 </td>
   <td style="text-align:right;"> 72.371410 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rf_model </td>
   <td style="text-align:left;"> im </td>
   <td style="text-align:right;"> 71.954005 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rf_model </td>
   <td style="text-align:left;"> aat10 </td>
   <td style="text-align:right;"> 66.483200 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rf_model </td>
   <td style="text-align:left;"> night_time_lights </td>
   <td style="text-align:right;"> 62.414999 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rf_model </td>
   <td style="text-align:left;"> ndvi20162 </td>
   <td style="text-align:right;"> 60.352507 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rf_model </td>
   <td style="text-align:left;"> slope </td>
   <td style="text-align:right;"> 52.092436 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rf_model </td>
   <td style="text-align:left;"> dem </td>
   <td style="text-align:right;"> 47.346744 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rf_model </td>
   <td style="text-align:left;"> hfp </td>
   <td style="text-align:right;"> 44.970417 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rf_model </td>
   <td style="text-align:left;"> hii </td>
   <td style="text-align:right;"> 36.851587 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rf_model </td>
   <td style="text-align:left;"> tadem </td>
   <td style="text-align:right;"> 9.813664 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rf_model </td>
   <td style="text-align:left;"> landform </td>
   <td style="text-align:right;"> 0.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xgb_model </td>
   <td style="text-align:left;"> aat0 </td>
   <td style="text-align:right;"> 100.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xgb_model </td>
   <td style="text-align:left;"> ndvi20161 </td>
   <td style="text-align:right;"> 95.840469 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xgb_model </td>
   <td style="text-align:left;"> ndvi20164 </td>
   <td style="text-align:right;"> 76.348390 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xgb_model </td>
   <td style="text-align:left;"> aridity </td>
   <td style="text-align:right;"> 67.247848 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xgb_model </td>
   <td style="text-align:left;"> dst_waterway </td>
   <td style="text-align:right;"> 58.830060 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xgb_model </td>
   <td style="text-align:left;"> landcover </td>
   <td style="text-align:right;"> 58.386049 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xgb_model </td>
   <td style="text-align:left;"> ndvi20163 </td>
   <td style="text-align:right;"> 49.371678 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xgb_model </td>
   <td style="text-align:left;"> night_time_lights </td>
   <td style="text-align:right;"> 39.739515 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xgb_model </td>
   <td style="text-align:left;"> slope </td>
   <td style="text-align:right;"> 38.494743 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xgb_model </td>
   <td style="text-align:left;"> dem </td>
   <td style="text-align:right;"> 29.223361 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xgb_model </td>
   <td style="text-align:left;"> hfp </td>
   <td style="text-align:right;"> 28.172320 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xgb_model </td>
   <td style="text-align:left;"> ndvi20162 </td>
   <td style="text-align:right;"> 25.147750 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xgb_model </td>
   <td style="text-align:left;"> im </td>
   <td style="text-align:right;"> 21.345413 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xgb_model </td>
   <td style="text-align:left;"> pa </td>
   <td style="text-align:right;"> 20.781159 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xgb_model </td>
   <td style="text-align:left;"> aat10 </td>
   <td style="text-align:right;"> 13.859504 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xgb_model </td>
   <td style="text-align:left;"> hii </td>
   <td style="text-align:right;"> 1.919728 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xgb_model </td>
   <td style="text-align:left;"> landform </td>
   <td style="text-align:right;"> 0.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xgb_model </td>
   <td style="text-align:left;"> tadem </td>
   <td style="text-align:right;"> 0.000000 </td>
  </tr>
</tbody>
</table>

- 用一个横向表格对比各种结果中不同变量重要性


```r
metrics_summary_test %>%
  dplyr::filter(metric %in% c("kap", "roc", "tss")) %>%
  group_by(metric) %>%
  slice_max(value) %>%
  ungroup() %>%
  dplyr::distinct(.keep_all = T, model.name) %>%
  dplyr::select(model.name) %>%
  group_by(model.name) %>%
  mutate(vip = map(model.name, ~ caret::varImp(get(model.name)) %>%
    .$importance %>%
    dplyr::select(last_col()) %>%
    rownames_to_column("variables") %>%
    setNames(c("variables", "importance")) %>%
    arrange(desc(importance)))) %>%
  unnest(vip) %>%
  mutate(rank = 1:n()) %>%
  ungroup() %>%
  dplyr::select(model.name, variables, rank) %>%
  pivot_wider(names_from = model.name, values_from = rank)
```

```
#> # A tibble: 18 × 5
#>    variables         C5.0_model gbm_model rf_model xgb_model
#>    <chr>                  <int>     <int>    <int>     <int>
#>  1 aat0                       1         3        3         1
#>  2 aridity                    2         6        4         4
#>  3 dem                        3        12       14        10
#>  4 im                         4         9        9        13
#>  5 night_time_lights          5         8       11         8
#>  6 slope                      6        10       13         9
#>  7 ndvi20162                  7        11       12        12
#>  8 landcover                  8         4        7         6
#>  9 aat10                      9        16       10        15
#> 10 pa                        10        14        6        14
#> 11 ndvi20164                 11         1        2         3
#> 12 ndvi20161                 12         7        8         2
#> 13 ndvi20163                 13         5        5         7
#> 14 dst_waterway              14         2        1         5
#> 15 hfp                       15        15       15        11
#> 16 hii                       16        13       16        16
#> 17 tadem                     17        18       17        18
#> 18 landform                  18        17       18        17
```

### 4.2 提升曲线


```r
lift.df <- ls() %>%
  as_tibble() %>%
  setNames("model.name") %>%
  dplyr::filter(str_detect(model.name, "_model")) %>%
  group_by(model.name) %>%
  mutate(model = list(get(model.name))) %>%
  mutate(pred = map(model, ~ extractProb(list(.x), testX = train) %>%
    dplyr::select(X0))) %>%
  dplyr::select(-model) %>%
  unnest(pred) %>%
  ungroup() %>%
  setNames(c("model", "prob")) %>%
  # 辅助列帮助转成tibble而非list
  # mutate(id = rep(1:nrow(train),10)) %>%
  mutate(across(.cols = model, .fns = function(x) str_remove(x, "_model"))) %>%
  pivot_wider(names_from = model, values_from = prob) %>%
  mutate(Class = train$class) %>%
  dplyr::select(-id)
```

- 根据上文生成的表格计算`lift curve`


```r
lift_obj <- lift(x = Class ~ AdaBoost.M1 + C5.0 + gbm + glm + J48 + knn + nb + rf + svm + xgb, data = lift.df)

ggplot(data = lift_obj, plot = "gain") +
  theme_bw()
```

看起来差别不大，因此不考虑使用提升曲线


```r
lift.plot <- ls() %>%
  as_tibble() %>%
  setNames("model.name") %>%
  dplyr::filter(str_detect(model.name, "_model")) %>%
  dplyr::filter(!model.name %in% c("J48_model")) %>%
  group_by(model.name) %>%
  mutate(model = list(get(model.name))) %>%
  mutate(train.pred = map(.x = model, .f = function(x) {
    train %>%
      mutate(pred = predict(object = x, newdata = train, type = "prob")[, "X1"]) %>%
      mutate(class = ifelse(class == "X0", 0, 1))
  })) %>%
  mutate(test.pred = map(.x = model, .f = function(x) {
    test %>%
      mutate(pred = predict(object = x, newdata = test, type = "prob")[, "X1"]) %>%
      mutate(class = ifelse(class == "X0", 0, 1))
  })) %>%
  mutate(plot = pmap(.l = list(train.pred, test.pred, model.name), .f = function(x, y, z) {
    lift_plot(train_pred = x, test_pred = y, target = "class", score = "pred") +
      ggtitle(label = paste(z %>%
        str_remove("_model") %>%
        toupper(), "Lift Chart", sep = " ")) +
      theme(
        plot.title = element_text(size = 10, hjust = 0.5, face = "bold"),
        text = element_text(size = 10, hjust = 0.5, family = "CAL"),
        axis.title.y = element_text(face = "bold", hjust = 0.5),
        axis.title.x = element_text(face = "bold", hjust = 0.5),
        axis.text.x = element_text(size = 8, face = "bold", family = "CAL", hjust = 0.5, vjust = 0.5),
        axis.text.y = element_text(size = 8, face = "bold", family = "CAL", hjust = 0.5, vjust = 0.5)
      )
  }))

# do.call(grid.arrange,c(lift.plot$plot,ncol = 5))
marrangeGrob(lift.plot$plot, nrow = 1, ncol = 1, npages = length(lift.plot$plot))
```


### 4.3 ks曲线


```r
ks.plot <- ls() %>%
  as_tibble() %>%
  setNames("model.name") %>%
  dplyr::filter(str_detect(model.name, "_model")) %>%
  dplyr::filter(!model.name %in% c("J48_model")) %>%
  group_by(model.name) %>%
  mutate(model = list(get(model.name))) %>%
  mutate(train.pred = map(.x = model, .f = function(x) {
    train %>%
      mutate(pred = predict(object = x, newdata = train, type = "prob")[, "X1"]) %>%
      mutate(class = ifelse(class == "X0", 0, 1))
  })) %>%
  mutate(test.pred = map(.x = model, .f = function(x) {
    test %>%
      mutate(pred = predict(object = x, newdata = test, type = "prob")[, "X1"]) %>%
      mutate(class = ifelse(class == "X0", 0, 1))
  })) %>%
  mutate(plot = pmap(.l = list(train.pred, test.pred, model.name), .f = function(x, y, z) {
    ks_plot(train_pred = x, test_pred = y, target = "class", score = "pred") +
      ggtitle(label = paste(z %>%
        str_remove("_model") %>%
        toupper(), "K-S Curve", sep = " ")) +
      theme(
        plot.title = element_text(size = 10, hjust = 0.5, face = "bold"),
        text = element_text(size = 10, hjust = 0.5, family = "CAL"),
        axis.title.y = element_text(face = "bold", hjust = 0.5),
        axis.title.x = element_text(face = "bold", hjust = 0.5),
        axis.text.x = element_text(size = 8, face = "bold", family = "CAL", hjust = 0.5, vjust = 0.5),
        axis.text.y = element_text(size = 8, face = "bold", family = "CAL", hjust = 0.5, vjust = 0.5)
      )
  }))

# do.call(grid.arrange,c(ks.plot$plot,ncol = 5))
marrangeGrob(ks.plot$plot, nrow = 1, ncol = 1, npages = length(ks.plot$plot))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-153-1.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-153-2.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-153-3.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-153-4.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-153-5.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-153-6.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-153-7.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-153-8.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-153-9.png" width="672" style="display: block; margin: auto;" />


### 4.4 roc曲线


```r
roc.plot <- ls() %>%
  as_tibble() %>%
  setNames("model.name") %>%
  dplyr::filter(str_detect(model.name, "_model")) %>%
  dplyr::filter(!model.name %in% c("J48_model")) %>%
  group_by(model.name) %>%
  mutate(model = list(get(model.name))) %>%
  mutate(train.pred = map(.x = model, .f = function(x) {
    train %>%
      mutate(pred = predict(object = x, newdata = train, type = "prob")[, "X1"]) %>%
      mutate(class = ifelse(class == "X0", 0, 1))
  })) %>%
  mutate(test.pred = map(.x = model, .f = function(x) {
    test %>%
      mutate(pred = predict(object = x, newdata = test, type = "prob")[, "X1"]) %>%
      mutate(class = ifelse(class == "X0", 0, 1))
  })) %>%
  mutate(plot = pmap(.l = list(train.pred, test.pred, model.name), .f = function(x, y, z) {
    roc_plot(train_pred = x, test_pred = y, target = "class", score = "pred") +
      ggtitle(label = paste(z %>%
        str_remove("_model") %>%
        toupper(), "ROC Curve", sep = " ")) +
      theme(
        plot.title = element_text(size = 10, hjust = 0.5, face = "bold"),
        text = element_text(size = 10, hjust = 0.5, family = "CAL"),
        axis.title.y = element_text(face = "bold", hjust = 0.5),
        axis.title.x = element_text(face = "bold", hjust = 0.5),
        axis.text.x = element_text(size = 8, face = "bold", family = "CAL", hjust = 0.5, vjust = 0.5),
        axis.text.y = element_text(size = 8, face = "bold", family = "CAL", hjust = 0.5, vjust = 0.5)
      )
  }))

# do.call(grid.arrange,c(roc.plot$plot,ncol = 5))
marrangeGrob(roc.plot$plot, nrow = 1, ncol = 1, npages = length(roc.plot$plot))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-154-1.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-154-2.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-154-3.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-154-4.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-154-5.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-154-6.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-154-7.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-154-8.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-154-9.png" width="672" style="display: block; margin: auto;" />


### 4.5 Precision recall curve


```r
pr.plot <- ls() %>%
  as_tibble() %>%
  setNames("model.name") %>%
  dplyr::filter(str_detect(model.name, "_model")) %>%
  dplyr::filter(!model.name %in% c("J48_model")) %>%
  group_by(model.name) %>%
  mutate(model = list(get(model.name))) %>%
  mutate(train.pred = map(.x = model, .f = function(x) {
    train %>%
      bind_cols(predict(object = x, newdata = train, type = "prob") %>%
        as_tibble())
  })) %>%
  mutate(test.pred = map(.x = model, .f = function(x) {
    test %>%
      bind_cols(predict(object = x, newdata = test, type = "prob") %>%
        as_tibble())
  })) %>%
  mutate(plot = pmap(.l = list(train.pred, test.pred, model.name), .f = function(x, y, z) {
    pr_curve(x, class, X0) %>%
      ggplot(aes(x = recall, y = precision)) +
      geom_path() +
      coord_equal() +
      ggtitle(label = paste(z %>%
        str_remove("_model") %>%
        toupper(), "Precision recall curve", sep = " ")) +
      theme(
        plot.title = element_text(size = 10, hjust = 0.5, face = "bold"),
        text = element_text(size = 10, hjust = 0.5, family = "CAL"),
        axis.title.y = element_text(face = "bold", hjust = 0.5),
        axis.title.x = element_text(face = "bold", hjust = 0.5),
        axis.text.x = element_text(size = 8, face = "bold", family = "CAL", hjust = 0.5, vjust = 0.5),
        axis.text.y = element_text(size = 8, face = "bold", family = "CAL", hjust = 0.5, vjust = 0.5)
      )
  }))

# do.call(grid.arrange,c(pr.plot$plot,ncol = 5))
marrangeGrob(pr.plot$plot, nrow = 1, ncol = 1, npages = length(pr.plot$plot))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-155-1.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-155-2.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-155-3.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-155-4.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-155-5.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-155-6.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-155-7.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-155-8.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-155-9.png" width="672" style="display: block; margin: auto;" />


### 4.6 Gain curve


```r
gain.plot <- ls() %>%
  as_tibble() %>%
  setNames("model.name") %>%
  dplyr::filter(str_detect(model.name, "_model")) %>%
  dplyr::filter(!model.name %in% c("J48_model")) %>%
  group_by(model.name) %>%
  mutate(model = list(get(model.name))) %>%
  mutate(train.pred = map(.x = model, .f = function(x) {
    train %>%
      bind_cols(predict(object = x, newdata = train, type = "prob") %>%
        as_tibble())
  })) %>%
  mutate(test.pred = map(.x = model, .f = function(x) {
    test %>%
      bind_cols(predict(object = x, newdata = test, type = "prob") %>%
        as_tibble())
  })) %>%
  mutate(plot = pmap(.l = list(train.pred, test.pred, model.name), .f = function(x, y, z) {
    gain_curve(x, class, X0) %>%
      autoplot() +
      ggtitle(label = paste(z %>%
        str_remove("_model") %>%
        toupper(), "Gain curve", sep = " ")) +
      theme(
        plot.title = element_text(size = 10, hjust = 0.5, face = "bold"),
        text = element_text(size = 10, hjust = 0.5, family = "CAL"),
        axis.title.y = element_text(face = "bold", hjust = 0.5),
        axis.title.x = element_text(face = "bold", hjust = 0.5),
        axis.text.x = element_text(size = 8, face = "bold", family = "CAL", hjust = 0.5, vjust = 0.5),
        axis.text.y = element_text(size = 8, face = "bold", family = "CAL", hjust = 0.5, vjust = 0.5)
      )
  }))

# do.call(grid.arrange,c(gain.plot$plot,ncol = 5))
marrangeGrob(gain.plot$plot, nrow = 1, ncol = 1, npages = length(gain.plot$plot))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-156-1.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-156-2.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-156-3.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-156-4.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-156-5.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-156-6.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-156-7.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-156-8.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-156-9.png" width="672" style="display: block; margin: auto;" />


### 4.7 概率分布图


```r
score.distribution.plot <- ls() %>%
  as_tibble() %>%
  setNames("model.name") %>%
  dplyr::filter(str_detect(model.name, "_model")) %>%
  dplyr::filter(!model.name %in% c("J48_model")) %>%
  group_by(model.name) %>%
  mutate(model = list(get(model.name))) %>%
  mutate(train.pred = map(.x = model, .f = function(x) {
    train %>%
      mutate(pred = predict(object = x, newdata = train, type = "prob")[, "X1"]) %>%
      mutate(class = ifelse(class == "X0", 0, 1))
  })) %>%
  mutate(test.pred = map(.x = model, .f = function(x) {
    test %>%
      mutate(pred = predict(object = x, newdata = test, type = "prob")[, "X1"]) %>%
      mutate(class = ifelse(class == "X0", 0, 1))
  })) %>%
  mutate(plot = pmap(.l = list(train.pred, test.pred, model.name), .f = function(x, y, z) {
    score_distribution_plot(train_pred = x, test_pred = y, target = "class", score = "pred") +
      ggtitle(label = paste(z %>%
        str_remove("_model") %>%
        toupper(), "Population Distribution", sep = " ")) +
      theme(
        plot.title = element_text(size = 10, hjust = 0.5, face = "bold"),
        text = element_text(size = 10, hjust = 0.5, family = "CAL"),
        axis.title.y = element_text(face = "bold", hjust = 0.5),
        axis.title.x = element_text(face = "bold", hjust = 0.5),
        axis.text.x = element_text(size = 8, face = "bold", family = "CAL", hjust = 0.5, vjust = 0.5),
        axis.text.y = element_text(size = 8, face = "bold", family = "CAL", hjust = 0.5, vjust = 0.5)
      )
  }))

# do.call(grid.arrange,c(score.distribution.plot$plot,ncol = 5))
marrangeGrob(score.distribution.plot$plot, nrow = 1, ncol = 1, npages = length(score.distribution.plot$plot))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-157-1.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-157-2.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-157-3.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-157-4.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-157-5.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-157-6.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-157-7.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-157-8.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-157-9.png" width="672" style="display: block; margin: auto;" />

- 表格形式展示信息


```r
ls() %>%
  as_tibble() %>%
  setNames("model.name") %>%
  dplyr::filter(str_detect(model.name, "_model")) %>%
  dplyr::filter(!model.name %in% c("J48_model")) %>%
  group_by(model.name) %>%
  mutate(model = list(get(model.name))) %>%
  mutate(train.pred = map(.x = model, .f = function(x) {
    train %>%
      mutate(pred = predict(object = x, newdata = train, type = "prob")[, "X1"]) %>%
      mutate(class = ifelse(class == "X0", 0, 1))
  })) %>%
  mutate(test.pred = map(.x = model, .f = function(x) {
    test %>%
      mutate(pred = predict(object = x, newdata = test, type = "prob")[, "X1"]) %>%
      mutate(class = ifelse(class == "X0", 0, 1))
  })) %>%
  mutate(perf.tab = pmap(.l = list(train.pred, test.pred, model.name), .f = function(x, y, z) {
    perf_table(train_pred = x, test_pred = y, target = "class", score = "pred") %>%
      mutate(bins = str_sub(bins, 4, nchar(bins))) %>%
      mutate(group = 1:n()) %>%
      mutate(model = z) %>%
      dplyr::select(model, group, everything())
  })) %>%
  dplyr::select(perf.tab) %>%
  unnest(perf.tab)
```

```
#> # A tibble: 79 × 20
#> # Groups:   model.name [9]
#>    model.name       model group bins  `#total` `#train` `#test` `%train` `%test`
#>    <chr>            <chr> <int> <chr>    <dbl>    <dbl>   <dbl>    <dbl>   <dbl>
#>  1 AdaBoost.M1_mod… AdaB…     1 (-In…       77       58      19     0.09    0.07
#>  2 AdaBoost.M1_mod… AdaB…     2 (0.0…      134       93      41     0.14    0.14
#>  3 AdaBoost.M1_mod… AdaB…     3 (0.0…       71       51      20     0.08    0.07
#>  4 AdaBoost.M1_mod… AdaB…     4 (0.1…      120       85      35     0.13    0.12
#>  5 AdaBoost.M1_mod… AdaB…     5 (0.1…       83       52      31     0.08    0.11
#>  6 AdaBoost.M1_mod… AdaB…     6 (0.1…       94       69      25     0.1     0.09
#>  7 AdaBoost.M1_mod… AdaB…     7 (0.2…       94       67      27     0.1     0.09
#>  8 AdaBoost.M1_mod… AdaB…     8 (0.2…      100       74      26     0.11    0.09
#>  9 AdaBoost.M1_mod… AdaB…     9 (0.3…      101       66      35     0.1     0.12
#> 10 AdaBoost.M1_mod… AdaB…    10 (0.4…       93       62      31     0.09    0.11
#> # ℹ 69 more rows
#> # ℹ 11 more variables: `%train_B` <dbl>, `%test_B` <dbl>, `%train_cumG` <dbl>,
#> #   `%train_cumB` <dbl>, `%test_cumG` <dbl>, `%test_cumB` <dbl>,
#> #   `train_K-S` <dbl>, `test_K-S` <dbl>, train_Lift <dbl>, test_Lift <dbl>,
#> #   PSI <dbl>
```


- 响应概率曲线

下面这个概率相应曲线看起来是没问题的，但是经过后期和`biomod2`包所跑结果比对，这个结果是不靠谱的。排查原因的话，是和数据没关系的<s>我利用`caret`和`randomForest`两个包所跑的随机森林模型对统一数据进行预测，发现预测概率结果是不同的</s>。万般无奈之下，我选择在先挑选出最优模型之后使用其他包`biomod2`以及`sdm`来跑这些模型


```r
rf_model %>%
  .$coefnames %>%
  as_tibble()
```

```
#> # A tibble: 18 × 1
#>    value            
#>    <chr>            
#>  1 aat0             
#>  2 aat10            
#>  3 aridity          
#>  4 dem              
#>  5 dst_waterway     
#>  6 hfp              
#>  7 hii              
#>  8 im               
#>  9 landcover        
#> 10 landform         
#> 11 ndvi20161        
#> 12 ndvi20162        
#> 13 ndvi20163        
#> 14 ndvi20164        
#> 15 night_time_lights
#> 16 pa               
#> 17 slope            
#> 18 tadem
```

```r
ls() %>%
  as_tibble() %>%
  setNames("model.name") %>%
  dplyr::filter(str_detect(model.name, "_model")) %>%
  # dplyr::filter(! model.name %in% c("J48_model","nb_model")) %>%
  group_by(model.name) %>%
  mutate(model = list(get(model.name))) %>%
  mutate(expl.name = map(model, ~ .x$coefnames %>% as_tibble()))
```

```
#> # A tibble: 9 × 3
#> # Groups:   model.name [9]
#>   model.name        model   expl.name        
#>   <chr>             <list>  <list>           
#> 1 AdaBoost.M1_model <train> <tibble [18 × 1]>
#> 2 C5.0_model        <train> <tibble [18 × 1]>
#> 3 gbm_model         <train> <tibble [18 × 1]>
#> 4 glm_model         <train> <tibble [18 × 1]>
#> 5 knn_model         <train> <tibble [18 × 1]>
#> 6 nb_model          <train> <tibble [18 × 1]>
#> 7 rf_model          <train> <tibble [18 × 1]>
#> 8 svm_model         <train> <tibble [18 × 1]>
#> 9 xgb_model         <train> <tibble [18 × 1]>
```

```r
varImp(rf_model) %>%
  .$importance %>%
  rownames_to_column("expl.name") %>%
  as_tibble() %>%
  setNames(c("expl.name", "importance")) %>%
  arrange(desc(importance)) %>%
  dplyr::select(expl.name)
```

```
#> # A tibble: 18 × 1
#>    expl.name        
#>    <chr>            
#>  1 dst_waterway     
#>  2 ndvi20164        
#>  3 aat0             
#>  4 aridity          
#>  5 ndvi20163        
#>  6 pa               
#>  7 landcover        
#>  8 ndvi20161        
#>  9 im               
#> 10 aat10            
#> 11 night_time_lights
#> 12 ndvi20162        
#> 13 slope            
#> 14 dem              
#> 15 hfp              
#> 16 hii              
#> 17 tadem            
#> 18 landform
```

```r
a <- varImp(rf_model) %>%
  .$importance %>%
  rownames_to_column("expl.name") %>%
  as_tibble() %>%
  setNames(c("expl.name", "importance")) %>%
  arrange(desc(importance)) %>%
  dplyr::select(expl.name) %>%
  mutate(model = list(rf_model)) %>%
  # 生成模型列
  mutate(train.data = list(train)) %>%
  # 对指定变量之外变量进行处理
  mutate(train.processed = map2(expl.name, train.data, .f = function(x, y) {
    y %>%
      dplyr::select(-class) %>%
      # 对17个自变量做取均值/中位数等处理
      mutate(across(.cols = -x, .fns = mean)) %>%
      # 对目标自变量等间距拉伸
      mutate(across(.cols = x, .fns = function(x) {
        tmp <- seq(from = min(x), max(x), length.out = length(x))
        return(tmp)
      }))
  })) %>%
  # 使用模型预测
  mutate(prob = pmap(.l = list(model, train.processed, expl.name), .f = function(x, y, z) {
    predict(object = x, newdata = y, type = "prob") %>%
      dplyr::select(X1) %>%
      setNames("prob") %>%
      bind_cols(y %>%
        dplyr::select(z) %>%
        setNames("value"))
  }))
myrp <- a %>%
  dplyr::select(-model, -train.data, -train.processed) %>%
  mutate(plot = map2(.x = prob, .y = expl.name, .f = function(x, y) {
    ggplot(data = x, aes(value, prob)) +
      geom_line() +
      geom_point(size = 1, alpha = 1 / 5) +
      geom_smooth() +
      ggtitle(paste(y)) +
      theme_light() +
      scale_x_continuous(n.breaks = 7) +
      scale_y_continuous(labels = function(x) paste0(x * 100, "%")) +
      # labs(x = "Environmental factor",
      # y = "Probability of existance") +
      theme(
        plot.title = element_text(size = 14, hjust = 0.5),
        # text = element_text(size = 12,hjust = 0.5,family = "CAL"),
        axis.title.y = element_text(size = 14, hjust = 0.5, family = "CAL"),
        axis.title.x = element_text(size = 14, hjust = 0.5, family = "CAL"),
        axis.text.x = element_text(size = 13, family = "RMN", hjust = 0.5, vjust = 0.5),
        axis.text.y = element_text(size = 13, family = "RMN", hjust = 0.5, vjust = 0.5),
        strip.text = element_text(size = 14, family = "CAL")
      )
  }))
# do.call(grid.arrange,c(myrp$plot,ncol = 6))
marrangeGrob(myrp$plot, nrow = 1, ncol = 1, npages = length(myrp$plot))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-159-1.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-159-2.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-159-3.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-159-4.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-159-5.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-159-6.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-159-7.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-159-8.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-159-9.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-159-10.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-159-11.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-159-12.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-159-13.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-159-14.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-159-15.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-159-16.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-159-17.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-159-18.png" width="672" style="display: block; margin: auto;" />
