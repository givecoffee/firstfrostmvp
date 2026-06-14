-- FirstFrost: indexes
-- Deploy after seed data is in place.
-- Issue #11: perf/11-indexing

CREATE INDEX idx_spaces_user_id      ON public.spaces(user_id);
CREATE INDEX idx_plants_space_id     ON public.plants(space_id);
CREATE INDEX idx_plants_user_id      ON public.plants(user_id);
CREATE INDEX idx_data_logs_plant_id  ON public.data_logs(plant_id);
CREATE INDEX idx_data_logs_logged_at ON public.data_logs(logged_at DESC);
CREATE INDEX idx_data_logs_metric_type ON public.data_logs(metric_type);
CREATE INDEX idx_tasks_space_id      ON public.tasks(space_id);
CREATE INDEX idx_tasks_user_due      ON public.tasks(user_id, due_date);
CREATE INDEX idx_tasks_pending       ON public.tasks(user_id, due_date)
  WHERE status = 'pending';

-- Verification
-- SELECT indexname, tablename, indexdef
-- FROM pg_indexes
-- WHERE schemaname = 'public'
-- ORDER BY tablename, indexname;