-- FirstFrost: row-level security
-- Enable RLS on all five tables and deploy 15 policies.
-- data_logs has no UPDATE policy by design — append-only.
-- Issue #8: schema/8-rls-policies

-- Enable RLS
ALTER TABLE public.profiles   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.spaces     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.plants     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.data_logs  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tasks      ENABLE ROW LEVEL SECURITY;

-- PROFILES
CREATE POLICY "profiles_select_own" ON public.profiles
  FOR SELECT USING (auth.uid() = id);
CREATE POLICY "profiles_insert_own" ON public.profiles
  FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "profiles_update_own" ON public.profiles
  FOR UPDATE USING (auth.uid() = id);

-- SPACES
CREATE POLICY "spaces_select_own" ON public.spaces
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "spaces_insert_own" ON public.spaces
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "spaces_update_own" ON public.spaces
  FOR UPDATE USING (auth.uid() = user_id);

-- PLANTS
CREATE POLICY "plants_select_own" ON public.plants
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "plants_insert_own" ON public.plants
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "plants_update_own" ON public.plants
  FOR UPDATE USING (auth.uid() = user_id);

-- DATA LOGS: SELECT and INSERT only, no UPDATE
CREATE POLICY "data_logs_select_own" ON public.data_logs
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "data_logs_insert_own" ON public.data_logs
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- TASKS: full CRUD
CREATE POLICY "tasks_select_own" ON public.tasks
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "tasks_insert_own" ON public.tasks
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "tasks_update_own" ON public.tasks
  FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "tasks_delete_own" ON public.tasks
  FOR DELETE USING (auth.uid() = user_id);

-- Verification query
-- SELECT tablename, policyname, cmd
-- FROM pg_policies
-- WHERE schemaname = 'public'
-- ORDER BY tablename, policyname;
-- Expected: 15 rows

-- RLS status check
-- SELECT tablename, rowsecurity
-- FROM pg_tables
-- WHERE schemaname = 'public'
-- ORDER BY tablename;
-- Expected: all five tables show true