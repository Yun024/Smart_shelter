rm(list=ls())

##### 라이브러리 불러오기
library(reshape)
library(readxl)
library(dplyr)


##### 작업 디렉토리 설정 
getwd()
#setwd("C:/Users/user/R_project/원본데이터")
setwd("C:/Users/user/R_project/정제데이터")
dir()


##### 데이터 불러오기 
data.sub <- read.csv("대전지역정류장정보.csv",fileEncoding = "cp949")
data.grp <- read.csv("승차객그룹핑.csv",fileEncoding = "cp949")
data.grp$고유번호.ARS. %>% typeof()
data.sub$고유번호.ARS. <- data.sub$고유번호.ARS. %>% as.character()
data.sub$고유번호.ARS. %>% typeof()
data.grp %>% head()
data.sub %>% head()


##### "고유번호.ARS."를 기준으로 데이터 병합 
data.fin<- inner_join(data.grp,data.sub,by="고유번호.ARS.")
data.fin$고유번호.ARS. %>% unique() %>% length() 
data.fin <- data.fin %>% distinct(고유번호.ARS.,.keep_all=T)
data.fin <- data.fin %>% filter(!위치.BIT.=="없음") %>% as.data.frame()
# aa <- data.fin %>% head(100) %>% select(고유번호.ARS.) 
# bb <- data.fin %>% head(100) %>% select(고유번호.ARS.)
# aa$고유번호.ARS. <- aa$고유번호.ARS. %>% as.numeric()
# bb$고유번호.ARS. <- bb$고유번호.ARS. %>% as.numeric()
# aa$검산 <- aa$고유번호.ARS.-bb$고유번호.ARS.
# aa$검산
data.fin %>% head()
data.fin %>% tail()
data.fin %>% names()
data.fin %>% nrow()


##### 400m버퍼를 찍은 데이터 불러오기 
dir()
data.sch <- read.csv("학교_수.csv",fileEncoding = "euc-kr")
data.rep <- read.csv("복지시설_수.csv",fileEncoding = "euc-kr")
data.train <- read.csv("지하철_수.csv",fileEncoding = "euc-kr")
data.dust <- read.csv("미세먼지_인자_수.csv",fileEncoding = "euc-kr")
data.pop <- read.csv("대전시_인구수_전처리.csv",fileEncoding = "cp949")
data.dax <- read.csv("버스DAX_계산.csv",fileEncoding = "cp949")
### 데이터 병합에 필요한 변수 추출 
data.dax <- data.dax %>% select(고유번호.ARS.,DAX....버스.노선별.대기시간...운행횟수.......운행횟수..)


##### "고유번호.A"를 기준으로 데이터 병합 
# inner_join %>% help()S
data.join <- inner_join(data.rep,data.sch,by="고유번호.A")
data.join <- inner_join(data.join,data.train,by="고유번호.A")
data.join <- inner_join(data.join,data.dust,by="고유번호.A")
data.join <- data.join %>% select(고유번호.A,X400m_내_미세먼지인자_수,X400m_내_지하철역_수,X400m_내_학교_수,X400m_내_복지시설_수)
data.join %>% names()
colnames(data.join)[1] <- "고유번호.ARS."
data.join$고유번호.ARS. <-  data.join$고유번호.ARS. %>% as.character()
data.dax$고유번호.ARS. <- data.dax$고유번호.ARS. %>% as.character()
### 위의 병합된 2개의 데이터프레임을 병합
data.final <- inner_join(data.fin,data.join,by="고유번호.ARS.")
data.final <- inner_join(data.final,data.dax,by="고유번호.ARS.")
data.final <- inner_join(data.final,data.pop,by="읍면동명")
data.final %>% head()
data.final %>% names()
### 필요한 변수 추출 
data.final <- data.final %>% select(-X.x,-X.y,-정류장명)


##### 데이터프레임의 변수명 및 순서 변경 
data.final %>% names()
name <- data.final %>% names() %>% as.vector() 
new <- NULL
### 반복문을 이용해 변수명 추출 
for (i in 1:23){
  name_old <- name[i]
  new <- paste0(new,",",name_old)
}
### 순서 변경 
new
data.final <- data.final %>% select(고유번호.ARS.,정류장,시군구명,읍면동명,유개승강장,차로위치,위치.BIT.,lat,lon,총인구수,X19세이하,X55세이상,X65세이상,X20세.54세,X20세.64세,DAX....버스.노선별.대기시간...운행횟수.......운행횟수..,초승수합,환승수합,총승차객합계,X400m_내_지하철역_수,X400m_내_학교_수,X400m_내_복지시설_수,X400m_내_미세먼지인자_수)

name <- data.final %>% names() %>% as.vector() 
new <- NULL
for (i in 1:23){
  name_old <- name[i]
  new <- paste0("'",new,",","'",name_old,"'")
}
### 변수명 변경 
new
names(data.final) <- c('고유번호.ARS.','정류장','시군구명','읍면동명','유개승강장','차로위치','위치.BIT.','위도(lat)','경도(lon)','총인구수','19세이하','55세이상','65세이상','20세_54세','20세_64세','대기시간','초승수합','환승수합','총승차객합계','400m_내_지하철역_수','400m_내_학교_수','400m_내_복지시설_수','400m_내_미세먼지인자_수')
data.final %>% names()
data.final %>% head()


##### 전처리 데이터 저장하기 
#write.csv(data.final,"최종데이터_2.csv",fileEncoding = "cp949",row.names = F)

