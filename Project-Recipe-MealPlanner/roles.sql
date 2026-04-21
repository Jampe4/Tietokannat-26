-- =========================================
-- roles.sql
-- Edistyneempi vaihe
-- PostgreSQL roles, users and grants
-- =========================================

-- -----------------------------------------
-- Tämä kannattaa ajaa vain kerran
-- tai muuten tarkistaa ensin olemassa olevat roolit.
-- -----------------------------------------

-- Mahdolliset vanhat esimerkkikäyttäjät/roolit pois
DROP ROLE IF EXISTS viewer_user1;
DROP ROLE IF EXISTS regular_user1;
DROP ROLE IF EXISTS teacher_user1;

DROP ROLE IF EXISTS viewer_role;
DROP ROLE IF EXISTS regular_user_role;
DROP ROLE IF EXISTS teacher_role;

-- =========================================
-- 1. Roolit
-- =========================================

CREATE ROLE teacher_role NOLOGIN;
CREATE ROLE regular_user_role NOLOGIN;
CREATE ROLE viewer_role NOLOGIN;

-- =========================================
-- 2. Esimerkkikäyttäjät
-- Vaihda salasanat tarvittaessa
-- =========================================

CREATE USER teacher_user1 WITH PASSWORD 'Teacher123!';
CREATE USER regular_user1 WITH PASSWORD 'User123!';
CREATE USER viewer_user1 WITH PASSWORD 'Viewer123!';

-- Annetaan roolit käyttäjille
GRANT teacher_role TO teacher_user1;
GRANT regular_user_role TO regular_user1;
GRANT viewer_role TO viewer_user1;

-- =========================================
-- 3. Skeeman käyttöoikeus
-- =========================================

GRANT USAGE ON SCHEMA public TO teacher_role;
GRANT USAGE ON SCHEMA public TO regular_user_role;
GRANT USAGE ON SCHEMA public TO viewer_role;

-- =========================================
-- 4. Opettajat
-- Saavat lukea, lisätä ja päivittää:
-- recipes, ingredients, categories
-- sekä liitostaulut
-- =========================================

GRANT SELECT, INSERT, UPDATE
ON recipe, ingredient, category, recipe_ingredient, recipe_category
TO teacher_role;

-- Tarvittaessa opettajat saavat lukea käyttäjätauluja
GRANT SELECT
ON app_user, teacher
TO teacher_role;

-- Identity/sequence-oikeudet lisäyksiä varten
GRANT USAGE, SELECT
ON ALL SEQUENCES IN SCHEMA public
TO teacher_role;

-- =========================================
-- 5. Tavalliset käyttäjät
-- Saavat lukea reseptejä, ainesosia, kategorioita
-- ja hallita meal plan -tauluja
-- =========================================

GRANT SELECT
ON recipe, ingredient, category, recipe_ingredient, recipe_category
TO regular_user_role;

GRANT SELECT, INSERT, UPDATE, DELETE
ON meal_plan, meal_plan_item
TO regular_user_role;

-- Tarvittaessa voivat lukea käyttäjiä
GRANT SELECT
ON app_user
TO regular_user_role;

-- Identity/sequence-oikeudet lisäyksiä varten
GRANT USAGE, SELECT
ON ALL SEQUENCES IN SCHEMA public
TO regular_user_role;

-- =========================================
-- 6. Katselijat
-- Saavat vain lukea kaikkia tauluja
-- =========================================

GRANT SELECT
ON recipe, ingredient, category, recipe_ingredient, recipe_category,
   app_user, teacher, meal_plan, meal_plan_item
TO viewer_role;