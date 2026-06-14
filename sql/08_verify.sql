-- FirstFrost: schema verification
-- Run after all schema, triggers, and RLS are deployed.
-- Issue #9: 9-schema-verification

-- Tables: expect 5
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- Foreign keys: expect 8
SELECT
  tc.table_name,
  kcu.column_name,
  ccu.table_name AS referenced_table
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu
  ON tc.constraint_name = ccu.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_schema = 'public'
ORDER BY tc.table_name;

-- Triggers: expect 6
SELECT trigger_name, event_object_table
FROM information_schema.triggers
WHERE trigger_schema = 'public'
   OR trigger_schema = 'auth'
ORDER BY event_object_table, trigger_name;

-- Policies: expect 15
SELECT tablename, policyname, cmd
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;