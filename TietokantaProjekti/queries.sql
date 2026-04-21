-- =========================================
-- queries.sql
-- Perusvaiheen 6 kyselyä
-- =========================================

-- 1. Reseptit kategorioineen
-- Listaa kaikki reseptit kategorianimineen.
-- Järjestys: kategorian nimi, sitten reseptin nimi.

SELECT
    c.name AS category_name,
    r.name AS recipe_name
FROM recipe r
JOIN recipe_category rc ON r.recipe_id = rc.recipe_id
JOIN category c ON rc.category_id = c.category_id
ORDER BY c.name, r.name;


-- 2. Reseptin ainesosat
-- Näytä valitun reseptin ainesosan nimi, määrä ja yksikkö.
-- Esimerkiksi 'Pannukakku'.

SELECT
    i.name AS ingredient_name,
    ri.amount,
    ri.unit
FROM recipe r
JOIN recipe_ingredient ri ON r.recipe_id = ri.recipe_id
JOIN ingredient i ON ri.ingredient_id = i.ingredient_id
WHERE r.name = 'Pannukakku'
ORDER BY i.name;


-- 3. Reseptit, joissa on tietty ainesosa
-- Listaa kaikki reseptit, joissa käytetään valittua ainesosaa.
-- Esimerkiksi ainesosa 'Jauho'.

SELECT
    r.name AS recipe_name,
    c.name AS category_name
FROM ingredient i
JOIN recipe_ingredient ri ON i.ingredient_id = ri.ingredient_id
JOIN recipe r ON ri.recipe_id = r.recipe_id
JOIN recipe_category rc ON r.recipe_id = rc.recipe_id
JOIN category c ON rc.category_id = c.category_id
WHERE i.name = 'Jauho'
ORDER BY r.name, c.name;


-- 4. Ainesosamäärä per resepti
-- Näytä jokaiselle reseptille käytettyjen ainesosien lukumäärä.
-- Järjestys eniten ainesosia sisältävistä alkaen.

SELECT
    r.name AS recipe_name,
    COUNT(ri.ingredient_id) AS ingredient_count
FROM recipe r
LEFT JOIN recipe_ingredient ri ON r.recipe_id = ri.recipe_id
GROUP BY r.recipe_id, r.name
ORDER BY ingredient_count DESC, r.name;


-- 5. Käyttämättömät ainesosat
-- Listaa ainesosat, joita ei käytetä missään reseptissä.

SELECT
    i.name AS unused_ingredient
FROM ingredient i
LEFT JOIN recipe_ingredient ri ON i.ingredient_id = ri.ingredient_id
WHERE ri.recipe_id IS NULL
ORDER BY i.name;

-- 6. Keskimääräinen valmistusaika kategorialla
-- Näytä kategorian nimi ja sen reseptien keskimääräinen valmistusaika.
-- Mukaan myös kategoriat, joilla ei ole reseptejä tai valmistusaikoja.

SELECT
    c.name AS category_name,
    AVG(r.prepare_time) AS average_prepare_time
FROM category c
LEFT JOIN recipe_category rc ON c.category_id = rc.category_id
LEFT JOIN recipe r ON rc.recipe_id = r.recipe_id
GROUP BY c.category_id, c.name
ORDER BY average_prepare_time DESC NULLS LAST, c.name;