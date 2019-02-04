from django.conf.urls import url
from . import views
from rest_framework_swagger.views import get_swagger_view

schema_view = get_swagger_view(title='apiserver')

urlpatterns = [
    url(r'^$', views.login),
    url('swagger/', schema_view),
    url('board/', views.board),
    url('login/', views.login),
    url('get_ass/', views.get_assignment),
    url('post_list/', views.get_postlist),
    url('post_add/', views.post_add),
    url('post_detail/(?P<pk>\d+)/$', views.get_postdetail),
    url('post_detail/(?P<pk>\d+)/post/update/$', views.post_update),
    url('post_detail/(?P<pk>\d+)/post/delete/$', views.post_delete),
    url('post_detail/(?P<pk>\d+)/comment/add/$', views.comment_add),
    url('post_detail/(?P<pk>\d+)/comment/update/(?P<pk2>\d+)/$', views.comment_update),
    url('post_detail/(?P<pk>\d+)/comment/delete/(?P<pk2>\d+)/$', views.comment_delete),
]