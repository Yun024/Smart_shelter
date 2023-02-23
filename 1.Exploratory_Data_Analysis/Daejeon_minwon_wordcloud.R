rm(list=ls())

###### 라이브러리 설치 및 불러오기
library(wordcloud)
library(RColorBrewer)
library(rvest)
library(stringr)
library(dplyr)
library(KoNLP)
### 세종사전 설치
useSejongDic()


##### 웹 크롤링
### 대전지역사회문제은행 모든 민원 타이틀 뽑아오기 
title <- NULL

for (i in 1:42){
  url_news <-paste0("https://www.qbank-daejeon.com/view_suggestion/index/page/",i)
  html_news <- read_html(url_news,encoding="utf-8")
  title <- c(title,html_news %>% html_nodes(".tt") %>% html_text())
}
use.data <- title 

### 대전지역사회문제은행 검색창에 "버스" 검색 후 민원 타이틀 뽑아오기 
# title <- NULL
# 
# for (i in 1:7){
#   url_news <-paste0("https://www.qbank-daejeon.com/view_suggestion/index/page/",i,"/search_category_id/eNortjK2UkrMyVGyBlwwD-QC0w~~/change_limit/eNortjK0UrJUsgZcMAkwAdE~/search_gu/eNortjK2UkrMyVGyBlwwD-QC0w~~/search_field/eNortjIysFJy1CsuTcpKTS7RdtRLzs8rSc0rKVayBlwwfjwJMA~~/search_keyword/eNortjKzUnq9qeVN1xIla1wwJuEF2A~~")
#   html_news <- read_html(url_news,encoding="utf-8")
#   title <- c(title,html_news %>% html_nodes(".tt") %>% html_text())
# }
# use.data <- title 


###### 데이터 정제 
###명사 추출
pword <- sapply(use.data,extractNoun,USE.NAMES = F)
###필터링
data <- unlist(pword)
#write(data,"bus_keyword.txt")
data <- Filter(function(x){nchar(x)>=2},data)
data <- gsub("\\d+","",data)
data <- gsub("\\n","",data)
data <- gsub("\\.","",data)
data <- gsub("\n","",data)
data <- gsub(" ","",data)
data <- gsub("-","",data)
data <- gsub("대전","",data)


###### 워드 클라우드
data_cnt <- table(data)
head(sort(data_cnt, decreasing=T), 30)
palete <- brewer.pal(9, "Set1")
x11()
wordcloud(names(data_cnt),freq=data_cnt,scale=c(10,0.5),rot.per=0.25,min.freq=3,
          random.order=F,random.color=T,colors=palete)

### brewer의 모든 색깔을 보여주는 함수 
display.brewer.all()


##### 작업 디렉토리 설정 후 Plot 설정 
getwd()
setwd("C:/Users/user/R_project/picture")
savePlot(filename = "DJ_minwon_wordcloud.png", type="png")
