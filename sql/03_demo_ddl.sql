-- FirstFrost: schema evolution demo
-- Demonstrates ALTER TABLE, TRUNCATE vs DROP on a scratch table.
-- None of this touches FirstFrost tables.
-- Issue #4: schema/4-evolution-demo

-- Block 1: create and populate
CREATE TABLE scratch_demo (
  id    SERIAL PRIMARY KEY,
  name  TEXT
);

INSERT INTO scratch_demo (name)
VALUES ('tomato'), ('basil'), ('pepper');

SELECT * FROM scratch_demo;

-- Block 2: ALTER TABLE, add a column
ALTER TABLE scratch_demo
ADD COLUMN planted_date DATE;

SELECT * FROM scratch_demo;

-- Block 3: TRUNCATE removes data, structure remains
TRUNCATE TABLE scratch_demo;

SELECT * FROM scratch_demo;
-- Result: 0 rows, table still exists

-- Block 4: DROP removes the table entirely
DROP TABLE scratch_demo;

SELECT * FROM scratch_demo;
-- Result: should get eRROR 42P01: relation "scratch_demo" does not exist