---
title: "中国新冠肺炎疫情地图可视化"
author: "学R不思则罔"
date: '2021-12-01'
output:
  prettydoc::html_pretty:
    theme: cayman
    highlight: github
subtitle: "基于2020年2月25日数据"
thumbnail: "新冠肺炎确诊病例省份分布.png"
categories: ["R"]
tags: ["dplyr", "sf","ggplot2"]
description: "使用2020年2月25日中国各省级行政区的新冠肺炎疫情数据绘制各省份感染地图，包含数据读取筛选、分组汇总、图形字体选用、标签设置、指南针比例尺添加等细节优化"
toc: true
---





# 1.加载扩展包


```r
library(readxl)
library(dplyr)
library(ggplot2)
library(sf)
```

# 2.数据处理


```r
data <- read_excel("data.xlsx") %>% 
  mutate(date = as.Date(date)) %>% 
  dplyr::filter(date == "2020-02-25") %>% 
  dplyr::filter(countrycode == "CN") %>% 
  dplyr::filter(! is.na(provincecode)) %>% 
  mutate(across(.cols = provincecode,.fns = as.character)) %>% 
  group_by(province,provincecode) %>% 
  summarise(confirmed = sum(confirmed,na.rm = TRUE))
```

```
## `summarise()` has grouped output by 'province'. You can override using the
## `.groups` argument.
```

```r
kableExtra::kable(head(data))
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> province </th>
   <th style="text-align:left;"> provincecode </th>
   <th style="text-align:right;"> confirmed </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 上海市 </td>
   <td style="text-align:left;"> 310000 </td>
   <td style="text-align:right;"> 672 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 云南省 </td>
   <td style="text-align:left;"> 530000 </td>
   <td style="text-align:right;"> 348 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 内蒙古自治区 </td>
   <td style="text-align:left;"> 150000 </td>
   <td style="text-align:right;"> 150 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 北京市 </td>
   <td style="text-align:left;"> 110000 </td>
   <td style="text-align:right;"> 800 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 台湾省 </td>
   <td style="text-align:left;"> 710000 </td>
   <td style="text-align:right;"> 62 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 吉林省 </td>
   <td style="text-align:left;"> 220000 </td>
   <td style="text-align:right;"> 186 </td>
  </tr>
</tbody>
</table>



```r
province_sf <- read_sf('china_prov_full_map.json') %>% 
  mutate(across(.cols = 省代码,.fns = as.character)) %>% 
  left_join(x = .,y = data,by = c("省代码" = "provincecode"))
kableExtra::kable(head(province_sf))
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> 省代码 </th>
   <th style="text-align:left;"> 省 </th>
   <th style="text-align:left;"> 类型 </th>
   <th style="text-align:left;"> geometry </th>
   <th style="text-align:left;"> province </th>
   <th style="text-align:right;"> confirmed </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 110000 </td>
   <td style="text-align:left;"> 北京市 </td>
   <td style="text-align:left;"> 直辖市 </td>
   <td style="text-align:left;"> POLYGON ((944606.7 4978448,... </td>
   <td style="text-align:left;"> 北京市 </td>
   <td style="text-align:right;"> 800 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 120000 </td>
   <td style="text-align:left;"> 天津市 </td>
   <td style="text-align:left;"> 直辖市 </td>
   <td style="text-align:left;"> POLYGON ((1019641 4904366, ... </td>
   <td style="text-align:left;"> 天津市 </td>
   <td style="text-align:right;"> 270 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 130000 </td>
   <td style="text-align:left;"> 河北省 </td>
   <td style="text-align:left;"> 省 </td>
   <td style="text-align:left;"> MULTIPOLYGON (((1155620 480... </td>
   <td style="text-align:left;"> 河北省 </td>
   <td style="text-align:right;"> 622 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 140000 </td>
   <td style="text-align:left;"> 山西省 </td>
   <td style="text-align:left;"> 省 </td>
   <td style="text-align:left;"> POLYGON ((744116.6 4918659,... </td>
   <td style="text-align:left;"> 山西省 </td>
   <td style="text-align:right;"> 266 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 150000 </td>
   <td style="text-align:left;"> 内蒙古自治区 </td>
   <td style="text-align:left;"> 自治区 </td>
   <td style="text-align:left;"> POLYGON ((1055732 6334586, ... </td>
   <td style="text-align:left;"> 内蒙古自治区 </td>
   <td style="text-align:right;"> 150 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 150000 </td>
   <td style="text-align:left;"> 中朝共有 </td>
   <td style="text-align:left;"> 不统计 </td>
   <td style="text-align:left;"> MULTIPOLYGON (((1584839 498... </td>
   <td style="text-align:left;"> 内蒙古自治区 </td>
   <td style="text-align:right;"> 150 </td>
  </tr>
</tbody>
</table>


# 3.绘图

> **[!Note]**        
> 对数据进行一次分组,具体分组在代码里面


```r
library(extrafont)
library(showtext)
showtext_auto(enable = TRUE)
font_add("Times", "./font/Times New Roman.ttf")
font_add("KaiTi", "./font/KaiTi.ttf")
```



```r
province_sf <- read_sf('china_prov_full_map.json') %>%
  mutate(across(.cols = 省代码,.fns = as.character)) %>% 
  left_join(x = .,y = data,by = c("省代码" = "provincecode")) %>% 
  mutate(confirmed_dis = case_when(
    is.na(confirmed) ~ "0~100",
    confirmed <= 100 ~ "0~100",
    confirmed <= 500 ~ "100~500",
    confirmed <= 1000 ~ "500~1000",
    confirmed <= 1500 ~ "1000~1500",
    confirmed <= 2000 ~ "1500~2000",
    confirmed <= 3000 ~ "2000~3000",
    TRUE ~ ">3000"
  ))
kableExtra::kable(head(province_sf))
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> 省代码 </th>
   <th style="text-align:left;"> 省 </th>
   <th style="text-align:left;"> 类型 </th>
   <th style="text-align:left;"> geometry </th>
   <th style="text-align:left;"> province </th>
   <th style="text-align:right;"> confirmed </th>
   <th style="text-align:left;"> confirmed_dis </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 110000 </td>
   <td style="text-align:left;"> 北京市 </td>
   <td style="text-align:left;"> 直辖市 </td>
   <td style="text-align:left;"> POLYGON ((944606.7 4978448,... </td>
   <td style="text-align:left;"> 北京市 </td>
   <td style="text-align:right;"> 800 </td>
   <td style="text-align:left;"> 500~1000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 120000 </td>
   <td style="text-align:left;"> 天津市 </td>
   <td style="text-align:left;"> 直辖市 </td>
   <td style="text-align:left;"> POLYGON ((1019641 4904366, ... </td>
   <td style="text-align:left;"> 天津市 </td>
   <td style="text-align:right;"> 270 </td>
   <td style="text-align:left;"> 100~500 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 130000 </td>
   <td style="text-align:left;"> 河北省 </td>
   <td style="text-align:left;"> 省 </td>
   <td style="text-align:left;"> MULTIPOLYGON (((1155620 480... </td>
   <td style="text-align:left;"> 河北省 </td>
   <td style="text-align:right;"> 622 </td>
   <td style="text-align:left;"> 500~1000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 140000 </td>
   <td style="text-align:left;"> 山西省 </td>
   <td style="text-align:left;"> 省 </td>
   <td style="text-align:left;"> POLYGON ((744116.6 4918659,... </td>
   <td style="text-align:left;"> 山西省 </td>
   <td style="text-align:right;"> 266 </td>
   <td style="text-align:left;"> 100~500 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 150000 </td>
   <td style="text-align:left;"> 内蒙古自治区 </td>
   <td style="text-align:left;"> 自治区 </td>
   <td style="text-align:left;"> POLYGON ((1055732 6334586, ... </td>
   <td style="text-align:left;"> 内蒙古自治区 </td>
   <td style="text-align:right;"> 150 </td>
   <td style="text-align:left;"> 100~500 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 150000 </td>
   <td style="text-align:left;"> 中朝共有 </td>
   <td style="text-align:left;"> 不统计 </td>
   <td style="text-align:left;"> MULTIPOLYGON (((1584839 498... </td>
   <td style="text-align:left;"> 内蒙古自治区 </td>
   <td style="text-align:right;"> 150 </td>
   <td style="text-align:left;"> 100~500 </td>
  </tr>
</tbody>
</table>



```r
library(stringr)
library(ggsflabel)
```

```
## 
## Attaching package: 'ggsflabel'
```

```
## The following objects are masked from 'package:ggplot2':
## 
##     geom_sf_label, geom_sf_text, StatSfCoordinates
```

```r
library(ggspatial)
```

```
## Warning: package 'ggspatial' was built under R version 4.2.3
```

```r
ggplot(province_sf) + 
  geom_sf(aes(fill = confirmed_dis),size = 0.1,color = "black") +
  scale_fill_manual(
    values = c("0~100" = "#FEF1DD",
               "100~500" = "#FDDDB2",
               "500~1000" = "#FDC38D", 
               "1000~1500" = "#FC9863",
               "1500~2000" = "#EF6648",
               "2000~3000" = "#D42C1C",
               ">3000" = "#A80000")
  ) +
  geom_sf_label_repel(
    data = province_sf %>% 
      dplyr::filter(str_sub(省,nchar(省)) %in% c("省","区","市")),
    aes(label = 省),family = 'KaiTi',
    nudge_x = -5, nudge_y = -5, seed = 10
  ) +
  guides(fill = guide_legend(nrow = 2,byrow = TRUE)) + 
  theme(plot.title = element_text(size = 16,hjust = 0.5,vjust = 0.5,face = "bold",family = "KaiTi"),
        plot.subtitle = element_text(size = 12,hjust = 0.5,vjust = 0.5,face = "bold",family = "KaiTi"),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks = element_blank(),
        legend.position = "bottom",
        legend.text = element_text(family = "Times"),
        legend.title = element_text(family = "KaiTi")) + 
  labs(fill = "确诊人数", 
       title = "新冠肺炎确诊病例省份分布",
       subtitle = paste0("2020-02-25 确诊病例 ",sum(province_sf$confirmed,na.rm = TRUE))) + 
  annotation_scale(location = "bl", width_hint = 0.3) +
  annotation_north_arrow(location = "tr", which_north = "false",
                         pad_x = unit(0.9, "cm"),
                         pad_y = unit(0.4, "cm"),
                         style = north_arrow_fancy_orienteering(
                           text_family = "KaiTi"
                         )) + 
  coord_sf(ylim = c(2068000, 6387786))
```

```
## Scale on map varies by more than 10%, scale bar may be inaccurate
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-6-1.png" width="960" />



```r
ggsave("新冠肺炎确诊病例省份分布.png",dpi = 200)
```

```
## Saving 7 x 5 in image
## Scale on map varies by more than 10%, scale bar may be inaccurate
```

---------------------
