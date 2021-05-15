from flask import Flask
app = Flask(__name__)

@app.route("/")
def helloflask():
	return "Visit my website www.kulonpaa.com"

app.run(debug=True)