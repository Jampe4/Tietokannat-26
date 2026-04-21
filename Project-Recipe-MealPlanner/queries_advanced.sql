-- =========================================
-- queries_advanced.sql
-- Edistyneempi vaihe / lisäkyselyt
-- =========================================

-- 1. Ateriasuunnitelmat käyttäjällä
-- Listaa kaikki ateriasuunnitelmat omistajineen.
-- Järjestys: omistaja, sitten ateriasuunnitelman nimi.

SELECT
    u.full_name AS user_name,
    mp.name AS meal_plan_name
FROM app_user u
JOIN meal_plan mp ON u.user_id = mp.user_id
ORDER BY u.full_name, mp.name;


-- 2. Reseptit ateriasuunnitelmassa
-- Näytä valitun ateriasuunnitelman reseptit, kategoriat ja paikka.
-- Esimerkkinä ateriasuunnitelma 'Viikon arkiruokalista'.

SELECT
    mp.name AS meal_plan_name,
    mpi.day_name,
    mpi.meal_type,
    mpi.position,
    r.name AS recipe_name,
    c.name AS category_name
FROM meal_plan mp
JOIN meal_plan_item mpi ON mp.meal_plan_id = mpi.meal_plan_id
JOIN recipe r ON mpi.recipe_id = r.recipe_id
JOIN recipe_category rc ON r.recipe_id = rc.recipe_id
JOIN category c ON rc.category_id = c.category_id
WHERE mp.name = 'Viikon arkiruokalista'
ORDER BY mpi.position, r.name, c.name;


-- 3. Käyttäjät ateriasuunnitelmalukumäärineen
-- Näytä jokaiselle käyttäjälle käyttäjän nimi ja ateriasuunnitelmien määrä.
-- Mukaan myös käyttäjät, joilla ei ole ateriasuunnitelmia.

SELECT
    u.full_name AS user_name,
    COUNT(mp.meal_plan_id) AS meal_plan_count
FROM app_user u
LEFT JOIN meal_plan mp ON u.user_id = mp.user_id
GROUP BY u.user_id, u.full_name
ORDER BY meal_plan_count DESC, u.full_name;

SELECT * FROM app_user;
SELECT * FROM meal_plan;
SELECT * FROM meal_plan_item;