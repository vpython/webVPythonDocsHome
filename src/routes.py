# -*- coding: utf-8 -*-

import flask

from . import app

import os


@app.route('/css/<path:filename>')
def css_static(filename):
    return flask.send_from_directory('../css', filename)


@app.route(r'/favicon.ico')
def favicon_static():
    return flask.send_from_directory('../static/images', r'favicon.ico')

@app.route(r'/docs/<path:filename>')
def get_doc(filename):
    return flask.send_from_directory('../docs/', filename)

@app.route('/')
@app.route('/index')
def root():
    return flask.redirect("/docs/VPythonDocs/index.html")
