---
title: "使用tmap对全球肥胖率数据绘图"
author: "学R不思则罔"
date: '2023-02-15'
output:
  prettydoc::html_pretty:
    theme: cayman
    highlight: github
categories: ["R"]
tags: ["dplyr", "sf","ggplot2"]
description: "使用营养学相关数据绘制全球分布，包含数据读取筛选、分组汇总、图形字体选用、标签设置等细节优化"
toc: true
---





## 1.准备工作

### 1.1 加载扩展包


```r
library(readxl)
library(tmap)
library(dplyr)
library(maps)
library(sf)
library(RColorBrewer)
```

### 1.2 读取字体


```r
library(extrafont)
library(showtext)
showtext_auto(enable = TRUE)
font_add("RMN", "./font/Times New Roman.ttf")
font_add("KaiTi", "./font/KaiTi.ttf")
```

### 1.3 设计图形零件


```r
world_json <- read_sf("world_high_resolution_mill.geo.json")
# 图<b1>
plot_title <- c(
  "Omega-3 polyunsaturated fat intake (% energy/day) for adults ≥20 years (＞2010)",
  "Omega-6 polyunsaturated fat intake (mg/day) for adults ≥20 years (>2010)",
  "Omega-6/omega-3 polyunsaturated fat intake for adults ≥20 years (>2010)"
)
# 图
legend_title <- c("% energy/day", "mg/day", "Omega-6/omega-3 \npolyunsaturated fat")
# 填
fill_breaks <- list(
  c(0.6, 1.2, 1.8, 2.4, 3),
  c(5, 10, 15, 20, 25),
  c(10, 20, 30, 40, 50)
)

# 区
breaks_label <- list(
  c("<0.6", "0.6-1.2", "1.2-1.8", "1.8-2.4", "2.4-3.0", "≥3.0"),
  c("<5", "5-10", "10-15", "15-20", "20-25", "≥25"),
  c("0-10", "10-20", "20-30", "30-40", "40-50", "≥50")
)
```

## 2. 绘图


```r
for (i in 1:2) {
  # 绘
  data_raw <-
    readxl::read_excel("world_omega36.xlsx", sheet = i) %>%
    setNames(c("Country", "value")) %>%
    dplyr::filter(!is.na(Country)) %>%
    dplyr::filter(!is.na(value)) %>%
    dplyr::filter(Country != "Regional Average") %>%
    dplyr::filter(Country != "	Global Average")

  data(World)

  data_sf_sub1 <- data_raw %>%
    left_join(World %>% dplyr::select(name), by = c("Country" = "name")) %>%
    st_as_sf() %>%
    filter(!st_is_empty(.)) %>%
    st_transform(crs = 4326)

  data_sf_sub2 <- data_raw %>%
    left_join(World %>% dplyr::select(name), by = c("Country" = "name")) %>%
    st_as_sf() %>%
    filter(st_is_empty(.)) %>%
    arrange(Country) %>%
    dplyr::filter(Country != "Global Average") %>%
    dplyr::mutate(Country = case_when(
      Country == "C<U+00F4>te d'Ivoire" ~ "Cote d'Ivoire",
      Country == "Congo, the Democratic Republic of the" ~ "Democratic Republic of the Congo",
      Country == "Korea, Republic of" ~ "Republic of Korea",
      Country == "Korea, Democratic People's Republic of" ~ "Democratic People's Republic of Korea",
      Country == "Libyan Arab Jamahiriya" ~ "Libya",
      Country == "Macedonia, the Former Yugoslav Republic of" ~ "the former Yugoslav Republic of Macedonia",
      Country == "Micronesia, Federated States of" ~ "the former Yugoslav Republic of Macedonia",
      Country == "Occupied Palestinian Territory" ~ "the former Yugoslav Republic of Macedonia",
      Country == "Viet Nam" ~ "Vietnam",
      TRUE ~ Country
    )) %>%
    left_join(iso3166 %>%
      dplyr::select(ISOname, a3), by = c("Country" = "ISOname")) %>%
    st_drop_geometry() %>%
    left_join(world_json, by = c("a3" = "code")) %>%
    st_as_sf() %>%
    dplyr::select(Country = name_en, value) %>%
    filter(!st_is_empty(.)) %>%
    st_transform(crs = 4326)

  data_sf <- data_sf_sub1 %>%
    bind_rows(data_sf_sub2) %>%
    sf::st_make_valid()

  tm_p <- tm_shape(data_sf) +
    tm_fill(
      col = "value",
      breaks = c(min(data_sf$value), fill_breaks[[i]], max(data_sf$value)),
      labels = breaks_label[[i]],
      palette = brewer.pal(7, "RdYlGn"),
      title = legend_title[i],
      style = "pretty"
    ) +
    tm_borders(col = "black", lwd = 0.5) +
    # 静态<c
    tmap_mode(mode = "plot") +
    # 设<b6>
    tm_layout(
      bg.color = "white",
      # 设<d6>
      # panel.labels = plot_title[i],
      # panel.label.bg.color = "white",
      # panel.label.size = 1,
      # panel.label.fontfamily = "RMN",

      # 设置图<
      title = plot_title[i],
      title.size = 0.8,
      title.position = c("left", "top"),
      frame = T,

      # 设<d6>
      legend.title.size = 0.6,
      legend.text.size = 0.5,
      legend.position = c("left", "bottom"),
      legend.frame = F,
      legend.title.fontface = "italic",
      legend.text.color = "grey40",
      legend.text.fontfamily = "RMN",
      inner.margins = c(.02, .15, .06, .15)
    )
  tm_p

  tmap_save(tm_p,
    paste0(getwd(), "./result/", i, ".png"),
    width = 1220, height = 480, asp = 0
  )
}
tm_p
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-4-1.png" width="672" />


- 单独绘制比值那张图


```r
i <- 3
# 绘
data_raw <-
  readxl::read_excel("world_omega36.xlsx", sheet = i) %>%
  setNames(c("Country", "value")) %>%
  dplyr::filter(!is.na(Country)) %>%
  dplyr::filter(!is.na(value)) %>%
  dplyr::filter(Country != "Regional Average") %>%
  dplyr::filter(Country != "	Global Average")

data(World)

data_sf_sub1 <- data_raw %>%
  left_join(World %>% dplyr::select(name), by = c("Country" = "name")) %>%
  st_as_sf() %>%
  filter(!st_is_empty(.)) %>%
  st_transform(crs = 4326)

data_sf_sub2 <- data_raw %>%
  left_join(World %>% dplyr::select(name), by = c("Country" = "name")) %>%
  st_as_sf() %>%
  filter(st_is_empty(.)) %>%
  arrange(Country) %>%
  dplyr::filter(Country != "Global Average") %>%
  dplyr::mutate(Country = case_when(
    Country == "C<U+00F4>te d'Ivoire" ~ "Cote d'Ivoire",
    Country == "Congo, the Democratic Republic of the" ~ "Democratic Republic of the Congo",
    Country == "Korea, Republic of" ~ "Republic of Korea",
    Country == "Korea, Democratic People's Republic of" ~ "Democratic People's Republic of Korea",
    Country == "Libyan Arab Jamahiriya" ~ "Libya",
    Country == "Macedonia, the Former Yugoslav Republic of" ~ "the former Yugoslav Republic of Macedonia",
    Country == "Micronesia, Federated States of" ~ "the former Yugoslav Republic of Macedonia",
    Country == "Occupied Palestinian Territory" ~ "the former Yugoslav Republic of Macedonia",
    Country == "Viet Nam" ~ "Vietnam",
    TRUE ~ Country
  )) %>%
  left_join(iso3166 %>%
    dplyr::select(ISOname, a3), by = c("Country" = "ISOname")) %>%
  st_drop_geometry() %>%
  left_join(world_json, by = c("a3" = "code")) %>%
  st_as_sf() %>%
  dplyr::select(Country = name_en, value) %>%
  filter(!st_is_empty(.)) %>%
  st_transform(crs = 4326)
```



```r
data_sf <- data_sf_sub1 %>%
  bind_rows(data_sf_sub2) %>%
  sf::st_make_valid()
head(data_sf)
```

```
## Simple feature collection with 6 features and 2 fields
## Geometry type: MULTIPOLYGON
## Dimension:     XY
## Bounding box:  xmin: 39.95501 ymin: 31.02958 xmax: 145.5431 ymax: 55.38525
## Geodetic CRS:  WGS 84
## # A tibble: 6 × 3
##   Country    value                                                      geometry
##   <chr>      <dbl>                                            <MULTIPOLYGON [°]>
## 1 Japan       4.81 (((133.9041 34.36493, 133.493 33.94462, 132.9244 34.0603, 13…
## 2 Armenia    27.6  (((43.75266 40.7402, 43.65644 40.25356, 44.40001 40.005, 44.…
## 3 Azerbaijan 37.5  (((44.79399 39.713, 44.95269 39.33576, 45.45772 38.87414, 46…
## 4 Georgia    31.2  (((42.61955 41.58317, 43.58275 41.09214, 44.97248 41.24813, …
## 5 Kazakhstan 21.3  (((71.18628 42.70429, 71.84464 42.8454, 73.48976 42.50089, 7…
## 6 Kyrgyzstan 30.7  (((71.25925 42.16771, 70.42002 41.52, 71.15786 41.14359, 71.…
```



```r
tm_p <- data_sf %>%
  mutate(value = cut(value,
    breaks = c(0, 10, 20, 30, 40, 50, +Inf),
    labels = c("0-10", "10-20", "20-30", "30-40", "40-50", "≥50")
  )) %>%
  tm_shape() +
  tm_fill(
    col = "value",
    # breaks = c(min(data_sf$value),fill_breaks[[i]],max(data_sf$value)),
    # labels = breaks_label[[i]],
    palette = brewer.pal(7, "RdYlGn"),
    title = legend_title[i],
    style = "pretty"
  ) +
  tm_borders(col = "black", lwd = 0.5) +
  # 静态<cd>
  tmap_mode(mode = "plot") +
  # 设定图
  tm_layout(
    bg.color = "white",
    # 设置面
    # panel.labels = plot_title[i],
    # panel.label.bg.color = "white",
    # panel.label.size = 1,
    # panel.label.fontfamily = "RMN",

    # 设置图<b1>
    title = plot_title[i],
    title.size = 0.8,
    title.position = c("left", "top"),
    frame = T,

    # 设置图
    legend.title.size = 0.6,
    legend.text.size = 0.5,
    legend.position = c("left", "bottom"),
    legend.frame = F,
    legend.title.fontface = "italic",
    legend.text.color = "grey40",
    legend.text.fontfamily = "RMN",
    inner.margins = c(.02, .15, .06, .15)
  )
tm_p
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-7-1.png" width="672" />



```r
tmap_save(tm_p,
  paste0(getwd(), "./result/", i, ".png"),
  width = 1220, height = 480, asp = 0
)
```

---------------------
