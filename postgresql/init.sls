postgresql:
  pkg.installed

'createuser devuser; createdb devuser':
  cmd.run:
    - runas: postgres
    - unless: 'psql -c "\du" | grep devuser'

postgresql.service:
  service.running:
    - name: postgresql
    - watch:
      - cmd: 'createuser devuser; createdb devuser'