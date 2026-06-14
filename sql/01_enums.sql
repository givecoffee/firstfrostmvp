-- FirstFrost: ENUM types
-- Deploy before any tables. Tables reference these types as column definitions.
-- Issue #2: schema/2-enums

CREATE TYPE space_type AS ENUM ('outdoor', 'indoor', 'both');

CREATE TYPE growth_stage AS ENUM (
  'seed', 'seedling', 'vegetative',
  'flowering', 'fruiting', 'harvest', 'dormant'
);

CREATE TYPE metric_type AS ENUM ('ph', 'ec', 'temperature', 'humidity', 'custom');

CREATE TYPE task_status AS ENUM ('pending', 'complete', 'skipped');