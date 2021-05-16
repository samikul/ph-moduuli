/usr/local/bin/usepublicdirs:
  file.managed:
    - source: salt://usepublicdirs/usepublicdirs
    - mode: "0755"