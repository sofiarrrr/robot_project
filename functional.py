from flask import Flask, render_template, request, json, make_response, jsonify
import requests
from datetime import datetime, date
from flask_web_log import Log
import time
import random

app = Flask(__name__)
app.config["LOG_TYPE"] = "CSV"
Log(app)

@app.route('/')
def index():
    text = "Initial page open"
    return render_template("index.html", text=text)

@app.route('/api/people/<int:id>/', methods=['GET'])
def people(id):
    if id in range(1,101):
        return {
            "greeting": ["hello", "world"],
            "date": datetime.today()
        }
    else:
        responseText = {'Error':'Page not found','Description':'The requested page does not exist'}
        return make_response(jsonify(responseText), 404)


@app.route('/api/planets/<int:id>/', methods=['GET'])
def planets(id):
    #time.sleep(random.uniform(0.2, 0.5))
    if id in range(1,101):
        return {
            "greeting": ["hello", "world"],
            "date": datetime.today()
        }
    else:
        responseText = {'Error':'Page not found','Description':'The requested page does not exist'}
        return make_response(jsonify(responseText), 404)

@app.route('/api/starships/<int:id>/', methods=['GET'])
def starships(id):
    if id in range(1,101):
        return {
            "greeting": ["hello", "world"],
            "date": datetime.today()
        }
    else:
        responseText = {'Error':'Page not found','Description':'The requested page does not exist'}
        return make_response(jsonify(responseText), 404)

app.run(host='0.0.0.0', port=81, debug=True)
