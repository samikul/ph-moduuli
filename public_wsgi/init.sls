libapache2-mod-wsgi-py3:
  pkg.installed

/etc/skel/public_wsgi:
  file.directory

/etc/apache2/sites-available/wsgi.conf:
  file.managed:
    - source: salt://public_wsgi/wsgi.conf

'a2ensite wsgi.conf; a2dissite 000-default.conf':
  cmd.run:
    - watch:
      - file: /etc/apache2/sites-available/wsgi.conf

/home/admuser/public_wsgi/test.wsgi:
  file.managed:
    - source: salt://public_wsgi/test.wsgi

/home/admuser/public_wsgi/helloworld.py:
  file.managed:
    - source: salt://public_wsgi/helloworld.py

apache2restartwsgi:
  service.running:
    - name: apache2
    - watch:
      - file: /etc/apache2/sites-available/wsgi.conf
