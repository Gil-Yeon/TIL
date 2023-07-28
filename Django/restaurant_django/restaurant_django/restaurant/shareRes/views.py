from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect
from django.urls import reverse
from .models import *

# Create your views here.

def index(request):
    # return HttpResponse("index")
    return render(request, 'shareRes/index.html')

def restaurantDetail(request):
    # return HttpResponse("restaurantDetail")
    return render(request, 'shareRes/restaurantDetail.html')

def restaurantCreate(request):
    return render(request, 'shareRes/restaurantCreate.html')

def categoryCreate(request):
    return render(request, 'shareRes/restaurantCreate.html')

def Create_category(request):
    category_name5 = request.GET['categoryName']
    new_category = Category(category_name = category_name5)
    new_category.save()
    return HttpResponseRedirect(reverse('index'))