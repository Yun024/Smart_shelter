rm(list=ls())

##### 라이브러리 불러오기
library(dplyr)
library(caret)

##### 작업 디렉토리 설정 
getwd()
setwd("C:/Users/user/R_project/정제데이터")
dir()


##### 데이터 불러온 후 확인  
data <- read.csv("최종데이터_2.csv",fileEncoding = "cp949")
data %>% head()
data %>% summary()
data.use <- data %>% select(총인구수,X19세이하,X65세이상,초승수합,환승수합,총승차객합계,대기시간,X400m_내_지하철역_수,X400m_내_학교_수,X400m_내_복지시설_수,X400m_내_미세먼지인자_수)
data.use %>% summary()
data.use %>% dim()

##### 민맥스 
data.norm <- preProcess(data.use,method="range")
data.norm %>% summary()
data.range <- predict(data.norm,data.use)
data.range %>% summary()
data.range %>% head()

tb <- list()
for (i in 1:11){
  tb[[i]] <- table(data.use[,i])
}

for (i in 1:11){
  print(dim(tb[[i]]))
}
