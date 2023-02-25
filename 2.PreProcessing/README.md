# 데이터 전처리

## 정류장 별 승하차객 전처리  *[바로가기](https://github.com/Yun024/Smartshelter_project/blob/main/2.PreProcessing/%EC%A0%95%EB%A5%98%EC%9E%A5%20%EB%B3%84%20%EC%8A%B9%ED%95%98%EC%B0%A8%EA%B0%9D%20%EC%A0%84%EC%B2%98%EB%A6%AC.R)*
![image](https://user-images.githubusercontent.com/52143231/221360650-4cecf982-c55e-4622-9b72-7dddbca31eb7.png)
- '정류장'컬럼을 분리하여 '고유번호'와 '정류장' 컬럼으로 분리
- '고유번호'와 '정류장'을 기준으로 그룹핑하여 '초승수합', '환승수합', '총승차객합계' 컬럼 산출 

## 정류장 위도경도 전처리     *[바로가기](https://github.com/Yun024/Smartshelter_project/blob/main/2.PreProcessing/%EC%A0%95%EB%A5%98%EC%9E%A5%20%EC%9C%84%EB%8F%84%EA%B2%BD%EB%8F%84%20%EC%A0%84%EC%B2%98%EB%A6%AC.R)*
![image](https://user-images.githubusercontent.com/52143231/221360532-0e15ac84-cb2b-4590-ab48-29e302bacea1.png)
- QGIS를 이용한 공간분석을 할 경우 '초' 단위 기준을 가진 위·경도 데이터가 필요
- 이를 위해 위·경도 컬럼의 기준을 '분' 단위에서 '초' 단위 기준으로 변경

## 읍면동 별 거주인구 전처리   *[바로가기](https://github.com/Yun024/Smartshelter_project/blob/main/2.PreProcessing/%EC%9D%8D%EB%A9%B4%EB%8F%99%20%EB%B3%84%20%EA%B1%B0%EC%A3%BC%EC%9D%B8%EA%B5%AC%20%EC%A0%84%EC%B2%98%EB%A6%AC.R)*
<img src="https://user-images.githubusercontent.com/52143231/221359851-f32dc27e-2daf-49d1-bb64-49890634439e.png" height=200 width = 500>

- '행정구역' 컬럼에서 읍면동명을 분리하여 '읍면동명' 컬럼 생성
- 문자타입의 범주형 컬럼을 숫자타입으로 변경
- 분석에 사용할 범주로 rowSums를 이용한 범주 변환 후 변수 생성  

## 데이터병합_최종전처리    *[바로가기](https://github.com/Yun024/Smartshelter_project/blob/main/2.PreProcessing/%EB%8D%B0%EC%9D%B4%ED%84%B0%EB%B3%91%ED%95%A9_%EC%B5%9C%EC%A2%85%EC%A0%84%EC%B2%98%EB%A6%AC.R)*
<img src="https://user-images.githubusercontent.com/52143231/221364938-5250a649-1aec-4d52-86dc-7b2c647d0c75.png" height=200 width = 650>

- '고유번호' 컬럼을 기준으로 `승하차, 인구, 정류장` 데이터 병합
- 400m내 버퍼 데이터 병합 
- 클러스터링 전 변수명 및 변수순서 변경 

