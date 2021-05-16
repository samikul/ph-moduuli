# Based on code written by Tero Karvinen.
# Visit Tero's website terokarvinen.com

# Code modified for learning purposes


from flask import Flask
app = Flask(__name__)

@app.route("/")
def helloworld():
	return "Visit my website kulonpaa.com!\n"
