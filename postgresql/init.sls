postgresql:
  pkg.installed

'createuser sami; createdb sami':
  cmd.run:
    - runas: postgres
    - unless: 'psql -c "\du" | grep sami'

postgresql.service:
  service.running:
    - name: postgresql
    - watch:
      - cmd: 'createuser sami; createdb sami'