from flask import Flask
app = Flask(__name__)

@app.route("/")
def helloflask():
	return "Hello flask dev-environment! Visit my website www.kulonpaa.com"

app.run(debug=True)