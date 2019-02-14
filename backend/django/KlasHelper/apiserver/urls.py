from django.conf.urls import url
from django.urls import path
from . import views
from rest_framework_swagger.views import get_swagger_view

schema_view = get_swagger_view(title='apiserver')

urlpatterns = [
    url(r'^$', views.login),
    url('swagger', schema_view),
    url('login', views.login),
    path('assignments/<str:semester_code>',views.get_assignments),
    path('semesters',views.get_semesters),

]