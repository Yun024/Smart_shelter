###### 패키지 및 작업디렉토리 설정
import matplotlib.pyplot as plt
%matplotlib inline
from sklearn.decomposition import PCA
import pandas as pd
import numpy as np
import seaborn as sns
### os에 따른 Font 깨짐 제거를 위해 Font 지정
import os
if os.name == 'nt':
    font_family = "Malgun Gothic"
else:
    font_family = "AppleGothic"  
### - 값이 깨지는 문제 해결을 위해 파라미터 값 설정
sns.set(font= font_family, rc = {"axes.unicode_minus" : False})
### 데이터 확인
dj_bus= pd.read_csv("C:\\Users\\user\\Desktop\\윤여준_빅데이터_청년인재\\Smart_Shelter/최종데이터/최종데이터_군집하기전.csv",encoding="cp949")
dj_bus.head()


###### 데이터 전처리
# 분석에 필요한 변수만 추출
x = dj_bus[['총인구수','19세이하','65세이상','대기시간','초승수합','환승수합','총승차객합계',"400m_내_지하철역_수",'400m_내_학교_수','400m_내_복지시설_수','400m_내_미세먼지인자_수']] 

# minmax 정규화
from sklearn.preprocessing import MinMaxScaler
scaler = MinMaxScaler()
x_minmax = scaler.fit_transform(x)
X = pd.DataFrame(x_minmax,columns =['총인구수','19세이하','65세이상','대기시간','초승수합','환승수합','총승차객합계',"400m_내_지하철역_수",'400m_내_학교_수','400m_내_복지시설_수','400m_내_미세먼지인자_수'])


#상관계수 히트맵
plt.figure(figsize=(15,15))

sns.heatmap(data = X.corr(), annot=True, fmt = '.2f', linewidths=.5, cmap='Blues')


주성분 분석

pca = PCA(random_state=1107)
x_p = pca.fit_transform(X)

pd.Series(np.cumsum(pca.explained_variance_ratio_))   # 주성분 5개까지 선택했을 때 0.86의 설명력을 가짐을 확인

# 주성분 분석에서 PC5까지 선택
pca5 = PCA(n_components=5)
x_pp = pca5.fit_transform(X)   #주성분 분석을 통해 PC5까지 선택

x_pca = pd.DataFrame(data=x_pp,columns = ['PC1','PC2','PC3','PC4','PC5'])
x_pca  

Kmeans군집분석
# 군집 수 결정
from sklearn.cluster import KMeans
from yellowbrick.cluster.elbow import kelbow_visualizer

model = KMeans()
visualizer = kelbow_visualizer(model, x_pca, k=(1,10))  # 군집 수 4개로 하는 것이 적합함을 확인

# 군집 수 4개로 k-means 분석을 실시
x_km = KMeans(init="k-means++", n_clusters=4)   
x_result = x_km.fit(x_pca)

k_means_labels = x_result.labels_

import plotly.express as px   

fig = px.scatter_3d(
    x_pca, x='PC1', y='PC2', z='PC3',
    color = x_result.labels_
)
fig.show()

실루엣 계수

from yellowbrick.cluster import SilhouetteVisualizer

visualizer_4 = SilhouetteVisualizer(x_km, colors='yellowbrick')

visualizer_4.fit(x_pca)      
visualizer_4.show()

result_df = x_pca.copy()

#클러스터ID 컬럼 생성 
result_df.loc[:,'clusterID'] = visualizer_4.predict(x_pca)
#실루엣 계수 컬럼 생성
result_df.loc[:,'silhouette coefficient'] = visualizer_4.silhouette_samples_

result_df.shape
result_df.head(5)

print('전체 군집의 실루엣 계수 평균')
result_df['silhouette coefficient'].mean()

print('군집별 실루엣 계수')
result_df.groupby('clusterID')['silhouette coefficient'].mean().reset_index()

최종 데이터 추출

X['cluster'] = x_result.labels_  #군집분석의 결과를 필요한 변수만 뽑은 데이터프레임에 추가.
X.head()
# 군집별 개수
X.groupby('cluster').count()
# 군집별 변수의 평균
x['cluster'] = x_result.labels_
x.groupby('cluster').mean()
# 군집별 변수의 중앙값
x.groupby('cluster').median()
# 각 군집별로 뽑은 후에 오름차순으로 정령.
idx = result_df[result_df['clusterID']==3].reset_index()['index']
group3 = dj_bus.iloc[idx]
group3['cluster_km'] = "3"
idx = result_df[result_df['clusterID']==2].reset_index()['index']
group2 = dj_bus.iloc[idx]
group2['cluster_km'] = "2"
idx = result_df[result_df['clusterID']==1].reset_index()['index']
group1 = dj_bus.iloc[idx]
group1['cluster_km'] = "1"
idx = result_df[result_df['clusterID']==0].reset_index()['index']
group0 = dj_bus.iloc[idx]
group0['cluster_km'] = "0"

real_result = pd.concat([group3,group2, group1, group0], axis=0)

real_result
# real_result.to_csv('C:\\Users\\user\\Desktop\\윤여준_빅데이터_청년인재\\Smart_Shelter\\최종데이터/최종데이터_1.csv',index=False,encoding='cp949')
