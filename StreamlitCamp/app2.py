import streamlit as st
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns
import plotly.graph_objects as go

def calculate_sales_revenue(price, total_sales):
    revenue = price * total_sales
    return revenue

iris = sns.load_dataset('iris')

def plot_matplotlib():
    st.title('Scatter with matplotlib')
    fig, ax = plt.subplots(figsize=(10,7))
    ax.scatter(iris['sepal_width'], iris['sepal_length'])
    ax.set_title('iris_sepal')
    st.pyplot(fig)

def plot_seaborn():
    st.title('Scatter with seaborn')
    fig, ax = plt.subplots(figsize=(10,7), ncols=2)
    sns.scatterplot(data = iris, x = 'sepal_width', y = 'sepal_length', hue = 'species', ax = ax[0])
    sns.scatterplot(data = iris, x = 'petal_width', y = 'petal_length', hue = 'species', ax = ax[1])
    ax[0].set_title('iris_sepal')
    ax[1].set_title('iris_petal')
    st.pyplot(fig)

def plot_plotly():
    st.title('Scatter Plot with Plotly')
    fig = go.Figure()
    fig.add_trace(
        go.Scatter(x = iris['sepal_width'],
                   y = iris['sepal_length'],
                   mode='markers')
    )
    st.plotly_chart(fig)

def main():
    st.title('오후 수업')

    price = st.slider("단가: ", 1000, 10000, value = 5000)
    total_sales = st.slider("전체 판매 갯수", 1, 1000, value = 500)

    st.write(price, total_sales)

    if st.button("매출액 계산"):
        result = calculate_sales_revenue(price, total_sales)
        st.write("전체 매출액은", result, "원(KRW)")

    # 체크박스
    x = np.linspace(0, 10, 100)
    y = np.sin(x)

    show_plot = st.checkbox("시각화 보여주기") # True / False
    st.write(show_plot)
    fig, ax = plt.subplots()
    ax.plot(x, y)

    if show_plot:
        st.pyplot(fig)

    st.write('-' * 50)
    plot_type = st.radio(
        "어떤 스타일의 산점도를 보고 싶으세요?",
        ("matplotlib", "seaborn", "plotly")
    )

    if plot_type == 'matplotlib':
       plot_matplotlib()
    elif plot_type == 'seaborn':
        plot_seaborn()
    elif plot_type == 'plotly':
        plot_plotly()
    else:
        st.error("에러")

    st.write('-' * 50)

    # selectbox
    st.markdown('## Raw Data')
    st.dataframe(iris)

    st.markdown("<hr>", unsafe_allow_html=True)
    st.markdown("### Selectbox")
    col_name = st.selectbox('1개의 종을 선택하세요!', iris['species'].unique())
    st.write(col_name)

    result = iris.loc[iris['species'] == col_name].reset_index()
    st.dataframe(result)

    st.title('Scatter with matplotlib')
    fig, ax = plt.subplots(figsize=(10,7))
    ax.scatter(result['sepal_width'], result['sepal_length'])
    ax.set_title('iris_sepal')
    st.pyplot(fig)

    st.title('Scatter with seaborn')
    fig, ax = plt.subplots(figsize=(10,7), ncols=2)
    sns.scatterplot(data = result, x = 'sepal_width', y = 'sepal_length', ax = ax[0])
    sns.scatterplot(data = result, x = 'petal_width', y = 'petal_length', ax = ax[1])
    ax[0].set_title('iris_sepal')
    ax[1].set_title('iris_petal')
    st.pyplot(fig)

    # MultiSelect
    cols = st.multiselect('복수의 컬럼 선택', iris.columns)
    st.write(cols)
    filtered_iris = iris.loc[:, cols]
    st.dataframe(filtered_iris)



if __name__ == '__main__':
    main()