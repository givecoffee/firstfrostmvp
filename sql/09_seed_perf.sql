-- FirstFrost: performance seed
-- Inserts 100,000 randomized data_logs rows for EXPLAIN ANALYZE testing.
-- Run after 04_seed.sql. References plants seeded in that file.
-- Issue #10: 10-seed-performance-data

INSERT INTO public.data_logs (plant_id, user_id, metric_type, metric_label, value, unit, logged_at)
SELECT
  CASE WHEN random() < 0.5
    THEN 'bbbbbbbb-0000-0000-0000-000000000001'::uuid
    ELSE 'bbbbbbbb-0000-0000-0000-000000000002'::uuid
  END AS plant_id,
  'b8b9ec50-6b0a-4c59-aaaa-8effecf78903'::uuid AS user_id,
  (ARRAY['ph','ec','temperature','humidity'])[floor(random() * 4 + 1)::int]::metric_type AS metric_type,
  NULL AS metric_label,
  round((random() * 100)::numeric, 2) AS value,
  (ARRAY['pH','mS/cm','F','%'])[floor(random() * 4 + 1)::int] AS unit,
  now() - (random() * interval '365 days') AS logged_at
FROM generate_series(1, 100000);

-- Verification
-- SELECT COUNT(*) FROM public.data_logs;
-- Expected: 100,004 (100,000 + 4 from baseline seed)

-- Distribution check
-- SELECT metric_type, COUNT(*)
-- FROM public.data_logs
-- GROUP BY metric_type
-- ORDER BY metric_type;
-- Expected: roughly 25,000 rows per metric_type