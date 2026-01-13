Alla on käytännöllinen lista yleisimmistä väärinkäsityksistä, joita tietokannoista usein esiintyy.

## 1. “Tiedostokansio on tietokanta”

**Väärinkäsitys:**

> “Kaikki data on tässä kansiossa, joten se on meidän tietokantamme.”

**Todellisuus:**

* Kansio on vain **tallennustilaa**
* Tietokanta tarjoaa lisäksi:

  * kyselyt (querying)
  * indeksoinnin
  * samanaikaisuuden hallinnan
  * datan eheyssäännöt

📌 Miksi sillä on väliä:
Ilman DBMS:ää datan käyttö muuttuu manuaaliseksi, virhealttiiksi ja monen käyttäjän tilanteessa turvattomaksi.

---

## 2. “JSON-tiedostot ovat tietokantoja”

**Väärinkäsitys:**

> “Tallennamme kaiken JSON:iin, joten emme tarvitse tietokantaa.”

**Todellisuus:**

* JSON on **dataformaatti**, ei tietokanta
* Siitä puuttuu:

  * tehokas kyselymahdollisuus
  * indeksit
  * transaktiot
  * samanaikaisen käytön hallinta

📌 JSON sopii hyvin:

* konfigurointiin
* datan siirtoon

📌 Ei tähän:

* pitkäaikaiseen, monen käyttäjän datan säilytykseen

---

## 3. “Google Sheets / Airtable ovat tietokantoja”

**Väärinkäsitys:**

> “Käytämme Airtablea, joten meillä on taustalla tietokanta.”

**Todellisuus:**

* Nämä ovat **datatyökaluja**, eivät täysiverisiä tietokantoja
* Ne:

  * piilottavat monimutkaisuutta
  * on optimoitu ihmisille, eivät järjestelmille

📌 Miksi sillä on väliä:
Ne eivät skaalaudu hyvin automaatioon, raskaaseen kyselyyn tai backend-logiikkaan.

---

## 4. “Datan tallentaminen = tietokantasuunnittelu”

**Väärinkäsitys:**

> “Kunhan data tallentuu, tietokanta on oikein.”

**Todellisuus:**
Oikea tietokantasuunnittelu sisältää mm.:

* relaatiot
* rajoitteet
* normalisoinnin
* indeksointistrategian

📌 Huono suunnittelu johtaa usein:

* duplikaattidataan
* epäjohdonmukaisiin arvoihin
* vaikeasti korjattaviin bugeihin myöhemmin

---

## 5. “Jos se on pysyvää, se on tietokanta”

**Väärinkäsitys:**

> “Data säilyy uudelleenkäynnistyksen yli, joten se on käytännössä tietokanta.”

**Todellisuus:**
Pysyvyys ≠ tietokanta. Tietokanta tarjoaa myös:

* kyselykielen
* samanaikaisuusturvan
* datan validoinnin
* palautumismekanismit

📌 Pysyvä tekstitiedosto ≠ tietokanta.

---

## 6. “Frontend-tallennus on tietokanta”

**Väärinkäsitys:**

> “Tallennamme datan localStorageen, joten käyttäjillä on tietokanta.”

**Todellisuus:**

* Selaimen tallennus on:

  * asiakaspäässä (client-side)
  * epäluotettavaa (untrusted)
  * rajallista
  * käyttäjän muokattavissa

📌 Se sopii:

* asetuksiin
* väliaikaiseen tilaan

📌 Ei koskaan:

* jaettuun tai auktoritatiiviseen (”totuuden lähde”) dataan

---

## 7. “Jos siinä on rivejä ja sarakkeita, se on relaatiomalli”

**Väärinkäsitys:**

> “Se näyttää taulukolta, joten se on relaatiotietokanta.”

**Todellisuus:**
Relaatiotietokanta edellyttää:

* määritellyn skeeman
* avaimet (primary/foreign)
* viite-eheyden

📌 CSV, jossa on rivejä ja sarakkeita, **ei ole relaatiomalli** – se on vain taulukkomuotoista dataa.

---

## 8. “Tietokanta on vain iso datasaavi”

**Väärinkäsitys:**

> “Tietokanta vain säilyttää tavaraa.”

**Todellisuus:**
Tietokannat valvovat **sääntöjä**, kuten:

* ei duplikaatti-ID:itä
* viitteet ovat valideja
* oikeat tietotyypit

📌 Tietokannat ovat *aktiivisia järjestelmiä*, eivät passiivisia säilytysastioita.

---

## 9. “Sovelluslogiikka takaa datan oikeellisuuden”

**Väärinkäsitys:**

> “Sovellus tarkistaa kaiken, joten tietokantaan ei tarvita sääntöjä.”

**Todellisuus:**

* sovellukset muuttuvat
* bugeja tapahtuu
* useat sovellukset voivat käyttää samaa tietokantaa

📌 Tietokanta on **viimeinen puolustuslinja** datan oikeellisuudelle.

---

## 10. “Tiedoston poistaminen = datan turvallinen poisto”

**Väärinkäsitys:**

> “Poistimme tiedoston, joten data on poissa.”

**Todellisuus:**
Tietokannat:

* seuraavat muutoksia
* tukevat rollbackeja
* mahdollistavat palautuksen

📌 Tiedoston poistaminen on usein peruuttamatonta ja riskialtista tärkeälle datalle.

---

## 11. “Pienet projektit eivät tarvitse oikeaa tietokantaa”

**Väärinkäsitys:**

> “Tämä on vain pieni sovellus, käytetään tiedostoja.”

**Todellisuus:**
Pienetkin sovellukset hyötyvät tietokannasta, koska:

* rakenne kasvaa nopeasti
* ominaisuudet laajenevat
* myöhempi migraatio on kivuliasta

📌 Tietokannat eivät liity kokoon – vaan **oikeellisuuteen ja rakenteeseen**.

---

## 12. “Tietokanta = backend”

**Väärinkäsitys:**

> “Meillä on tietokanta, joten meillä on backend.”

**Todellisuus:**
Backend sisältää yleensä:

* liiketoimintalogiikan
* autentikoinnin
* validoinnin
* API:t

📌 Tietokanta on yksi **komponentti**, ei koko järjestelmä.

---

## 13. “Tietokanta” vs. “DBMS” (käytetään samana asiana)

**Väärinkäsitys:**

> “PostgreSQL *on* tietokanta.”

**Todellisuus:**

* **tietokanta** = itse rakenteinen data (kannan sisältö)
* **DBMS** (Database Management System) = ohjelmisto, joka tallentaa, kyselyttää, suojaa ja hallitsee tuota dataa

📌 PostgreSQL, MySQL, MongoDB jne. ovat **DBMS:iä**, eivät itse “tietokanta” (sisältö) termin tiukassa merkityksessä.

---

## 14. SQL on tietokanta

**Väärinkäsitys:**

> “Käytämme SQL:ää MongoDB:n sijaan.”

**Todellisuus:**

* **SQL on kieli**, ei tietokanta
* MongoDB on **DBMS**, SQL on **kyselykieli**

Oikea vertailu:

* PostgreSQL **vs** MongoDB
* SQL **vs** MongoDB Query Language

---

## 15. NoSQL tarkoittaa “ei SQL:ää ollenkaan”

**Väärinkäsitys:**

> “NoSQL-tietokannat eivät tue SQL:ää.”

**Todellisuus:**

* NoSQL tarkoittaa usein **“Not Only SQL”**
* Monet NoSQL-järjestelmät tukevat:

  * SQL-tyylistä syntaksia
  * SQL-yhteensopivuuskerroksia
  * hybridikyselyä

📌 Ero liittyy **tietomalliin ja rajoitteisiin**, ei siihen “saako SQL:ää käyttää”.

---

## 16. Relaatiomalli = vanha / NoSQL = moderni

**Väärinkäsitys:**

> “Relaatiotietokannat ovat vanhentuneita.”

**Todellisuus:**

* relaatiotietokantoja:

  * kehitetään aktiivisesti
  * voidaan skaalata erittäin pitkälle
  * käyttää valtaosa suurista järjestelmistä
* NoSQL syntyi ratkaisemaan **tiettyjä ongelmia**, ei korvaamaan SQL:ää kaikkialla

📌 Valinta tehdään **käyttötapauksen**, ei iän perusteella.

---

## 17. Taulut vs. taulukkolaskenta

**Väärinkäsitys:**

> “Tietokannan taulu on kuin Excel-taulukko.”

**Todellisuus:**
Ne näyttävät samalta, mutta:

* taulut valvovat **skeemoja, tyyppejä ja rajoitteita**
* tukevat **transaktioita**
* tukevat **indeksejä ja joineja**
* on suunniteltu **samanaikaiseen käyttöön**

📌 Taulukkolaskenta on ihmisille; tietokantataulu järjestelmille.

---

## 18. ACID tarkoittaa “hidasta”

**Väärinkäsitys:**

> “ACID-transaktiot heikentävät suorituskykyä.”

**Todellisuus:**

* ACID takaa **oikeellisuuden**, ei hitauden
* modernit tietokannat toteuttavat ACID:n **hyvin tehokkaasti**
* monet suorituskykyongelmat johtuvat:

  * huonosta indeksoinnista
  * huonoista kyselyistä
  * liiallisesta datan hakemisesta (overfetching)

📌 Oikeellisuusongelmat tulevat usein kalliimmiksi kuin suorituskyvyn optimointi.

---

## 19. Indeksit nopeuttavat kaikkea

**Väärinkäsitys:**

> “Lisätään vain lisää indeksejä.”

**Todellisuus:**
Indeksit:

* nopeuttavat **lukuja**
* hidastavat **kirjoituksia**
* kasvattavat **levynkäyttöä**

Yli-indeksointi on yleinen antipattern.

---

## 20. Joinit ovat aina huonoja

**Väärinkäsitys:**

> “Joinit eivät skaalaudu.”

**Todellisuus:**

* joinit ovat yksi relaatiotietokantojen **ydinvahvuuksista**
* ongelmia aiheuttavat usein huono skeemasuunnittelu tai puuttuvat indeksit
* moni denormalisoi turhaan tämän myytin vuoksi

📌 Hyvin indeksoidut joinit skaalautuvat erittäin hyvin.

---

## 21. ORM poistaa tarpeen ymmärtää tietokantoja

**Väärinkäsitys:**

> “Kun käytän ORM:ää, en tarvitse SQL-osaamista.”

**Todellisuus:**

* ORM:t **tuottavat SQL:ää**, eivät korvaa sitä
* tietokannan väärinymmärrys johtaa helposti:

  * N+1-kyselyongelmiin
  * tehottomiin kyselyihin
  * virheellisiin transaktioihin

ORM:t ovat tuottavuustyökaluja, eivät tietokannan “poistajia”.

---

## 22. Skeematon tarkoittaa “ei rakennetta”

**Väärinkäsitys:**

> “NoSQL-tietokannoissa ei ole skeemaa.”

**Todellisuus:**

* niissä on usein **implisiittinen skeema**
* skeeman valvonta siirtyy tietokannasta:

  * sovellukseen
  * validointikerroksiin

Valvomaton skeema ≠ rakenteeton data.

---

## 23. Yksi tietokanta per sovellus on aina paras

**Väärinkäsitys:**

> “Sovelluksen pitäisi käyttää vain yhtä tietokantaa.”

**Todellisuus:**
Monet järjestelmät käyttävät **polyglot persistence** -mallia:

* relaatiokanta transaktioille
* hakukone täystekstihakuun
* välimuisti suorituskykyyn
* aikasarjakanta metriikoille

Jokainen tietokanta ratkaisee eri ongelman.

---

## 24. Skaalaus = siirtyminen NoSQL:ään

**Väärinkäsitys:**

> “Vaihdetaan NoSQL:ään, kun skaalaamme.”

**Todellisuus:**
Useimmat skaalausongelmat ratkeavat:

* indeksoinnilla
* kyselyoptimoinnilla
* välimuistilla
* luku-replikoilla
* vertikaalisella skaalauksella

Tietokannan vaihtaminen on usein **viimeinen** ratkaisu, ei ensimmäinen.

---

## 25. Tietokantavalinta on kertapäätös

**Väärinkäsitys:**

> “Meidän on valittava täydellinen tietokanta nyt.”

**Todellisuus:**

* skeemat muuttuvat
* kuormat muuttuvat
* järjestelmät kasvavat

Hyvät järjestelmät suunnitellaan **sopeutuviksi**, ei varhaisten oletusten vangiksi.
