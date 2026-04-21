-- =========================
-- seed.sql
-- Recipe & Meal Planner DB
-- Perusvaihe / esimerkkidata
-- =========================

-- =========================
-- 1. Kategoriat
-- vähintään 4
-- =========================

INSERT INTO category (name) VALUES
('Aamiainen'),
('Pääruoka'),
('Jälkiruoka'),
('Keitto'),
('Kasvis');

-- =========================
-- 2. Ainesosat
-- vähintään 12
-- =========================

INSERT INTO ingredient (name, default_unit) VALUES
('Jauho', 'g'),
('Maito', 'ml'),
('Muna', 'kpl'),
('Sokeri', 'g'),
('Suola', 'g'),
('Voi', 'g'),
('Kana', 'g'),
('Riisi', 'g'),
('Tomaatti', 'kpl'),
('Sipuli', 'kpl'),
('Valkosipuli', 'kpl'),
('Oliiviöljy', 'ml'),
('Pasta', 'g'),
('Kasvisliemi', 'ml'),
('Kaneli', 'g');

-- =========================
-- 3. Reseptit
-- vähintään 6
-- =========================

INSERT INTO recipe (name, instructions, prepare_time, serving_count) VALUES
(
    'Pannukakku',
    'Sekoita ainekset kulhossa. Paista taikina pannulla molemmin puolin kypsäksi.',
    20,
    4
),
(
    'Kanariisi',
    'Kypsennä riisi. Paista kana pannulla ja tarjoile riisin kanssa.',
    35,
    3
),
(
    'Tomaattikeitto',
    'Kuullota sipuli ja valkosipuli. Lisää tomaatit ja kasvisliemi, keitä ja soseuta.',
    30,
    4
),
(
    'Kasvispasta',
    'Keitä pasta. Paista vihannekset pannulla ja sekoita pastan joukkoon.',
    25,
    2
),
(
    'Munakas',
    'Vatkaa munat, lisää maito ja suola. Paista pannulla kypsäksi.',
    10,
    1
),
(
    'Riisipuuro',
    'Keitä riisi maidossa miedolla lämmöllä. Lisää lopuksi hieman suolaa.',
    40,
    4
);

-- =========================
-- 4. Resepti-kategoria-liitokset
-- vähintään 15
-- jokaisella reseptillä vähintään 1 kategoria
-- vähintään 2 reseptillä useita kategorioita
-- =========================

-- Pannukakku
INSERT INTO recipe_category (recipe_id, category_id)
SELECT r.recipe_id, c.category_id
FROM recipe r, category c
WHERE r.name = 'Pannukakku' AND c.name = 'Aamiainen';

INSERT INTO recipe_category (recipe_id, category_id)
SELECT r.recipe_id, c.category_id
FROM recipe r, category c
WHERE r.name = 'Pannukakku' AND c.name = 'Jälkiruoka';

-- Kanariisi
INSERT INTO recipe_category (recipe_id, category_id)
SELECT r.recipe_id, c.category_id
FROM recipe r, category c
WHERE r.name = 'Kanariisi' AND c.name = 'Pääruoka';

-- Tomaattikeitto
INSERT INTO recipe_category (recipe_id, category_id)
SELECT r.recipe_id, c.category_id
FROM recipe r, category c
WHERE r.name = 'Tomaattikeitto' AND c.name = 'Keitto';

INSERT INTO recipe_category (recipe_id, category_id)
SELECT r.recipe_id, c.category_id
FROM recipe r, category c
WHERE r.name = 'Tomaattikeitto' AND c.name = 'Kasvis';

-- Kasvispasta
INSERT INTO recipe_category (recipe_id, category_id)
SELECT r.recipe_id, c.category_id
FROM recipe r, category c
WHERE r.name = 'Kasvispasta' AND c.name = 'Pääruoka';

INSERT INTO recipe_category (recipe_id, category_id)
SELECT r.recipe_id, c.category_id
FROM recipe r, category c
WHERE r.name = 'Kasvispasta' AND c.name = 'Kasvis';

-- Munakas
INSERT INTO recipe_category (recipe_id, category_id)
SELECT r.recipe_id, c.category_id
FROM recipe r, category c
WHERE r.name = 'Munakas' AND c.name = 'Aamiainen';

INSERT INTO recipe_category (recipe_id, category_id)
SELECT r.recipe_id, c.category_id
FROM recipe r, category c
WHERE r.name = 'Munakas' AND c.name = 'Pääruoka';

-- Riisipuuro
INSERT INTO recipe_category (recipe_id, category_id)
SELECT r.recipe_id, c.category_id
FROM recipe r, category c
WHERE r.name = 'Riisipuuro' AND c.name = 'Aamiainen';

INSERT INTO recipe_category (recipe_id, category_id)
SELECT r.recipe_id, c.category_id
FROM recipe r, category c
WHERE r.name = 'Riisipuuro' AND c.name = 'Jälkiruoka';

-- Lisätään vielä lisää, jotta saadaan vähintään 15 liitosta
INSERT INTO recipe_category (recipe_id, category_id)
SELECT r.recipe_id, c.category_id
FROM recipe r, category c
WHERE r.name = 'Kanariisi' AND c.name = 'Aamiainen';

INSERT INTO recipe_category (recipe_id, category_id)
SELECT r.recipe_id, c.category_id
FROM recipe r, category c
WHERE r.name = 'Kasvispasta' AND c.name = 'Aamiainen';

INSERT INTO recipe_category (recipe_id, category_id)
SELECT r.recipe_id, c.category_id
FROM recipe r, category c
WHERE r.name = 'Pannukakku' AND c.name = 'Pääruoka';

INSERT INTO recipe_category (recipe_id, category_id)
SELECT r.recipe_id, c.category_id
FROM recipe r, category c
WHERE r.name = 'Riisipuuro' AND c.name = 'Kasvis';

-- =========================
-- 5. Resepti-ainesosa-liitokset
-- vähintään 15
-- jokaisella reseptillä vähintään 2 ainesosaa
-- =========================

-- Pannukakku
INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 200, 'g'
FROM recipe r, ingredient i
WHERE r.name = 'Pannukakku' AND i.name = 'Jauho';

INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 500, 'ml'
FROM recipe r, ingredient i
WHERE r.name = 'Pannukakku' AND i.name = 'Maito';

INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 2, 'kpl'
FROM recipe r, ingredient i
WHERE r.name = 'Pannukakku' AND i.name = 'Muna';

INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 30, 'g'
FROM recipe r, ingredient i
WHERE r.name = 'Pannukakku' AND i.name = 'Sokeri';

-- Kanariisi
INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 300, 'g'
FROM recipe r, ingredient i
WHERE r.name = 'Kanariisi' AND i.name = 'Kana';

INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 200, 'g'
FROM recipe r, ingredient i
WHERE r.name = 'Kanariisi' AND i.name = 'Riisi';

INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 10, 'ml'
FROM recipe r, ingredient i
WHERE r.name = 'Kanariisi' AND i.name = 'Oliiviöljy';

INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 1, 'kpl'
FROM recipe r, ingredient i
WHERE r.name = 'Kanariisi' AND i.name = 'Sipuli';

-- Tomaattikeitto
INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 4, 'kpl'
FROM recipe r, ingredient i
WHERE r.name = 'Tomaattikeitto' AND i.name = 'Tomaatti';

INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 1, 'kpl'
FROM recipe r, ingredient i
WHERE r.name = 'Tomaattikeitto' AND i.name = 'Sipuli';

INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 2, 'kpl'
FROM recipe r, ingredient i
WHERE r.name = 'Tomaattikeitto' AND i.name = 'Valkosipuli';

INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 700, 'ml'
FROM recipe r, ingredient i
WHERE r.name = 'Tomaattikeitto' AND i.name = 'Kasvisliemi';

-- Kasvispasta
INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 250, 'g'
FROM recipe r, ingredient i
WHERE r.name = 'Kasvispasta' AND i.name = 'Pasta';

INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 2, 'kpl'
FROM recipe r, ingredient i
WHERE r.name = 'Kasvispasta' AND i.name = 'Tomaatti';

INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 1, 'kpl'
FROM recipe r, ingredient i
WHERE r.name = 'Kasvispasta' AND i.name = 'Sipuli';

INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 15, 'ml'
FROM recipe r, ingredient i
WHERE r.name = 'Kasvispasta' AND i.name = 'Oliiviöljy';

-- Munakas
INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 3, 'kpl'
FROM recipe r, ingredient i
WHERE r.name = 'Munakas' AND i.name = 'Muna';

INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 50, 'ml'
FROM recipe r, ingredient i
WHERE r.name = 'Munakas' AND i.name = 'Maito';

INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 2, 'g'
FROM recipe r, ingredient i
WHERE r.name = 'Munakas' AND i.name = 'Suola';

INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 10, 'g'
FROM recipe r, ingredient i
WHERE r.name = 'Munakas' AND i.name = 'Voi';

-- Riisipuuro
INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 180, 'g'
FROM recipe r, ingredient i
WHERE r.name = 'Riisipuuro' AND i.name = 'Riisi';

INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 1000, 'ml'
FROM recipe r, ingredient i
WHERE r.name = 'Riisipuuro' AND i.name = 'Maito';

INSERT INTO recipe_ingredient (recipe_id, ingredient_id, amount, unit)
SELECT r.recipe_id, i.ingredient_id, 3, 'g'
FROM recipe r, ingredient i
WHERE r.name = 'Riisipuuro' AND i.name = 'Suola';

SELECT * FROM category;
SELECT * FROM ingredient;
SELECT * FROM recipe;
SELECT * FROM recipe_category;
SELECT * FROM recipe_ingredient;

