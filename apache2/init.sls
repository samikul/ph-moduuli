apache2:
  pkg.installed

/var/www/html/index.html:
  file.managed:
    - source: salt://apache2/index.html

a2enmod userdir:
 cmd.run:
   - creates: /etc/apache2/mods-enabled/userdir.conf

apache2restart:
  service.running:
    - name: apache2
    - watch:
      - file: /var/www/html/index.html
      - cmd: 'a2enmod userdir'