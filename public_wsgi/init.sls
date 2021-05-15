libapache2-mod-wsgi-py3:
  pkg.installed

/etc/skel/public_wsgi:
  file.directory

/etc/apache2/sites-available/wsgi.conf:
  file.managed:
    - source: salt://public_wsgi

'a2ensite wsgi.conf; a2dissite 000-default.conf':
  cmd.run