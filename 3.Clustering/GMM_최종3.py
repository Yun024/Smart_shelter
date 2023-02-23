###### 패키지 및 작업 디렉토리 설정
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
import pandas as pd
import numpy as np
dj_bus= pd.read_csv("C:\\Users\\user\\Desktop\\윤여준_빅데이터_청년인재\\Smart_Shelter/최종데이터/최종데이터_2.csv",encoding="cp949")
dj_bus.head()


###### 데이터 전처리
### 분석에 필요한 변수 추출
x = dj_bus[['총인구수','19세이하','65세이상','대기시간','초승수합','환승수합','총승차객합계',"400m_내_지하철역_수",'400m_내_학교_수','400m_내_복지시설_수','400m_내_미세먼지인자_수']]   #분석에 필요한 데이터만 추출
### MinMax정규화
from sklearn.preprocessing import MinMaxScaler
scaler = MinMaxScaler()
x_minmax = scaler.fit_transform(x)
X = pd.DataFrame(x_minmax,columns =['총인구수','19세이하','65세이상','대기시간','초승수합','환승수합','총승차객합계',"400m_내_지하철역_수",'400m_내_지하철역_수','400m_내_복지시설_수','400m_내_미세먼지인자_수'])


###### 주성분 분석
pca = PCA(random_state=1107)
x_p = pca.fit_transform(X)
pd.Series(np.cumsum(pca.explained_variance_ratio_))
### 주성분 분석에서 PC5까지 선택
pca3 = PCA(n_components=5)
x_pp = pca3.fit_transform(X)
x_ppp = pd.DataFrame(data=x_pp,columns = ['PC1','PC2','PC3','PC4','PC5'])
x_pca = x_ppp.iloc[:,:5]
x_pca

####### GMM_Clustering
### 군집 수 결정 그래프
from sklearn.mixture import GaussianMixture
n_components = np.arange(1, 6)
models = [GaussianMixture(n, covariance_type='full', random_state=0).fit(x_pca)
          for n in n_components]
plt.plot(n_components, [m.bic(x_pca) for m in models], label='BIC')
###plt.plot(n_components, [m.aic(Xmoon) for m in models], label='AIC')
plt.legend(loc='best')
plt.xlabel('n_components');
gmm = GaussianMixture(n_components = 5)
gmm_result = gmm.fit(x_pca)
gmm_labels = gmm.predict(x_pca)
x_pca['cluster_gmm'] = gmm_labels
x['cluster_gmm'] = gmm_labels
### 군집별 개수
x.groupby('cluster_gmm').count()
### 군집별 변수의 평균
x.groupby('cluster_gmm').mean()
### 군집별 변수의 중앙값
x.groupby('cluster_gmm').median()
### GMM 시각화
import plotly.express as px

fig = px.scatter_3d(
    x_pca, x='PC1', y='PC2', z='PC3',
    color = gmm_labels
)
fig.show()


###### 실루엣 계수
from sklearn.metrics import silhouette_samples, silhouette_score
score_samples = silhouette_samples(x_pca, x_pca['cluster_gmm'])
print('silhouette_samples( ) return 값의 shape' , score_samples.shape)
x_pca['silhouette_coeff'] = score_samples
print('전체 군집의 실루엣 계수 평균')
average_score = silhouette_score(x_pca, x_pca['cluster_gmm'])
average_score
average_score = silhouette_score(x_pca, x_pca['cluster_gmm'])
average_score


###### 최종 데이터 추출
X['cluster'] = gmm_labels
X.head()
idx = X[X['cluster']==4].reset_index()['index']
group4 = dj_bus.iloc[idx]
group4['cluster_gmm'] = "4"
idx = X[X['cluster']==3].reset_index()['index']
group3 = dj_bus.iloc[idx]
group3['cluster_gmm'] = "3"
idx = X[X['cluster']==2].reset_index()['index']
group2 = dj_bus.iloc[idx]
group2['cluster_gmm'] = "2"
idx = X[X['cluster']==1].reset_index()['index']
group1 = dj_bus.iloc[idx]
group1['cluster_gmm'] = "1"
idx = X[X['cluster']==0].reset_index()['index']
group0 = dj_bus.iloc[idx]
group0['cluster_gmm'] = "0"

real_result = pd.concat([group4,group3, group2, group1, group0], axis=0)
real_result
# real_result.to_csv('C:\\Users\\user\\Desktop\\윤여준_빅데이터_청년인재\\Smart_Shelter\\최종데이터/최종데이터.csv',index=False,encoding='cp949')
