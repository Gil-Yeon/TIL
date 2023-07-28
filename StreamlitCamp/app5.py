import streamlit as st
import matplotlib.pyplot as plt
import seaborn as sns

def main():
    st.title("확인")
    with st.sidebar:
        st.header("sidebar")
        day = st.selectbox("요일 선택", ["Thur", "Fri", "Sat", "Sun"])
    
    tips = sns.load_dataset("tips")
    filtered_tips = tips.loc[tips['day'] == day]
    top_bill = filtered_tips['total_bill'].max()
    top_tip = filtered_tips['tip'].max()

    st.dataframe(filtered_tips)

    tab1, tab2, tab3 = st.tabs(['Total Bill', 'Tip', 'Size'])
    with tab1:
        fig, ax = plt.subplots()
        st.header("Total Bill")
        sns.histplot(filtered_tips['total_bill'], kde=False, ax=ax)
        st.pyplot(fig)

    with tab2:
        st.metric("Highest tip", top_tip)
    





if __name__ == "__main__":
    main()