import json

from django import template
from django.http import HttpResponse
from django.views.generic.base import TemplateView
from django.utils.decorators import method_decorator
from django.contrib.auth.decorators import login_required, user_passes_test
from django.shortcuts import redirect

from mwlearnapp import data

register = template.Library()


@register.filter(name='private')
def private(obj, attribute):
	return getattr(obj, attribute)


@login_required
def data_view(request):
	result = data.process_request(request)
	return HttpResponse(json.dumps(result), mimetype='application/json')


@login_required
def log_append_view(request):
	post = request.POST
	result = data.log_write(request.user.username,
							session_date=post['session_date'],
							start_time=post['start_time'],
							end_time=post['end_time'],
							num_activity=post['num_activity'],
							num_new_activity=post['num_new_activity']
							)
	return HttpResponse(json.dumps(result), mimetype='application/json')


@login_required
def log_delete_view(request):
	post = request.POST
	result = data.log_delete(request.user.username,
							entry_id=post['entry_id']
							)
	return HttpResponse(json.dumps(result), mimetype='application/json')


def login_success(request):
	if request.user.is_superuser:
		return redirect("status")
	elif user_is_exp(request.user):
		return redirect("experiment")
	else:
		return redirect("log")


def user_is_exp(user):
	return user.groups.filter(name='exp').exists()


def user_is_con(user):
	return user.groups.filter(name='con').exists()


class Home(TemplateView):
	template_name = "index.html"

	def get_context_data(self, **kwargs):
		context = super(Home, self).get_context_data(**kwargs)
		return context


class Experiment(TemplateView):
	template_name = "experiment.html"

	def get_context_data(self, **kwargs):
		context = super(Experiment, self).get_context_data(**kwargs)
		return context

	@method_decorator(login_required)
	@method_decorator(user_passes_test(user_is_exp))
	def dispatch(self, *args, **kwargs):
		return super(Experiment, self).dispatch(*args, **kwargs)


class Log(TemplateView):
	template_name = "log.html"

	def get_context_data(self, **kwargs):
		context = super(Log, self).get_context_data(**kwargs)

		context['sessions'] = data.log_read(self.request.user.username)

		return context

	@method_decorator(login_required)
	@method_decorator(user_passes_test(user_is_con))
	def dispatch(self, *args, **kwargs):
		return super(Log, self).dispatch(*args, **kwargs)


class Status(TemplateView):
	template_name = "status.html"

	def get_context_data(self, **kwargs):
		context = super(Status, self).get_context_data(**kwargs)

		context['user_sessions'] = data.user_sessions()
		return context
