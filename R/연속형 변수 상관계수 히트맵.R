# install.packages("ggcorrplot")
library(dplyr)
library(ggcorrplot)
library(ggplot2)
getwd()
setwd("C:/Users/user/R_project/정제데이터")
dir()

data <- read.csv("최종데이터_2.csv",fileEncoding = "cp949")
data %>% names()
data.use <- data[,c(10,11,13,16,19,17,18,20:23)]
data.use %>% names()
colnames(data.use)[2] <- "19세이하"
colnames(data.use)[3] <- "65세이하"
colnames(data.use)[8] <- "400m_내_지하철역_수"
colnames(data.use)[9] <- "400m_내_학교_수"
colnames(data.use)[10] <- "400m_내_복지시설_수"
colnames(data.use)[11] <- "400m_내_미세먼지인자_수"
data.use %>% head()

cor.data <- data.use %>% cor() %>% round(2)
cor.data
p.value <- data.use %>% cor() %>% round(2)
ggc <- ggcorrplot(cor.data, type="lower",legend.title="피어슨 상관계수",show.diag=T,
           outline.color="white",lab=T,lab_col="black",lab_size=3.5,title="상관계수 히트맵",
           digits=2,tl.cex=10,tl.col="black",tl.srt=45,ggtheme=ggplot2::theme_test())
ggc + theme(plot.title=element_text(size=50,hjust=0.5)) 
