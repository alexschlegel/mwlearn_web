import json

from django import template
from django.http import HttpResponse
from django.views.generic.base import TemplateView

from mrtapp import data


def data_view(request):
	result = data.process_request(request)
	return HttpResponse(json.dumps(result), mimetype='application/json')


class MRT(TemplateView):
	template_name = "mrtapp/mrt.html"

	def get_context_data(self, **kwargs):
		context = super(MRT, self).get_context_data(**kwargs)
		return context

	#@method_decorator(login_required)
	#@method_decorator(user_passes_test(user_is_exp))
	def dispatch(self, *args, **kwargs):
		return super(MRT, self).dispatch(*args, **kwargs)

