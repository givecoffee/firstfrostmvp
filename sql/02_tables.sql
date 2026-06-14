-- FirstFrost: core tables
-- Run after 01_enums.sql. Tables reference ENUMs defined there.
-- Issue #3: schema/3-tables

CREATE TABLE public.profiles (
  id            UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name  TEXT,
  location_zip  TEXT,
  units         TEXT NOT NULL DEFAULT 'imperial'
                  CHECK (units IN ('imperial', 'metric')),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE public.spaces (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  name        TEXT NOT NULL CHECK (char_length(name) BETWEEN 1 AND 100),
  space_type  space_type NOT NULL DEFAULT 'outdoor',
  description TEXT,
  is_active   BOOLEAN NOT NULL DEFAULT true,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE public.plants (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  space_id       UUID NOT NULL REFERENCES public.spaces(id) ON DELETE CASCADE,
  user_id        UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  common_name    TEXT NOT NULL CHECK (char_length(common_name) BETWEEN 1 AND 100),
  variety        TEXT,
  planted_date   DATE,
  current_stage  growth_stage NOT NULL DEFAULT 'seed',
  is_active      BOOLEAN NOT NULL DEFAULT true,
  notes          TEXT,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE public.data_logs (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  plant_id     UUID NOT NULL REFERENCES public.plants(id) ON DELETE CASCADE,
  user_id      UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  metric_type  metric_type NOT NULL,
  metric_label TEXT,
  value        NUMERIC NOT NULL,
  unit         TEXT NOT NULL,
  notes        TEXT,
  logged_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE public.tasks (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  space_id     UUID NOT NULL REFERENCES public.spaces(id) ON DELETE CASCADE,
  user_id      UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  plant_id     UUID REFERENCES public.plants(id) ON DELETE SET NULL,
  title        TEXT NOT NULL CHECK (char_length(title) BETWEEN 1 AND 200),
  due_date     DATE,
  status       task_status NOT NULL DEFAULT 'pending',
  completed_at TIMESTAMPTZ,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);
