-- =========================================
-- schema_advanced.sql
-- Edistyneempi vaihe
-- Ajetaan perusskeeman paalle
-- =========================================

DROP TABLE IF EXISTS meal_plan_item;
DROP TABLE IF EXISTS meal_plan;
DROP TABLE IF EXISTS teacher;
DROP TABLE IF EXISTS app_user;

-- =========================
-- 1. Kayttajat
-- =========================

CREATE TABLE app_user (
    user_id      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name    VARCHAR(100) NOT NULL,
    email        VARCHAR(150) NOT NULL UNIQUE
);

-- =========================
-- 2. Opettajat
-- Teacher on kayttajan alityyppi
-- =========================

CREATE TABLE teacher (
    user_id      INTEGER PRIMARY KEY,

    CONSTRAINT fk_teacher_user
        FOREIGN KEY (user_id)
        REFERENCES app_user(user_id)
        ON DELETE CASCADE
);

-- =========================
-- 3. Ateriasuunnitelmat
-- =========================

CREATE TABLE meal_plan (
    meal_plan_id   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id        INTEGER NOT NULL,
    name           VARCHAR(150) NOT NULL,
    description    TEXT,
    created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_meal_plan_user
        FOREIGN KEY (user_id)
        REFERENCES app_user(user_id)
        ON DELETE CASCADE
);

-- =========================
-- 4. Ateriasuunnitelman rivit
-- Tallennetaan paikka:
-- paiva + ateriatyyppi + jarjestys
-- =========================

CREATE TABLE meal_plan_item (
    meal_plan_item_id   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    meal_plan_id        INTEGER NOT NULL,
    recipe_id           INTEGER NOT NULL,
    day_name            VARCHAR(20),
    meal_type           VARCHAR(30),
    position            INTEGER NOT NULL,

    CONSTRAINT chk_meal_plan_item_position
        CHECK (position >= 1),

    CONSTRAINT fk_meal_plan_item_meal_plan
        FOREIGN KEY (meal_plan_id)
        REFERENCES meal_plan(meal_plan_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_meal_plan_item_recipe
        FOREIGN KEY (recipe_id)
        REFERENCES recipe(recipe_id)
        ON DELETE RESTRICT,

    CONSTRAINT uq_meal_plan_item_position
        UNIQUE (meal_plan_id, position)
);