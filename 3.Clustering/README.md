# 군집분석 

```
- 입지 선정에 대한 지도 학습이 불가했기 때문에 군집분석 시행 
- 집단을 나누어 각 집단의 특성 파악
- 파악한 특성을 토대로 스마트 쉘터를 설치하기 위한 최적의 조건을 가진 집단 선택 
```
-------------
## PCA

### Scree plot을 이용한 차원 선택 
![image](https://user-images.githubusercontent.com/52143231/221378010-3839938e-10fc-445a-9790-2bede6554a68.png)
- PC5일 때 Scree plot의 기울기가 급격히 줄어들고 PC6에서 설명력의 크기 변화가 미비함
- PC5 기준 Explained Ratio가 91%의 설명력을 지님
- 이에 따라 데이터를 5차원으로 축소하여 군집분석 시행     

### 주성분 분석 결과 

![image](https://user-images.githubusercontent.com/52143231/221378098-f1547aa7-134c-4602-8a15-ba72fcf8ee9e.png)

------------

## Kmeans

### Elbow method
![image](https://user-images.githubusercontent.com/52143231/221396481-86b81a72-2a9f-4395-8eaa-7c11c22ab0f0.png)
- 'n-clusters' = 4 일 때 기울기가 크게 감소하며 그래프가 꺾이므로 군집 수 4개로 선정 

### Silhouette Diagram 
![image](https://user-images.githubusercontent.com/52143231/221396871-34766e55-a0ce-4821-8229-4579dd140954.png)
- 전체 실루엣 계수 평균값이 0.3008에서 크게 벗어나지 않아 군집화 진행 

### k-means 최적의 군집 
![image](https://user-images.githubusercontent.com/52143231/221397038-33d149e0-892a-4be7-8783-ebc3a67c7b94.png)
- 0번 군집 438개, 1번 군집 403개, 2번 군집 90개, 3번 군집229개의 결과 
- 군집 별 그룹핑 후 변수별로 순위를 산출하고 rowSum하여 최적의 군집 '2번'선정 

-----------------

## DBSCAN

### 군집 별 시각화
<img src="https://user-images.githubusercontent.com/52143231/221398220-d5f2b02f-f12e-488b-8b6d-1c5b8844b9f5.png" width = "450" height ="250">

- 실루엣 계수 : 0.5328796337863478
- -1번 군집 319, 0번 군집 174, 1번 군집 667 

### DBSCAN 최적의 군집
![image](https://user-images.githubusercontent.com/52143231/221399021-b31c1349-f650-4614-936f-e440f3335702.png)


- 군집 별 그룹핑 후 변수별로 순위를 산출하고 rowSum하여 최적의 군집 '-1번'선정 

----------------

## GMM

### BIC plot

![image](https://user-images.githubusercontent.com/52143231/221399156-c925ae50-5383-426d-94e8-84d2bd490ede.png)

- n_components의 범위를 1~6 사이로 지정
- 시각화 결과, n_clusters=5일 때 최소값을 가져 군집 수 5개로 선정
- 실루엣 계수 평균값 : 0.5822

### GMM 최적의 군집 
![image](https://user-images.githubusercontent.com/52143231/221399232-3c71c1ff-ae31-48da-a769-b39bd5f834ef.png)

- 0번 군집 32, 1번 군집 123, 2번 군집 210, 3번 군집 149, 4번 군집 646
- 군집 별 그룹핑 후 변수별로 순위를 산출하고 rowSum하여 최적의 군집 '3번'선정 

---------------------------

## 시군구 별 정류장 순위 산출 
![image](https://user-images.githubusercontent.com/52143231/221399320-474dee92-1f43-45e0-aa5a-8d6d43235ea1.png)

- 정류장 순위분석에 사용할 변수 선택 
- `반복문, 조건문, cut함수`를 이용해 각 변수별 가중치를 고려한 점수 부여 후 순위 산출  
- 시군구 별 그룹핑을 진행하여 분할하고 순위 컬럼을 기준으로 정렬하여 Top6 정류장 선정 
- 최종 선정된 10개 정류장의 위치 

