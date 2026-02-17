# **Harjoitus 3: SQL-perusteet — Kirjaston lainausjärjestelmä (PostgreSQL)**

# **Rakenna kirjaston lainaus-tietokanta ja harjoittele kyselyitä**

> **Ohjeet:**
> Työskentele jokaisen osion läpi järjestyksessä. Rakenna pieni kirjaston lainaus-tietokanta alusta alkaen: luo uusi tietokanta, määritä taulut (Books, Authors, BookAuthors, Members, Loans, Fines), lisää esimerkkidata ja harjoittele sitten kyselyitä. Kirjoita SQL-kyselysi annettuihin koodilohkoihin. Käytä tarvittaessa viitteenä materiaaleja 05 (SQL-perusteet) ja 06 (SQL-perusteet, osa 2).

---

## **OSA A — Tietokannan rakentaminen**

Perustuu tiedostoon [Materiaalit/05-SQL-perusteet.md](../../Materiaalit/05-SQL-perusteet.md). Luot tietokannan, kirjoitat kaikki `CREATE TABLE` -lauseet, lisäät esimerkkidatan ja suoritat perus-`SELECT`-kyselyitä tarkistusta varten.

---

### **A0 — Luo uusi tietokanta**

Luo uusi PostgreSQL-tietokanta nimeltä **`library_db`**.

Voit suorittaa tämän **psql**:ssä (yhdistä ensin PostgreSQL:hen ja suorita komento) tai luoda tietokannan **pgAdmin**:lla (hiiren oikea painike Tietokannat → Luo → Tietokanta, nimeä se `library_db`). Yhdistä sen jälkeen tietokantaan `library_db` kaikissa seuraavissa vaiheissa.

**Kirjoita SQL (jos käytät psql):**

```sql


```

---

### **A1 — CREATE TABLE (kuusi taulua)**

Luo seuraavat taulut **riippuvuusjärjestyksessä** (ensin viitatut taulut). Käytä alla olevia sarakemäärittelyjä. Käytä taulu- ja sarakenimissä **snake_case** -kirjoitusasua. Jokaisella taululla on pääavain; käytä kokonaislukusurrogaattiavaimissa `GENERATED ALWAYS AS IDENTITY` silloin kun mainitaan.

**Taulukohtaiset määrittelyt:**

| Table            | Columns and constraints                                                                                                                                                                                                                                          |
| ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **books**        | `book_id` INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, `title` VARCHAR(300) NOT NULL, `isbn` VARCHAR(20) UNIQUE (nullable), `publication_year` INTEGER CHECK (publication_year BETWEEN 1000 AND 2100)                                                       |
| **authors**      | `author_id` INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, `full_name` VARCHAR(100) NOT NULL                                                                                                                                                                  |
| **book_authors** | `book_id` INTEGER NOT NULL REFERENCES books(book_id), `author_id` INTEGER NOT NULL REFERENCES authors(author_id), PRIMARY KEY (book_id, author_id)                                                                                                               |
| **members**      | `member_id` INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, `full_name` VARCHAR(100) NOT NULL, `email` VARCHAR(255) UNIQUE (nullable)                                                                                                                          |
| **loans**        | `loan_id` INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, `book_id` INTEGER NOT NULL REFERENCES books(book_id), `member_id` INTEGER NOT NULL REFERENCES members(member_id), `loan_date` DATE NOT NULL, `due_date` DATE NOT NULL, `return_date` DATE (nullable) |
| **fines**        | `fine_id` INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, `loan_id` INTEGER NOT NULL REFERENCES loans(loan_id), `amount` NUMERIC(6,2) NOT NULL CHECK (amount >= 0), `paid` BOOLEAN NOT NULL DEFAULT FALSE                                                      |

**Luontijärjestys:** books → authors → book_authors → members → loans → fines.

**Kirjoita CREATE TABLE -lauseesi tähän:**

```sql
-- books
CREATE TABLE books (
    book_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(300) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    publication_year INTEGER CHECK (publication_year BETWEEN 1000 AND 2100)
);

-- authors
CREATE TABLE authors (
    author_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL
);

-- book_authors
CREATE TABLE book_authors (
    book_id INTEGER NOT NULL REFERENCES books(book_id),
    author_id INTEGER NOT NULL REFERENCES authors(author_id),
    PRIMARY KEY (book_id, author_id)
);

-- members
CREATE TABLE members (
    member_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE
);

-- loans
CREATE TABLE loans (
    loan_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    book_id INTEGER NOT NULL REFERENCES books(book_id),
    member_id INTEGER NOT NULL REFERENCES members(member_id),
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE
);

-- fines
CREATE TABLE fines (
    fine_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    loan_id INTEGER NOT NULL REFERENCES loans(loan_id),
    amount NUMERIC(6,2) NOT NULL CHECK (amount >= 0),
    paid BOOLEAN NOT NULL DEFAULT FALSE
);

```

---

### **A2 — INSERT esimerkkidata**

Lisää alla olevat rivit jokaiseen tauluun. **Älä sisällytä identity-sarakkeita** (PostgreSQL generoi ne). Lisää tässä järjestyksessä: books, authors, book_authors, members, loans, fines (jotta viiteavaimet ovat olemassa ennen viittausta).

**Lisättävä data:**

**books** (title, isbn, publication_year):

| title           | isbn              | publication_year |
| --------------- | ----------------- | ---------------- |
| The Great Novel | 978-0-00-000001-1 | 2020             |
| Databases 101   | 978-0-00-000002-2 | 2019             |
| Web Development | _(NULL)_          | 2021             |
| Algorithms      | 978-0-00-000004-4 | 2018             |

**authors** (full_name):

| full_name     |
| ------------- |
| Jane Smith    |
| Mika Virtanen |
| Aino Laine    |

**book_authors** (book_id, author_id):

| book_id | author_id |
| ------- | --------- |
| 1       | 1         |
| 1       | 2         |
| 2       | 1         |
| 2       | 2         |
| 3       | 2         |
| 3       | 3         |
| 4       | 3         |

**members** (full_name, email):

| full_name     | email           |
| ------------- | --------------- |
| Aino Laine    | aino@library.fi |
| Mika Virtanen | mika@library.fi |
| Sara Niemi    | _(NULL)_        |
| Olli Koski    | olli@gmail.com  |

**loans** (book_id, member_id, loan_date, due_date, return_date):

| book_id | member_id | loan_date  | due_date   | return_date |
| ------- | --------- | ---------- | ---------- | ----------- |
| 1       | 1         | 2024-01-01 | 2024-01-15 | 2024-01-10  |
| 2       | 1         | 2024-02-01 | 2024-02-15 | _(NULL)_    |
| 1       | 2         | 2024-01-10 | 2024-01-25 | 2024-01-20  |
| 3       | 2         | 2024-03-01 | 2024-03-15 | _(NULL)_    |
| 2       | 3         | 2024-02-10 | 2024-02-24 | 2024-02-20  |
| 4       | 4         | 2024-03-10 | 2024-03-24 | 2024-03-20  |

**fines** (loan_id, amount, paid):

| loan_id | amount | paid  |
| ------- | ------ | ----- |
| 1       | 2.00   | TRUE  |
| 3       | 5.50   | FALSE |
| 5       | 10.00  | TRUE  |
| 6       | 3.00   | FALSE |

**Kirjoita INSERT-lauseesi tähän:**

```sql
-- books
INSERT INTO books (title, isbn, publication_year) VALUES
('The Great Novel', '978-0-00-000001-1', 2020),
('Databases 101', '978-0-00-000002-2', 2019),
('Web Development', NULL, 2021),
('Algorithms', '978-0-00-000004-4', 2018);

-- authors
INSERT INTO authors (full_name) VALUES
('Jane Smith'),
('Mika Virtanen'),
('Aino Laine');

-- book_authors
INSERT INTO book_authors VALUES
(1,1),
(1,2),
(2,1),
(2,2),
(3,2),
(3,3),
(4,3);

-- members
INSERT INTO members (full_name, email) VALUES
('Aino Laine', 'aino@library.fi'),
('Mika Virtanen', 'mika@library.fi'),
('Sara Niemi', NULL),
('Olli Koski', 'olli@gmail.com');

-- loans
INSERT INTO loans (book_id, member_id, loan_date, due_date, return_date) VALUES
(1,1,'2024-01-01','2024-01-15','2024-01-10'),
(2,1,'2024-02-01','2024-02-15',NULL),
(1,2,'2024-01-10','2024-01-25','2024-01-20'),
(3,2,'2024-03-01','2024-03-15',NULL),
(2,3,'2024-02-10','2024-02-24','2024-02-20'),
(4,4,'2024-03-10','2024-03-24','2024-03-20');

-- fines
INSERT INTO fines (loan_id, amount, paid) VALUES
(1,2.00,TRUE),
(3,5.50,FALSE),
(5,10.00,TRUE),
(6,3.00,FALSE);

```

---

### **A3 — Perus SELECT (tarkistus)**

Suorita kaksi kyselyä varmistaaksesi, että data on paikallaan:

1. Valitse **kaikki sarakkeet** yhdestä taulusta (esim. `books` tai `members`).
2. Valitse **vain tietyt sarakkeet** toisesta taulusta (esim. `title` ja `publication_year` taulusta `books`).

**Kirjoita SELECT-lauseesi tähän:**

```sql
-- 1. Kaikki sarakkeet yhdestä taulusta
SELECT * FROM books;

-- 2. Tietyt sarakkeet toisesta taulusta
SELECT title, publication_year FROM books;

```

---

## **OSA B — Kyselyharjoitukset**

Perustuu tiedostoon [Materiaalit/06-SQL-perusteet-2.md](../../Materiaalit/06-SQL-perusteet-2.md). Käytä kirjaston skeemaa (Books, Authors, BookAuthors, Members, Loans, Fines). Kirjoita jokaiselle tehtävälle SQL vastaavaan koodilohkoon. Tarkista tulos **Odotus / Itsetarkistus** -vihjeen avulla.

---

### **B1 — WHERE (suodatus)**

**B1.1** Listaa kirjat, joiden `publication_year` on 2020.

_Odotus: 1 rivi (The Great Novel)._ Kyllä

```sql

SELECT * FROM books
WHERE publication_year = 2020;
```

---

**B1.2** Listaa jäsenet, joiden sähköposti **ei ole** `aino@library.fi`. (Muista: NULL-sähköposti ei tule tuloksiin.)

_Itsetarkistus: 2 riviä (Mika Virtanen, Olli Koski)._ Kyllä

```sql
SELECT * FROM members
WHERE email <> 'aino@library.fi';

```

---

**B1.3** Listaa sakot, joiden `amount` on suurempi kuin 5.

_Itsetarkistus: 2 riviä (5,50 ja 10,00)._ Kyllä

```sql
SELECT * FROM fines
WHERE amount > 5;

```

---

**B1.4** Listaa lainat, joissa `book_id` on 1 **TAI** `book_id` on 2.

_Itsetarkistus: 4 riviä._ Kyllä

```sql

SELECT * FROM loans
WHERE book_id = 1 OR book_id = 2;
```

---

**B1.5** Listaa jäsenet, joiden `member_id` IN (1, 3).

_Itsetarkistus: 2 riviä (Aino Laine, Sara Niemi)._ Kyllä

```sql

SELECT * FROM members
WHERE member_id IN (1,3);
```

---

**B1.6** Listaa kirjat, joiden `publication_year` on BETWEEN 2018 AND 2020 (molemmat mukaan lukien).

_Itsetarkistus: 3 riviä._ Kyllä

```sql

SELECT * FROM books
WHERE publication_year BETWEEN 2018 AND 2020;
```

---

**B1.7** Listaa jäsenet, joiden sähköposti päättyy `@library.fi`.

_Itsetarkistus: 2 riviä._ Kyllä

```sql

SELECT * FROM members
WHERE email LIKE '%@library.fi';
```

---

**B1.8** Listaa jäsenet, joilla **ei ole** sähköpostia (email IS NULL).

_Itsetarkistus: 1 rivi (Sara Niemi)._ Kyllä

```sql

SELECT * FROM members
WHERE email IS NULL;
```

---

**B1.9** Listaa lainat, jotka **eivät ole vielä palautettu** (return_date IS NULL).

_Itsetarkistus: 2 riviä._ Kyllä

```sql

SELECT * FROM loans
WHERE return_date IS NULL;
```

---

### **B2 — ORDER BY ja LIMIT**

**B2.1** Listaa kaikki kirjat järjestettynä `publication_year`-sarakkeen mukaan **laskevaan** järjestykseen, sitten `title`-sarakkeen mukaan **nousevaan** (tasatilanteissa).

_Itsetarkistus: Ensimmäinen rivi on Web Development (2021), sitten The Great Novel (2020), sitten Databases 101 (2019), sitten Algorithms (2018)._ Kyllä

```sql

SELECT * FROM books
ORDER BY publication_year DESC, title ASC;
```

---

**B2.2** Listaa **kaksi uusinta** kirjaa `publication_year`-sarakkeen mukaan (uusin ensin). Käytä ORDER BY ja LIMIT.

_Itsetarkistus: 2 riviä (Web Development, The Great Novel)._ Kyllä

```sql
SELECT * FROM books
ORDER BY publication_year DESC
LIMIT 2;

```

---

### **B3 — Aggregaatiot**

**B3.1** Kuinka monta kirjaa tietokannassa on? Käytä `COUNT(*)` ja anna tulosarakkeelle alias (esim. `book_count`).

_Itsetarkistus: 4._ Kyllä

```sql
SELECT COUNT(*) AS book_count FROM books;

```

---

**B3.2** Kuinka monella jäsenellä on sähköposti? Käytä `COUNT(email)`.

_Itsetarkistus: 3 (Saralla NULL-sähköposti)._ Kyllä

```sql

SELECT COUNT(email) FROM members;
```

---

**B3.3** Mikä on sakkojen **keskiarvo**? Käytä `AVG(amount)` aliasilla.

_Itsetarkistus: 5,125 (tai 5,13 pyöristyksestä riippuen)._ Kyllä

```sql
SELECT AVG(amount) FROM fines;

```

---

**B3.4** Mikä on **maksamattomien** sakkojen (paid = FALSE) **yhteissumma**? Käytä `SUM(amount)` ja WHERE.

_Itsetarkistus: 8,50 (5,50 + 3,00)._ Kyllä

```sql

SELECT SUM(amount) FROM fines
WHERE paid = FALSE;
```

---

### **B4 — GROUP BY ja HAVING**

**B4.1** Jokaiselle jäsenelle: näytä `member_id` ja **lainojen lukumäärä**. Käytä `GROUP BY member_id` ja `COUNT(*)` aliasilla (esim. `loan_count`). Järjestä `loan_count`:n mukaan laskevaan järjestykseen.

_Itsetarkistus: Jäsenellä 1 on 2 lainaa; jäsenillä 2, 3 ja 4 kullakin 1._ EI

```sql
SELECT member_id, COUNT(*) AS loan_count
FROM loans
GROUP BY member_id
ORDER BY loan_count DESC;


```

---

**B4.2** Listaa vain jäsenet, joilla on **vähintään 2 lainaa**. Käytä sama ryhmittely kuin B4.1 ja lisää `HAVING COUNT(*) >= 2`.

_Itsetarkistus: 1 rivi (member_id 1)._ EI

```sql

SELECT member_id, COUNT(*) AS loan_count
FROM loans
GROUP BY member_id
HAVING COUNT(*) >= 2;
```

---

**B4.3** Jokaiselle tekijälle: näytä `author_id` ja **kirjojen lukumäärä** (taulun `book_authors` kautta). Käytä `GROUP BY author_id`. Järjestä kirjojen määrän mukaan laskevaan järjestykseen.

_Itsetarkistus: Tekijöillä 2 ja 3 on kullakin 2 kirjaa; tekijällä 1 on 2 kirjaa._ EI

```sql
SELECT author_id, COUNT(*) AS book_count
FROM book_authors
GROUP BY author_id
ORDER BY book_count DESC;
```

---

### **B5 — Aliasit**

**B5.1** Laske lainojen kokonaislukumäärä. Käytä `COUNT(*) AS total_loans`.

_Itsetarkistus: 6._ Kyllä

```sql

SELECT COUNT(*) AS total_loans FROM loans;
```

---

**B5.2** Listaa jokainen laina **jäsenen koko nimen** ja **kirjan nimen** kanssa. Käytä JOINeja taulujen `loans`, `members` ja `books` välillä. Käytä **taulualias-nimiä** (esim. `l`, `m`, `b`). Järjestä jäsenen nimen, sitten kirjan nimen mukaan.

_Itsetarkistus: 6 riviä; ensimmäinen rivi voi olla Aino Laine kirjanimellä._

```sql
SELECT m.full_name, b.title
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN books b ON l.book_id = b.book_id
ORDER BY m.full_name, b.title;

```

---

### **B6 — Yhdistetty kysely (valinnainen)**

**B6.1** Listaa **jäsenen koko nimet**, joilla on **vähintään 2 lainaa**, sekä heidän lainamääränsä, järjestettynä lainamäärän mukaan **laskevaan** järjestykseen ja sitten nimen mukaan. Käytä JOIN(eja), GROUP BY, HAVING ja ORDER BY.

_Itsetarkistus: 1 rivi — Aino Laine, loan_count 2._

```sql


```

---

## **Itsetarkistus (validointi)**

Varmista seuraavat asiat:

1. Palauttaako B1.1 täsmälleen 1 rivin? Kyllä
2. Palauttaako B1.8 täsmälleen 1 rivin (Sara Niemi)? Kyllä
3. Palauttaako B3.1 arvon 4? Kyllä
4. Palauttaako B4.2 täsmälleen 1 rivin? EI
5. Palauttaako B5.1 arvon 6? Kyllä

---

_Harjoitus 3 loppuu tähän._
