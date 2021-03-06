# Sami Kulonpää

Visit my website [kulonpaa.com](https://kulonpaa.com/).

## Palvelimen konfigurointi Saltin avulla Flask testikehitykseen ja tuotantokelpoiseen julkaisuun

Tämä on Haaga-Helia Ammattikorkeakoulun Palvelinten Hallinta - ICT4TN022-3011 opintojakson kurssityö, jonka tarkoituksena on rakentaa oma keskitettyyn hallintaan tarkoitettu moduuli. Tarkempi tehtävänanto löytyy [kurssisivuilta](https://terokarvinen.com/2021/configuration-management-systems-palvelinten-hallinta-ict4tn022-spring-2021/#h7-oma-moduli). Opintojakson opettaja on [Tero Karvinen](https://terokarvinen.com/).

### Moduuli-info
Moduulini:
- asentaa Apache2 palvelinohjelman, vaihtaa sen oletussivun ja luo käyttäjäkohtaisen kotisivun
- asentaa palomuurin konfigurointiin tarkoitetun ohjelman, käynnistää sen ja avaa portin SSH-yhteydelle
- asentaa Flaskin ja testaa sen toimivuuden testiympäristössä
- asentaa mod_wsgi:n ja julkaisee tuotantokelpoisen web-applikaation
- asentaa PostgreSQL:n, luo tietokantakäyttäjän sekä käyttäjäkohtaisen tietokannan
  - testaa tietokannan toimivuuden hyödyntäen SQL-Alchemyä Flask-testiympäristössä
- asentaa kehitystyössä hyödyllisiä ohjelmia, kuten `curl`, `git`, ja `wget`
- lisää skriptin `usepublicdirs`, joka lisää käyttäjähakemistoihin kehitystyöhön vaaditut hakemistot ja tiedostot.

![kuva](https://user-images.githubusercontent.com/58463139/118494957-5d328200-b72b-11eb-9447-3ef0ec8ba523.png)

### Lisenssi
Tätä materiaalia saa kopioida ja muokata [GNU General Public License (versio 3)](https://www.gnu.org/licenses/gpl-3.0.html) mukaisesti.

### Moduulin hakemistopuu
```
/srv/salt/
├── apache2
├── flask
├── helloworld
├── postgresql
├── public_html
├── public_wsgi
├── tools
├── ufw
└── usepublicdirs
```

## Raportti
Moduulin työstämisen eri vaiheet on raportoitu [tänne](https://github.com/samikul/PalvelintenHallinta-ICT4TN022-3011/wiki/h7). Muut kurssin aikana työstämäni raportit ja viikkotehtävät löytyvät [täältä](https://github.com/samikul/PalvelintenHallinta-ICT4TN022-3011/wiki). Edeltävän opintojakson [Linux Palvelimet](https://terokarvinen.com/2020/linux-palvelimet-2021-alkukevat-kurssi-ict4tn021-3014/) aikana kirjoittamani raportit löytyvät [täältä](https://github.com/samikul/LinuxPalvelimet-ICT4TN021-3014/wiki).

## Vaatimukset ja käyttöönotto
Moduuli vaatii Salt-Stackin asennuksen ja käyttöönoton. Käyttöönottoapua saa esimerkiksi [Salt in 10 minutes](https://docs.saltproject.io/en/latest/topics/tutorials/walkthrough.html) (Salt Stack, 2021) tai [Salt Quickstart – Salt Stack Master and Slave on Ubuntu Linux](https://terokarvinen.com//2018/salt-quickstart-salt-stack-master-and-slave-on-ubuntu-linux/index.html?fromSearch=) (Tero Karvinen, 2018).

#### Vaihe 1.
Asenna ja ota käyttöön Salt-arkkitehtuuri.

#### Vaihe 2.
Masterin järjestelmässä kloonaa tämä varasto, luo Saltille hakemisto ja kopioi moduuli
```
$ git clone https://github.com/samikul/ph-moduuli.git
$ sudo mkdir /srv/salt
$ sudo cp -r /ph-moduuli/* /srv/salt/
```

### Vaihe 3.
Moduulissa minionia kutsutaan `moduuliminion`. Vaihda nimi `top.sls` tiedostossa toiseen mikäli et käytä samaa nimeä.

### Vaihe 4.
Moduulissa luodaan testiympäristö käyttäjälle `sami`. Vaihda nimen `sami` tilalle unix-käyttäjäsi nimi seuraavissa tiedostoissa:
- `/postgresql/init.sls`
- `/flask/hellodatabase.py`
- `/public_wsgi/init.sls`
- `/public_wsgi/test.wsgi`
- `/public_wsgi/wsgi.conf`

### Vaihe 5.
Ota moduuli käyttöön.
```
$ sudo salt moduuliminion state.highstate
```

### Vaihe 6.
Aja minionilla käyttäjähakemistot lisäävän skriptin ja aloita kehitystyö!
```
$ usepublicdirs
```

___



## Moduulin käyttöönotto
Opintojakson lopputyön vuoksi raportoin oman asennuksen, moduulin käyttöönoton ja tuotantovalmiin applikaation testaamisen sekä tietokantojen toimivuuden varmistamisen.

### Salt master
Asensin masterin
```
$ apt-get update
$ apt-get -y install salt-master
```
Pidensin yhteyden aikakatkaisua 300 sekuntiin (5min)
```
- sudoedit /etc/salt/master
...
# Set the default timeout for the salt command and api. The default is 5
# seconds.
timeout: 300
...
```
Käynnistin masterin uudelleen
```
$ sudo systemctl restart salt-master.service
```
### Salt-minion
Loin yhteyden palvelimelle
```
$ ssh root@xx.xxx.xx.xxx
```
```
root@devdroplet:~# apt-get update
root@devdroplet:~# apt-get install -y salt-minion
```
Lisäsin masterin IP-osoitteen ja nimesin minionin
```
root@devdroplet:~# nano /etc/salt/minion
...
master: xxx.xx.x.xxx
id: moduuliminion
...
```
Käynnistin minionin uudelleen
```
root@devdroplet:~# systemctl restart salt-minion.service
```
Käynnistin masterin uudelleen
```
$ sudo systemctl restart salt-master.service
```
Tarkistin, että master löysin minionin avaimen ja hyväksyin (`--accept`) yhteyden masterin ja minionin välille
```
$ sudo salt-key
$ sudo salt-key -a moduuliminion
```
Testasin yhteyden toimivuuden ja minionin järjestelmän käynnissäolon
```salt
$ sudo salt moduuliminion test.ping
moduuliminion:
    True
```
Loin käyttäjän `sami`, annoin `sudo`-oikeudet ja kirjauduin ulos
```
root@devdroplet:~# usermod -aG sudo sami
root@devdroplet:~# usermod -aG adm sami
root@devdroplet:~# exit
```
Kirjauduin sisään uudella käyttäjällä
```
$ ssh sami@xx.xx.xxx.xxx
```
Lukitsin juurikäyttäjän ja estin sillä sisäänkirjautumisen
```
$ sudo usermod --lock root
$ sudoedit /etc/ssh/sshd_config
# ...
PermitRootLogin no
# ...
```
Testasin yhteyden
```salt
$ sudo salt moduuliminion test.ping
moduuliminion:
    True
```
Ajoin tilan
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
Ajoin moduulin skriptin minionilla
```
$ usepublicdirs 
'/etc/skel/public_html' -> '/home/sami/public_html'
'/etc/skel/public_html/index.html' -> '/home/sami/public_html/index.html'
```

### Testaus

Testasin masterina arkkitehtuurin toimivuuden
```salt
sami@master:~$ sudo salt moduuliminion state.apply helloworld
moduuliminion:
----------
          ID: /tmp/helloworld.txt
    Function: file.managed
      Result: True
     Comment: File /tmp/helloworld.txt is in the correct state
     Started: 13:01:44.541985
    Duration: 30.597 ms
     Changes:   

Summary for moduuliminion
------------
Succeeded: 1
Failed:    0
------------
Total states run:     1
Total run time:  30.597 ms
```

Testasin palomuurin toiminnan ja sen, että portti 22 on auki
```
$ sudo ufw verbose
```

![kuva](https://user-images.githubusercontent.com/58463139/118492567-cebd0100-b728-11eb-9df2-8735c7db5010.png)

Testasin tuotantoon tarkoitetun Flask-webappin toimivuuden ja `curl` apuohjelman asentumisen
```
$ curl localhost
```

![kuva](https://user-images.githubusercontent.com/58463139/118494957-5d328200-b72b-11eb-9447-3ef0ec8ba523.png)

Testasin tietokannan ja SQL-Alchemyn toimivuuden käynnistämällä tietokantaa testaavan applikaation
```
$ python3 /tmp/hellodatabase.py
```
Avasin toisen terminal-ikkunan, loin palvelimelle ssh-yhteyden ja testasin tietokantojen toimivuuden.
```
$ ssh sami@xx.xxx.xx.xxx
$ curl localhost:5000
```

![kuva](https://user-images.githubusercontent.com/58463139/118479041-39664080-b719-11eb-8835-bac0679e6740.png)

Testasin testiympäristöön tarkoitetun Flask-webappin toimivuuden. Keskeytin edellisen ohjelman <kbd>CTRL</kbd>+<kbd>C</kbd>. Toisessa terminaali-ikkunassa ajoin ohjelman
```
$ python3 /tmp/helloflask.py
```
Toisessa ikkunassa testasin ohjelman toimivuuden
```
$ curl localhost:5000
```

![kuva](https://user-images.githubusercontent.com/58463139/118667475-b7e7de80-b7fc-11eb-8513-019dded7fa94.png)

---
Palautuksen jälkeen tapahtunutta:
muokattu 18.5
- kirjoitusvirheiden korjaamista
- `helloflask.py` ohjelman testaus
- moduuli luo hakemiston `/etc/skel/public_wsgi/`
