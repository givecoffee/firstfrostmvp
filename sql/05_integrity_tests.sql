-- FirstFrost: referential integrity tests
-- Proves FK constraints, CASCADE, and SET NULL behavior.
-- Issue #6: 6-referential-integrity-tests

-- Block 1: illegal insert (FK violation)
-- Attempts to insert a data_log referencing a plant_id that does not exist.
INSERT INTO public.data_logs (plant_id, user_id, metric_type, value, unit)
VALUES (
  'ffffffff-ffff-ffff-ffff-ffffffffffff',
  'b8b9ec50-6b0a-4c59-aaaa-8effecf78903',
  'ph',
  7.0,
  'pH'
);
-- Expected: ERROR on foreign key constraint violation

-- Block 2: CASCADE delete
-- Check plants in Windowsill space before deleting
SELECT id, common_name FROM public.plants
WHERE space_id = 'aaaaaaaa-0000-0000-0000-000000000003';

-- Delete the space
DELETE FROM public.spaces
WHERE id = 'aaaaaaaa-0000-0000-0000-000000000003';

-- Confirm plant is gone
SELECT id, common_name FROM public.plants
WHERE space_id = 'aaaaaaaa-0000-0000-0000-000000000003';
-- Expected: 0 rows

-- Block 3: SET NULL
-- Check task before deleting plant
SELECT id, title, plant_id FROM public.tasks
WHERE plant_id = 'bbbbbbbb-0000-0000-0000-000000000003';

-- Delete the plant
DELETE FROM public.plants
WHERE id = 'bbbbbbbb-0000-0000-0000-000000000003';

-- Confirm task survived with plant_id NULL
SELECT id, title, plant_id FROM public.tasks
WHERE title = 'Check pH levels';
-- Expected: task exists, plant_id is NULL