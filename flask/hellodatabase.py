# Based on code written by Tero Karvinen (2017)
# http://terokarvinen.com/2017/09/28/database-connection-from-python-flask-to-postgre-using-raw-sql/index.html?fromSearch=
# Visit Tero's website terokarvinen.com

# Code modified for learning purposes

from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
db = SQLAlchemy(app)

app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql:///admuser'

def sql(rawSql, sqlVars={}):
 "Execute raw sql, optionally with prepared query"
 assert type(rawSql)==str
 assert type(sqlVars)==dict
 res=db.session.execute(rawSql, sqlVars)
 db.session.commit()
 return res

@app.before_first_request
def initDBforFlask():
 sql("CREATE TABLE IF NOT EXISTS colors (id SERIAL PRIMARY KEY, name VARCHAR(100) UNIQUE);")
 sql("INSERT INTO colors(name) VALUES ('Red')  ON CONFLICT (name) DO NOTHING;")
 sql("INSERT INTO colors(name) VALUES ('Blue')  ON CONFLICT (name) DO NOTHING;")
 sql("INSERT INTO colors(name) VALUES ('Green')  ON CONFLICT (name) DO NOTHING;")
 sql("INSERT INTO colors(name) VALUES ('Yellow')  ON CONFLICT (name) DO NOTHING;")

@app.route("/")
def colors():
 res = db.session.execute("SELECT * FROM colors;", {})
 return str(list(res))
 
app.run(debug=True)
