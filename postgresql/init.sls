postgresql:
  pkg.installed

'createuser admuser; createdb admuser':
  cmd.run:
    - runas: postgres
    - unless: 'psql -c "\du" | grep admuser'

postgresql.service:
  service.running:
    - name: postgresql
    - watch:
      - cmd: 'createuser admuser; createdb admuser'