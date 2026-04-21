# Itsetarkistusohje — Resepti- ja ateriasuunnittelutietokanta -projekti

Käytä tätä tarkistuslistaa ennen palautusta varmistaaksesi, että työsi täyttää arviointikriteerit. Ruksaa jokainen suoritettu kohta. Kohdat, joissa on *(pakollinen)*, tarvitaan perusvaiheessa.

**Pisteyhteenveto:** Perus 10 pistettä | Edistynyt 10 pistettä | ORM 5 pistettä | **Yhteensä 25 pistettä**

---

## Perusvaihe (10 pistettä)

### ER-kaavio (2 pistettä)

- [X] *(pakollinen)* Kaikki entiteetit näkyvät (kategoriat, reseptit, ainesosat ja liitostaulut)
- [X] Pääavaimet ja viiteavaimet on merkitty
- [X] Kardinaliteetti on selkeä (1:N, M:N)
- [X] Valinnaiset vs pakolliset attribuutit näkyvät
- [X] Kaavio on luettava (selkeät nimet, ei päällekkäisiä elementtejä)

### Skeema (3 pistettä)

- [X] *(pakollinen)* Kaikki vaaditut taulut ovat olemassa
- [X] Tietotyypit sopivat jokaiselle sarakkeelle
- [X] Rajoitteet on käytetty tarpeen mukaan (NOT NULL, UNIQUE, CHECK)
- [X] Viiteavaimilla on sopiva viite-eheys (mitä tapahtuu poistettaessa)
- [X] Resepti–kategoria -suhde tukee useita kategorioita per resepti
- [X] `schema.sql` suorittuu ilman virheitä tyhjällä tietokannalla

### Esimerkkidata (2 pistettä)

- [X] *(pakollinen)* Vähintään 4 kategoriaa
- [X] Vähintään 6 reseptiä
- [X] Vähintään 12 ainesosaa
- [X] Vähintään 15 resepti–ainesosa -liitosta
- [X] Vähintään 15 resepti–kategoria -liitosta
- [X] Vähintään 2 reseptiä useilla kategorioilla
- [X] Jokaisella reseptillä vähintään 2 ainesosaa
- [X] `seed.sql` suorittuu ilman virheitä skeeman jälkeen

### Kyselyt (3 pistettä)

- [X] *(pakollinen)* Kysely 1: Reseptit kategorioineen — oikea tulos ja järjestys
- [X] Kysely 2: Reseptin ainesosat — oikea tulos ja järjestys
- [X] Kysely 3: Reseptit tietyn ainesosan kanssa — oikea tulos
- [X] Kysely 4: Ainesosamäärä per resepti — oikea GROUP BY ja COUNT
- [X] Kysely 5: Käyttämättömät ainesosat — oikea tulos (ainesosat, joita ei ole missään reseptissä)
- [X] Kysely 6: Keskimääräinen valmistusaika kategorialla — oikea tulos, tyhjät kategoriat käsitelty

---

## Edistyneempi vaihe (10 pistettä) — jos suoritit sen

### Laajennettu ER-kaavio (1 piste)

- [X] Käyttäjät ja opettajat (tai vastaava) näkyvät
- [X] Ateriasuunnitelmat ja niiden linkit käyttäjiin ja resepteihin näkyvät
- [X] Pääavaimet, viiteavaimet ja kardinaliteetti oikein

### Skeeman laajennukset (3 pistettä)

- [X] Taulut käyttäjille ja opettajille (tai rooleille)
- [X] Taulut ateriasuunnitelmille ja suunnitelmariveille
- [X] Viiteavaimet ja rajoitteet oikein
- [X] `schema_advanced.sql` suorittuu ilman virheitä perusskeeman päällä

### Esimerkkidatan laajennukset (1 piste)

- [X] Vähintään 3 käyttäjää
- [X] Vähintään 1 opettaja
- [X] Vähintään 2 ateriasuunnitelmaa
- [X] Jokaisella ateriasuunnitelmalla vähintään 3 reseptimerkintää
- [X] `seed_advanced.sql` suorittuu ilman virheitä

### Indeksit (2 pistettä)

- [X] Indeksit tukevat reseptien hakutta kategorian mukaan
- [X] Indeksit tukevat reseptin ainesosien listaa
- [X] Indeksit tukevat reseptien hakutta ainesosan mukaan
- [X] Indeksit tukevat ainesosien hakutta nimen mukaan
- [X] Indeksit tukevat ateriasuunnitelmien hakutta käyttäjän mukaan
- [X] Indeksit tukevat suunnitelmarivien hakutta reseptin mukaan

### Roolit (2 pistettä)

- [X] Opettajarooli sopivilla oikeuksilla
- [X] Tavallinen käyttäjärooli sopivilla oikeuksilla
- [X] Katselijarooli (vain luku)
- [X] `roles.sql` suorittuu ilman virheitä

### Lisäkyselyt (1 piste)

- [X] Kysely 1: Ateriasuunnitelmat käyttäjällä — oikea tulos
- [X] Kysely 2: Reseptit ateriasuunnitelmassa — oikea tulos paikkatiedoin
- [X] Kysely 3: Käyttäjät ateriasuunnitelmalukumäärineen — sisältää käyttäjät ilman suunnitelmia

---

## Konsolisovellus — ORM-vaihe (5 pistettä) — jos suoritit sen

### Sovellus (5 pistettä)

- [ ] Sovellus yhdistää tietokantaan ORM:ää käyttäen (ei raakaa SQL:ää)
- [ ] Sovellus listaa reseptit (kategorioineen)
- [ ] Yhteysmerkkijono on konfiguraatiossa, ei kovakoodattuna
- [ ] README selittää miten konfiguroida, rakentaa ja ajaa
- [ ] Sovellus rakentuu ja suorittuu onnistuneesti

---

## Ennen palautusta

- [X] Kaikki tiedostot on nimetty oikein (katso Ohjeet)
- [X] Ei salasanoja tai arkaluonteisia tietoja koodissa tai kuvakaappauksissa
- [X] ER-kaavio vastaa skeemaasi
- [X] Olet ajanut koko työnkulun: skeema → seed → kyselyt (ja edistynyt/ORM jos sovellettavissa)

---

## Arvioitu pistemäärä

| Jos suoritit... | Arv. max pisteet |
|-----------------|-------------------|
| Vain perusvaiheen | 10 |
| Perus + edistynyt | 20 |
| Perus + edistynyt + ORM | 25 |

*Osittainen hyväksyntä on mahdollista. Tämä ohje auttaa tunnistamaan puutteet; opettaja käyttää täyttä arviointimatriisia lopullisessa arvioinnissa.*
