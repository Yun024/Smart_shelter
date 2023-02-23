###### 패키지 및 작업 디렉토리 설정
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA

import pandas as pd
import numpy as np
import seaborn as sns

dj_bus= pd.read_csv("C:\\Users\\user\\Desktop\\윤여준_빅데이터_청년인재\\Smart_Shelter/최종데이터/최종데이터_1.csv",encoding="cp949")
dj_bus.head()


###### 데이터 전처리
### 분석에 필요한 변수 추출
x = dj_bus[['총인구수','19세이하','65세이상','대기시간','초승수합','환승수합','총승차객합계',"400m_내_지하철역_수",'400m_내_학교_수','400m_내_복지시설_수','400m_내_미세먼지인자_수']]   #분석에 필요한 데이터만 추출
### MinMax정규화
from sklearn.preprocessing import MinMaxScaler
scaler = MinMaxScaler()
x_minmax = scaler.fit_transform(x)
X = pd.DataFrame(x_minmax,columns =['총인구수','19세이하','65세이상','대기시간','초승수합','환승수합','총승차객합계',"400m_내_지하철역_수",'400m_내_학교_수','400m_내_복지시설_수','400m_내_미세먼지인자_수'])


###### 주성분 분석
pca = PCA(random_state=1107)
x_p = pca.fit_transform(X)
pd.Series(np.cumsum(pca.explained_variance_ratio_))
### # 주성분 분석에서 PC5까지 선택
pca3 = PCA(n_components=5)
x_pp = pca3.fit_transform(X)

x_ppp = pd.DataFrame(data=x_pp,columns = ['PC1','PC2','PC3','PC4','PC5'])
x_pca = x_ppp.iloc[:,:5]
x_pca


###### DBSCAN 분석
from sklearn.cluster import DBSCAN

db_scan = DBSCAN(eps=0.3 ,min_samples=70).fit(x_pca)   #초기값으로 eps=0.3, 최소 개수는 70개로 지정 후 DBSCAN 분석 수행
x_pca['cluster_db'] = db_scan.labels_

x['cluster_db'] = db_scan.labels_

### 군집 별 개수
x.groupby('cluster_db').count()

### 군집별 변수의 평균
x.groupby('cluster_db').mean()

### 군집별 변수의 중앙값
x.groupby('cluster_db').median()

### 군집 별 시각화
sns.lmplot(x='PC1', y='PC2', data=x_pca, hue='cluster_db', fit_reg=False)

from mpl_toolkits.mplot3d import Axes3D

fig = plt.figure(figsize=(6,6))
ax = Axes3D(fig, rect=[0, 0, .95, 1], elev=48, azim=134)
ax.scatter(x_pca['PC1'],x_pca['PC2'],x_pca['PC3'],c=x_pca['cluster_db'],alpha=0.5)
ax.set_xlabel('PC1')
ax.set_ylabel('PC2')
ax.set_zlabel('PC3')
plt.show()

import plotly.express as px

fig = px.scatter_3d(
    x_pca, x='PC1', y='PC2', z='PC3',
    color = x_pca.cluster_db
)
fig.show()


###### 실루엣 계수
from sklearn.metrics import silhouette_samples, silhouette_score

score_samples = silhouette_samples(x_pca, x_pca['cluster_db'])
print('silhouette_samples( ) return 값의 shape' , score_samples.shape)

x_pca['silhouette_coeff'] = score_samples

average_score = silhouette_score(x_pca, x_pca['cluster_db'])
average_score  # 실루엣계수


###### 최종 데이터 추출
X['cluster_db'] = db_scan.labels_
X.head()

idx = X[X['cluster_db']==1].reset_index()['index']
group1 = dj_bus.iloc[idx]
group1['cluster_db'] = "1"

idx = X[X['cluster_db']==0].reset_index()['index']
group0 = dj_bus.iloc[idx]
group0['cluster_db'] = "0"

idx = X[X['cluster_db']==-1].reset_index()['index']
group2 = dj_bus.iloc[idx]
group2['cluster_db'] = "-1"

real_result = pd.concat([group1, group0, group2], axis=0)
real_result
# real_result.to_csv('C:\\Users\\user\\Desktop\\윤여준_빅데이터_청년인재\\Smart_Shelter\\최종데이터/최종데이터_2.csv',index=False,encoding='cp949')
