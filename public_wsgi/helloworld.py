# Based on code written by Tero Karvinen.
# Visit Tero's website terokarvinen.com

# Code modified for learning purposes


from flask import Flask
app = Flask(__name__)

@app.route("/")
def helloworld():
	return "Flask production style web-app is up and running!\n\nVisit my website kulonpaa.com!\n"
