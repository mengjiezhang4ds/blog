---
title: "parallel之初体验"
author: "学R不思则罔"
date: '2023-02-28'
output:
  prettydoc::html_pretty:
    theme: cayman
    highlight: github
categories: ["R"]
tags: ["dplyr","parallel"]
description: "使用parallel扩展包进行对矩阵进行多线程运算，代码中很多地方还略显粗糙，后期有待优化"
toc: true
---





## 1.准备工作

### 1.1 加载扩展包


```r
rm(list = ls())
library(dplyr)
library(tidyr)
library(purrr)
library(parallel)
```

### 1.2 加载扩展包


```r
load("Y.RData")
load("X.RData")
load("Missing.RData")
TT <- 36
T <- NROW(X)
N <- NCOL(X)
```


### 1.3 启用多线程


```r
cores <- detectCores(logical = FALSE)
cl <- makeCluster(cores)
```

### 1.4 编写多线程函数


```r
EM_estV2 <- function(Yt = tempY, Z1 = tempX, Z2 = tempX, missing = tempMissing) {
  Tz <- NROW(Z1)
  N <- NCOL(Z1)
  K1 <- if (length(dim(Z1)) > 2) dim(Z1)[3] else 1
  K2 <- if (length(dim(Z2)) > 2) dim(Z2)[3] else 1
  
  # set.seed(123)
  BT <- matrix(rnorm(Tz * (K1 + 1)), nrow = Tz)
  BT_fixT <- matrix(rnorm(Tz * (K1 + 1)), nrow = Tz)
  BN <- matrix(rnorm(N * ((N - 1) * K2)), nrow = N)
  
  list(BN = BN, BT = BT, BT_fixT = BT_fixT)
}

squeezefun <- function(tmp) {
  dimres <- dim(tmp)
  filter <- which(dimres != 1)
  if (length(filter) == 2) {
    matrix(tmp, dimres[filter[1]], dimres[filter[2]])
  } else if (length(filter) == 1) {
    if (filter[1] == 2) {
      matrix(tmp, 1, dimres[filter[1]])
    } else {
      matrix(tmp, dimres[filter[1]], 1)
    }
  } else {
    tmp
  }
}
```

### 1.5 编写核心函数


```r
clusterExport(cl,varlist = c("X","Y","Missing",
                             "TT","T","N","squeezefun","EM_estV2"))

# 定义函数以提取信息
fill_tidy <- function(j) {
  library(dplyr)
  library(tidyr)
  library(purrr)
  # 声明变量
  # TT <- 36
  # T <- NROW(X)
  # N <- NCOL(X)
  # 数据产生
  Twindow <- (j - TT):(j)
  tempX <- X[Twindow, , ]
  tempY <- Y[Twindow, ]
  tempMissing <- Missing[Twindow, ]
  
  DeleteI <- which(apply(tempMissing, 2, sum) > 1 / 3 * length(Twindow)) ## %delete individuals with more than 30% missing values
  
  dim_X <- dim(X)
  rm(Twindow,Missing,Y,X)
  
  if (length(DeleteI) == 0) {
    DeleteI <- dim(tempMissing)[2] + 1
  }
  tempMissing <- tempMissing[, -DeleteI]
  tempY <- tempY[, -DeleteI]
  tempX <- tempX[, -DeleteI, ]
  # MissingT <- apply(tempMissing, 1, sum)
  
  Ntemp <- dim(tempY)[2]
  DeleteT <- which(apply(tempMissing, 1, sum) > 1 / 3 * Ntemp) ## %delete individuals with more than 30% missing values
  
  if (length(DeleteT) == 0) {
    DeleteT <- length(apply(tempMissing, 1, sum)) + 1
  }
  
  DeleteT <- c(DeleteT, 61)
  DeleteT <- DeleteT[!duplicated(DeleteT)]
  DeleteT <- DeleteT[-which(DeleteT == 61)]
  tempMissingF <- tempMissing[-DeleteT, ]
  tempYF <- tempY[-DeleteT, ]
  tempXF <- tempX[-DeleteT, , ]
  
  lt <- dim(tempYF)[1]
  tempMissing <- tempMissingF[-lt, ]
  tempY <- tempYF[-lt, ]
  tempX <- tempXF[-lt, , ]
  
  rm(tempYF,tempMissingF)
  
  if (dim(tempY)[1] < 24) {
    next
  }
  
  result <- EM_estV2(tempY, tempX, tempX, tempMissing)
  tempBT <- result$BT
  tempBT_fixT <- result$BT_fixT
  tempBN <- result$BN
  
  rm(result)
  
  avegBT <- apply(tempBT[(TT - 4):TT, ], 2, mean)
  avegBT_fixT <- apply(tempBT_fixT[(TT - 4):TT, ], 2, mean)
  Nt <- dim(tempXF)[2]
  
  res <- setdiff(1:118, DeleteI) %>%
    as_tibble() %>%
    setNames("column") %>%
    mutate(group = 1:n()) %>%
    group_by(group) %>%
    mutate(Y = map(.x = group, .f = function(x) {
      ifelse(length(dim_X) > 2,
             sum(avegBT * c(1, as.vector(squeezefun(tempXF[lt, x, ])))),
             sum(avegBT * c(1, (tempXF[lt, x, ])))
      )
    })) %>%
    mutate(Y_fixT = map(.x = group, .f = function(x) {
      ifelse(length(dim_X) > 2,
             sum(avegBT_fixT * c(1, as.vector(squeezefun(tempXF[lt, x, ])))),
             sum(avegBT_fixT * c(1, (tempXF[lt, x, ])))
      )
    })) %>%
    mutate(Xi = map(.x = group, .f = function(x) {
      Xi <- t(tempXF[lt, , ]) %>%
        .[, -x] %>%
        t()
      Xi <- matrix(Xi, NROW(Xi) * NCOL(Xi), 1)
      Xi[is.na(Xi)] <- 0
      Xi
    })) %>%
    mutate(tempBN = map(.x = group, .f = function(x) {
      tempBN[x, ][is.na(tempBN[x, ])] <- 0
      tempBN
    })) %>%
    mutate(Y_p = pmap(list(group, Xi, tempBN), .f = function(x, y, z) {
      z[x, ] %*% y
    })) %>%
    mutate(Y_new = map2(.x = Y, .y = Y_p, .f = function(x, y) {
      x + y
    })) %>%
    mutate(Y_fixT_p = pmap(list(group, Xi, tempBN), .f = function(x, y, z) {
      z[x, ] %*% y
    })) %>%
    mutate(Y_fixT_new = map2(.x = Y_fixT, .y = Y_fixT_p, .f = function(x, y) {
      x + y
    })) %>%
    dplyr::select(column, Y, Y_p, Y_new, Y_fixT, Y_fixT_p, Y_fixT_new) %>%
    mutate(t = j) %>%
    unnest(cols = c(Y, Y_p, Y_new, Y_fixT, Y_fixT_p, Y_fixT_new)) %>%
    ungroup() %>%
    mutate(Y, Y_fixT, Y_p = Y_p[, 1], Y_fixT_p = Y_fixT_p[, 1], Y_new = Y_new[, 1], Y_fixT_new = Y_fixT_new[, 1]) %>%
    dplyr::select(t, column, Y_new, Y_fixT_new) %>%
    setNames(c("r", "c", "Y", "Y_fixT"))
  
  return(res)
}
```


## 2.多线程计算


```r
system.time({
  res <- parLapply(cl, (TT + 1):T, fill_tidy)
})
```

```
##    user  system elapsed 
##    0.00    0.00    1.93
```

```r
stopCluster(cl)
head(res)
```

```
## [[1]]
## # A tibble: 105 × 4
##        r     c       Y Y_fixT
##    <int> <int>   <dbl>  <dbl>
##  1    37     1   2.40    3.86
##  2    37     2  -7.13   -5.29
##  3    37     3  -0.245  -1.26
##  4    37     4   3.02    4.12
##  5    37     5  -1.78   -1.61
##  6    37     6 -11.0    -9.79
##  7    37     7  28.6    29.0 
##  8    37     8   1.97    2.02
##  9    37     9 -11.9   -11.0 
## 10    37    10   5.52    5.35
## # ℹ 95 more rows
## 
## [[2]]
## # A tibble: 106 × 4
##        r     c       Y Y_fixT
##    <int> <int>   <dbl>  <dbl>
##  1    38     1  -0.941  -1.50
##  2    38     2  -2.10   -2.53
##  3    38     3  -1.68   -1.75
##  4    38     4  -6.25   -6.88
##  5    38     5  24.8    24.8 
##  6    38     6   6.95    6.59
##  7    38     7 -18.6   -19.0 
##  8    38     8  -6.76   -7.05
##  9    38     9  -7.36   -7.57
## 10    38    10  11.8    11.8 
## # ℹ 96 more rows
## 
## [[3]]
## # A tibble: 106 × 4
##        r     c      Y  Y_fixT
##    <int> <int>  <dbl>   <dbl>
##  1    39     1   4.17   5.29 
##  2    39     2   7.29   8.80 
##  3    39     3  -8.61  -9.21 
##  4    39     4  11.1   11.5  
##  5    39     5  -1.12  -0.934
##  6    39     6  11.9   12.2  
##  7    39     7  16.9   16.6  
##  8    39     8  10.1   10.1  
##  9    39     9 -21.0  -21.2  
## 10    39    10  -9.32  -9.99 
## # ℹ 96 more rows
## 
## [[4]]
## # A tibble: 107 × 4
##        r     c       Y  Y_fixT
##    <int> <int>   <dbl>   <dbl>
##  1    40     1 -10.6   -11.6  
##  2    40     2   5.43    3.90 
##  3    40     3   9.07    8.37 
##  4    40     4  -1.52   -1.77 
##  5    40     5  10.8     9.78 
##  6    40     6  -1.30   -1.79 
##  7    40     7   6.86    6.47 
##  8    40     8  -0.155  -0.638
##  9    40     9  -2.57   -3.07 
## 10    40    10  10.5     9.82 
## # ℹ 97 more rows
## 
## [[5]]
## # A tibble: 108 × 4
##        r     c       Y  Y_fixT
##    <int> <int>   <dbl>   <dbl>
##  1    41     1 -14.7   -14.9  
##  2    41     2  -4.44   -3.77 
##  3    41     3  -4.53   -4.57 
##  4    41     4  15.5    14.8  
##  5    41     5 -17.0   -16.7  
##  6    41     6 -16.9   -17.2  
##  7    41     7  12.4    12.2  
##  8    41     8  18.5    18.1  
##  9    41     9  -0.705  -0.906
## 10    41    10 -10.9   -11.3  
## # ℹ 98 more rows
## 
## [[6]]
## # A tibble: 109 × 4
##        r     c      Y Y_fixT
##    <int> <int>  <dbl>  <dbl>
##  1    42     1 -14.7  -14.2 
##  2    42     2   1.77   1.22
##  3    42     3   6.49   6.53
##  4    42     4 -17.8  -16.9 
##  5    42     5  -9.24  -9.37
##  6    42     6   7.61   8.14
##  7    42     7   7.77   8.20
##  8    42     8   3.61   3.95
##  9    42     9  -5.53  -4.82
## 10    42    10  -8.84  -8.38
## # ℹ 99 more rows
```

## 3.结果展示


```r
head(rlist::list.rbind(res))
```

```
## # A tibble: 6 × 4
##       r     c       Y Y_fixT
##   <int> <int>   <dbl>  <dbl>
## 1    37     1   2.40    3.86
## 2    37     2  -7.13   -5.29
## 3    37     3  -0.245  -1.26
## 4    37     4   3.02    4.12
## 5    37     5  -1.78   -1.61
## 6    37     6 -11.0    -9.79
```



```r
# 根据行列数转矩阵
rc2df <- function(r, c) {
  result <- data.frame(
    r = rep(1:r, c),
    c = rep(1:c, each = r)
  )
  return(result)
}
lasso_hat_Y <- rc2df(r = T, c = N) %>%
  left_join(rlist::list.rbind(res)) %>%
  dplyr::arrange(c, r) %>%
  pull(Y) %>%
  matrix(data = ., nrow = T, ncol = N)
```



```r
lasso_hat_Y_fixT <- rc2df(r = T, c = N) %>%
  left_join(rlist::list.rbind(res)) %>%
  dplyr::arrange(c, r) %>%
  pull(Y_fixT) %>%
  matrix(data = ., nrow = T, ncol = N)
```

- 最终结果


```r
head(lasso_hat_Y)
```

```
##      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10] [,11] [,12] [,13] [,14]
## [1,]   NA   NA   NA   NA   NA   NA   NA   NA   NA    NA    NA    NA    NA    NA
## [2,]   NA   NA   NA   NA   NA   NA   NA   NA   NA    NA    NA    NA    NA    NA
## [3,]   NA   NA   NA   NA   NA   NA   NA   NA   NA    NA    NA    NA    NA    NA
## [4,]   NA   NA   NA   NA   NA   NA   NA   NA   NA    NA    NA    NA    NA    NA
## [5,]   NA   NA   NA   NA   NA   NA   NA   NA   NA    NA    NA    NA    NA    NA
## [6,]   NA   NA   NA   NA   NA   NA   NA   NA   NA    NA    NA    NA    NA    NA
##      [,15] [,16] [,17] [,18] [,19] [,20] [,21] [,22] [,23] [,24] [,25] [,26]
## [1,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [2,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [3,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [4,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [5,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [6,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
##      [,27] [,28] [,29] [,30] [,31] [,32] [,33] [,34] [,35] [,36] [,37] [,38]
## [1,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [2,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [3,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [4,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [5,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [6,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
##      [,39] [,40] [,41] [,42] [,43] [,44] [,45] [,46] [,47] [,48] [,49] [,50]
## [1,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [2,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [3,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [4,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [5,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [6,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
##      [,51] [,52] [,53] [,54] [,55] [,56] [,57] [,58] [,59] [,60] [,61] [,62]
## [1,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [2,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [3,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [4,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [5,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [6,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
##      [,63] [,64] [,65] [,66] [,67] [,68] [,69] [,70] [,71] [,72] [,73] [,74]
## [1,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [2,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [3,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [4,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [5,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [6,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
##      [,75] [,76] [,77] [,78] [,79] [,80] [,81] [,82] [,83] [,84] [,85] [,86]
## [1,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [2,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [3,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [4,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [5,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [6,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
##      [,87] [,88] [,89] [,90] [,91] [,92] [,93] [,94] [,95] [,96] [,97] [,98]
## [1,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [2,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [3,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [4,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [5,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [6,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
##      [,99] [,100] [,101] [,102] [,103] [,104] [,105] [,106] [,107] [,108]
## [1,]    NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
## [2,]    NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
## [3,]    NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
## [4,]    NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
## [5,]    NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
## [6,]    NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
##      [,109] [,110] [,111] [,112] [,113] [,114] [,115] [,116] [,117] [,118]
## [1,]     NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
## [2,]     NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
## [3,]     NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
## [4,]     NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
## [5,]     NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
## [6,]     NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
```



```r
head(lasso_hat_Y_fixT)
```

```
##      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10] [,11] [,12] [,13] [,14]
## [1,]   NA   NA   NA   NA   NA   NA   NA   NA   NA    NA    NA    NA    NA    NA
## [2,]   NA   NA   NA   NA   NA   NA   NA   NA   NA    NA    NA    NA    NA    NA
## [3,]   NA   NA   NA   NA   NA   NA   NA   NA   NA    NA    NA    NA    NA    NA
## [4,]   NA   NA   NA   NA   NA   NA   NA   NA   NA    NA    NA    NA    NA    NA
## [5,]   NA   NA   NA   NA   NA   NA   NA   NA   NA    NA    NA    NA    NA    NA
## [6,]   NA   NA   NA   NA   NA   NA   NA   NA   NA    NA    NA    NA    NA    NA
##      [,15] [,16] [,17] [,18] [,19] [,20] [,21] [,22] [,23] [,24] [,25] [,26]
## [1,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [2,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [3,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [4,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [5,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [6,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
##      [,27] [,28] [,29] [,30] [,31] [,32] [,33] [,34] [,35] [,36] [,37] [,38]
## [1,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [2,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [3,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [4,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [5,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [6,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
##      [,39] [,40] [,41] [,42] [,43] [,44] [,45] [,46] [,47] [,48] [,49] [,50]
## [1,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [2,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [3,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [4,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [5,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [6,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
##      [,51] [,52] [,53] [,54] [,55] [,56] [,57] [,58] [,59] [,60] [,61] [,62]
## [1,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [2,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [3,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [4,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [5,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [6,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
##      [,63] [,64] [,65] [,66] [,67] [,68] [,69] [,70] [,71] [,72] [,73] [,74]
## [1,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [2,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [3,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [4,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [5,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [6,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
##      [,75] [,76] [,77] [,78] [,79] [,80] [,81] [,82] [,83] [,84] [,85] [,86]
## [1,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [2,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [3,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [4,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [5,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [6,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
##      [,87] [,88] [,89] [,90] [,91] [,92] [,93] [,94] [,95] [,96] [,97] [,98]
## [1,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [2,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [3,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [4,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [5,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
## [6,]    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
##      [,99] [,100] [,101] [,102] [,103] [,104] [,105] [,106] [,107] [,108]
## [1,]    NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
## [2,]    NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
## [3,]    NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
## [4,]    NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
## [5,]    NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
## [6,]    NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
##      [,109] [,110] [,111] [,112] [,113] [,114] [,115] [,116] [,117] [,118]
## [1,]     NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
## [2,]     NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
## [3,]     NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
## [4,]     NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
## [5,]     NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
## [6,]     NA     NA     NA     NA     NA     NA     NA     NA     NA     NA
```

## 4.结果验证


```r
# 根据行列数转矩阵
lasso_hat_Y <- rc2df(r = T, c = N) %>%
  left_join(rlist::list.rbind(res)) %>%
  dplyr::arrange(c, r) %>%
  pull(Y) %>%
  matrix(data = ., nrow = T, ncol = N)
```



```r
lasso_hat_Y_fixT <- rc2df(r = T, c = N) %>%
  left_join(rlist::list.rbind(res)) %>%
  dplyr::arrange(c, r) %>%
  pull(Y_fixT) %>%
  matrix(data = ., nrow = T, ncol = N)
```



```r
multi_threading_lasso_hat_Y <- lasso_hat_Y
multi_threading_lasso_hat_Y_fixT <- lasso_hat_Y_fixT
```



```r
# 比较数据
m2df <- function(data) {
  result <- data.frame(
    r = rep(1:nrow(data), ncol(data)),
    c = rep(1:ncol(data), each = nrow(data)),
    value = as.vector(data)
  )
  return(result)
}
```



```r
single_thread_lasso_hat_Y <- lasso_hat_Y
single_thread_lasso_hat_Y_fixT <- lasso_hat_Y_fixT
```



```r
# 结果相同记做0
tibble(
  x = as.vector(single_thread_lasso_hat_Y),
  y = as.vector(multi_threading_lasso_hat_Y)
) %>%
  mutate(res = case_when(
    is.na(x) == TRUE & is.na(y) == TRUE ~ 0,
    x == y ~ 0,
    TRUE ~ 1
  )) %>%
  pull(res) %>%
  table()
```

```
## .
##    0 
## 7080
```



```r
tibble(
  x = as.vector(single_thread_lasso_hat_Y_fixT),
  y = as.vector(multi_threading_lasso_hat_Y_fixT)
) %>%
  mutate(res = case_when(
    is.na(x) == TRUE & is.na(y) == TRUE ~ 0,
    x == y ~ 0,
    x - y == 0 ~ 0,
    TRUE ~ 1
  )) %>%
  pull(res) %>%
  table()
```

```
## .
##    0 
## 7080
```

**结果是对得上的**


-------------
