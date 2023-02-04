rm(list=ls())

##### 라이브러리 불러오기 
library(dplyr)


##### 작업 디렉토리 설정
getwd()
setwd("C:/Users/user/R_project/원본데이터")
dir()


##### 데이터 불러온 후 확인 
dj <- read.csv("대전광역시_시내버스 기반정보_20210527.csv",fileEncoding="euc-kr")
dj %>% head()
dj %>% names()
data.use <- dj
data.use %>% names()
data.use %>% tail()


##### 위도_경도_전처리
lat.1 <- gsub('\\D','',data.use$위도.십진수.도_분..표기)%>% substr(1,2) %>% as.numeric()
lat.2<-  (gsub('\\D','',data.use$위도.십진수.도_분..표기)%>% substring(3) %>% as.numeric)/600000 %>% as.numeric()
lat.2 %>% head()

lon.1 <- gsub('\\D','',data.use$경도.십진수.도_분..표기)%>% substr(1,3) %>% as.numeric()
lon.2 <- (gsub('\\D','',data.use$경도.십진수.도_분..표기)%>% substring(4) %>% as.numeric)/600000 %>% as.numeric()
lon.2 %>% head()

data.use$lat <- lat.1 + lat.2   #위도
data.use$lon <- lon.1 + lon.2   #경도
data.use$lat %>% head()
data.use$lon %>% head()

data.use %>% head()
data.use <- data.use[,-13:-16]
data.use <- data.use %>% select(-국토부ID,-정산ID,-행정구역코드,-시도명,-순번)

##### 데이터 저장 
#setwd("C:/Users/user/R_project/정제데이터")
write.csv(data.use,"대전지역정류장정보.csv",fileEncoding ="cp949")

