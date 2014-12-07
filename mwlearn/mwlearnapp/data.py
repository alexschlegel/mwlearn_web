"""SHORT DESCRIPTION

LONG DESCRIPTION

@author:    Alex Schlegel (schlegel@gmail.com).
created on: 2014-11-07

copyright 2014 Alex Schlegel (schlegel@gmail.com).  all rights reserved.
"""
import json
import time
import datetime
import dateutil.parser as parser
from pymongo import MongoClient
from bson.objectid import ObjectId

from django.contrib.auth.models import User

client = MongoClient()
db = client.mwlearn
training_data = db.training_data
control_data = db.control_data
archive_data = db.archive_data


def process_request(request):
	result = {'success': False}

	if request.method == 'GET':
		data = request.GET
	elif request.method == 'POST':
		data = request.POST
	else:
		return result

	user = request.user.username

	if 'action' in data and 'key' in data:
		result['action'] = data['action']
		result['key'] = data['key']

		if result['action'] == 'read':
			read(user, result)
		elif result['action'] == 'write' and 'value' in data:
			value = json.loads(data['value'])
			write(user, result, value)
		elif result['action'] == 'archive' and 'value' in data:
			archive_time = data['time'] if 'time' in data else None
			value = json.loads(data['value'])
			archive(user, result, value, archive_time)

	return result


def read(user, result):
	key = result['key']

	data = training_data.find_one({'user': user}, {key: True})

	if not (data is None) and key in data:
		result['status'] = 'read'
		result['value'] = data[key]
	else:
		result['status'] = 'nonexistent'
		result['value'] = None

	result['success'] = True


def write(user, result, value):
	key = result['key']

	training_data.update({'user': user}, {"$set": {key: value}}, upsert=True)

	result['value'] = value
	result['status'] = 'write'
	result['success'] = True


def archive(user, result, value, archive_time=None):
	key = result['key']

	update_time = int(round(time.time()*1000))
	if archive_time is None:
		archive_time = update_time
	else:
		archive_time = int(archive_time)

	query = {'user': user, 'time': archive_time}
	data = {
		'user': user,
		'key': key,
		'value': value,
		'time': archive_time,
		'updated': update_time,
	}

	archive_data.update(query, data, upsert=True)

	result['time'] = archive_time
	result['value'] = value
	result['status'] = 'archive'
	result['success'] = True


def log_read(user):
	log = list(control_data.find({'user': user}))
	for entry in log:
		entry['id'] = entry['_id']

	return log


def log_write(user, session_date, start_time, end_time, num_activity, num_new_activity):
	start_time = parser.parse(session_date + " " + start_time)
	end_time = parser.parse(session_date + " " + end_time)

	control_data.insert({
		'user': user,
		'start_time': start_time,
		'end_time': end_time,
		'num_activity': num_activity,
		'num_new_activity': num_new_activity
	})

	return {'success': True}


def log_delete(user, entry_id):
	entry_id = ObjectId(entry_id)

	control_data.remove({'_id': entry_id})

	return {
		'success': True,
		'entry_id': str(entry_id)
	}


def user_sessions():
	ret = {'exp': [], 'con': []}

	for user in User.objects.all():
		if 'exp' in user.groups.values_list('name',flat=True):
			user_group = 'exp'

			d = training_data.find_one(
				{'user': user.username},
				{'sessions_finished': True}
			)
			sessions_finished = d['sessions_finished']['value'] if d else 0

			d = archive_data.find_one(
				{'user': user.username},
				{'time': True}
			)
			start_date = datetime.datetime.fromtimestamp(d['time']/1000 if d else 0)
		else:
			user_group = 'con'

			sessions_finished = control_data.find(
				{'user': user.username}
			).count()

			d = control_data.find_one(
				{'user': user.username},
				{'start_time': True}
			)
			start_date = d['start_time'] if d else datetime.datetime.fromtimestamp(0)

		ret[user_group].append({
			'user': user,
			'sessions_finished': sessions_finished,
			'start_date': start_date,
			'finish_date': start_date + datetime.timedelta(days=28),
		})

	for key in ret:
		ret[key] = sorted(ret[key], key=lambda k: k['start_date'], reverse=True)

	return ret