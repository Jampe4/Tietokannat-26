# SQL-perusteet, osa III (PostgreSQL)

### LIITOKSET (JOIN), viite-eheys ja rajoitteet tarkemmin

Materiaaleissa [05](./Materiaalit/05-SQL-perusteet.md) rakensimme tauluja ja käyttöön tuli `REFERENCES` taulujen linkittämiseen.  
Materiaaleissa [06](./Materiaalit/06-SQL-perusteet-2.md) opimme suodattamaan, lajittelemaan, koostamaan ja kosketimme lyhyesti `JOIN`-kyselyihin.

Nyt syvennymme aiheisiin:

- **JOIN (liitos)** → kuinka yhdistää rivejä useista tauluista yhdessä kyselyssä
- **Viite-eheys** → mitä viiteavaimet (foreign keys) oikeasti takaavat ja mitä tapahtuu, kun viitatut rivit muuttuvat
- **Rajoitteet (constraints)** → kaikki rajoitetyypit, miten ne toimivat ja milloin niitä käytetään

Tämä luku olettaa, että tunnet tietokantakaavion: `students`, `courses`, `enrollments`, `grades`, `teachers`.

---

## Yhteinen esimerkkikaavio (yliopisto tietokanta)

### Taulu: `students`

| student_id | full_name     | email          |
| ---------: | ------------- | -------------- |
|          1 | Aino Laine    | aino@uni.fi    |
|          2 | Mika Virtanen | mika@uni.fi    |
|          3 | Sara Niemi    | _(NULL)_       |
|          4 | Olli Koski    | olli@gmail.com |

### Taulu: `teachers`

| teacher_id | full_name      | email        |
| ---------: | -------------- | ------------ |
|          1 | Liisa Korhonen | liisa@uni.fi |
|          2 | Pekka Salo     | pekka@uni.fi |
|          3 | Maria Lind     | maria@uni.fi |

### Taulu: `courses`

| course_id | title           | credits | teacher_id |
| --------: | --------------- | ------: | ---------: |
|         1 | Databases       |       5 |          1 |
|         2 | Algorithms      |       6 |          2 |
|         3 | Web Development |       5 |          3 |

### Taulu: `enrollments`

| student_id | course_id |
| ---------: | --------: |
|          1 |         1 |
|          1 |         2 |
|          2 |         1 |
|          3 |         1 |
|          3 |         3 |
|          4 |         3 |

### Taulu: `grades`

| student_id | course_id | grade |
| ---------: | --------: | ----: |
|          1 |         1 |     5 |
|          1 |         2 |     4 |
|          2 |         1 |     3 |
|          3 |         1 |     2 |
|          3 |         3 |     5 |
|          4 |         3 |     4 |

---

# 1) LIITOKSET (JOIN) — taulujen yhdistäminen yhdessä kyselyssä

**JOIN (liitos)** yhdistää rivejä kahdesta tai useammasta taulusta niiden välisen suhteen perusteella.  
Ilman liitoksia tarvitsisit useita erillisiä kyselyjä ja manuaalista yhdistelyä.

### Miksi liitokset ovat tärkeitä

- Data on jaettu tauluihin duplikaattien välttämiseksi (normalisointi).
- Useimmat kysymykset vaativat tietoa useista tauluista: "Mitkä kurssit Aino suoritti?" vaatii taulut `students` + `enrollments` + `courses`.
- Liitosten avulla voit vastata näihin kysymyksiin yhdellä kyselyllä.

---

## Liitosten perusteet: täsmäyslogiikka

Jokaisessa liitoksessa on:

1. **Vasen taulu** (se, joka tulee `FROM`-lauseen jälkeen)
2. **Oikea taulu** (se, joka tulee `JOIN`-lauseen jälkeen)
3. **Liitosehto** (yleensä `ON vasen.sarake = oikea.sarake`)

Ehto päättää, mitkä vasemman ja oikean taulun rivit paritetaan keskenään.

---

## INNER JOIN — vain täsmäävät rivit

**INNER JOIN** palauttaa vain ne rivit, joilla liitosehto on tosi molemmissa tauluissa.

### Esimerkki: Opiskelijat ja heidän ilmoittautumisensa (nimet ja kurssinimet)

```sql
SELECT s.full_name, c.title
FROM enrollments e
INNER JOIN students s ON s.student_id = e.student_id
INNER JOIN courses  c ON c.course_id  = e.course_id
ORDER BY s.full_name, c.title;
```

**Tulos**

| full_name     | title           |
| ------------- | --------------- |
| Aino Laine    | Algorithms      |
| Aino Laine    | Databases       |
| Mika Virtanen | Databases       |
| Olli Koski    | Web Development |
| Sara Niemi    | Databases       |
| Sara Niemi    | Web Development |

**Selitys**

- `enrollments` linkittää opiskelijat kursseihin `student_id`- ja `course_id`-kautta.
- Ensimmäinen JOIN: lisätään opiskelijanimet taulusta `students`.
- Toinen JOIN: lisätään kurssinimet taulusta `courses`.
- Vain ne ilmoittautumiset, joilla on sekä validi opiskelija että validi kurssi, näkyvät tuloksessa.

---

### Vaihe vaiheelta: miten kysely suoritetaan

#### Vaihe 0: Aloitetaan FROM-taulusta (`enrollments`)

| student_id | course_id |
| ---------: | --------: |
|          1 |         1 |
|          1 |         2 |
|          2 |         1 |
|          3 |         1 |
|          3 |         3 |
|          4 |         3 |

Aloitamme 6 rivillä. Jokainen rivi on yksi ilmoittautumistapahtuma (opiskelija X kurssilla Y).

---

#### Vaihe 1: INNER JOIN `students` (täsmäys `student_id`:n perusteella)

Jokaiselle ilmoittautumisriville etsimme vastaavan opiskelijan. Täsmäys: `s.student_id = e.student_id`.

| e.student_id | e.course_id | s.full_name   |
| ------------ | ----------- | ------------- |
| 1            | 1           | Aino Laine    |
| 1            | 2           | Aino Laine    |
| 2            | 1           | Mika Virtanen |
| 3            | 1           | Sara Niemi    |
| 3            | 3           | Sara Niemi    |
| 4            | 3           | Olli Koski    |

Jokaisella ilmoittautumisella on validi opiskelija, joten kaikki 6 riviä säilyvät. Opiskelijanimet on nyt liitetty.

---

#### Vaihe 2: INNER JOIN `courses` (täsmäys `course_id`:n perusteella)

Jokaiselle Vaiheen 1 riville etsimme vastaavan kurssin. Täsmäys: `c.course_id = e.course_id`.

| s.full_name   | c.title         |
| ------------- | --------------- |
| Aino Laine    | Databases       |
| Aino Laine    | Algorithms      |
| Mika Virtanen | Databases       |
| Sara Niemi    | Databases       |
| Sara Niemi    | Web Development |
| Olli Koski    | Web Development |

Jokaisella ilmoittautumisella on validi kurssi, joten kaikki 6 riviä säilyvät. Kurssinimet on nyt liitetty.

---

#### Vaihe 3: SELECT ja ORDER BY (lopullinen tulos)

Pidetään vain `full_name` ja `title`, sitten lajitellaan nimen ja kurssinimen mukaan.

| full_name     | title           |
| ------------- | --------------- |
| Aino Laine    | Algorithms      |
| Aino Laine    | Databases       |
| Mika Virtanen | Databases       |
| Olli Koski    | Web Development |
| Sara Niemi    | Databases       |
| Sara Niemi    | Web Development |

---

### Esimerkki: Kurssit ja niiden opettajien nimet

```sql
SELECT c.title, c.credits, t.full_name AS teacher_name
FROM courses c
INNER JOIN teachers t ON t.teacher_id = c.teacher_id
ORDER BY c.title;
```

**Tulos**

| title           | credits | teacher_name   |
| --------------- | ------: | -------------- |
| Algorithms      |       6 | Pekka Salo     |
| Databases       |       5 | Liisa Korhonen |
| Web Development |       5 | Maria Lind     |

**Selitys**

- Jokaisella kurssilla on `teacher_id`, joka viittaa tauluun `teachers`.
- JOIN tuo opettajan nimen taulusta `teachers` jokaiselle kurssille.

---

### Vaihe vaiheelta: miten kysely suoritetaan

#### Vaihe 0: Aloitetaan FROM-taulusta (`courses`)

| course_id | title           | credits | teacher_id |
| --------- | --------------- | ------: | ---------: |
| 1         | Databases       |       5 |          1 |
| 2         | Algorithms      |       6 |          2 |
| 3         | Web Development |       5 |          3 |

---

#### Vaihe 1: INNER JOIN `teachers` (täsmäys `teacher_id`:n perusteella)

Jokaiselle kurssiriville etsimme opettajan. Täsmäys: `t.teacher_id = c.teacher_id`.

| c.title         | c.credits | t.full_name    |
| --------------- | --------: | -------------- |
| Databases       |         5 | Liisa Korhonen |
| Algorithms      |         6 | Pekka Salo     |
| Web Development |         5 | Maria Lind     |

Jokaisella kurssilla on täsmälleen yksi vastaava opettaja. Kaikki 3 riviä säilyvät.

---

#### Vaihe 2: SELECT ja ORDER BY (lopullinen tulos)

| title           | credits | teacher_name   |
| --------------- | ------: | -------------- |
| Algorithms      |       6 | Pekka Salo     |
| Databases       |       5 | Liisa Korhonen |
| Web Development |       5 | Maria Lind     |

---

## LEFT JOIN (LEFT OUTER JOIN) — pidetään kaikki vasemman taulun rivit

**LEFT JOIN** palauttaa kaikki vasemman taulun rivit ja täsmäävät rivit oikeasta taulusta.  
Jos täsmäystä ei löydy, oikean taulun sarakkeet täytetään arvolla `NULL`.

### Esimerkki: Kaikki opiskelijat ja kurssimääränsä (myös ilman ilmoittautumisia)

```sql
SELECT s.full_name, COUNT(e.course_id) AS course_count
FROM students s
LEFT JOIN enrollments e ON e.student_id = s.student_id
GROUP BY s.student_id, s.full_name
ORDER BY s.full_name;
```

**Tulos**

| full_name     | course_count |
| ------------- | -----------: |
| Aino Laine    |            2 |
| Mika Virtanen |            1 |
| Olli Koski    |            1 |
| Sara Niemi    |            2 |

_(Nykyisellä datalla jokaisella opiskelijalla on vähintään yksi ilmoittautuminen. Jos lisäisimme 5. opiskelijan ilman ilmoittautumisia, hän näkyisi arvolla `course_count = 0`.)_

**Selitys**

- `LEFT JOIN` pitää jokaisen taulun `students` rivin.
- `COUNT(e.course_id)` laskee vain ei-NULL-ilmoittautumiset; ilmoittautumattomilla opiskelijoilla tulos on 0.

---

### Vaihe vaiheelta: miten kysely suoritetaan

#### Vaihe 0: Aloitetaan FROM-taulusta (`students`)

| student_id | full_name     |
| ---------: | ------------- |
|          1 | Aino Laine    |
|          2 | Mika Virtanen |
|          3 | Sara Niemi    |
|          4 | Olli Koski    |

---

#### Vaihe 1: LEFT JOIN `enrollments` (täsmäys `student_id`:n perusteella)

Jokaiselle opiskelijalle etsimme täsmäävät ilmoittautumiset. **LEFT JOIN pitää jokaisen opiskelijan**, vaikka täsmäyksiä ei olisi.

| s.student_id | s.full_name   | e.student_id | e.course_id |
| ------------ | ------------- | ------------ | ----------- |
| 1            | Aino Laine    | 1            | 1           |
| 1            | Aino Laine    | 1            | 2           |
| 2            | Mika Virtanen | 2            | 1           |
| 3            | Sara Niemi    | 3            | 1           |
| 3            | Sara Niemi    | 3            | 3           |
| 4            | Olli Koski    | 4            | 3           |

Ainolle 2 riviä (2 ilmoittautumista), Mikalle 1, Saralle 2, Ollille 1. Jos opiskelijalla ei olisi ilmoittautumisia, hän näkyisi kerran arvoilla `e.student_id` ja `e.course_id` = NULL.

---

#### Vaihe 2: GROUP BY ja COUNT

Ryhmitellään opiskelijan mukaan ja lasketaan `e.course_id` (NULL-arvoja ei lasketa).

| full_name     | course_count |
| ------------- | -----------: |
| Aino Laine    |            2 |
| Mika Virtanen |            1 |
| Olli Koski    |            1 |
| Sara Niemi    |            2 |

---

### Esimerkki: Kaikki kurssit ja ilmoittautumismäärä (myös kurssit ilman ilmoittautumisia)

Oletetaan, että lisäämme kurssin ilman ilmoittautumisia:

```sql
INSERT INTO courses (title, credits, teacher_id) VALUES ('Statistics', 4, 1);
```

```sql
SELECT c.title, COUNT(e.student_id) AS enrollment_count
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.course_id
GROUP BY c.course_id, c.title
ORDER BY c.title;
```

**Tulos**

| title           | enrollment_count |
| --------------- | ---------------: |
| Algorithms      |                1 |
| Databases       |                3 |
| Statistics      |                0 |
| Web Development |                2 |

**Selitys**

- `LEFT JOIN` pitää jokaisen kurssin.
- Statisticsilla ei ilmoittautumisia → näillä riveillä `e.student_id` on NULL → `COUNT(e.student_id)` = 0.

---

### Vaihe vaiheelta: miten kysely suoritetaan

#### Vaihe 0: Aloitetaan FROM-taulusta (`courses`)

Statistics lisättynä (course_id 4):

| course_id | title           |
| --------- | --------------- |
| 1         | Databases       |
| 2         | Algorithms      |
| 3         | Web Development |
| 4         | Statistics      |

---

#### Vaihe 1: LEFT JOIN `enrollments` (täsmäys `course_id`:n perusteella)

Jokaiselle kurssille etsimme täsmäävät ilmoittautumiset. **LEFT JOIN pitää jokaisen kurssin**, vaikka täsmäyksiä ei olisi.

| c.course_id | c.title         | e.student_id | e.course_id |
| ----------- | --------------- | ------------ | ----------- |
| 1           | Databases       | 1            | 1           |
| 1           | Databases       | 2            | 1           |
| 1           | Databases       | 3            | 1           |
| 2           | Algorithms      | 1            | 2           |
| 3           | Web Development | 3            | 3           |
| 3           | Web Development | 4            | 3           |
| 4           | Statistics      | _(NULL)_     | _(NULL)_    |

Statistics (4) ei ole ilmoittautumisia → se esiintyy kerran NULL-arvoilla ilmoittautumissarakkeissa. Databases esiintyy 3 kertaa (3 ilmoittautumista), Algorithms 1, Web Development 2.

---

#### Vaihe 2: GROUP BY ja COUNT

Ryhmitellään kurssin mukaan ja lasketaan `e.student_id` (NULL-arvoja ei lasketa).

| title           | enrollment_count |
| --------------- | ---------------: |
| Algorithms      |                1 |
| Databases       |                3 |
| Statistics      |                0 |
| Web Development |                2 |

Statistics näyttää oikein 0.

---

### Esimerkki: Kaikki kurssit opettajien nimineen (myös kurssit ilman opettajaa)

Jos `courses`-taulun `teacher_id` on NULL-salliva, joillakin kursseilla ei välttämättä ole opettajaa.  
`LEFT JOIN teachers` pitää nämä kurssit mukana ja näyttää opettajan nimenä NULL:

```sql
SELECT c.title, t.full_name AS teacher_name
FROM courses c
LEFT JOIN teachers t ON t.teacher_id = c.teacher_id
ORDER BY c.title;
```

Nykyisellä kaaviolla (kaikilla kursseilla on opettaja) jokaisella rivillä on opettajan nimi.  
Jos meillä olisi kurssi, jolla `teacher_id = NULL`, se näkyisi silti tuloksessa, ja `teacher_name` olisi NULL.

---

### Vaihe vaiheelta: miten kysely suoritetaan

#### Vaihe 0: Aloitetaan FROM-taulusta (`courses`)

| course_id | title           | teacher_id |
| --------- | --------------- | ---------: |
| 1         | Databases       |          1 |
| 2         | Algorithms      |          2 |
| 3         | Web Development |          3 |

---

#### Vaihe 1: LEFT JOIN `teachers` (täsmäys `teacher_id`:n perusteella)

Jokaiselle kurssille etsimme opettajan. **LEFT JOIN pitää jokaisen kurssin**, vaikka täsmäystä ei olisi.

| c.title         | t.full_name    |
| --------------- | -------------- |
| Databases       | Liisa Korhonen |
| Algorithms      | Pekka Salo     |
| Web Development | Maria Lind     |

Nykyisellä datalla jokaisella kurssilla on opettaja, joten kaikki täsmäykset onnistuvat.  
**Jos** meillä olisi kurssi, jolla `teacher_id = NULL`, se näkyisi yhdenä rivinä, jolla `teacher_name` = NULL.

---

### Visuaalinen: LEFT JOIN pitää kaikki vasemman taulun rivit

```
courses (vasen)     enrollments (oikea)
─────────────       ──────────────────
Databases (1)   ───► (1,1), (2,1), (3,1)  ✓ täsmää
Algorithms (2)  ───► (1,2)                ✓ täsmää
Web Dev (3)     ───► (3,3), (4,3)         ✓ täsmää
Statistics (4)  ───► (ei täsmäystä)       ✓ silti tuloksessa, oikean sarakkeet = NULL
```

---

## RIGHT JOIN ja FULL OUTER JOIN

### RIGHT JOIN (RIGHT OUTER JOIN)

Sama idea kuin LEFT JOIN, mutta pidetään kaikki **oikean** taulun rivit.  
Harvoin tarvitaan: RIGHT JOIN voidaan aina kirjoittaa uudelleen LEFT JOINina vaihtamalla taulujen järjestys.

### FULL OUTER JOIN

Pidetään kaikki rivit molemmista tauluista.  
Kohdissa, joissa ei ole täsmäystä, toisen puolen sarakkeet ovat NULL.

```sql
SELECT s.full_name, c.title
FROM students s
FULL OUTER JOIN enrollments e ON e.student_id = s.student_id
FULL OUTER JOIN courses c ON c.course_id = e.course_id;
```

Hyödyllinen, kun halutaan "kaikki molemmilta puolilta" (esim. virheenetsintä tai täysi täsmäytys).

---

## Itseliitos — taulun liittäminen itseensä

**Itseliitoksessa** taulu liitetään itseensä. Käytät eri aliaksia "vasemmalle" ja "oikealle" kopiolle.

### Esimerkki: Työntekijät ja heidän esimiehensä

Oletetaan taulu `employees`:

| employee_id | full_name    | manager_id |
| ----------: | ------------ | ---------: |
|           1 | Anna Boss    |       NULL |
|           2 | Bob Worker   |          1 |
|           3 | Carol Worker |          1 |

```sql
SELECT e.full_name AS employee, m.full_name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;
```

**Tulos**

| employee     | manager   |
| ------------ | --------- |
| Anna Boss    | _(NULL)_  |
| Bob Worker   | Anna Boss |
| Carol Worker | Anna Boss |

---

### Vaihe vaiheelta: miten itseliitos suoritetaan

#### Vaihe 0: Aloitetaan FROM-taulusta (`employees` aliaksella `e`)

| e.employee_id | e.full_name  | e.manager_id |
| ------------- | ------------ | -----------: |
| 1             | Anna Boss    |         NULL |
| 2             | Bob Worker   |            1 |
| 3             | Carol Worker |            1 |

---

#### Vaihe 1: LEFT JOIN `employees` aliaksella `m` (täsmäys `e.manager_id` = `m.employee_id`)

Jokaiselle työntekijälle etsimme esimiehen **samasta taulusta** eri aliaksella (`m`).

| e.full_name  | m.full_name |
| ------------ | ----------- |
| Anna Boss    | _(NULL)_    |
| Bob Worker   | Anna Boss   |
| Carol Worker | Anna Boss   |

- Annalla `manager_id = NULL` → ei täsmäystä → `m.full_name` on NULL.
- Bobilla ja Carolilla `manager_id = 1` → täsmäys työntekijään 1 (Anna) → `m.full_name` = Anna Boss.

---

## Liitosehdot: ON vs WHERE

### ON — osa liitosta

`ON` määrittää, mitkä rivit täsmäävät kahden taulun välillä.

```sql
SELECT s.full_name, c.title
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id
WHERE c.credits >= 5;
```

- `ON` määrittää suhteen.
- `WHERE` suodattaa tuloksen liiton jälkeen.

### USING — kun sarakenimet ovat samat

Jos molemmissa tauluissa on sama sarakenimi liitossa, voit käyttää `USING`-syntaksia:

```sql
SELECT s.full_name, c.title
FROM enrollments e
JOIN students s USING (student_id)
JOIN courses c USING (course_id);
```

`USING (student_id)` vastaa lausetta `ON e.student_id = s.student_id`, kun molemmissa tauluissa on sarake `student_id`.

---

## Yhteenveto: liitostyypit

| Liitostyyppi    | Pitää mukana                                                        |
| --------------- | ------------------------------------------------------------------- |
| INNER JOIN      | Vain rivit, jotka täsmäävät molemmissa                              |
| LEFT JOIN       | Kaikki vasemman rivit + täsmäävät oikealta (NULL, jos ei täsmäystä) |
| RIGHT JOIN      | Kaikki oikean rivit + täsmäävät vasemmalta (NULL, jos ei täsmäystä) |
| FULL OUTER JOIN | Kaikki rivit molemmista tauluista                                   |

---

# 2) Viite-eheys — mitä viiteavaimet takaavat

**Viite-eheys** tarkoittaa: jokaisen viiteavaimen arvon on viitattava olemassa olevaan riviin viitattavassa taulussa (tai oltava NULL, jos sarake sallii sen).

PostgreSQL valvoo tätä automaattisesti, kun määrittelet `REFERENCES`.

---

## Mitä tietokanta tarkistaa

### INSERT- tai UPDATE-operaatiossa (taulussa, jolla on viiteavain)

- Et voi lisätä riviä `(student_id = 99, course_id = 1)` tauluun `enrollments`, jos opiskelijaa, jolla `student_id = 99`, ei ole.
- Sama pätee `course_id`:hen: sen on oltava olemassa taulussa `courses`.

### DELETE- tai UPDATE-operaatiossa (viitatussa taulussa)

- Jos yrität poistaa opiskelijan 1, PostgreSQL päättää: mitä tapahtuu niille ilmoittautumisriveille, jotka viittaavat opiskelija 1:een?
- Sama kysymys syntyy, kun päivität pääavaimen (harvinaista ja yleensä välteltävää).

Käyttäytymisen hallinta tapahtuu `ON DELETE`- ja `ON UPDATE`-vaihtoehtojen avulla.

---

## ON DELETE- ja ON UPDATE-vaihtoehdot

Viiteavaimen määrittelyssä voit ilmoittaa:

```sql
REFERENCES parent_table(parent_column)
  ON DELETE action
  ON UPDATE action
```

### Yleisimmät toimenpiteet

| Toimenpide    | Merkitys                                                                                  |
| ------------- | ----------------------------------------------------------------------------------------- |
| `RESTRICT`    | Estää DELETE/UPDATE, jos lapsirivejä viittaa tähän riviin (oletus)                        |
| `CASCADE`     | Poistaa/päivittää lapsirivit, kun vanhemmarivi poistetaan/päivitetään                     |
| `SET NULL`    | Asettaa viiteavainsarakkeen arvoksi NULL lapsiriveissä (sarakkeen on oltava NULL-salliva) |
| `SET DEFAULT` | Asettaa viiteavaimen oletusarvoon lapsiriveissä                                           |
| `NO ACTION`   | Käytännössä sama kuin RESTRICT viivästettävissä rajoitteissa                              |

---

### Esimerkki: RESTRICT (oletus)

```sql
CREATE TABLE enrollments (
  student_id INTEGER NOT NULL REFERENCES students(student_id) ON DELETE RESTRICT,
  course_id  INTEGER NOT NULL REFERENCES courses(course_id)   ON DELETE RESTRICT,
  PRIMARY KEY (student_id, course_id)
);
```

Jos yrität:

```sql
DELETE FROM students WHERE student_id = 1;
```

PostgreSQL palauttaa virheen, koska ilmoittautumiset viittaavat opiskelija 1:een.

---

### Esimerkki: CASCADE

```sql
CREATE TABLE enrollments (
  student_id INTEGER NOT NULL REFERENCES students(student_id) ON DELETE CASCADE,
  course_id  INTEGER NOT NULL REFERENCES courses(course_id)   ON DELETE CASCADE,
  PRIMARY KEY (student_id, course_id)
);
```

Jos poistat opiskelijan 1:

```sql
DELETE FROM students WHERE student_id = 1;
```

PostgreSQL poistaa myös kaikki `enrollments`-rivit, joilla `student_id = 1`.

**Käytä CASCADE:a varovaisesti** — se voi poistaa paljon dataa.

---

### Esimerkki: SET NULL

Vaaditaan, että viiteavainsarake on NULL-salliva:

```sql
CREATE TABLE grades (
  student_id INTEGER REFERENCES students(student_id) ON DELETE SET NULL,
  course_id  INTEGER REFERENCES courses(course_id)   ON DELETE SET NULL,
  grade      INTEGER,
  PRIMARY KEY (student_id, course_id)
);
```

Kun poistat opiskelijan, heidän arvosanariviensä `student_id` muuttuu NULLiksi.  
_Huom: Tämä muuttaa taulun merkitystä; ilmoittautumisissa/arvosanoissa yleensä suositaan RESTRICT tai CASCADE._

---

### Esimerkki: Opettajat ja kurssit — SET NULL, kun opettaja poistetaan

Jos kurssi voi olla olemassa ilman opettajaa, käytä `ON DELETE SET NULL`:

```sql
CREATE TABLE courses (
  course_id  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  title      VARCHAR(200) NOT NULL,
  credits    INTEGER NOT NULL,
  teacher_id INTEGER REFERENCES teachers(teacher_id) ON DELETE SET NULL
);
```

Kun poistat opettajan, heidän kurssinsa jäävät, mutta `teacher_id` muuttuu NULLiksi (kurssi "ei ole osoitettu kenellekään").

---

## Milloin kumpaakin vaihtoehtoa

| Tilanne                                           | Tyypillinen valinta                      |
| ------------------------------------------------- | ---------------------------------------- |
| Lapsirivit ovat järkeviä vain vanhemman kanssa    | `ON DELETE CASCADE`                      |
| Lapsirivien ei saa viitata puuttuvaan vanhempaan  | `ON DELETE RESTRICT`                     |
| Halutaan "irroittaa" viite mutta pitää lapsirivit | `ON DELETE SET NULL` (jos NULL sallittu) |

---

# 3) Rajoitteet tarkemmin

Rajoitteet ovat sääntöjä, joita tietokanta valvoo.  
Ne pitävät datan yhtenäisenä ja merkityksellisenä.

---

## Rajoitetyypit PostgreSQLissä

| Rajoite     | Tarkoitus                                                              |
| ----------- | ---------------------------------------------------------------------- |
| PRIMARY KEY | Yksilöi jokaisen rivin; sisältää NOT NULL -vaatimuksen                 |
| FOREIGN KEY | Viittaa toiseen tauluun; varmistaa viite-eheyden                       |
| UNIQUE      | Kahdella rivillä ei saa olla sama(t) arvo(t) rajoitetuissa sarakkeissa |
| NOT NULL    | Sarake ei voi olla NULL                                                |
| CHECK       | Arvon on täytettävä boolean-ehto                                       |
| DEFAULT     | Arvo, jota käytetään INSERTissä, jos saraketta ei anneta               |

---

## PRIMARY KEY

- Jokaisella rivillä on yksilöllinen tunniste.
- Taululla voi olla vain yksi PRIMARY KEY (mutta se voi olla yhdistetty: useita sarakkeita).
- Sisältää `NOT NULL`- ja `UNIQUE`-vaatimukset.

```sql
CREATE TABLE students (
  student_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  full_name  VARCHAR(100) NOT NULL
);
```

Yhdistetty pääavain:

```sql
CREATE TABLE enrollments (
  student_id INTEGER NOT NULL REFERENCES students(student_id),
  course_id  INTEGER NOT NULL REFERENCES courses(course_id),
  PRIMARY KEY (student_id, course_id)
);
```

---

## FOREIGN KEY (REFERENCES)

- Linkittää sarakkeen (tai sarakkeet) toisen taulun pääavaimen tai UNIQUE-sarakkeen arvoon.
- Varmistaa, että jokainen ei-NULL-arvo löytyy viitatusta taulusta.

```sql
CREATE TABLE enrollments (
  student_id INTEGER NOT NULL REFERENCES students(student_id),
  course_id  INTEGER NOT NULL REFERENCES courses(course_id),
  PRIMARY KEY (student_id, course_id)
);
```

Nimetty rajoite (hyödyllinen virheilmoitusten ja hallinnan kannalta):

```sql
CREATE TABLE enrollments (
  student_id INTEGER NOT NULL,
  course_id  INTEGER NOT NULL,
  PRIMARY KEY (student_id, course_id),
  CONSTRAINT fk_enrollments_student
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
  CONSTRAINT fk_enrollments_course
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE RESTRICT
);
```

---

## UNIQUE

- Kahdella rivillä ei saa olla sama arvo (tai arvoyhdistelmä) rajoitetuissa sarakkeissa.
- NULL on sallittu (PostgreSQLissä UNIQUE-sarakkeessa useat NULL-arvot ovat usein sallittuja).

```sql
CREATE TABLE students (
  student_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  email      VARCHAR(255) UNIQUE
);
```

---

## NOT NULL

- Sarake ei voi olla NULL.
- Usein pakollisten kenttien kohdalla: nimi, id, päivämäärä jne.

```sql
CREATE TABLE teachers (
  teacher_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  full_name  VARCHAR(100) NOT NULL,
  email      VARCHAR(255) UNIQUE
);

CREATE TABLE courses (
  course_id  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  title      VARCHAR(200) NOT NULL,
  credits    INTEGER NOT NULL,
  teacher_id INTEGER REFERENCES teachers(teacher_id)
);
```

---

## CHECK

- Arvon on täytettävä boolean-ehto.
- Mahdollistaa liikesääntöjen valvonnan suoraan tietokannassa.

```sql
CREATE TABLE courses (
  course_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  title     VARCHAR(200) NOT NULL,
  credits   INTEGER NOT NULL CHECK (credits BETWEEN 1 AND 20)
);
```

```sql
CREATE TABLE grades (
  student_id INTEGER NOT NULL REFERENCES students(student_id),
  course_id  INTEGER NOT NULL REFERENCES courses(course_id),
  grade      INTEGER CHECK (grade >= 0 AND grade <= 5),
  PRIMARY KEY (student_id, course_id)
);
```

Nimetty CHECK-rajoite:

```sql
CREATE TABLE grades (
  ...
  CONSTRAINT chk_grade_range CHECK (grade >= 0 AND grade <= 5)
);
```

---

## DEFAULT

- Antaa arvon, kun INSERTissä saraketta ei anneta.

```sql
CREATE TABLE fines (
  fine_id   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  amount    NUMERIC(6,2) NOT NULL,
  paid      BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## Rajoitteiden lisääminen ja muuttaminen

### Rajoitteen lisääminen olemassa olevaan tauluun

```sql
ALTER TABLE students
  ADD CONSTRAINT uq_students_email UNIQUE (email);
```

```sql
ALTER TABLE grades
  ADD CONSTRAINT chk_grade_range CHECK (grade >= 0 AND grade <= 5);
```

### Rajoitteen poistaminen

```sql
ALTER TABLE students DROP CONSTRAINT uq_students_email;
```

### Sarakkeen tekeminen NOT NULL -sarakeksi

```sql
ALTER TABLE students ALTER COLUMN full_name SET NOT NULL;
```

---

## Rajoitteiden nimentä (hyvä käytäntö)

Nimettyjen rajoitteiden avulla virheilmoitukset ovat selkeämpiä ja skeeman muutokset helpommin hallittavissa:

| Yleissopimus | Esimerkki                   |
| ------------ | --------------------------- |
| Pääavain     | `pk_table` tai `table_pkey` |
| Viiteavain   | `fk_lapsi_vanhempi`         |
| UNIQUE       | `uq_table_sarake`           |
| CHECK        | `chk_table_kuvaus`          |

```sql
CREATE TABLE enrollments (
  student_id INTEGER NOT NULL,
  course_id  INTEGER NOT NULL,
  CONSTRAINT pk_enrollments PRIMARY KEY (student_id, course_id),
  CONSTRAINT fk_enrollments_student FOREIGN KEY (student_id) REFERENCES students(student_id),
  CONSTRAINT fk_enrollments_course FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
```

---

## Yhteenveto

| Aihe            | Keskeiset asiat                                                                |
| --------------- | ------------------------------------------------------------------------------ |
| **INNER JOIN**  | Vain täsmäävät rivit molemmista tauluista                                      |
| **LEFT JOIN**   | Kaikki vasemman rivit + oikean täsmäykset (NULL, jos ei täsmäystä)             |
| **Viite-eheys** | Viiteavaimen on viitattava olemassa olevaan riviin; ON DELETE/UPDATE hallitsee |
| **Rajoitteet**  | PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, CHECK, DEFAULT                     |
| **Nimentä**     | Nimeä rajoitteet selkeämpien virheiden ja helpomman ylläpidon vuoksi           |

---

_Materiaali 07 loppuu._
