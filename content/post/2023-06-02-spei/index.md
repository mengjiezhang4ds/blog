---
title: "标准化降水蒸散指数(SPEI)计算"
author: "学R不思则罔"
date: '2023-06-02'
output:
  prettydoc::html_pretty:
    theme: cayman
    highlight: github
thumbnail: "thumbnail.png"
categories: ["R"]
tags: ["snow", "nc","spei"]
description: "基于1901年到2022年的潜在蒸散量数据和降水量数据，使用**spei**函数多线程计算spei指数，输入和输出格式都以nc格式保存，提供nc转txt格式接口"
toc: true
---





## 1.加载扩展包

Compute SPEI at various time scales from very large netCDF files, using parallel computing. The resulting netCDF files are stored  to disk on directory './outputNcdf/'.


```r
if (!require('pacman')) install.packages('pacman')
pacman::p_load(ncdf4, snowfall, parallel, Hmisc, devtools)
```

Using SPEI package version 1.8.0. Please, note that this will replace any
 other version of the SPEI package that you might have installed!


```r
devtools::install_github('sbegueria/SPEI@v1.8.0')
```

## 2.加载函数

 A function to efficiently compute the SPEI over a large netCDF file (using multiple cores).


```r
source('./R/functions.R')
spei.nc
```

```
## function (sca, inPre, outFile, inEtp = NA, title = NA, comment = NA, 
##     version = NA, inMask = NA, block = 18, tlapse = NA) 
## {
##     require(ncdf4)
##     require(snowfall)
##     require(Hmisc)
##     pre.nc <- nc_open(inPre)
##     if (!is.na(inEtp)) {
##         etp.nc <- nc_open(inEtp)
##         isSPEI <- TRUE
##     }
##     else {
##         isSPEI <- FALSE
##     }
##     if (!is.na(inMask)) {
##         mask.nc <- nc_open(inMask)
##         isMask <- TRUE
##     }
##     else {
##         isMask <- FALSE
##     }
##     if (!is.na(tlapse[1])) {
##         spi.dim.tme <- ncdim_def(pre.nc$dim$time$name, pre.nc$dim$time$units, 
##             pre.nc$dim$time$vals[tlapse[1]:tlapse[2]], unlim = TRUE, 
##             calendar = "gregorian")
##     }
##     else {
##         spi.dim.tme <- ncdim_def(pre.nc$dim$time$name, pre.nc$dim$time$units, 
##             pre.nc$dim$time$vals, unlim = TRUE, calendar = "gregorian")
##     }
##     if (isSPEI) {
##         nam <- "spei"
##         longnam <- "Standardized Precipitation-Evapotranspiration Index"
##     }
##     else {
##         nam <- "spi"
##         longnam <- "Standardized Precipitation Index"
##     }
##     out.nc.var <- ncvar_def(name = nam, units = "1", dim = list(pre.nc$dim$lon, 
##         pre.nc$dim$lat, spi.dim.tme), missval = 1e+30, longname = longnam, 
##         prec = "float", compression = 9)
##     crs_def <- ncvar_def(name = "crs", units = "", dim = list(), 
##         longname = "CRS definition", prec = "integer")
##     out.nc <- nc_create(outFile, vars = list(out.nc.var, crs_def))
##     ncatt_put(out.nc, nam, "grid_mapping", "crs")
##     ncatt_put(out.nc, "crs", "grid_mapping_name", "latitude_longitude")
##     ncatt_put(out.nc, "crs", "semi_major_axis", 6378137)
##     ncatt_put(out.nc, "crs", "inverse_flattening", 298.257223563)
##     ncatt_put(out.nc, "crs", "crs_wkt", "GEODCRS[\"WGS 84\",DATUM[\"World Geodetic System 1984\",ELLIPSOID[\"WGS 84\",6378137,298.257223563,LENGTHUNIT[\"metre\",1.0]]],PRIMEM[\"Greenwich\",0],CS[ellipsoidal,3],AXIS[\"(lat)\",north,ANGLEUNIT[\"degree\",0.0174532925199433]],AXIS[\"(lon)\",east,ANGLEUNIT[\"degree\",0.0174532925199433]],AXIS[\"ellipsoidal height (h)\",up,LENGTHUNIT[\"metre\",1.0]]]")
##     ncatt_put(out.nc, "lon", "standard_name", "longitude")
##     ncatt_put(out.nc, "lon", "axis", "X")
##     ncatt_put(out.nc, "lat", "standard_name", "latitude")
##     ncatt_put(out.nc, "lat", "axis", "Y")
##     ncatt_put(out.nc, "time", "standard_name", "time")
##     ncatt_put(out.nc, "time", "axis", "T")
##     ncatt_put(out.nc, 0, "conventions", "CF-1.8")
##     ncatt_put(out.nc, 0, "title", title)
##     ncatt_put(out.nc, 0, "version", version)
##     ncatt_put(out.nc, 0, "id", outFile)
##     ncatt_put(out.nc, 0, "summary", paste("Global dataset of the Standardized Precipitation-Evapotranspiration Index (SPEI) at the ", 
##         sca, "-month", ifelse(sca == 1, "", "s"), " time scale. ", 
##         comment, sep = ""))
##     ncatt_put(out.nc, 0, "keywords", "drought, climatology, SPEI, Standardized Precipitation-Evapotranspiration Index")
##     ncatt_put(out.nc, 0, "institution", "Consejo Superior de Investigaciones Científicas, CSIC")
##     ncatt_put(out.nc, 0, "source", "http://sac.csic.es/spei")
##     ncatt_put(out.nc, 0, "creators", "Santiago Beguería <santiago.begueria@csic.es> and Sergio Vicente-Serrano <svicen@ipe.csic.es>")
##     ncatt_put(out.nc, 0, "software", "Created in R using the SPEI package (https://cran.r-project.org/web/packages/SPEI/;https://github.com/sbegueria/SPEI)")
##     b <- match.call()
##     ncatt_put(out.nc, 0, "call", paste(b[[1]], "(", names(b)[[2]], 
##         "=", b[[2]], ", ", names(b)[[3]], "=", b[[3]], ", ", 
##         names(b)[[4]], "=", b[[4]], ")", sep = ""))
##     ncatt_put(out.nc, 0, "date", date())
##     ncatt_put(out.nc, 0, "reference", "Beguería S., Vicente-Serrano S., Reig F., Latorre B. (2014) Standardized precipitation evapotranspiration index (SPEI) revisited: Parameter fitting, evapotranspiration models, tools, datasets and drought monitoring. International Journal of Climatology 34, 3001-3023.")
##     ncatt_put(out.nc, 0, "reference2", "Vicente-Serrano S.M., Beguería S., López-Moreno J.I. (2010) A Multiscalar Drought Index Sensitive to Global Warming: The Standardized Precipitation Evapotranspiration Index. Journal of Climate 23, 1696–1718.")
##     ncatt_put(out.nc, 0, "reference3", "Beguería S., Vicente-Serrano S., Angulo-Martínez M. (2010) A multi-scalar global drought data set: the SPEIbase. Bulletin of the American Meteorological Society 91(10), 1351–1356.")
##     dimlon <- out.nc.var$dim[[1]]$len
##     dimlat <- out.nc.var$dim[[2]]$len
##     dimtme <- out.nc.var$dim[[3]]$len
##     if (isSPEI) {
##         ndays <- Hmisc::monthDays(as.Date(out.nc.var$dim[[3]]$vals, 
##             origin = "1900-1-1"))
##     }
##     n <- block
##     for (j in seq(dimlat, 1, -n) - n + 1) {
##         start <- c(1, j, ifelse(is.na(tlapse[1]), 1, tlapse[1]))
##         count <- c(dimlon, n, dimtme)
##         if (isSPEI) {
##             x <- ncvar_get(etp.nc, varid = etp.nc$var[[1]]$name, 
##                 start, count) * ndays
##             x <- ncvar_get(pre.nc, varid = pre.nc$var[[1]]$name, 
##                 start, count) - x
##         }
##         else {
##             x <- ncvar_get(pre.nc, varid = pre.nc$var[[1]]$name, 
##                 start, count)
##         }
##         if (isMask) {
##             msk <- ncvar_get(mask.nc, "mask", c(1, j), c(dimlon, 
##                 n))
##         }
##         x.list <- vector("list", dimlon * n)
##         for (i in 1:dimlon) {
##             for (h in 1:n - 1) {
##                 if (!isMask) {
##                   x.list[[h * dimlon + i]] <- x[i, {
##                     h + 1
##                   }, ]
##                 }
##                 else {
##                   if (msk[i, {
##                     h + 1
##                   }] == 1) {
##                     x.list[[h * dimlon + i]] <- x[i, {
##                       h + 1
##                     }, ]
##                   }
##                   else {
##                     x.list[[h * dimlon + i]] <- rep(NA, dimtme)
##                   }
##                 }
##             }
##         }
##         speii <- function(d, s) {
##             SPEI::spei(d, s, na.rm = TRUE, verbose = FALSE)$fitted
##         }
##         x.list <- sfLapply(x.list, speii, sca)
##         for (i in 1:dimlon) {
##             for (h in 1:n - 1) {
##                 part <- x.list[[h * dimlon + i]]
##                 part[is.nan(part/part)] <- NA
##                 x[i, {
##                   h + 1
##                 }, ] <- part
##             }
##         }
##         ncvar_put(out.nc, nam, x, c(1, j, 1), count)
##         nc_sync(out.nc)
##     }
##     nc_close(out.nc)
## }
```


Initialize a parallel computing cluster; modify the parameter `cpus` to the desired number of cores; otherwise, it will use all available cores.


```r
sfInit(parallel=TRUE, cpus=detectCores())
```

```
## Warning in searchCommandline(parallel, cpus = cpus, type = type, socketHosts =
## socketHosts, : Unknown option on commandline: --file
```

```
## R Version:  R version 4.2.2 (2022-10-31 ucrt)
```

```
## snowfall 1.84-6.2 initialized (using snow 0.4-4): parallel execution on 16 CPUs.
```

```r
sfExport(list='spei', namespace='SPEI')
```


## 3.计算spei

Compute SPEI at all time scales between 1 and 48 and store to disk.


```r
for (i in c(1,3)) {#  for (i in c(1:48)) {
    spei.nc(
      sca=i,
		  inPre='./inputData/cru_ts4.07.1901.2022.pre.dat.nc',
		  inEtp='./inputData/cru_ts4.07.1901.2022.pet.dat.nc',
		  outFile=paste('./outputNcdf/spei',
		              formatC(i, width=2, format='d', flag='0'),'.nc',sep=''),
		  title=paste('Global ',i,'-month',
		            ifelse(i==1,'','s'),' SPEI, z-values, 0.5 degree',sep=''),
		  comment='Using CRU TS 4.07 precipitation and potential evapotranspiration data',
	    	  version='2.9.0',
		  block=36,
		  inMask=NA,
		  tlapse=NA
	  )
  gc()
}
# Stop the parallel cluster
sfStop()
```



## 参考文献

1.[Standardized Precipitation Evapotranspiration Index (SPEI)](https://climatedataguide.ucar.edu/climate-data/standardized-precipitation-evapotranspiration-index-spei)

---------------------
