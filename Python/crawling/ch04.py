import requests
from bs4 import BeautifulSoup
import pandas as pd

# 벅스 차트 타이틀 가져오기

def crawler(soup):
    result = []
    titles = soup.find_all('p', class_='title')
    for i in titles:
        result.append(i.get_text().strip())
    return result

def createDF(result_list):
    result_df = pd.DataFrame({"title": result_list})
    return result_df

def main():
    custom_header = {
        'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36'
    }

    url = "https://music.bugs.co.kr/chart"
    req = requests.get(url, headers=custom_header)
    soup = BeautifulSoup(req.text, "html.parser")
    result = crawler(soup)
    df = createDF(result)
    print(df)
    df.to_csv("result.csv", index=False)

if __name__ == "__main__":
    main()