-- =========================================
-- indexes.sql
-- Edistyneempi vaihe
-- =========================================

-- 1. Reseptien haku kategorian mukaan
CREATE INDEX idx_recipe_category_category_id
ON recipe_category (category_id);

-- 2. Reseptin ainesosien listaus
CREATE INDEX idx_recipe_ingredient_recipe_id
ON recipe_ingredient (recipe_id);

-- 3. Reseptien haku ainesosan mukaan
CREATE INDEX idx_recipe_ingredient_ingredient_id
ON recipe_ingredient (ingredient_id);

-- 4. Ainesosien haku nimen mukaan
-- ingredient.name on jo UNIQUE ja sillä on index. 

-- 5. Ateriasuunnitelmien haku käyttäjän mukaan
CREATE INDEX idx_meal_plan_user_id
ON meal_plan (user_id);

-- 6. Ateriasuunnitelmarivien haku reseptin mukaan
CREATE INDEX idx_meal_plan_item_recipe_id
ON meal_plan_item (recipe_id);

-- 7. Bonus index ateriasuunnitelman hakemiseen. 
CREATE INDEX idx_meal_plan_item_meal_plan_id
ON meal_plan_item (meal_plan_id);