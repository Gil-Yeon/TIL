from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect
from django.urls import reverse
from .models import *

# Create your views here.

# before
'''
def index(request):
    return HttpResponse('나의 첫번째 페이지')
'''

# after
def index(request):
    todos = Todo.objects.all()
    content = {'todos' : todos}
    return render(request, 'my_test_app/index.html', content)

def createTodo(request):
    user_input_str = request.POST['todoContent']
    print("저장한 data : ", user_input_str)
    new_todo = Todo(content = user_input_str)
    new_todo.save()
    return HttpResponseRedirect(reverse('index'))

def deleteTodo(request):
    delete_todo_id = request.GET['todoNum']
    print("삭제한 todo의 id : ", delete_todo_id)
    todo = Todo.objects.get(id = delete_todo_id)
    todo.delete()
    return HttpResponseRedirect(reverse('index'))