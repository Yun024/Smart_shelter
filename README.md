# 스마트 쉘터 입지 선정 프로젝트
## 스마트쉘터란?
스마트 쉘터는 자동정차 시스템, 공기청정기, UV에어커튼, CCTV, 냉난방기, 핸드폰 무선충전, 와이파이 등 각종 편의시설이 융합된 미래형 버스정류소를 말함

## 연구 목표
- 대전에 스마트 쉘터를 도입하였을 때의 최적의 입지를 선정하고자 함 
- 최적의 입지 기준으로 유동인구, 교통량, 미세먼지 유발 인자 외 6개 변수 고려 

## 프로젝트 기간
- 2022년 7월 26일 ~ 8월 19일
- 6인 1조 팀프로젝트 
  + 팀원 명 : 윤여준, 이관영, 조민규, 안동수, 이수지, 장하영
  
  
## 사용 기술 : [모듈 및 패키지]
`EDA & PreProcessing` 
- R : [ wordcloud, RColorBrewer, rvest, stringr, dplyr, KoNLP, useSejongDic, reshape, readxl, ggplot2, ggcorrplot ]
- Excel

`Mapping`
- Geo coding 
- QGIS

`Clustering`
- Python : [ matplotlib, sklearn, pandas, numpy, seaborn, os, yellowbrick, plotly, mpl_toolkits ]
- R : [ dplyr ]

## 데이터 설명 
|번호|활용 데이터|형식|행|데이터 소스|
|:------:|------|------|------|------|
|1|대전 시내버스 정류장 데이터|csv|2,807건|공공데이터포털|
|2|대전 시내버스 이용량 데이터|csv|50,449건|교통데이터 DW시스템|
|3|대전 시내버스 배치시간 별 운행 데이터|csv||대전교통정보센터|
|4|대전광역시 취약계층 복지건물 현황 데이터|csv||대전광역시청|
|5|대전 유·초·중·고 데이터|csv||대전광역시교육청|
|6|대전 미세먼지 발생 및 배출 시설 데이터|csv|2,830건|공공데이터포털|
|7|대전 구별 및 읍면동 연령별_인구 데이터|csv|790건|대전광역시청|
|8|대전 지하철 위치정보 데이터|shp||Google Map|
|9|대전 민원 텍스트 데이터|txt|373건|대전지역 사회문제 은행|


## Contents
### 1. EDA : *[Readme바로가기](https://github.com/Yun024/Smartshelter_project/blob/main/Exploratory_Data_Analysis/EDA_README.md)*
* 대전 민원 분석(워드클라우드)
* 탐색적 데이터 분석 전 전처리
* 연속형 변수 상관계수 히트맵

### 2. PreProcessing : *[Readme바로가기](https://github.com/Yun024/Smartshelter_project/blob/main/PreProcessing/PreProcessing_README.md)*
* 승차객 그룹 평균
* 위도 경도 전처리
* 인구 전처리
* 최종 전처리 및 데이터 병합

### 3. Clustering : *[Readme바로가기](https://github.com/Yun024/Smartshelter_project/blob/main/Machine_Learning/Clustering_README.md)*
* Kmeans
* DBSCAN
* GMM

## 느낀 점 
- QGIS를 이용하여 시각화하면 맵핑이 편리하며 공간분석에 용이하다는 사실을 배움
- 입지 선정 지수와 같이 주관적인 지표가 들어가면 객관적인 근거가 매우 필요하다는 정보를 얻게 됨
- 정성적인 자료도 중요하지만 정량적 자료가 많을 수록 프로젝트를 뒷받침하는 근거가 강해짐
- 한 가지 분석기법을 여러 프로그래밍언어에서 다룰 수 있도록 다방면으로 공부할 필요성을 느낌
