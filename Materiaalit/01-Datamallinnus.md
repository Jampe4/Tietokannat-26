
# **0. Johdanto — Miksi datamallinnus on tärkeää**

Ennen kuin yhtään tietokantaa rakennetaan, meidän täytyy pysähtyä ajattelemaan.

Tietokanta ei ole pelkästään säiliö datalle — se on **strukturoitu esitys todellisuudesta**. Jos tämä esitys on huonosti suunniteltu, tietokannasta tulee sekava, epäjohdonmukainen ja vaikeasti käytettävä.

**Pohjimmiltaan datamallinnus vastaa kolmeen perustavanlaatuiseen kysymykseen:**

- **Mitä asioita maailmassa on, joista välitämme?**
    
- **Mitä tietoa haluamme tallentaa näistä asioista?**
    
- **Miten nämä asiat liittyvät toisiinsa?**
    

Nämä kysymykset muodostavat kaiken tietokantasuunnittelun perustan.

### Analogia: Talon rakentaminen

- Et aloita asettamalla tiiliä satunnaisesti.
    
- Ensin luonnostelet konseptuaalisen idean talosta.
    
- Sitten teet yksityiskohtaiset piirustukset.
    
- Lopuksi rakennat fyysisen rakennuksen.
    

Samalla tavalla tietokannoissa etenemme eri mallinnustasoilla:

- Konseptuaalinen → Looginen → Fyysinen
    

Tämä ei ole ylimääräistä työtä — se on välttämätöntä merkityksellisten ja luotettavien tietokantojen luomiseksi.

---

# **1. Kolme datamallin tasoa**

Moderni tietokantasuunnittelu erottaa tyypillisesti **kolme abstraktiotasoa**. Jokaisella on eri tarkoitus.

[What is data modeling?](https://www.ibm.com/think/topics/data-modeling)

---

## **1.1 Konseptuaalinen datamalli — “Suuri kuva”**

Näitä kutsutaan myös domain-malleiksi, ja ne tarjoavat kokonaiskuvan siitä, mitä järjestelmä sisältää, miten se on järjestetty ja mitkä liiketoimintasäännöt ovat mukana.

**Tarkoitus:**

- Kuvata **pääkäsitteet ja suhteet** toimialueella.
    
- Välittää ideoita liiketoiminnan sidosryhmien, analyytikoiden ja suunnittelijoiden välillä.
    

**Keskeiset ominaisuudet:**

- Korkean tason ja ei-tekninen
    
- Keskittyy merkitykseen, ei rakenteeseen
    
- Välttelee toteutusyksityiskohtia
    
- Ei määrittele:
    
    - Pääavaimia (primary keys)
        
    - Vierasavaimia (foreign keys)
        
    - Tietotyyppejä
        
    - Tauluja
        

**Esimerkki: Konseptuaalinen malli yliopistolle**

Pääkäsitteet:

- Opiskelija
    
- Kurssi
    
- Professori
    
- Laitos
    

Keskeiset suhteet:

- Opiskelija suorittaa Kurssin
    
- Professori opettaa Kurssia
    
- Professori kuuluu Laitokseen
    

**Yhteenveto:**

> Konseptuaalinen malli kertoo meille, _mitä on olemassa ja miten asiat liittyvät toisiinsa_, ei _miten ne tallennetaan_.

---

## **1.2 Looginen datamalli — “Rakenteellinen näkymä”**

Looginen malli tuo mukaan rakenteen, mutta pysyy riippumattomana mistä tahansa tietystä tietokantajärjestelmästä. Se on vähemmän abstrakti ja antaa enemmän yksityiskohtia käsitteistä ja niiden suhteista.

**Tällä tasolla määrittelemme:**

- Entiteetit
    
- Attribuutit
    
- Pääavaimet
    
- Suhteet
    
- Kardinaalisuuden (1:1, 1:N, M:N)
    

Tässä vaiheessa käytetään yleisimmin **ER-kaavioita**.

**Esimerkki (Looginen malli):**

```
Student(student_id, name, email)
Course(course_id, title, credits)

Student >----< Course
```

Tässä:

- Nimeämme tietyt attribuutit
    
- Tunnistamme pääavaimet
    
- Määrittelemme suhteet selkeästi
    

**Silti emme vielä määrittele:**

- SQL-syntaksia
    
- Tarkkoja taulurakenteita
    
- Indeksointistrategioita
    

**Yhteenveto:**

> Looginen malli määrittelee _miltä datan rakenne näyttää_, mutta ei sitä, miten se toteutetaan.

---

## **1.3 Fyysinen datamalli — “Toteutus”**

Tämä on viimeinen vaihe — jossa datasta tulee oikea tietokanta. Fyysinen datamalli määrittelee skeeman siitä, miten data tallennetaan fyysisesti tietokantaan. Se on vähiten abstrakti kaikista tasoista.

Tällä tasolla määrittelemme:

- Varsinaiset taulut
    
- Sarakkeiden tietotyypit
    
- Vierasavaimet
    
- Rajoitteet (constraints)
    
- Indeksit
    

**Esimerkki (Fyysinen malli SQL:ssä):**

```sql
CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    title VARCHAR(100),
    credits INT
);

CREATE TABLE Enrollment (
    student_id INT,
    course_id INT,
    grade CHAR(2),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);
```

**Yhteenveto:**

> Fyysinen malli on paikka, jossa teoriasta tulee toimiva tietokanta.

---

## **1.4 Miten kolme tasoa liittyvät toisiinsa**

|Taso|Fokus|Tyypillinen tulos|
|---|---|---|
|Konseptuaalinen|Datan merkitys|Epämuodolliset kaaviot|
|Looginen|Datan rakenne|ER-kaaviot|
|Fyysinen|Todellinen tallennus|SQL-taulut|

> Jokainen taso tarkentaa edellistä — lisäämällä yksityiskohtia, tarkkuutta ja teknistä spesifisyyttä.

---

# **2. Entiteetit ja attribuutit**

## **2.1 Mikä on entiteetti?**

**Entiteetti** edustaa todellisen maailman objektia tai käsitettä, joka:

- Voidaan yksilöidä
    
- Sisältää merkityksellistä dataa
    
- On relevantti järjestelmälle
    

**Esimerkkejä hyvistä entiteeteistä:**

- Asiakas
    
- Tilaus
    
- Tuote
    
- Työntekijä
    
- Pankkitili
    

**Huonoja entiteettiesimerkkejä:**

- “Tänään”
    
- “Jokin”
    
- “Satunnainen tapahtuma”
    

Nämä ovat epämääräisiä, eivät selkeästi määriteltyjä, eivätkä sovellu strukturoituun tallennukseen.

---

## **2.2 Entiteettityyppi vs. entiteetti-instanssi**

On tärkeää erottaa:

- **Entiteettityyppi** → Yleinen kategoria
    
    - Esimerkki: Opiskelija
        
- **Entiteetti-instanssi** → Yksittäinen todellinen objekti
    
    - Esimerkki (rivi tietokannassa):
        
        - Opiskelija #1001: Alice
            
        - Opiskelija #1002: Bob
            

|StudentId|Name|
|---|---|
|1001|Alice|
|1002|Bob|

Tietokannoissa taulut edustavat **entiteettityyppejä**, ja rivit edustavat **entiteetti-instansseja**.

---

## **2.3 Mikä on attribuutti?**

Attribuutit kuvaavat entiteettejä. Ne vastaavat kysymyksiin kuten:

- Kuka tämä on?
    
- Mikä tämä on?
    
- Milloin tämä tapahtui?
    

**Esimerkki: Order-entiteetti**

Mahdolliset attribuutit:

- order_id
    
- order_date
    
- total_amount
    
- shipping_address
    
- name
    
- title
    

Jokainen rivi Order-taulussa vastaa yhtä todellista tilausta.

---

## **2.4 Attribuuttien tyypit**

### ✅ Yksinkertaiset vs. yhdistetyt attribuutit

- **Yksinkertainen attribuutti**: Ei voi jakaa osiin
    
    - Esimerkki: student_id → numeerinen/merkkijonoarvo, joka pysyy muuttumattomana
        
- **Yhdistetty attribuutti**: Voidaan jakaa osiin
    
    - Esimerkki: address →
        
        - street
            
        - city
            
        - postal_code
            
        - country
            

Miksi jakaa yhdistettyjä attribuutteja?

- Helpompi haku
    
- Parempi datarakenne
    
- Lisää joustavuutta
    

Keskeinen idea on mahdollistaa tarkemmat kyselyt (esim. SQL).

- Esim. jos haluamme hakea opiskelijan sukunimen:
    
    - Jos meillä on vain yksi kenttä nimelle (etunimi + sukunimi yhdessä), joudumme lisäämään ylimääräistä logiikkaa kyselyihin.
        
    - Entä jos opiskelijalla on kolme nimeä?
        
    - Entä jos nimi koostuu useasta osasta?
        
    - Entä jos sukunimi puuttuu?
        
    - Jakamalla nimi etu- ja sukunimeen, haku helpottuu ja virheellinen data on helpompi hallita.
        

---

### ✅ Yksi- vs. moniarvoiset attribuutit

- **Yksiarvoinen**: Yksi arvo per entiteetti
    
    - Esimerkki: birth_date
        
- **Moniarvoinen**: Useita arvoja per entiteetti
    
    - Esimerkki: phone_numbers
        

Relaatiotietokannoissa moniarvoiset attribuutit muunnetaan yleensä erillisiksi tauluiksi.

Esim. [Student] 1 --- < [Phone]

Tarvittaessa käytetään myös **liitostauluja (junction tables)**.

---

### ✅ Johdetut attribuutit

Johdettu attribuutti lasketaan muusta datasta.

Esimerkki:

- Tallennetaan: date_of_birth
    
- Johdetaan: age
    

Tämä välttää redundanssia ja epäjohdonmukaisuutta.

- Iän tapauksessa meidän pitäisi päivittää arvo joka vuosi
    
- Mitä jos päivityskysely epäonnistuu?
    

---

## **2.5 Pääavain — tunniste**

**Pääavain (primary key)** on attribuutti, jota käytetään rivien tunnistamiseen ja sen täytyy täyttää:

- **Uniikkius** — ei duplikaatteja
    
- **Minimaalisuus** — ei tarpeettomia attribuutteja
    
- **Pysyvyys** — ei muutu ajan myötä
    
    - Jos pääavainta täytyy muuttaa, yleensä luodaan uusi rivi ja poistetaan vanha
        

Miksi emme käytä nimeä tai sähköpostia pääavaimena?

- Kaksi ihmistä voi jakaa saman nimen
    
- Sähköposti voi olla jaettu perheenjäsenten välillä
    
- Nimet ja sähköpostit voivat muuttua
    

Siksi käytämme:

- student_id
    
- employee_id
    
- order_id
    

(Toimituskoodit voivat olla uniikkeja, mutta nekin voivat muuttua.)

---
# **3. Suhteet (Relationships)**

Suhteet ovat yksi datamallinnuksen keskeisimmistä käsitteistä. Ne kuvaavat, **miten entiteetit liittyvät toisiinsa todellisessa maailmassa** ja miten nämä yhteydet esitetään tietokannassa.

Ilman suhteita tietokanta olisi vain kokoelma irrallisia tauluja, joilla ei olisi merkityksellisiä yhteyksiä toisiinsa.

---

## **3.1 Mikä on suhde (relationship)?**

**Suhde (relationship)** kuvaa, miten kaksi (tai joskus useampi) entiteetti liittyy toisiinsa.

Voit ajatella suhdetta vastauksena kysymykseen:

> “Miten nämä kaksi asiaa ovat yhteydessä toisiinsa?”

**Esimerkki:**

Oletetaan, että meillä on kaksi entiteettiä:

- Student (Opiskelija)
    
- Course (Kurssi)
    

Näiden välillä on suhde:

- Student **takes** Course  
    (Opiskelija **suorittaa** Kurssin)
    

Tämä suhde antaa tietokannalle merkityksen ja mahdollistaa kyselyt kuten:

- Mitkä opiskelijat ovat millä kursseilla?
    
- Ketkä opiskelijat ovat tietyllä kurssilla?
    
- Mitä kursseja tietty opiskelija suorittaa?
    

**Tärkeä ajatus:**

> Ilman suhteita emme voisi esittää tai kysyä mitään “yhteyksistä” eri asioiden välillä — vain yksittäisiä erillisiä tietoja.

---

## **3.2 Binääriset vs. ternääriset suhteet**

### **Binäärinen suhde (kahden entiteetin välillä)**

Useimmat suhteet ovat **binäärisiä**, eli ne tapahtuvat **kahden entiteetin välillä**.

Tämä on tyypillisin ja helpoimmin mallinnettava tapaus.

**Esimerkki:**

- Student — **takes** — Course
    

Tässä:

- Osallistuvat entiteetit: Student ja Course
    
- Suhde on selkeä ja yksinkertainen: “opiskelija suorittaa kurssin”
    

Suurin osa kurssitason ER-malleista perustuu lähes kokonaan binäärisiin suhteisiin.

---

### **Ternäärinen suhde (kolmen entiteetin välillä)**

Joskus todellisessa maailmassa suhde koskee **kolmea entiteettiä samanaikaisesti**. Tätä kutsutaan **ternääriseksi suhteeksi**.

**Esimerkki:**

- Doctor **treats** Patient **in** Hospital
    

Tässä mukana ovat kolme entiteettiä:

- Doctor (Lääkäri)
    
- Patient (Potilas)
    
- Hospital (Sairaala)
    

Tämä tarkoittaa:

- Lääkäri hoitaa potilasta **tietyssä sairaalassa**
    

Miksi tämä on monimutkaisempi?

Koska:

- Sama lääkäri voi hoitaa eri potilaita eri sairaaloissa
    
- Sama potilas voi olla hoidossa eri lääkäreillä eri sairaaloissa
    

---

### **Miten ternääriset suhteet yleensä toteutetaan?**

Käytännössä relaatiotietokannoissa ternääriset suhteet muunnetaan usein **liitostauluksi (junction table)**, joka yhdistää kaikki kolme entiteettiä.

Esimerkiksi:

```
Treatment(doctor_id, patient_id, hospital_id, treatment_date)
```

Tämä tekee mallista:

- helpommin toteutettavan SQL:ssä
    
- selkeämmän
    
- joustavamman
    

---

## **3.3 Suhteen attribuutit**

Suhteilla voi olla **omia attribuutteja** — eli tietoa, joka ei kuulu pelkästään kumpaankaan osallistuvaan entiteettiin, vaan **itse suhteeseen**.

Tämä on erittäin tärkeä käsite datamallinnuksessa.

---

### **Esimerkki: Student takes Course**

Suhteella “Student takes Course” voi olla attribuutteja kuten:

- grade (arvosana)
    
- semester (lukukausi)
    

Nämä eivät ole:

- Studentin attribuutteja (koska opiskelijalla voi olla eri arvosana eri kursseilla)
    
- Course-attribuutteja (koska kurssilla ei ole yhtä ainoaa arvosanaa)
    

Ne ovat nimenomaan **suhteen attribuutteja** — eli ne kuvaavat _yksittäistä opiskelijan ja kurssin välistä yhteyttä_.

---

### **Mitä tämä tarkoittaa tietokannassa?**

Kun suhteella on omia attribuutteja, se on hyvin vahva merkki siitä, että tarvitsemme **erillisen taulun** tätä suhdetta varten.

Tässä tapauksessa voisimme luoda uuden liitostaulun, esimerkiksi:

- Course_Result  
    tai
    
- Enrollment
    

Tämä taulu voisi sisältää:

```
Enrollment(
    student_id,
    course_id,
    grade,
    semester
)
```

Tässä:

- student_id viittaa Student-tauluun
    
- course_id viittaa Course-tauluun
    
- grade ja semester ovat suhteen attribuutteja
    

---

# **4. Kardinaalisuus**

Kardinaalisuus kuvaa, **kuinka monta instanssia** (riviä) yhdestä entiteetistä voi liittyä toisen entiteetin instanssiin tietyn suhteen kautta.

Toisin sanoen se vastaa kysymykseen:

- “Kun minulla on yksi A, montako B:tä siihen voi liittyä?”
    
- “Kun minulla on yksi B, montako A:ta siihen voi liittyä?”
    

Kardinaalisuus on yksi tärkeimmistä asioista mallissa, koska se vaikuttaa suoraan siihen:

- tarvitaanko vierasavain vai liitostaulu
    
- missä kohtaa (missä taulussa) viittaus sijaitsee
    
- miten estetään duplikaatit ja epäjohdonmukaiset linkitykset
    

---

## **4.1 Yksi-yhteen (1:1)**

**Määritelmä:**  
Jokainen entiteetin A instanssi liittyy **enintään yhteen** entiteetin B instanssiin, ja jokainen entiteetin B instanssi liittyy **enintään yhteen** entiteetin A instanssiin.

**Esimerkkejä:**

- Person ↔ Passport
    
    - yhdellä henkilöllä on tyypillisesti yksi passi
        
- Car ↔ License Plate
    
    - yhdellä autolla on yksi rekisterikilpi
        

**Käytännön tulkinta:**

- Tällainen suhde ei ole kovin yleinen, mutta sitä käytetään esimerkiksi silloin kun:
    
    - jokin tieto halutaan erottaa omaan tauluun (esim. turvallisuussyistä)
        
    - tietty lisäosa on “valinnainen”, mutta jos se on olemassa, sitä on vain yksi
        

**Toteutus tietokannassa (idea):**

- Usein toteutetaan niin, että toisessa taulussa on **vierasavain**, joka on myös **UNIQUE**.
    

Esim. (kuvitteellisesti):

- Passport.person_id on FOREIGN KEY → Person.person_id
    
- Passport.person_id on UNIQUE  
    ⇒ näin varmistetaan 1:1
    

**Huom:** 1:1-suhteessa joudut lähes aina päättämään “kummin päin” viittaus laitetaan, ja tämä päätös liittyy usein valinnaisuuteen (onko passi pakollinen vai valinnainen).

---

## **4.2 Yksi-moneen (1:N)**

**Määritelmä:**  
Yksi A:n instanssi voi liittyä **moneen** B:n instanssiin, mutta jokainen B:n instanssi liittyy **vain yhteen** A:n instanssiin.

**Esimerkkejä:**

- Department employs many Employees
    
    - yhdellä osastolla voi olla monta työntekijää
        
    - mutta työntekijä kuuluu (mallissa) yhteen osastoon
        
- Customer places many Orders
    
    - yhdellä asiakkaalla voi olla monta tilausta
        
    - mutta yksittäinen tilaus kuuluu yhdelle asiakkaalle
        

Tämä on **yleisin** suhde relaatiotietokannoissa.

**Toteutus tietokannassa (sääntö):**

- Vierasavain tulee **N-puolelle** (”monet”-puolelle).
    

Esim.:

- Employee.department_id → Department.department_id
    
- Order.customer_id → Customer.customer_id
    

**Miksi näin?**

- Koska jokainen “monen puolen” rivi tarvitsee tiedon siitä, mihin “yhden puolen” instanssiin se kuuluu.
    

**Tyypillinen virhe:**

- Yritetään tallentaa listaa employee_id-arvoista Department-tauluun (esim. “employees”-kenttä).
    
    - Relaatiomallissa tämä on huono ratkaisu → se tekee hausta ja eheydestä vaikeaa.
        

---

## **4.3 Moni-moneen (M:N)**

**Määritelmä:**  
Yksi A:n instanssi voi liittyä **moneen** B:n instanssiin, ja yksi B:n instanssi voi liittyä **moneen** A:n instanssiin.

**Esimerkki:**

- Student ↔ Course
    
    - kurssilla voi olla monta opiskelijaa
        
    - ja opiskelija voi osallistua moneen kurssiin
        

**Miksi tätä ei voi toteuttaa suoraan?**

Jos yrittäisit toteuttaa tämän suoraan vain yhdellä vierasavaimella, törmäät ongelmaan:

- Jos laitat `course_id` Student-tauluun → opiskelijalla voisi olla vain yksi kurssi
    
- Jos laitat `student_id` Course-tauluun → kurssilla voisi olla vain yksi opiskelija
    

Siksi M:N-suhde täytyy muuntaa rakenteeksi, joka tukee useita linkityksiä.

**Ratkaisu: liitostaulu (junction table)**

M:N toteutetaan aina erillisellä taululla, joka sisältää:

- vähintään kaksi vierasavainta (FK:t)
    
- usein yhdistelmäpääavaimen (composite PK)
    

Esim.:

- Enrollment(student_id, course_id)
    

**Miksi liitostaulu on tärkeä?**

- Ilman sitä syntyy:
    
    - paljon redundanssia
        
    - vaikeasti ylläpidettävä rakenne
        
    - duplikaatteja (sama opiskelija samaan kurssiin monta kertaa)
        
    - rikkoontuva eheys (data ei pysy “yhdessä totuudessa”)
        

**Lisähuomio (hyvin käytännöllinen):**

M:N-suhteella on usein myös omia attribuutteja, kuten:

- semester
    
- grade
    
- enrollment_date
    

Tämä on vahva merkki siitä, että liitostaulu ei ole vain “tekninen pakko”, vaan oikeasti tärkeä osa mallia.

---

## **4.4 Nopea tarkistus: miten tunnistat suhteen tyypin?**

Kun sinulla on kaksi entiteettiä A ja B, tee tämä:

1. Valitse yksi A
    
    - “Kuinka monta B:tä tähän yhteen A:han voi liittyä?”
        
2. Valitse yksi B
    
    - “Kuinka monta A:ta tähän yhteen B:hen voi liittyä?”
        

Tulokset:

- 1 ja 1 ⇒ **1:1**
    
- 1 ja monta ⇒ **1:N**
    
- monta ja monta ⇒ **M:N**
    

---

# **5. Valinnainen vs. pakollinen suhde**

## **5.1 Pakollinen osallistuminen**

Jos osallistuminen on pakollista, entiteetin täytyy olla mukana suhteessa.

Esimerkki:

- Jokaisen Employee:n täytyy kuulua Departmentiin
    
- Jokaisen Studentin täytyy kuulua Universityyn
    

Tietokannassa:

- department_id ei voi olla NULL
    
- university_id ei voi olla NULL
    

---

## **5.2 Valinnainen osallistuminen**

Osallistuminen voi olla vapaaehtoista.

Esimerkki:

- Studentilla voi olla Mentor — tai ei
    

Tietokannassa:

- mentor_id voi olla NULL
    

---

## **5.3 Kardinaalisuuden ja valinnaisuuden yhdistäminen**

Esimerkki:

- Department voi työllistää monta Employeea (1:N)
    
- Voi olla nolla työntekijää (valinnainen)
    
- Jokaisen Employeen täytyy kuulua Departmentiin (pakollinen)
    

Tämä ajattelu on keskeistä hyvälle datamallinnukselle.

---
# **6. Datamallinnusprosessi**

Seuraavassa on käytännöllinen, yleinen ja **vaiheittainen prosessi**, jota voit seurata datamallinnuksessa.

---

## **Vaihe 1: Ymmärrä toimialue ja rajaus (scope)**

**Tavoite:** Ymmärtää, mitä olet mallintamassa — ja yhtä tärkeää, mitä **et** ole mallintamassa.

Lue tehtävänanto tai vaatimusmäärittely huolellisesti ja listaa:

- Mikä järjestelmän tarkoitus on (mihin sitä käytetään?)
    
- Ketkä ovat käyttäjiä (toimijat/sidosryhmät)?
    
- Mitä tehtäviä järjestelmän täytyy tukea (käyttötapaukset)?
    

Määrittele myös rajat:

- Mitä dataa täytyy ehdottomasti tallentaa?
    
- Mikä jää tämän mallinnuksen ulkopuolelle?
    

**Tuotos:**  
Lyhyt rajausdokumentti + lista käyttötapauksista (esim. “ilmoita opiskelija kurssille”, “tallenna arvosana”, “luo uusi tilaus”).

---

## **Vaihe 2: Kerää liiketoimintasäännöt (vaatimukset sääntöinä)**

**Tavoite:** Muuttaa epämääräiset kuvaukset selkeiksi ja yksiselitteisiksi säännöiksi.

Kirjoita säännöt luonnollisella kielellä, esimerkiksi:

- “Jokainen tilaus tehdään täsmälleen yhden asiakkaan toimesta.”
    
- “Asiakas voi tehdä useita tilauksia.”
    
- “Kurssilla voi olla useita opiskelijoita, ja opiskelija voi suorittaa useita kursseja.”
    
- “Työntekijällä voi olla parkkipaikka (valinnainen).”
    

Nämä säännöt ohjaavat suoraan ER-kaavion rakennetta.

**Tuotos:**  
Numeroitu lista liiketoimintasäännöistä (nämä määrittävät, onko mallisi oikein).

---

## **Vaihe 3: Tunnista ehdokkaat entiteeteiksi (substantiivit)**

**Tavoite:** Päätellä, mitkä ovat “asioita”, joista meidän täytyy tallentaa tietoa.

Etsi vaatimuksista substantiiveja ja kysy jokaisesta:

- Onko tämä asia, josta tallennamme dataa?
    
- Onko sillä useita instansseja?
    
- Tarvitseeko se yksilöllisen tunnisteen?
    
- Onko sillä omia attribuutteja?
    

**Yleisiä entiteettejä:**

- Customer (Asiakas)
    
- Order (Tilaus)
    
- Product (Tuote)
    
- Student (Opiskelija)
    
- Course (Kurssi)
    
- Department (Osasto/Laitos)
    

**Tuotos:**  
Lista ehdokkaista entiteeteiksi + lyhyt yhden lauseen määritelmä jokaiselle.

---

## **Vaihe 4: Valitse tunnisteet (pääavaimet) jokaiselle entiteetille**

**Tavoite:** Varmistaa, että jokainen entiteetti-instanssi voidaan yksilöidä.

Jokaiselle entiteetille valitaan pääavain:

- Suosi pysyviä ja uniikkeja tunnisteita, kuten:
    
    - `student_id`
        
    - `order_id`
        
- Vältä epävakaita avaimia, kuten:
    
    - nimi
        
    - sähköposti (voi muuttua)
        
- Jos luonnollista avainta ei ole, käytä keinotekoista avainta (surrogate key), esim. automaattisesti kasvava id.
    

**Tuotos:**  
Entiteettilista päivitettynä pääavaimilla.

---

## **Vaihe 5: Tunnista attribuutit jokaiselle entiteetille**

**Tavoite:** Määritellä, mitä tietoa tallennamme kustakin entiteetistä.

Käy jokainen entiteetti läpi ja listaa sen attribuutit. Sen jälkeen:

- Poista attribuutit, jotka oikeasti kuuluvat toiselle entiteetille.
    
- Pilko yhdistetyt attribuutit tarvittaessa:
    
    - Address → Street, City, Postcode, Country
        
- Merkitse johdetut attribuutit:
    
    - Age (johdettu syntymäpäivästä)
        

**Tuotos:**  
Entiteetti–attribuuttilista (usein “data dictionary” -taulukko).

---

## **Vaihe 6: Tunnista suhteet (verbit) entiteettien välillä**

**Tavoite:** Yhdistää entiteetit sen mukaan, miten ne liittyvät toisiinsa todellisessa maailmassa.

Etsi verbejä vaatimuksista:

- Student _enrolls in_ Course
    
- Customer _places_ Order
    
- Department _employs_ Employee
    

Jokaiselle suhteelle:

- Anna selkeä nimi (verbilause)
    
- Määrittele, mitkä entiteetit liittyvät toisiinsa
    

**Tuotos:**  
Lista suhteista nimineen ja osallistuvine entiteetteineen.

---

## **Vaihe 7: Määrittele kardinaalisuus (1:1, 1:N, M:N)**

**Tavoite:** Määritellä “kuinka monta” molemmilla puolilla suhdetta.

Kysy jokaisesta suhteesta kaksi kysymystä:

1. Kuinka monta B:tä voi liittyä yhteen A:han?
    
2. Kuinka monta A:ta voi liittyä yhteen B:hen?
    

**Esimerkki: Customer–Order**

- Yksi Customer → monta Orderia
    
- Yksi Order → yksi Customer  
    ⇒ **1:N**
    

**Esimerkki: Student–Course**

- Yksi Student → monta Coursea
    
- Yksi Course → monta Studentia  
    ⇒ **M:N**
    

**Tuotos:**  
Suhteet merkittynä kardinaalisuudella.

---

## **Vaihe 8: Määrittele valinnaisuus (mandatory vs optional)**

**Tavoite:** Päättää, onko osallistuminen pakollista vai valinnaista.

Kysy:

- “Täytyykö jokaisen A:n olla yhteydessä johonkin B:hen?”
    
- “Voiko A olla olemassa ilman B:tä?”
    

**Esimerkkejä:**

- Tilaus **täytyy** kuulua asiakkaalle → pakollinen Order-puolella
    
- Asiakkaalla **voi olla nolla** tilausta → valinnainen Customer-puolella
    
- Työntekijän **täytyy** kuulua osastoon → pakollinen
    
- Osastolla **voi olla nolla** työntekijää → valinnainen
    

**Tuotos:**  
Jokainen suhde merkittynä pakolliseksi/valinnaiseksi molemmilla puolilla.

---

## **Vaihe 9: Käsittele suhteen attribuutit (ja päätä, muuttuuko suhde entiteetiksi)**

**Tavoite:** Sijoittaa attribuutit oikeaan paikkaan.

Jos suhteella on attribuutteja, tämä usein tarkoittaa:

- monen-moneen-suhdetta, tai
    
- että suhteesta pitäisi tulla oma assosiatiivinen entiteetti
    

**Esimerkki:**

Student–Course “Enrollment” sisältää:

- semester
    
- grade
    

Tämä johtaa usein uuden taulun luomiseen: **Enrollment**.

**Tuotos:**  
Päivitetty malli, jossa suhdeattribuutit on sijoitettu oikein.

---

## **Vaihe 10: Piirrä konseptuaalinen/looginen ER-kaavio**

**Tavoite:** Esittää malli visuaalisesti ER-kaaviona.

Sisällytä:

- Entiteetit ja pääavaimet
    
- Tärkeimmät attribuutit
    
- Suhteet, joissa näkyy:
    
    - kardinaalisuus
        
    - valinnaisuus
        

**Laatutarkistus:**

- Nimet ovat johdonmukaisia
    
- Jokaisella entiteetillä on pääavain
    
- Monen-moneen-suhteet on esitetty selkeästi
    
- Suhdeattribuutit on sijoitettu oikein
    

**Tuotos:**  
ER-kaavio (looginen malli).

---

## **Vaihe 11: Validoi malli esimerkkidatalla ja kyselyillä**

**Tavoite:** Varmistaa, että malli tukee tarvittavia kysymyksiä.

Luo muutama esimerkkirivi (“testitapaus”) ja varmista, että voit vastata esimerkiksi:

- “Mitä kursseja Student 1001 suorittaa?”
    
- “Kuinka monta tilausta Customer 5 on tehnyt?”
    
- “Mitkä tuotteet ovat Order 77:ssa ja missä määrissä?”
    

Jos et pysty vastaamaan vaadittuun kysymykseen, tarkista:

- entiteetit
    
- attribuutit
    
- suhteet
    
- kardinaalisuus/valinnaisuus
    

**Tuotos:**  
Pieni esimerkkiaineisto + lista kyselyistä, joihin malli pystyy vastaamaan.

---

## **Vaihe 12: Muunna ER-kaavio relaatiotauluiksi**

**Tavoite:** Muuttaa looginen malli tietokantatauluiksi.

Käytä standardisääntöjä:

- **Entiteetti → Taulu**
    
- **1:N → Vierasavain N-puolelle**
    
- **M:N → Liitostaulu (yhdistelmä-PK + FK:t)**
    
- **1:1 → Uniikki vierasavain (tai yhdistä taulut tarvittaessa)**
    
- **Valinnainen suhde → FK voi olla NULL**
    
- **Pakollinen suhde → FK on NOT NULL**
    

**Tuotos:**  
Relaatioskeema (taulut, PK:t, FK:t).

---

## **Vaihe 13: Normalisoi ja hienosäädä (vältä redundanssia)**

**Tavoite:** Poistaa tarpeeton päällekkäisyys ja päivitysvirheet.

Tarkistukset:

- Onko taulussa toistuvia listoja? (huono merkki)
    
- Tallennetaanko sama fakta useaan paikkaan?
    
- Riippuuko ei-avainattribuutti vain osasta pääavainta?
    

Perustason kursseilla pyritään yleensä **3NF:ään (Third Normal Form).**

**Tuotos:**  
Parannettu ja normalisoitu relaatiomalli.

---

## **Vaihe 14: Luo fyysinen malli (DB-kohtaiset yksityiskohdat)**

**Tavoite:** Valmistella malli toteutettavaksi tietyssä tietokantajärjestelmässä (PostgreSQL, MySQL, SQL Server jne.).

Lisää:

- Tietotyypit (INT, VARCHAR, DATE…)
    
- Indeksit (PK:ille ja yleisille hakusarakkeille)
    
- Rajoitteet (UNIQUE, CHECK, NOT NULL)
    
- ON DELETE / ON UPDATE -säännöt
    

**Tuotos:**  
SQL DDL -skripti (CREATE TABLE -lauseet).

