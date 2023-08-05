import requests
from bs4 import BeautifulSoup

url = 'https://www.naver.com/'

# 요청 url 변수에 담긴 url의 html 문서를 출력한다.
req = requests.get(url)
print(req.status_code)