libapache2-mod-wsgi-py3:
  pkg.installed

/etc/skel/public_wsgi:
  file.directory

/home/sami/public_wsgi:
  file.directory:
    - mode: "0755"

/etc/apache2/sites-available/wsgi.conf:
  file.managed:
    - source: salt://public_wsgi/wsgi.conf

'a2ensite wsgi.conf; a2dissite 000-default.conf':
  cmd.run:
    - watch:
      - file: /etc/apache2/sites-available/wsgi.conf

/home/sami/public_wsgi/test.wsgi:
  file.managed:
    - source: salt://public_wsgi/test.wsgi

/home/sami/public_wsgi/helloworld.py:
  file.managed:
    - source: salt://public_wsgi/helloworld.py

/etc/skel/public_wsgi/test.wsgi:
  file.managed:
    - source: salt://public_wsgi/test.wsgi

/etc/skel/public_wsgi/helloworld.py:
  file.managed:
    - source: salt://public_wsgi/helloworld.py

apache2restartwsgi:
  service.running:
    - name: apache2
    - watch:
      - file: /etc/apache2/sites-available/wsgi.conf