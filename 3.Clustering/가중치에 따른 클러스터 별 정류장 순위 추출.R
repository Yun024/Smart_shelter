rm(list=ls())

##### 라이브러리 불러오기
library(dplyr)


##### 작업 디렉토리 설정 
getwd()
#setwd("C:/Users/user/R_project/원본데이터")
setwd("C:/Users/user/R_project/정제데이터")
dir()


##### 데이터 불러오기 및 할당
dj.bus <- read.csv("최종데이터_이게끝.csv",fileEncoding="euc-kr")
dj.bus  %>% head()
x <- dj.bus[,c(1, 2, 3, 8, 9, 10, 11, 13, 16:26)]
head(x)


##### 시각화에 필요한 클러스터 지정 
x_gmm <- x[x[,19]==3,]
count(x_gmm)
head(x_gmm)


##### 변수 생성 변수 선택
x_gmm$"19세 이하 비율" <- x_gmm[,7]/x_gmm[,6] 
x_gmm$"65세 이상 비율" <- x_gmm[,8]/x_gmm[,6] 
head(x_gmm)
summary(x_gmm)
result <- x_gmm[,c('총승차객합계','X400m_내_지하철역_수', 'X400m_내_학교_수', 'X400m_내_복지시설_수', 'X400m_내_미세먼지인자_수',  '19세 이하 비율', '65세 이상 비율')]
summary(result)

##### 사분위수를 저장하는 함수 제작
two <- function(x){
  quantile(x)[[2]] %>% unlist() %>% as.numeric()
}
three <- function(x){
  quantile(x)[[3]] %>% unlist() %>% as.numeric()
} 
four <- function(x){
  quantile(x)[[4]] %>% unlist() %>% as.numeric()
}
five <- function(x){
  quantile(x)[[5]] %>% unlist() %>% as.numeric()
}


##### 반복문과 조건문 cut함수를 이용해 각 변수에 가중치를 고려한 점수 부여
for (i in 1:7){
  if (i == 1){
  result[,i] <- cut(result[,i],breaks=c(0,two(result[,i]),three(result[,i]),four(result[,i]),five(result[,i])),labels=c(1,2,3,4),include.lowest=T,right=T)
  }else if(i==2){
    result[,i] <- cut(result[,i],breaks=c(0,three(result[,i]),five(result[,i])),labels=c(2,4),include.lowest=T,right=T)
  }else if(i==3){
    result[,i] <- cut(result[,i],breaks=c(0,0.9,three(result[,i]),four(result[,i]),five(result[,i])),labels=c(1,2,3,4),include.lowest=T,right=T)
  }else if(i==4){
    result[,i] <- cut(result[,i],breaks=c(0,four(result[,i]),five(result[,i])),labels=c(2,4),include.lowest=T,right=T)
  }else if(i==5){
    result[,i] <- cut(result[,i],breaks=c(0,two(result[,i]),three(result[,i]),four(result[,i]),five(result[,i])),labels=c(1,2,3,4),include.lowest=T,right=T)
  }else if(i==6){
    result[,i] <- cut(result[,i],breaks=c(0,two(result[,i]),three(result[,i]),four(result[,i]),five(result[,i])),labels=c(1,2,3,4),include.lowest=T,right=T)
  }else{
    result[,i] <- cut(result[,i],breaks=c(0,two(result[,i]),three(result[,i]),four(result[,i]),five(result[,i])),labels=c(1,2,3,4),include.lowest=T,right=T)
  }
}
result %>% summary()
result %>%  head(20)


##### 변수를 수치형 데이터로 변환후 합산하여 순위 산출
for(i in 1:7){
  result[,i] <- as.numeric(as.character(result[,i]))
}
result %>% head(20)
Score <- apply(result[,1:7],1,sum)
result <- cbind(x_gmm,Score)
head(result)
result$Rank <- dense_rank(-result$Score)
result %>% head(20)


##### 데이터를 시군구별 데이터로 분할
seo <- result[result[,"시군구명"]=="서구",]
dong <- result[result[,"시군구명"]=="동구",]
you <- result[result[,"시군구명"]=="유성구",]
dae <- result[result[,"시군구명"]=="대덕구",]
jung <- result[result[,"시군구명"]=="중구",]
### 내림차순 정렬
seo <- seo[c(order(seo$Rank)),] 
dong <- dong[c(order(dong$Rank)),] 
you <- you[c(order(you$Rank)),]
dae <- dae[c(order(dae$Rank)),] 
jung <- jung[c(order(jung$Rank)),] 
### 데이터프레임으로 변환
result_seo_1 <- seo[1:6,] %>% as.data.frame()
result_dong_1 <- dong[1:5,] %>% as.data.frame()
result_you_1 <- you[1:6,] %>% as.data.frame()
result_jung_1 <- jung[1:6,] %>% as.data.frame()
result_dae_1 <- dae[1:2,] %>% as.data.frame()


##### 데이터 저장하기
write.csv(result_seo_1,"서구top6.csv",fileEncoding = "cp949")
write.csv(result_dong_1,"동구top6.csv",fileEncoding = "cp949")
write.csv(result_you_1,"유성구top6.csv",fileEncoding = "cp949")
write.csv(result_jung_1,"중구top6.csv",fileEncoding = "cp949")
write.csv(result_dae_1,"대덕구top2.csv",fileEncoding = "cp949")


