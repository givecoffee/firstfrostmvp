# FirstFrost

Grow-tracking backend for outdoor gardeners and hydroponic growers. Building a first edition alongside the AD350 Database Technology course at North Seattle.

Users organize plants into spaces, log sensor readings, and track care tasks. This repo covers the backend only: schema design, Supabase configuration, and a Postman test suite that exercises every concept from the course.

---

## Stack

| Layer | Technology |
|-------|-----------|
| Database | PostgreSQL (Supabase managed) |
| API | PostgREST (auto-generated REST from schema) |
| Auth | Supabase Auth (JWT) |
| Security | Row-level security policies |
| Testing | Postman |

---

## Schema

Five tables. Three levels of nesting. Every arrow is a foreign key.

```
auth.users
    └──< profiles
             └──< spaces
                      ├──< plants
                      │        └──< data_logs  (append-only)
                      └──< tasks
```

### Tables

| Table | Purpose |
|-------|---------|
| `profiles` | One row per user, extends auth.users |
| `spaces` | Growing environments: raised beds, grow tents, windowsills |
| `plants` | Crops growing inside a space |
| `data_logs` | Sensor readings tied to a plant, append-only |
| `tasks` | Care reminders tied to a space, optionally to a plant |

### ENUMs

| Type | Values |
|------|--------|
| `space_type` | outdoor, indoor, both |
| `growth_stage` | seed, seedling, vegetative, flowering, fruiting, harvest, dormant |
| `metric_type` | ph, ec, temperature, humidity, custom |
| `task_status` | pending, complete, skipped |

### Key design decisions

- UUID primary keys via `gen_random_uuid()` — no sequential IDs exposed
- `NUMERIC` for sensor values — exact decimal precision, no float rounding
- `TIMESTAMPTZ` for all timestamps — UTC stored, timezone-aware
- `DATE` for `planted_date` — calendar date only, no false time precision
- `tasks.plant_id` is nullable with `ON DELETE SET NULL` — deleting a plant preserves task history
- `data_logs` is append-only — no `UPDATE` policy deployed by design
- `completed_at` on tasks is set by trigger, never by the client

---

## Repository Structure

```
firstfrostmvp/
├── sql/
│   ├── 01_enums.sql
│   ├── 02_tables.sql
│   ├── 03_demo_ddl.sql
│   ├── 04_seed.sql
│   ├── 05_integrity_tests.sql
│   ├── 06_triggers.sql
│   ├── 07_rls.sql
│   ├── 08_verify.sql
│   ├── 09_seed_perf.sql
│   ├── 10_indexes.sql
│   ├── 11_jsonb.sql
│   └── 12_queries.sql
├── postman/
│   └── firstfrost.postman_collection.json
├── docs/
│   └── type-decisions.md
├── DEVLOG.md
├── CHANGELOG.md
└── README.md
```

---

## Setup

### 1. Supabase project

Create a new project at [supabase.com](https://supabase.com) named `xxxx`. Select the region closest to you. Save the database password somewhere secure.

From **Settings → API**, copy the Project URL and anon key. You will need both for the Postman environment.

### 2. Run SQL in order

Open the Supabase SQL Editor and run each file from the `sql/` directory in numbered order. Do not skip steps — later files depend on earlier ones.

### 3. Postman

Import `postman/firstfrost.postman_collection.json`. Create an environment with:

| Variable | Value |
|----------|-------|
| `baseUrl` | Your Supabase Project URL |
| `anonKey` | Your Supabase anon key |
| `accessToken` | Set automatically by pre-request script after auth |

Run the auth request first to populate `accessToken`, then work through the collection in order.

---

## Notes

Supabase pauses free tier projects after 7 days of inactivity. Data is preserved — resume from the dashboard.

The `service_role` key bypasses RLS entirely. Do not put it in the Postman collection.

---

## Related

- [Wiki](../../wiki) — build log, schema notes, Postman notes, blockers and fixes
- [Build plan](firstfrost-build-plan.md) — nine-step build order
- [AD350 course repo](https://github.com/givecoffee/AD350)
