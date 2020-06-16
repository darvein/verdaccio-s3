import os
import json
import pytest
import requests
import subprocess

from requests.auth import HTTPBasicAuth

VERDACCIO_IP_ADDR  = os.environ['VERDACCIO_IP_ADDR']
VERDACCIO_HTTP_URL = "http://{}".format(VERDACCIO_IP_ADDR)
VERDACCIO_USER     = os.environ['HTPASSWD_USER']
VERDACCIO_PASSWORD = os.environ['HTPASSWD_PASSWORD']

@pytest.hookimpl(hookwrapper=True)
def pytest_runtest_makereport(item, call):
    outcome = yield
    report = outcome.get_result()

    test_fn = item.obj
    docstring = getattr(test_fn, '__doc__')
    if docstring:
        report.nodeid = docstring

def run_cmd(cmd):
    try:
        return subprocess.call(cmd, shell=True)
    except subprocess.CalledProcessError as e:
        print(e.output)


def test_verdaccio_http_request():
    res = requests.get(VERDACCIO_HTTP_URL)

    assert res.status_code == 200
    assert 'verdaccio' in res.headers['X-Powered-By']


def get_npm_token(url):
    r = requests.put(
            '{}/-/user/org.couchdb.user:{}'.format(VERDACCIO_HTTP_URL, VERDACCIO_USER), 
            json={'name': '{}'.format(VERDACCIO_USER), 'password':'{}'.format(VERDACCIO_PASSWORD), 'type':'user'}, 
            auth=HTTPBasicAuth('{}'.format(VERDACCIO_USER), '{}'.format(VERDACCIO_PASSWORD)))
    return json.loads(r.text.encode('utf-8'))['token']


def test_npm_publish():
    token = get_npm_token(VERDACCIO_HTTP_URL)
    cmd = "npm set registry {}".format(VERDACCIO_HTTP_URL)
    cmd += "; npm set //{}/:_authToken {}".format(VERDACCIO_IP_ADDR, token)
    cmd += "; cd dummy-npm-package && npm publish"
    assert run_cmd(cmd) == 0


def test_npm_unpublish():
    token = get_npm_token(VERDACCIO_HTTP_URL)
    cmd = "npm set registry {}".format(VERDACCIO_HTTP_URL)
    cmd += "; npm set //{}/:_authToken {}".format(VERDACCIO_IP_ADDR, token)
    cmd += "; cd dummy-npm-package && npm --force unpublish"
    assert run_cmd(cmd) == 0
