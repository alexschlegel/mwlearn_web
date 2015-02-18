"""
Django settings for mwlearn project.

For more information on this file, see
https://docs.djangoproject.com/en/1.6/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.6/ref/settings/
"""

import platform
import os

from django.conf.global_settings import TEMPLATE_CONTEXT_PROCESSORS, \
	STATICFILES_FINDERS

#set some stuff based on where we are
ME_DEV = 'grendel'
ME_TEST = 'wertheimer'
ME = platform.node()

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(__file__))

SECURE_DIR = '/var/www/mwlearn/secure/'

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY_LOCATION = os.path.join(SECURE_DIR,'secret_key')
with open(SECRET_KEY_LOCATION) as file:
	SECRET_KEY = file.read()

# SECURITY WARNING: don't run with debug turned on in production!
if ME == ME_DEV:
	DEBUG = True
else:
	DEBUG = False

TEMPLATE_DEBUG = DEBUG

ALLOWED_HOSTS = [
	'wertheimer.dartmouth.edu',
	'localhost',
]

TEMPLATE_DIRS = [os.path.join(BASE_DIR, 'templates')]

# Application definition

INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
	'south',
	'compressor',
#	'djangobower',
    'mwlearnapp',
	'mrtapp',
)

MIDDLEWARE_CLASSES = (
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
)

ROOT_URLCONF = 'mwlearn.urls'

WSGI_APPLICATION = 'mwlearn.wsgi.application'


TEMPLATE_CONTEXT_PROCESSORS += (
	'django.core.context_processors.request',
)


# Database
# https://docs.djangoproject.com/en/1.6/ref/settings/#databases

if ME == ME_DEV:
	DB_USER = 'alex'
elif ME == ME_TEST:
	DB_USER = 'tselab'
else:
	raise Exception("Where am I ? ({0})".format(ME))

DATABASE_PW_LOCATION = os.path.join(SECURE_DIR,'database_pw')
with open(DATABASE_PW_LOCATION) as file:
	DATABASE_PW = file.read()

DATABASES = {
    'default': {
		'ENGINE': 'django.db.backends.postgresql_psycopg2',
		'NAME': 'mwlearn',
		'USER': DB_USER,
		'PASSWORD': DATABASE_PW,
		'HOST': '127.0.0.1',
		'PORT': '5432'
	}
}

# Auth

AUTH_USER_MODEL = 'auth.User'

LOGIN_URL = 'account-login'
LOGIN_REDIRECT_URL = 'login_success'
LOGOUT_URL = 'account-logout'

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.6/howto/static-files/

STATIC_ROOT = os.path.join(BASE_DIR, 'static')
STATIC_URL = '/static/'

STATICFILES_FINDERS += (
	'compressor.finders.CompressorFinder',
)

# compressor
COMPRESS_PRECOMPILERS = (
	('text/x-sass', 'sass "{infile}" "{outfile}"'),
	('text/x-scss', 'sass --scss --compass "{infile}" "{outfile}"'),
	('text/coffeescript', 'coffee --compile --stdio'),
)

COMPRESS_CSS_FILTERS = (
	'compressor.filters.css_default.CssAbsoluteFilter',
	'compressor.filters.cssmin.CSSMinFilter',
)

COMPRESS_JS_FILTERS = (
	'compressor.filters.jsmin.JSMinFilter',
)

# Email
EMAIL_PW_LOCATION = os.path.join(SECURE_DIR,'email_pw')
with open(EMAIL_PW_LOCATION) as file:
	EMAIL_HOST_PASSWORD = file.read()
EMAIL_USE_TLS = True
EMAIL_HOST = 'smtp.gmail.com'
EMAIL_HOST_USER = 'schlegelindustries@gmail.com'
SERVER_EMAIL = EMAIL_HOST_USER
EMAIL_PORT = 587
ADMINS = (
	('Alex', 'schlegel@gmail.com'),
)

# Internationalization
# https://docs.djangoproject.com/en/1.6/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True

USE_TZ = True
