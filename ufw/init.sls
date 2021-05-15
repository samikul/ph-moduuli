ufw:
  pkg.installed

ufw.service:
  service.running:
    - cmd.run: 'ufw enable'
    - unless: 'ufw enable | grep active'

'ufw allow 22/tcp':
  cmd.run:
    - unless: 'ufw status | grep "22/tcp                     ALLOW       Anywhere"'