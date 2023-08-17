# 加载包
library(readxl)
library(tmap)
library(dplyr)
library(maps)
library(sf)
library(RColorBrewer)

# 设置字体
windowsFonts(KT=windowsFont("KaiTi_GB2312"),
             RMN=windowsFont("Times New Roman"),
             ARL=windowsFont("Arial"))

# 世界地图数据
world_json <- read_sf("world_high_resolution_mill.geo(1).json")

# 图标题
plot_title <- c("Omega-3 polyunsaturated fat intake (% energy/day) for adults ≥20 years (＞2010)",
                "Omega-6 polyunsaturated fat intake (mg/day) for adults ≥20 years (>2010)",
                "Omega-6/omega-3 polyunsaturated fat intake for adults ≥20 years (>2010)")
# 图例标题
legend_title <- c("% energy/day","mg/day","Omega-6/omega-3 \npolyunsaturated fat")
# 填充区间
fill_breaks <- list(c(0.6,1.2,1.8,2.4,3),
                    c(5,10,15,20,25),
                    c(10,20,30,40,50))

# 区间标签
breaks_label <- list(c("<0.6","0.6-1.2","1.2-1.8","1.8-2.4","2.4-3.0","≥3.0"),
                     c("<5","5-10","10-15","15-20","20-25","≥25"),
                     c("0-10","10-20","20-30","30-40","40-50","≥50"))

# 绘图
for (i in 1:2) {
  # 绘图数据
  data_raw <-
    readxl::read_excel("world_omega36.xlsx",sheet = i) %>% 
    setNames(c("Country","value")) %>% 
    dplyr::filter(! is.na(Country)) %>% 
    dplyr::filter(! is.na(value)) %>% 
    dplyr::filter(Country != "Regional Average") %>% 
    dplyr::filter(Country != "	Global Average")
  
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
            breaks = c(min(data_sf$value),fill_breaks[[i]],max(data_sf$value)),
            labels = breaks_label[[i]],
            palette = brewer.pal(7,"RdYlGn"),
            title = legend_title[i],
            style = "pretty") +
    tm_borders(col = "black",lwd = 0.5) +
    # 静态图形式
    tmap_mode(mode = "plot") +
    # 设定图片边界
    tm_layout(bg.color = "white",
              # 设置面板参数
              # panel.labels = plot_title[i],
              # panel.label.bg.color = "white",
              # panel.label.size = 1,
              # panel.label.fontfamily = "RMN",
              
              # 设置图标题参数
              title = plot_title[i],
              title.size =  0.8,
              title.position = c("left","top"),
              
              frame = T,
              
              # 设置图例参数
              legend.title.size = 0.6, 
              legend.text.size = 0.5,
              legend.position = c("left","bottom"),
              legend.frame = F,
              legend.title.fontface = "italic",
              legend.text.color = "grey40",
              legend.text.fontfamily = "RMN",
              
              inner.margins = c(.02, .15, .06, .15))
  tm_p
  
  tmap_save(tm_p,
            paste0(getwd(),"/secondtime图片",i,".png"),
            width=1220, height=480, asp=0)
}




# 单独绘制比值那张图 ---------------------------------------------------------------



i <- 3
# 绘图数据
data_raw <-
  readxl::read_excel("world_omega36.xlsx",sheet = i) %>% 
  setNames(c("Country","value")) %>% 
  dplyr::filter(! is.na(Country)) %>% 
  dplyr::filter(! is.na(value)) %>% 
  dplyr::filter(Country != "Regional Average") %>% 
  dplyr::filter(Country != "	Global Average")

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
  mutate(value = cut(value,breaks = c(0,10,20,30,40,50,+Inf),
                     labels = c("0-10","10-20","20-30","30-40","40-50","≥50"))) %>% 
  tm_shape() +
  tm_fill(col = "value",
          # breaks = c(min(data_sf$value),fill_breaks[[i]],max(data_sf$value)),
          # labels = breaks_label[[i]],
          palette = brewer.pal(7,"RdYlGn"),
          title = legend_title[i],
          style = "pretty") +
  tm_borders(col = "black",lwd = 0.5) +
  # 静态图形式
  tmap_mode(mode = "plot") +
  # 设定图片边界
  tm_layout(bg.color = "white",
            # 设置面板参数
            # panel.labels = plot_title[i],
            # panel.label.bg.color = "white",
            # panel.label.size = 1,
            # panel.label.fontfamily = "RMN",
            
            # 设置图标题参数
            title = plot_title[i],
            title.size =  0.8,
            title.position = c("left","top"),
            
            frame = T,
            
            # 设置图例参数
            legend.title.size = 0.6, 
            legend.text.size = 0.5,
            legend.position = c("left","bottom"),
            legend.frame = F,
            legend.title.fontface = "italic",
            legend.text.color = "grey40",
            legend.text.fontfamily = "RMN",
            
            inner.margins = c(.02, .15, .06, .15))
tm_p

tmap_save(tm_p,
          paste0(getwd(),"/secondtime图片",i,".png"),
          width=1220, height=480, asp=0)

