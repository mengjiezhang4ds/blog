# 加载包
library(readxl)
library(tmap)
library(dplyr)
library(maps)
library(sf)
library(RColorBrewer)

# 世界地图数据
world_json <- read_sf("world_high_resolution_mill.geo(1).json")

for (i in 1:3) {
  # 绘图数据
  data_raw <-
    readxl::read_excel("raw_data.xlsx",sheet = i) %>% 
    setNames(c("Country","value")) %>% 
    dplyr::filter(! is.na(Country)) %>% 
    dplyr::filter(! is.na(value)) %>% 
    dplyr::filter(Country != "Regional Average") %>% 
    dplyr::filter(Country != "	Global Average")
  
  # 图例名称
  title_name <- readxl::read_excel("raw_data.xlsx",sheet = i) %>% 
    colnames() %>% 
    .[2]
  
  data(World) 
  
  data_sf_sub1 <- data_raw %>% 
    left_join(World %>% dplyr::select(name),by = c("Country" = "name")) %>% 
    st_as_sf() %>% 
    filter(!st_is_empty(.)) %>% 
    st_transform(crs = 4326)
  
  data_sf_sub2 <- data_raw %>% 
    left_join(World %>% dplyr::select(name),by = c("Country" = "name")) %>% 
    st_as_sf() %>% 
    filter(st_is_empty(.)) %>% 
    arrange(Country) %>% 
    dplyr::filter(Country != "Global Average") %>% 
    dplyr::mutate(Country = case_when(
      Country == "Côte d'Ivoire" ~ "Cote d'Ivoire",
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
                dplyr::select(ISOname,a3),by = c("Country" = "ISOname")) %>% 
    st_drop_geometry() %>% 
    left_join(world_json,by = c("a3" = "code")) %>% 
    st_as_sf() %>%
    dplyr::select(Country = name_en,value) %>% 
    filter(!st_is_empty(.)) %>% 
    st_transform(crs = 4326)
  
  data_sf <- data_sf_sub1 %>% 
    bind_rows(data_sf_sub2)
  
  tm_p <- tm_shape(data_sf) +
    tm_fill(col = "value",
            palette = rev(brewer.pal(7,"Spectral")),
            title = title_name,
            style = "pretty") +
    tm_borders(col = "black",lwd = 0.5) +
    # 静态图形式
    tmap_mode(mode = "plot") +
    # 设定图片边界
    tm_layout(bg.color = "white",
              title.size =  1,           
              legend.title.size = 0.7, 
              legend.text.size = 0.6,
              legend.position = c("left","bottom"),
              legend.title.fontface = "italic",
              title.position = c("center","top"),
              inner.margins = c(.02, .15, .06, .15))
  
  tmap_save(tm_p,
            paste0(getwd(),"/图片",i,".png"),
            width=1920, height=1080, asp=0)
}


# 绘图数据
data_raw <-
  readxl::read_excel("raw_data.xlsx",sheet = 4) %>% 
  setNames(c("Country","value")) %>% 
  dplyr::filter(! is.na(Country)) %>% 
  dplyr::filter(! is.na(value)) %>% 
  dplyr::filter(Country != "Regional Average") %>% 
  dplyr::filter(Country != "	Global Average")

# 图例名称
title_name <- readxl::read_excel("raw_data.xlsx",sheet = 4) %>% 
  colnames() %>% 
  .[2]

data(World) 

data_sf_sub1 <- data_raw %>% 
  left_join(World %>% dplyr::select(name),by = c("Country" = "name")) %>% 
  st_as_sf() %>% 
  filter(!st_is_empty(.)) %>% 
  st_transform(crs = 4326)

data_sf_sub2 <- data_raw %>% 
  left_join(World %>% dplyr::select(name),by = c("Country" = "name")) %>% 
  st_as_sf() %>% 
  filter(st_is_empty(.)) %>% 
  arrange(Country) %>% 
  dplyr::filter(Country != "Global Average") %>% 
  dplyr::mutate(Country = case_when(
    Country == "Côte d'Ivoire" ~ "Cote d'Ivoire",
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
              dplyr::select(ISOname,a3),by = c("Country" = "ISOname")) %>% 
  st_drop_geometry() %>% 
  left_join(world_json,by = c("a3" = "code")) %>% 
  st_as_sf() %>%
  dplyr::select(Country = name_en,value) %>% 
  filter(!st_is_empty(.)) %>% 
  st_transform(crs = 4326)

data_sf <- data_sf_sub1 %>% 
  bind_rows(data_sf_sub2)
 

tm_p <- data_sf %>% 
  mutate(value = cut(value, 
                    breaks = c(0,50,74,99,149,199,249,349,449,549,+Inf),
                    labels = c("< 50","50 ~ 74","74 ~ 99",
                               "99 ~ 149","149 ~ 199","199 ~ 249","249 ~ 349",
                               "349 ~ 449","449 ~ 549","> 549"))) %>% 
  tm_shape() +
  tm_fill(col = "value",
          palette = "-Spectral",
          title = title_name,
          legend.format = list(text.align="right", text.to.columns = TRUE),
          style = "pretty") +
  tm_borders(col = "black",lwd = 0.5) +
  # 静态图形式
  tmap_mode(mode = "plot") +
  # 设定图片边界
  tm_layout(bg.color = "white",
            title.size =  1,           
            legend.title.size = 0.7, 
            legend.text.size = 0.6,
            legend.position = c("left","bottom"),
            legend.title.fontface = "italic",
            title.position = c("center","top"),
            inner.margins = c(.02, .15, .06, .15))

tmap_save(tm_p,
          paste0(getwd(),"/图片",4,".png"),
          width=1920, height=1080, asp=0)
