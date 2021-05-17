# ph-moduuli
Salt-moduuli, joka konfiguroi palvelimen valmiiksi Flask web-applikaatoiden testikehittämiseen

https://github.com/samikul/PalvelintenHallinta-ICT4TN022-3011/wiki/h7

## Käyttöönotto

### Salt-arkkitehtuurin käyttöönotto

Luo yhteys palvelimelle
```
$ ssh root@xx.xxx.xx.xxx
```
```
root@devdroplet:~# apt-get update
root@devdroplet:~# apt-get install -y salt-minion
```
Lisää masterin osoite ja nimeä minion
```
root@devdroplet:~# nano /etc/salt/minion
...
master: 159.89.9.104
id: moduuliminion
...
```
Käynnistä minion uudelleen
```
root@devdroplet:~# systemctl restart salt-minion.service
```
Käynnistä master uudelleen
```
$ sudo systemctl restart salt-master.service
```
Tarkista, että master löytää minionin ja hyväksy se
```
$ sudo salt-key
$ sudo salt-key -a moduuliminion
```
Testaa yhteyden toimivuus ja minionin järjestelmän käynnissäolo
```salt
$ sudo salt moduuliminion test.ping
moduuliminion:
    True
```
Luo käyttäjä `sami`, anna `sudo`-oikeudet ja kirjaudu ulos
```
root@devdroplet:~# usermod -aG sudo sami
root@devdroplet:~# usermod -aG adm sami
root@devdroplet:~# exit
```
Kirjaudu sisään uudella käyttäjällä
```
$ ssh sami@46.101.197.127
```
Lukitse juurikäyttäjä ja estä sillä sisäänkirjautuminen
```
$ sudo usermod --lock root
$ sudoedit /etc/ssh/sshd_config
# ...
PermitRootLogin no
# ...
```
Testaa yhteys
```salt
$ sudo salt moduuliminion test.ping
moduuliminion:
    True
```
Aja tila
```
$ sudo salt moduuliminion state.highstate
```
```salt
...
Summary for moduuliminion
-------------
Succeeded: 31 (changed=29)
Failed:     0
-------------
Total states run:     31
Total run time:  113.646 s
```
Aja moduulin skripti minionilla
```
$ usepublicdirs 
'/etc/skel/public_html' -> '/home/sami/public_html'
'/etc/skel/public_html/index.html' -> '/home/sami/public_html/index.html'
```
Testaa tuotanto-Flask-webappin toimivuus
```
$ curl localhost
```

![kuva](https://user-images.githubusercontent.com/58463139/118478037-14250280-b718-11eb-9532-d3b819814ac6.png)


[Salt Quickstart – Salt Stack Master and Slave on Ubuntu Linux](https://terokarvinen.com//2018/salt-quickstart-salt-stack-master-and-slave-on-ubuntu-linux/index.html?fromSearch=) (Tero Karvinen, 2018).
