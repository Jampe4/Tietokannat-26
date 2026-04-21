-- =========================================
-- seed_advanced.sql
-- Edistyneempi vaihe / esimerkkidata
-- Ajetaan perusskeeman + schema_advanced.sql:n jälkeen
-- =========================================

-- =========================
-- 1. Käyttäjät
-- vähintään 3
-- =========================

INSERT INTO app_user (full_name, email) VALUES
('Anna Virtanen', 'anna@example.com'),
('Mikko Laine', 'mikko@example.com'),
('Laura Korhonen', 'laura@example.com');

-- =========================
-- 2. Opettajat
-- vähintään 1
-- Laura on opettaja
-- =========================

INSERT INTO teacher (user_id)
SELECT user_id
FROM app_user
WHERE email = 'laura@example.com';

-- =========================
-- 3. Ateriasuunnitelmat
-- vähintään 2
-- =========================

INSERT INTO meal_plan (user_id, name, description)
SELECT user_id, 'Viikon arkiruokalista', 'Arkipäivien ateriasuunnitelma'
FROM app_user
WHERE email = 'anna@example.com';

INSERT INTO meal_plan (user_id, name, description)
SELECT user_id, 'Kevyt viikkomeny', 'Helppoja ja kevyitä aterioita viikolle'
FROM app_user
WHERE email = 'mikko@example.com';

-- =========================
-- 4. Ateriasuunnitelman rivit
-- vähintään 3 per ateriasuunnitelma
-- =========================

-- -------------------------
-- Viikon arkiruokalista
-- -------------------------

INSERT INTO meal_plan_item (meal_plan_id, recipe_id, day_name, meal_type, position)
SELECT mp.meal_plan_id, r.recipe_id, 'Maanantai', 'Lounas', 1
FROM meal_plan mp, recipe r
WHERE mp.name = 'Viikon arkiruokalista'
  AND r.name = 'Kanariisi';

INSERT INTO meal_plan_item (meal_plan_id, recipe_id, day_name, meal_type, position)
SELECT mp.meal_plan_id, r.recipe_id, 'Tiistai', 'Päivällinen', 2
FROM meal_plan mp, recipe r
WHERE mp.name = 'Viikon arkiruokalista'
  AND r.name = 'Tomaattikeitto';

INSERT INTO meal_plan_item (meal_plan_id, recipe_id, day_name, meal_type, position)
SELECT mp.meal_plan_id, r.recipe_id, 'Keskiviikko', 'Päivällinen', 3
FROM meal_plan mp, recipe r
WHERE mp.name = 'Viikon arkiruokalista'
  AND r.name = 'Kasvispasta';

-- -------------------------
-- Kevyt viikkomeny
-- -------------------------

INSERT INTO meal_plan_item (meal_plan_id, recipe_id, day_name, meal_type, position)
SELECT mp.meal_plan_id, r.recipe_id, 'Torstai', 'Aamiainen', 1
FROM meal_plan mp, recipe r
WHERE mp.name = 'Kevyt viikkomeny'
  AND r.name = 'Munakas';

INSERT INTO meal_plan_item (meal_plan_id, recipe_id, day_name, meal_type, position)
SELECT mp.meal_plan_id, r.recipe_id, 'Perjantai', 'Aamiainen', 2
FROM meal_plan mp, recipe r
WHERE mp.name = 'Kevyt viikkomeny'
  AND r.name = 'Riisipuuro';

INSERT INTO meal_plan_item (meal_plan_id, recipe_id, day_name, meal_type, position)
SELECT mp.meal_plan_id, r.recipe_id, 'Lauantai', 'Jälkiruoka', 3
FROM meal_plan mp, recipe r
WHERE mp.name = 'Kevyt viikkomeny'
  AND r.name = 'Pannukakku';