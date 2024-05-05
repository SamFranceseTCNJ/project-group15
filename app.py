#! /usr/bin/python3

"""
This is an example Flask | Python | Psycopg2 | PostgreSQL
application that connects to the 7dbs database from Chapter 2 of
_Seven Databases in Seven Weeks Second Edition_
by Luc Perkins with Eric Redmond and Jim R. Wilson.
The CSC 315 Virtual Machine is assumed.

John DeGood
degoodj@tcnj.edu
The College of New Jersey
Spring 2020

----

One-Time Installation

You must perform this one-time installation in the CSC 315 VM:

# install python pip and psycopg2 packages
sudo pacman -Syu
sudo pacman -S python-pip python-psycopg2 python-flask

----

Usage

To run the Flask application, simply execute:

export FLASK_APP=app.py 
flask run
# then browse to http://127.0.0.1:5000/

----

References

Flask documentation:  
https://flask.palletsprojects.com/  

Psycopg documentation:
https://www.psycopg.org/

This example code is derived from:
https://www.postgresqltutorial.com/postgresql-python/
https://scoutapm.com/blog/python-flask-tutorial-getting-started-with-flask
https://www.geeksforgeeks.org/python-using-for-loop-in-flask/
"""

import psycopg2
from config import config
import matplotlib.pyplot as plt
import numpy as np
from io import BytesIO
import base64
import matplotlib as mpl
from flask import Flask, render_template, request

# Connect to the PostgreSQL database server
def connect(query):
    conn = None
    try:
        # read connection parameters
        params = config()
 
        # connect to the PostgreSQL server
        print('Connecting to the %s database...' % (params['database']))
        conn = psycopg2.connect(**params)
        print('Connected.')
      
        # create a cursor
        cur = conn.cursor()
        
        # execute a query using fetchall()
        cur.execute(query)
        rows = cur.fetchall()

        # close the communication with the PostgreSQL
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
            print('Database connection closed.')
    # return the query result from fetchall()
    return rows

def read_file_to_string(filename):
	file = open(filename, 'r')
	content = file.read()
	return content

def makeVigorGraph(xData, yData, xName, yName):
	fig, ax = plt.subplots()
	bar_labels = xData
	ax.bar(xData, yData, label=bar_labels)
	ax.set_ylabel(yName)

def birthWeightGraph(maleWeights, femaleWeights):
	n_bins = 20

	fig, axs = plt.subplots(1, 2, sharey=True, tight_layout=True)

	# We can set the number of bins with the *bins* keyword argument.
	axs[0].hist(maleWeights, bins=n_bins)
	axs[1].hist(femaleWeights, bins=n_bins)

# app.py
app = Flask(__name__)


# serve form web page
@app.route("/")
def form():
    return render_template('my-form.html')

# handle venue POST and serve result web page
@app.route('/query-1', methods=['POST'])
def venue_handler():
  	#read queries into string
	if(request.form['select'] == 'average adg'):
		query = read_file_to_string('query.txt')
		#make bar graph for adg
		combinedData = connect(query)
		vigorScores = []
		adg = []
		for i in range(0, len(combinedData)):
			if(combinedData[i][0] != 71):
				vigorScores.append(combinedData[i][0])
				adg.append(combinedData[i][1])
		makeVigorGraph(vigorScores, adg, "vigor score", "average daily gain")
	else:
		query = read_file_to_string('lifespan query.txt')
		#bar graph for lifespan
		query = read_file_to_string('lifespan query.txt')
		combinedData = connect(query)
		vigorScores = []
		lifespans = []
		for i in range(0, len(combinedData)):
			vigorScores.append(combinedData[i][0])
			lifespans.append(combinedData[i][1])
		makeVigorGraph(vigorScores, lifespans, "vigor score", "lifespan in days")

	rows = connect(query)
	heads = ['vigor', request.form['select']]

	buf = BytesIO()
	plt.savefig(buf, format="png")
	buf.seek(0)
	data = base64.b64encode(buf.getvalue()).decode()
	plt.close()

	return render_template('my-result.html', rows=rows, heads=heads, data=data)

# handle query POST and serve result web page
@app.route('/year-input', methods=['POST'])
def query_handler():
	#get query from text file
	query = read_file_to_string('query2.txt')
	#take input from form
	year1 = request.form['query1']
	year2 = request.form['query2']
	
	#years default to 2012 and 2023 if not in range
	if(int(year1) < 2012 or int(year1) > 2023):
		year1 = "2012"
	if(int(year2) < 2012 or int(year2) > 2023):
		year2 = "2023"

	#execute query and render html
	rows = connect("SELECT * FROM GoatBW WHERE Year=" + year1 + " OR Year=" + year2 + ";")
	heads = ['year', 'average birthweight']
	return render_template('my-result.html', rows=rows, heads=heads)

@app.route('/gender-input', methods=['POST'])
def male_bw():
	if(request.form['select'] == 'Male avg birth weight'):
		rowsBW = connect("SELECT * FROM MaleBW;")
		columns = ['year', 'male average birthweight']
	else:
		rowsBW = connect("SELECT * FROM FemaleBW;")
		columns = ['year', 'female average birthweight']

	#second query
	years = ("2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023")
	maleBWs = []
	femaleBWs = []
	for i in range(0, len(years)):
		yearWeight = connect("SELECT Mbw FROM MaleBW WHERE Year=" + years[i] + ";")
		maleBWs.append(yearWeight[0][0])
		yearWeight = connect("SELECT Fbw FROM FemaleBW WHERE Year=" + years[i] + ";")
		femaleBWs.append(yearWeight[0][0])

	birthweightData = {
		"Males": maleBWs,
		"Females": femaleBWs,
	}
	x = np.arange(len(years))  # the label locations
	width = 0.25  # the width of the bars
	multiplier = 0

	fig, ax = plt.subplots(layout='constrained')

	for attribute, measurement in birthweightData.items():
		offset = width * multiplier
		rects = ax.bar(x + offset, measurement, width, label=attribute)
		ax.bar_label(rects, padding=3)
		multiplier += 1

	# Add some text for labels, title and custom x-axis tick labels, etc.
	ax.set_ylabel('Birth Weight')
	ax.set_title('Birth Weights for male and female goats')
	ax.set_xticks(x + width, years)
	ax.legend(loc='upper left', ncols=2)
	#ax.set_ylim(0, 250)

	buf = BytesIO()
	plt.savefig(buf, format="png")
	buf.seek(0)
	data = base64.b64encode(buf.getvalue()).decode()
	plt.close()

	return render_template('my-result.html', rowsBW=rowsBW, columns=columns, data=data)	

@app.route('/all-years', methods=['POST'])
def all_bw():
	rowsBW = connect("SELECT * FROM GoatBW;")
	columns = ["year", "average birth weight"]
	return render_template('my-result.html', rowsBW=rowsBW, columns=columns)
	
	
