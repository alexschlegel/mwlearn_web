from django.conf.urls import patterns, url
from django.contrib.auth.decorators import login_required
from django.contrib.auth.views import login, logout
from django.views.generic.base import RedirectView
from django.contrib.admin.views.decorators import staff_member_required

from mrtapp import views

urlpatterns = patterns('',
	url(r'^$', views.MRT.as_view(), name='mrt'),
	url(r'^data/$', views.data_view, name='data'),
)
