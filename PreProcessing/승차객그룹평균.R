rm(list=ls())

##### 라이브러리 불러오기 
library(reshape)
library(readxl)
library(dplyr)


###### 작업디렉토리 설정 
getwd()
setwd("C:/Users/user/R_project/원본데이터")
dir()


##### 데이터 불러온 후 확인 
dj.bus <- read.csv("2021년1월~2022년6월)정류장 승하차 정보.csv",fileEncoding="euc-kr")
data.use <- dj.bus
data.use %>% summary()
data.use %>% tail()
data.use <- data.use[-50448:-50450]
length(data.use$정류장 %>% unique())
data.use$승차승객 %>% class()


##### 정류장별 그룹핑 후 승,하,환승 합계 추출 
data.use$합계 <- data.use$승차승객 + data.use$환승
aa <- data.use %>% group_by(정류장) %>% summarize(초승수합=sum(승차승객),환승수합=sum(환승),총승차객합계=sum(합계)) 
aa.order <-aa[order(-aa$총승차객합계),]
aa.order %>% head()
aa.order %>% tail()
aa.order <- aa.order[-1,] %>% as.data.frame()
aa.order <- aa.order[-2695,]
###월별 변수는 안쓰기로해서 주석처리 
#aa <- data.use %>% group_by(정류장) %>% summarize(월평균승차객=mean(합계),총승차객합계=sum(합계)) 
#aa.order <-aa[order(-aa$월평균승차객),] 
#aa.order$월평균승차객 <- aa.order$월평균승차객 %>% round()


##### 하나로 되어있는 고유번호와 정류장의 문자열 분리 
data.sub <- aa.order
data.sub$"고유번호(ARS)" <- strsplit(data.sub$정류장,split='\\(') %>% sapply('[',2)
data.sub$정류장 <- strsplit(data.sub$정류장,split='\\(') %>% sapply('[',1)
data.sub$`고유번호(ARS)`<- strsplit(data.sub$`고유번호(ARS)`,split=')') 
data.sub <- data.sub %>% relocate("고유번호(ARS)")
data.sub %>% head()


##### 다른데이터와 달리 괄호가 두개 들어가 있는 데이터 전처리 
### 인덱스찾기
bb <- data.sub$`고유번호(ARS)`=="BRT" 
which(bb==T)
data.sub %>% filter(정류장=="한남오거리")
aa.order[184,]
aa.order[627,]
### 직접 변경
data.sub[184,1] <- "53420"
data.sub[184,2] <- "한남오거리(BRT)"
data.sub[627,1] <- "53430"
data.sub[627,2] <- "한남오거리(BRT)"
data.sub %>% filter(정류장=="한남오거리(BRT)")
data.sub$`고유번호(ARS)` <- data.sub$`고유번호(ARS)` %>% unlist()
data.sub %>% head()


##### 데이터 저장
write.csv(data.sub,"C:/Users/user/R_project/정제데이터/승차객그룹핑.csv",fileEncoding = "cp949")


