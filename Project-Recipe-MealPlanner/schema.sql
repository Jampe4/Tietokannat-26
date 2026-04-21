-- =========================
-- schema.sql
-- Recipe & Meal Planner DB
-- Perusvaihe
-- =========================

-- Poistetaan taulut, jos ne ovat jo olemassa
DROP TABLE IF EXISTS recipe_ingredient;
DROP TABLE IF EXISTS recipe_category;
DROP TABLE IF EXISTS ingredient;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS recipe;

-- =========================
-- 1. Päätaulut
-- =========================

CREATE TABLE recipe (
    recipe_id      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name           VARCHAR(150) NOT NULL,
    instructions   TEXT,
    prepare_time   INTEGER,
    serving_count  INTEGER,

    CONSTRAINT chk_recipe_prepare_time
        CHECK (prepare_time IS NULL OR prepare_time >= 0),

    CONSTRAINT chk_recipe_serving_count
        CHECK (serving_count IS NULL OR serving_count >= 1)
);

CREATE TABLE category (
    category_id    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name           VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE ingredient (
    ingredient_id  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name           VARCHAR(100) NOT NULL UNIQUE,
    default_unit   VARCHAR(20)
);

-- =========================
-- 2. Liitostaulut
-- =========================

CREATE TABLE recipe_category (
    recipe_id      INTEGER NOT NULL,
    category_id    INTEGER NOT NULL,

    CONSTRAINT pk_recipe_category
        PRIMARY KEY (recipe_id, category_id),

    CONSTRAINT fk_recipe_category_recipe
        FOREIGN KEY (recipe_id)
        REFERENCES recipe(recipe_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_recipe_category_category
        FOREIGN KEY (category_id)
        REFERENCES category(category_id)
        ON DELETE CASCADE
);

CREATE TABLE recipe_ingredient (
    recipe_id      INTEGER NOT NULL,
    ingredient_id  INTEGER NOT NULL,
    amount         NUMERIC(10,2) NOT NULL,
    unit           VARCHAR(20) NOT NULL,

    CONSTRAINT pk_recipe_ingredient
        PRIMARY KEY (recipe_id, ingredient_id),

    CONSTRAINT chk_recipe_ingredient_amount
        CHECK (amount > 0),

    CONSTRAINT fk_recipe_ingredient_recipe
        FOREIGN KEY (recipe_id)
        REFERENCES recipe(recipe_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_recipe_ingredient_ingredient
        FOREIGN KEY (ingredient_id)
        REFERENCES ingredient(ingredient_id)
        ON DELETE RESTRICT
);