from django.conf.urls import patterns, url
from django.contrib.auth.decorators import login_required
from django.contrib.auth.views import login, logout
from django.views.generic.base import RedirectView
from django.contrib.admin.views.decorators import staff_member_required

from mwlearnapp import views

urlpatterns = patterns('',
	url(r'^$', RedirectView.as_view(url='/login/'), name='home'),
	url(r'^login/$', login, {'template_name':'login.html'}, name='account-login'),
	url(r'login_success/$', views.login_success, name='login_success'),
	url(r'^logout/$', logout, {'next_page': 'home'}, name='account-logout'),
	url(r'^experiment/$', views.Experiment.as_view(), name='experiment'),
	url(r'^log/$', views.Log.as_view(), name='log'),
	url(r'^log_append/$', views.log_append_view, name='log_append'),
	url(r'^log_delete/$', views.log_delete_view, name='log_delete'),
	url(r'^data/$', views.data_view, name='data'),
	url(r'^status/$', staff_member_required(views.Status.as_view()), name='status'),
)
