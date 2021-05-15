python3-flask:
  pkg.installed

/tmp/helloflask.py:
  file.managed:
    - source: salt://flask/helloflask.py

python3-flask-sqlalchemy:
  pkg.installed

python3-psycopg2:
  pkg.installed

/tmp/hellodatabase.py:
  file.managed:
    - source: salt://flask/hellodatabase.py