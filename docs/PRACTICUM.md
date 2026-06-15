# Week 10: What the Season Taught Me

This is the final dev update for FirstFrost, my AD350 Database Technology capstone at North Seattle College. Ten weeks, one project, and a lot of SQL.

The goal going in was simple: take every concept from the course and apply it to something real instead of a series of disconnected exercises. Schema design, referential integrity, indexing, JSONB, JOIN queries, API testing. All of it, in one place, building on itself.

I was the sole developer. Designed and built the full backend from scratch.

---

## What Got Built

The schema is five tables: profiles, spaces, plants, data_logs, tasks. Each one feeds into the next. auth.users creates a profile on signup via trigger. Profiles own spaces. Spaces hold plants. Plants produce data logs. Tasks attach to spaces, optionally to a specific plant.

That hierarchy matters because the FK design determines what can and can't exist. ON DELETE CASCADE means deleting a space takes its plants with it. ON DELETE SET NULL on tasks.plant_id means deleting a plant leaves the task behind as a historical record. That distinction came up in the FULL OUTER JOIN query at the end and produced a legitimate orphaned row without manufacturing one.

Here is what shipped across the ten weeks:

- Provisioned PostgreSQL on Supabase, confirmed with SELECT version() -- PostgreSQL 17.6
- Four custom ENUM types: space_type, growth_stage, metric_type, task_status
- Five tables deployed in dependency order so FK references resolved without errors
- Schema evolution demo: ALTER TABLE, TRUNCATE vs DROP on a scratch table
- Referential integrity tests: illegal insert blocked by FK, CASCADE confirmed, SET NULL confirmed
- Three triggers: updated_at on every change, handle_new_user on signup, set_task_completed_at when a task completes
- RLS on all five tables, 15 policies, no UPDATE policy on data_logs by design
- 100K data_logs rows seeded with generate_series for performance testing
- B-Tree index on metric_type: Seq Scan at 34.07ms dropped to Index Scan at 8.64ms -- 74.6% faster, 3.9x speedup
- JSONB metadata column on plants with GIN index, two plants with structurally different data in the same column
- Filtering queries: ILIKE plant search, IS NULL audit, INNER JOIN, LEFT JOIN, FULL OUTER JOIN
- 14-request Postman collection: auth, full CRUD across all five tables, trigger verification, append-only enforcement

---

## What Broke and How It Got Fixed

Supabase's free tier rate-limits auth emails, which meant creating a second test user through the normal flow was not possible. The workaround was inserting directly into auth.users via SQL and setting passwords with crypt(). That worked for the first user. The second one hit a wall: the aud column was NULL on the record, which Supabase Auth requires to be set to authenticated. Setting it via SQL UPDATE did not resolve the login failure -- the auth service has its own caching layer that does not immediately reflect direct SQL changes.

The RLS cross-user test ended up being verified via SQL simulation instead of a second Postman user. The result was the same: querying Rae's spaces as the test user UUID returned 0 rows. The lesson is to create test users through the dashboard or the Admin API, not via direct SQL insert.

Schema ordering also caused early friction. ENUMs have to exist before tables reference them. Tables have to have seed data before FK integrity tests can run against real rows. RLS has to come after seeding, because enabling it first silently blocks all the inserts and nothing errors -- it just returns empty arrays. That last one took a moment to figure out.

---

## What Stuck

The FULL OUTER JOIN result at the end of Week 7 is the thing that made the whole project click. Three rows:

- Basil: plant exists, no tasks
- Tomato: plant with a valid task and a matching plant_id
- NULL: Check pH levels task, plant_id NULL

That NULL row is the task that survived when the Northern Lights plant was deleted in Issue 6. The schema produced it naturally through ON DELETE SET NULL. No manufactured data, no workaround. The design decision made weeks earlier showed up exactly where it was supposed to.

The other thing: RLS failures in PostgREST return 200 with an empty array, not 403. That is by design. If you are expecting an error code and getting a silent empty response, check your policies before assuming the query is wrong.
