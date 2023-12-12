
# 1. 프로젝트 정보
## 전세가 예측 모델을 활용한 전세사기 예방 프로젝트

<div style="display: flex; justify-content: center;"><img src="https://github.com/Gil-Yeon/TIL/assets/90386792/232e36f3-e019-42e1-99d3-8beb3059f1ba" style="max-width: 300px;" alt="이미지"></div>
<a href="https://hits.seeyoufarm.com", ><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FGil-Yeon%2FTIL%2Ftree%2Fmaster%2FProject%2FJeonse_Price&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false"/></a>

## 진행 단체 및 기간
단체 : 멀티캠퍼스 데이터 분석가&엔지니어 훈련
기간 : 2023.09.06 ~ 2023.09.26

## 배포 주소
https://jeonseapp-q98zbyabcszasknduhe4pe.streamlit.app/

## 프로젝트 소개
부동산 갭 투자, 인천 빌라왕 등 최근 들어 전세사기로 인한 피해가 급증하고 있는 가운데
저희팀은 이러한 피해를 방지하고자 전세가 예측 모델로 전세가를 예측하고 전세가율을 계산하여
사용자들이 전세사기의 위험성이 있는 매물을 미리 파악하는데 도움을 주고자 하였습니다.

배포된 저희 웹사이트를 이용하시면 아래의 기능들을 사용하실 수 있습니다.
  - 전세가 예측을 기반으로 한 전세계약의 안정성 파악
  - 주변 인프라 정보 제공

# 2. 시작 가이드
## Requirements
- Python 3.11.5
- Visual Studio Code 1.85

## Installation
```
$ git clone https://github.com/Gil-Yeon/Jeonse_Streamlit.git
$ cd Jeonse_Streamlit
$ pip install -r requirements.txt
$ streamlit run Main_app.py
```
# 3. 기술 스택
## Environment
 <img src="https://img.shields.io/badge/Jupyter Notebook-F37626?style=for-the-badge&logo=Jupyter&logoColor=white">
<img  src="https://img.shields.io/badge/VISUAL STUDIO CODE-007ACC?style=for-the-badge&logo=Visualstudiocode&logoColor=white">
<img src="https://img.shields.io/badge/표시할이름-색상?style=for-the-badge&logo=기술스택아이콘&logoColor=white">

## Language
 <img src="https://img.shields.io/badge/python-3776AB?style=for-the-badge&logo=python&logoColor=white">

## Libraries and Packages

## Communication


-   Data Preprocessing
    -   Pandas
    -   Numpy
    -   Sklearn.IsolationForest
    -   XGBoost
-   Statistics
    -   Logistic Regression
    -   VIF
    -   Wald Test
    -   Prophet
-   Machine Learning
    -   KNN
    -   Random Forest
    -   LightGBM
    -   XGBoost
-   Deep Learning
    -   FNN
    -   LSTM
    -   GRU
-   Data Visulization
    -   matplotlib
    -   seaborn
-   Dashboard
    -   streamlit
