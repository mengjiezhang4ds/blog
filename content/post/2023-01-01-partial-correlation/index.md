---
title: "栅格数据偏相关分析"
author: "学R不思则罔"
date: '2023-01-05'
output:
  prettydoc::html_pretty:
    theme: cayman
    highlight: github
categories: ["R"]
tags: ["dplyr", "terra","ggplot2"]
description: "使用terra包对栅格数据进行逐项元偏相关分析"
toc: true
---

## 0.西海情歌

``` r
library(embedr)
audio <- "西海情歌.mp3"
embed_audio(audio, attribute = c("controls"))
```

<audio controls> <source src='西海情歌.mp3' type='audio/mpeg'> Your browser does not support the audio tag;  for browser support, please see:  https://www.w3schools.com/tags/tag_audio.asp </audio>

``` r
library(terra)
library(tidyverse)
library(tidyterra)
```

## 1.无缺失值情况

### 1.1 生成数据

``` r
sos <- rast(array(runif(10 * 10 * 20), c(10, 10, 20)))
tem <- rast(array(runif(10 * 10 * 20), c(10, 10, 20)))
pre <- rast(array(runif(10 * 10 * 20), c(10, 10, 20)))
NDVI <- rast(array(runif(10 * 10 * 20), c(10, 10, 20)))
z <- c(NDVI, tem, pre)
```

### 1.2 编写函数

``` r
fun_cor <- function(x) {
  Rs <- ppcor::pcor.test(x[1:20], x[21:40], x[41:60])
  Rx <- Rs$estimate
  Px <- Rs$p.value
  return(c(Rx, Px))
}
pc_res <- app(z, fun_cor, cores = 4)
pc_res
```

    ## class       : SpatRaster 
    ## dimensions  : 10, 10, 2  (nrow, ncol, nlyr)
    ## resolution  : 1, 1  (x, y)
    ## extent      : 0, 10, 0, 10  (xmin, xmax, ymin, ymax)
    ## coord. ref. :  
    ## source(s)   : memory
    ## names       :      lyr.1,       lyr.2 
    ## min values  : -0.6715273, 0.001641855 
    ## max values  :  0.5543745, 0.993421419

### 1.3 结果可视化

``` r
plot(pc_res)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-5-1.png" width="672" />

## 2.存在缺失值情况

### 2.1 生成数据

``` r
ndvi <- rast(array(runif(10 * 10 * 20), c(10, 10, 20)))
names(ndvi) <- paste0("ndvi", 1:20)
sos <- rast(array(runif(10 * 10 * 20), c(10, 10, 20)))
names(sos) <- paste0("sos", 1:20)
tem <- rast(array(runif(10 * 10 * 20), c(10, 10, 20)))
names(tem) <- paste0("tem", 1:20)
ssd <- rast(array(runif(10 * 10 * 20), c(10, 10, 20)))
names(ssd) <- paste0("ssd", 1:20)
pre <- rast(array(runif(10 * 10 * 20), c(10, 10, 20)))
names(pre) <- paste0("pre", 1:20)
# 合并数据
all_data <- c(ndvi, sos, tem, ssd, pre)
all_data
```

    ## class       : SpatRaster 
    ## dimensions  : 10, 10, 100  (nrow, ncol, nlyr)
    ## resolution  : 1, 1  (x, y)
    ## extent      : 0, 10, 0, 10  (xmin, xmax, ymin, ymax)
    ## coord. ref. :  
    ## source(s)   : memory
    ## names       :       ndvi1,       ndvi2,       ndvi3,        ndvi4,      ndvi5,      ndvi6, ... 
    ## min values  : 0.005713493, 0.007358169, 0.001519259, 0.0003856248, 0.01222557, 0.01009995, ... 
    ## max values  : 0.999250853, 0.995558584, 0.996669351, 0.9967179818, 0.98248789, 0.99712850, ...

### 2.2 编写函数

``` r
func_pcor <- function(x) {
  temp_ndvi <- x[1:20]
  temp_sos <- x[21:40]
  temp_tem <- x[41:60]
  temp_ssd <- x[61:80]
  temp_pre <- x[81:100]

  temp_data <- data.frame(cbind(temp_ndvi, temp_sos, temp_tem, temp_ssd, temp_pre))

  if (is.na(sum(temp_data))) {
    return(c(NA, NA, NA, NA, NA, NA, NA, NA))
  } else {
    corValue <- ppcor::pcor(temp_data)
    # 相关系数
    cor_pre <- corValue$estimate[1, 2]
    cor_tem <- corValue$estimate[1, 3]
    cor_rhu <- corValue$estimate[1, 4]
    cor_ssd <- corValue$estimate[1, 5]
    # 显著性
    pvalue_pre <- corValue$p.value[1, 2]
    pvalue_tem <- corValue$p.value[1, 3]
    pvalue_rhu <- corValue$p.value[1, 4]
    pvalue_ssd <- corValue$p.value[1, 5]

    print(c(cor_pre, cor_tem, cor_rhu, cor_ssd))
    return(c(cor_pre, pvalue_pre, cor_tem, pvalue_tem, cor_rhu, pvalue_rhu, cor_ssd, pvalue_ssd))
  }
}
pc_res <- terra::app(all_data, func_pcor, cores = 8)
```

    ## [1]  0.1109228  0.1524621  0.1571929 -0.1581176
    ## [1] -0.2370984 -0.3740203 -0.3060371 -0.2669154
    ## [1]  0.29817136 -0.08232196 -0.23883653 -0.07014584
    ## [1] -0.1489053 -0.3588139 -0.2812474  0.4646105
    ## [1] -0.3654143  0.1390341 -0.2352565 -0.3259933
    ## [1]  0.01927616  0.20679737 -0.13743319 -0.42337333
    ## [1]  0.21838445  0.05984813 -0.17028954 -0.37680067
    ## [1] -0.30852194 -0.17220729 -0.48607360 -0.03088648
    ## [1] -0.09231782 -0.10577304  0.31940466 -0.05586390
    ## [1]  0.04020495  0.27958506  0.03005220 -0.17942730

``` r
# names(pc_res) = c("pre","pre_pvalue", "tem","tem_pvalue","rhu","rhu_pvalue","ssd","ssd_pvalue")
```

### 2.3 结果可视化

``` r
plot(pc_res)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-8-1.png" width="672" />

### 2.4 结果保存删除

``` r
writeRaster(pc_res, "pc_res.tif", overwrite = TRUE)
rast("pc_res.tif") %>% plot()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-9-1.png" width="672" />

``` r
file.remove("pc_res.tif")
```

    ## [1] TRUE

------------------------------------------------------------------------
