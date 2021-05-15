/etc/skel/public_html:
  file.directory

/etc/skel/public_html/index.html:
  file.managed:
    - source: salt://public_html/index.html


#/etc/skel/public_html:
#  file.managed:
#    - source: salt://public_html/index.html