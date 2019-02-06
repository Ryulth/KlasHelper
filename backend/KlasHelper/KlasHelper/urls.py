"""
auth by ryulth
"""
from django.contrib import admin
from django.urls import path
from django.conf.urls import include, url

urlpatterns = [
    path('admin/', admin.site.urls),
    url('', include('apiserver.urls')),

]
