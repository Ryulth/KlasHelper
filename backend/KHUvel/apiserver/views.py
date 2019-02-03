from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from json import loads as json_loads
from . import paser
#from . import models
from . import posts
from . import forms
# Create your views here.
import os
@csrf_exempt#인증문제 해결
def main_page(request):
    return render(request, 'apiserver/main_page.html', {})

@csrf_exempt#인증문제 해결
def login(request):
    # TODO request.id , request.password 같은 식으로 로그인 처리
    if request.method=='POST':
        req=json_loads(request.body.decode("utf-8"))
        res=paser.login(req)
        data=res
        return JsonResponse(data, safe=False)
    else:
        data = {'status': 'RequestError'}
        return JsonResponse(data, safe=False)

@csrf_exempt
def update(request):
    if request.method == 'POST':
        req = json_loads(request.body.decode("utf-8"))
        res=paser.clova_login(req)
        data=res
        return JsonResponse(data, safe=False)
    else:
        data = {'status': 'RequestError'}
        return JsonResponse(data, safe=False)
@csrf_exempt
def clova_ass(request):
    if request.method == 'POST':
        req = json_loads(request.body.decode("utf-8"))
        res=paser.clova_ass(req)
        data=res
        return JsonResponse(data, safe=False)
    else:
        data = {'status': 'RequestError'}
        return JsonResponse(data, safe=False)

@csrf_exempt
def clova_lec(request):
    if request.method == 'POST':
        req = json_loads(request.body.decode("utf-8"))
        res=paser.clova_lec(req)
        data=res
        return JsonResponse(data, safe=False)
    else:
        data = {'status': 'RequestError'}
        return JsonResponse(data, safe=False)



@csrf_exempt
def get_assignment(request):
    # 학번 비밀번호 받아서 과제/싸강 긁어오기
    if request.method=='POST':
        req=json_loads(request.body.decode("utf-8"))
        data = {'status': 'SUCCESS'}
        res=paser.get_assignment(req)
        data["assignment"]=res
        return JsonResponse(data, safe=False)
    else:
        data = {'STATUS': 'GET_ASS_ERROR'}
        return JsonResponse(data, safe=False)

@csrf_exempt#인증문제 해결
def board(request):
    if request.method == 'POST':
        req = json_loads(request.body.decode("utf-8"))
        data = {'status': 'Success'}
        res = posts.board_list(req)
        data["board"]=res
        return JsonResponse(data, safe=False)
    else:
        data = {'status': 'RequestError'}
        return JsonResponse(data, safe=False)
@csrf_exempt#인증문제 해결
def get_postlist(request):
    if request.method == 'POST':
        req = json_loads(request.body.decode("utf-8"))
        data = {'status': 'Success'}
        res = posts.get_postlist(req)
        data["posts"]=res
        return JsonResponse(data, safe=False)
    else:
        data = {'status': 'RequestError'}
        return JsonResponse(data, safe=False)
@csrf_exempt#인증문제 해결
def get_postdetail(request,pk):
    data = posts.get_postdetail(pk)
    return JsonResponse(data, safe=False)

@csrf_exempt
def post_add(request):
    if request.method == 'POST':
        form=forms.PostForm(request.POST)
        if form.is_valid():
            posts.post_add(form)
            data = {'status': 'Success'}
            return JsonResponse(data, safe=False)
        else:
            data = {'status': 'FormError'}
            return JsonResponse(data, safe=False)
    else:
        data = {'status': 'RequestError'}
        return JsonResponse(data, safe=False)

@csrf_exempt
def post_update(request,pk):
    if request.method == 'POST':
        form = forms.PostForm(request.POST)
        if form.is_valid():
            data=  posts.post_update(form,pk)
            return JsonResponse(data, safe=False)
        else:
            data = {'status': 'FormError'}
            return JsonResponse(data, safe=False)
    else:
        data = {'status': 'RequestError'}
        return JsonResponse(data, safe=False)

@csrf_exempt#인증문제 해결
def post_delete(request,pk):
    if request.method == 'POST':
        req = json_loads(request.body.decode("utf-8"))
        data = posts.post_delete(req,pk)
        return JsonResponse(data, safe=False)
    else:
        data = {'status': 'RequestError'}
        return JsonResponse(data, safe=False)

@csrf_exempt
def comment_add(request, pk):
    if request.method == 'POST':
        form=forms.CommentForm(request.POST)
        if form.is_valid():
            posts.comment_add(form,pk)
            data = {'status': 'Success'}
            return JsonResponse(data, safe=False)
        else:
            data = {'status': 'FormError'}
            return JsonResponse(data, safe=False)
    else:
        data = {'status': 'RequestError'}
        return JsonResponse(data, safe=False)

@csrf_exempt
def comment_update(request,pk,pk2):
    if request.method == 'POST':
        form=forms.CommentForm(request.POST)
        if form.is_valid():
            data= posts.comment_update(form,pk2)
            return JsonResponse(data, safe=False)
        else:
            data = {'status': 'FormError'}
            return JsonResponse(data, safe=False)
    else:
        data = {'status': 'RequestError'}
        return JsonResponse(data, safe=False)

@csrf_exempt#인증문제 해결
def comment_delete(request,pk,pk2):
    if request.method == 'POST':
        req = json_loads(request.body.decode("utf-8"))
        data = posts.comment_delete(req,pk2)
        return JsonResponse(data, safe=False)
    else:
        data = {'status': 'RequestError'}
        return JsonResponse(data, safe=False)
