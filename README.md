# Sami Kulonpää

Visit my website [kulonpaa.com](https://kulonpaa.com/).

## Palvelimen konfigurointi Saltin avulla Flask testikehittämiseen ja tuotantokelpoiseen julkaisuun

Repossa on Haaga-Helia Ammattikorkeakoulun Palvelinten Hallinta - ICT4TN022-3011 opintojakson kurssityö, jonka tarkoituksena on rakentaa oma keskitettyyn hallintaan tarkoitettu moduuli. Tarkempi tehtävänanto löytyy [kurssisivuilta](https://terokarvinen.com/2021/configuration-management-systems-palvelinten-hallinta-ict4tn022-spring-2021/#h7-oma-moduli). Tarkempi raportointi moduulin eri työvaiheista löytyy [täältä](https://github.com/samikul/PalvelintenHallinta-ICT4TN022-3011/wiki/h7). Muut kurssin aikana työstämäni raportit ja viikkotehtävät löytyvät [täältä](https://github.com/samikul/PalvelintenHallinta-ICT4TN022-3011/wiki).

### Moduuli-info
Moduulini:
- asentaa Apache2 palvelinohjelman, vaihtaa sen oletussivun ja luo käyttäjäkohtaisen kotisivun
- asentaa palomuurin konfigurointiin tarkoitetun ohjelman, käynnistää sen ja avaa portin SSH-yhteydelle
- asentaa Flaskin ja testaa sen toimivuuden testiympäristössä
- asentaa mod_wsgi:n ja julkaisee tuotantokelpoisen web-applikaation
- asentaa PostgreSQL:n, luo tietokantakäyttäjän sekä tietokannan
  - testaa tietokannan toimivuuden hyödyntäen SQL-Alchemyä Flask-testiympäristössä
- asentaa kehitystyössä hyödyllisiä ohjelmia, kuten `curl`, `git`, ja `wget`
- lisää skriptin `usepublicdirs`, joka lisää käyttäjähakemistoihin kehitystyöhön vaaditut hakemistot.

### Hakemistopuu
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
### Lisenssi
Tätä dokumenttia saa kopioida ja muokata [GNU General Public License (versio 3)](https://www.gnu.org/licenses/gpl-3.0.html) mukaisesti.

## Raportti
Moduulin työstämisen eri vaiheet on raportoitu [tänne](https://github.com/samikul/PalvelintenHallinta-ICT4TN022-3011/wiki/h7).

## Vaatimukset ja käyttöönotto
Moduuli vaatii Salt-Stackin asennuksen ja käyttöönoton. Käyttöönottoapua saa esimerkiksi [Salt in 10 minutes](https://docs.saltproject.io/en/latest/topics/tutorials/walkthrough.html) (Salt Stack, 2021) ja [Salt Quickstart – Salt Stack Master and Slave on Ubuntu Linux](https://terokarvinen.com//2018/salt-quickstart-salt-stack-master-and-slave-on-ubuntu-linux/index.html?fromSearch=) (Tero Karvinen, 2018).
### Vaihe 1.
Asenna ja ota käyttöön Salt-arkkitehtuuri.
#### Vaihe 2.
Kloonaa tämä varasto, luo Saltille hakemisto ja kopioi moduuli
```
$ sudo mkdir /srv/salt
$ sudo cp -r ph-moduuli/* /srv/salt/
```
### Vaihe 3.
Moduulissa minionia kutsutaan `moduuliminion`. Vaihda nimi `top.sls` tiedostossa toiseen mikäli et käytä samaa nimeä.
### Vaihe 4.
Moduulissa luodaan testiympäristö käyttäjälle `sami`. Vaihda nimen `sami` tilalle unix-käyttäjäsi nimi tiedostoissa:
- `/postgresql/init.sls`
- `/flask/hellodatabase.py`
- `/public_wsgi/init.sls`
- `/public_wsgi/test.wsgi`
- `/public_wsgi/wsgi.conf`
### Vaihe 5.
Ota moduuli käyttöön ja aloita kehitystyö
```
$ sudo salt moduuliminion state.highstate
```


## Testaus

Opintojakson lopputyön vuoksi raportoin oman asennuksen, moduulin käyttöönoton ja 

## Salt master
Asenna master
```
$ apt-get update
$ apt-get -y install salt-master
```
Pidennä yhteyden aikakatkaisua esim. 300 sekuntiin (5min)
```
- sudoedit /etc/salt/master
...
# Set the default timeout for the salt command and api. The default is 5
# seconds.
timeout: 300
...
```
Potkaise master käyntiin
```
$ sudo systemctl restart salt-master.service
```
## Salt-minion
Luo yhteys palvelimelle
```
$ ssh root@xx.xxx.xx.xxx
```
```
root@devdroplet:~# apt-get update
root@devdroplet:~# apt-get install -y salt-minion
```
Lisää masterin IP-osoite ja nimeä minion
```
root@devdroplet:~# nano /etc/salt/minion
...
master: xxx.xx.x.xxx
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
Tarkista, että master löytää minionin avaimen ja hyväksy yhteys masterin ja minionin välille
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

Testaa tietokannan toimivuus.
Käynnistä tietokantaa testaava applikaatio
```
$ python3 /tmp/hellodatabase.py
```
Avaa toinen terminal-ikkuna, luo palvelimelle ssh-yhteys ja testaa tietokantojen toimivuus.
```
$ ssh sami@xx.xxx.xx.xxx
$ curl localhost:5000
```

![kuva](https://user-images.githubusercontent.com/58463139/118479041-39664080-b719-11eb-8835-bac0679e6740.png)
