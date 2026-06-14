-- FirstFrost: filtering and JOIN queries
-- Issue #13: analytics/13-filtering-joins

-- Block 1: ILIKE case-insensitive search
SELECT common_name, variety, current_stage
FROM public.plants
WHERE common_name ILIKE '%to%';
-- Result: Tomato, San Marzano, flowering

-- Block 2: IS NULL audit (plants with no data logs)
SELECT p.common_name, p.variety, p.current_stage
FROM public.plants p
LEFT JOIN public.data_logs dl ON p.id = dl.plant_id
WHERE dl.id IS NULL;
-- Result: 0 rows — both plants have logs from the 100K seed

-- Block 3: INNER JOIN (active readings feed)
SELECT p.common_name, dl.metric_type, dl.value, dl.unit, dl.logged_at
FROM public.plants p
INNER JOIN public.data_logs dl ON p.id = dl.plant_id
ORDER BY dl.logged_at DESC
LIMIT 5;
-- Result: 5 most recent logs across Tomato and Basil

-- Block 4: FULL OUTER JOIN (surface SET NULL orphan)
SELECT p.common_name, t.title, t.status, t.plant_id
FROM public.plants p
FULL OUTER JOIN public.tasks t ON p.id = t.plant_id
ORDER BY p.common_name NULLS LAST;
-- Result: 3 rows
-- Basil: no tasks (NULL right side)
-- Tomato: Feed tomatoes, valid plant_id
-- NULL: Check pH levels, plant_id NULL (orphan from Issue #6)