# -*- coding:utf-8 -*-
    # 한글 처리를 위해

from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name="index"), # views.py에서 index를 찾으라는 뜻
    path('createTodo', views.createTodo, name="createTodo"), # index.html form 태그 action
    path('deleteTodo', views.deleteTodo, name='deleteTodo')
]