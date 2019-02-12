from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from json import loads as json_loads
from . import crawler


# Create your views here.

@csrf_exempt  # 인증문제 해결
def login(request):
    # TODO request.id , request.password 같은 식으로 로그인 처리
    if request.method == 'POST':
        req = json_loads(request.body.decode("utf-8"))
        res_data = crawler.login(req)
        return JsonResponse(res_data, safe=False)
    else:
        res_data = {'status': 'RequestError'}
        return JsonResponse(res_data, safe=False)


@csrf_exempt
def get_assignments(request, semester_code):
    # 학번 비밀번호 받아서 과제/싸강 긁어오기
    if request.method == 'GET':
        if "test" == request.META.get("HTTP_APPTOKEN"):
            res_data = crawler.get_assignments(request, semester_code)
            return JsonResponse(res_data, safe=False)
        else:
            res_data = {'status': 'AppTokenError'}
            return JsonResponse(res_data, safe=False)
    else:
        res_data = {'status': 'RequestError'}
        return JsonResponse(res_data, safe=False)


@csrf_exempt
def get_semesters(request):
    if request.method == 'GET':
        if "test" == request.META.get("HTTP_APPTOKEN"):
            res_data = crawler.get_semesters(request)
            return JsonResponse(res_data, safe=False)
        else:
            res_data = {'status': 'AppTokenError'}
            return JsonResponse(res_data, safe=False)
    else:
        res_data = {'status': 'RequestError'}
        return JsonResponse(res_data, safe=False)
