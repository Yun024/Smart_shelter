rm(list=ls())

##### 라이브러리 불러오기  
library(reshape)
library(readxl)
library(dplyr)
library(stringr)


##### 작업 디렉토리 지정 
getwd()
setwd("C:/Users/user/R_project/원본데이터")
dir()


##### 데이터 불러온 후 확인   
data <- read_excel("2._2022년_7월말_구별_동별_연령별(5세단위)_인구(대전).xlsx",skip=2)
data %>% names()
data.all <- data[,1:24] %>% as.data.frame()
data.all %>% head()

##### 변수명 변경 
data.all[1,1] <- "ㅋㅋ"
data.all %>% head()
name <- data.all[1,] %>% unlist() %>% as.vector()
data.all %>% names() 
names(data.all) <- name


##### 하나로 되어있는 시군구명과 읍면동명 문자열 분리 
data.all$시군구명 <- strsplit(data.all$ㅋㅋ,split='시') %>% sapply('[',2)
data.all$시군구명 <- strsplit(data.all$시군구명,split=' ') %>% sapply('[',2) %>% str_trim()
data.all$읍면동명 <- strsplit(data.all$ㅋㅋ,split='구') %>% sapply('[',2)
data.all$읍면동명 <- strsplit(data.all$읍면동명,split='\\(') %>% sapply('[',1) %>% str_trim()
data.all %>% head()
### 읍면동명이 없는 데이터 삭제 
data.all$읍면동명 <- replace(data.all$읍면동명,data.all$읍면동명=="",NA)
data.all <- data.all %>% na.omit()
data.all %>% head()


##### 문자로 되어있는 변수를 숫자변환 후 필요한 범주로 나누기 
for (i in 2:24){
  data.all[i] <- data.all[i] %>% unlist() %>% as.numeric() %>% as.data.frame
}
data.all$"19세이하" <- rowSums(data.all[,4:7],na.rm=T)
#data.all$"55세이상" <- rowSums(data.all[,15:24],na.rm=T)
data.all$"65세이상" <- rowSums(data.all[,17:24],na.rm=T)
#data.all$"20세~54세" <- rowSums(data.all[,8:14],na.rm=T)
#data.all$"20세~64세" <- rowSums(data.all[,8:16],na.rm=T)
data.all %>% head()
data.all %>% names()
data.use <- data.all %>% select(2,25:28)


##### 전처리 데이터 저장 
#setwd("C:/Users/user/R_project/정제데이터")
write.csv(data.use,"EDA데이터1.csv",fileEncoding = "cp949",row.names = F)
