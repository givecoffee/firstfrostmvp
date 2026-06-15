# FirstFrost: A Practicum Reflection

Ten weeks ago I started AD350 Database Technology at North Seattle College with a Supabase project named DB-Tech-Week-1 and a SELECT version() query. This week I submitted the capstone.

The project is called FirstFrost. It is a grow-tracking backend for gardeners and hydroponic growers. The idea came from a real problem: most gardening apps are reminder systems. They tell you when to water. They do not help you understand why your pH is drifting or what your EC readings looked like three weeks before a plant went sideways. FirstFrost is built around environmental logging -- the kind of data that actually explains what is happening in a grow.

The backend is PostgreSQL on Supabase, accessed through PostgREST, secured with row-level security, and tested with a 14-request Postman collection. 

---

## Why Build Something Real

The course covered ten weeks of database concepts. Each week had its own assignment -- CREATE TABLE one week, foreign keys the next, indexing after that. They were good exercises, but they were isolated. I wanted to see what it looked like when everything connected.

So instead of treating each week as a standalone deliverable, I built FirstFrost as a single project that grew week by week. The schema from Week 2 is the same schema the JOIN queries run against in Week 7. The seed data from Week 3 is what the EXPLAIN ANALYZE results are measured against in Week 5. The foreign key decisions from Week 4 produce the legitimate orphaned task that surfaces in the FULL OUTER JOIN in Week 8.

That continuity changed how the concepts landed. Referential integrity is not abstract when you can see that deleting a space removes four plants and sixteen data logs in one operation, and a task that referenced one of those plants is still sitting there with a NULL where the plant used to be.

---

## What Got Built

The schema is five tables: profiles, spaces, plants, data_logs, tasks. The hierarchy runs from auth.users down through profiles and spaces to plants, with data_logs and tasks branching off plants and spaces respectively.

Every column type was a deliberate choice. UUID primary keys over SERIAL -- no sequential IDs exposed through the API. NUMERIC for sensor values -- exact decimal precision, no float rounding on pH or EC readings. TIMESTAMPTZ for all timestamps -- timezone-aware from the start. DATE for planted_date -- a calendar date is a calendar date, not a moment in time. The units column on profiles uses TEXT with a CHECK constraint rather than an ENUM because two valid values do not warrant a named type.

Four custom ENUMs handle the domain vocabulary: space_type, growth_stage, metric_type, task_status. These are not just type constraints. They show up in introspection queries, produce readable error messages, and document the domain directly in the schema.

Three triggers handle the automation layer. The updated_at trigger fires before every update across profiles, spaces, plants, and tasks. handle_new_user fires after a new auth user is created and inserts a matching profiles row automatically. set_task_completed_at fires before a task update and sets completed_at to now() when status changes to complete -- and clears it back to NULL if the task is reopened. The client never sends completed_at directly. The database owns that value.

Row-level security locks down all five tables with 15 policies. Every policy scopes reads and writes to auth.uid() = user_id. data_logs has SELECT and INSERT policies only -- no UPDATE by design. Sensor readings are facts about a moment in time. Editing them after the fact would compromise the integrity of the log.

The performance work seeded 100,000 data_logs rows with generate_series and ran EXPLAIN ANALYZE before and after adding a B-Tree index on metric_type. The baseline was a Seq Scan at 34.07ms across 100,002 rows. After the index, the same query ran as an Index Scan at 8.64ms -- 74.6% faster, 3.9x speedup. For comparison, the StreamFlix exercise in Week 5 hit 99.1% and 111x on 1 million rows. The smaller improvement here reflects a smaller dataset and a lower-cardinality column with only four distinct values. The pattern is the same: index the column you filter on.

The JSONB metadata column on plants stores structurally different data per row without schema changes. The hydro plant has nutrient line, EC target, pH target, reservoir size, and grow medium. The outdoor plant has soil type, amendments as an array, sun exposure, and watering schedule. Same column, completely different keys. A GIN index makes containment queries fast at scale. The ->> operator extracts text, @> checks containment. Both confirmed working.

---

## What Broke

The Supabase free tier rate-limits auth emails. Creating a second test user through the normal invite flow hit the limit immediately. The workaround was inserting directly into auth.users via SQL and setting passwords with crypt(). That worked for the first user.

The second test user failed to authenticate despite having the right email, a hashed password, email_confirmed_at set, and role set to authenticated. The issue turned out to be a NULL aud column. Supabase Auth requires aud to be set to authenticated, and setting it via SQL UPDATE did not resolve the login failure. The auth service has an internal caching layer that does not immediately reflect direct SQL changes to encrypted_password or aud.

The RLS cross-user test was verified via SQL simulation instead. Set the JWT claims to the test user UUID, query Rae's spaces -- 0 rows returned. The result is the same. The lesson is that test users should be created through the Supabase dashboard or the Admin API, not via direct SQL insert into auth.users.

Schema ordering caused friction early. ENUMs must exist before tables reference them as column types. Seed data must exist before FK integrity tests can run against real rows. RLS must come after seeding -- enabling it first silently blocks all inserts and returns empty arrays with no error. That last one is easy to miss if you are not expecting it.

---

## What Actually Landed

The thing that made the project click was a three-row result set from a FULL OUTER JOIN.

```
common_name   title              status    plant_id
Basil         NULL               NULL      NULL
Tomato        Feed tomatoes      pending   bbbbbbbb-...
NULL          Check pH levels    pending   NULL
```

Three rows. Three different stories. Basil exists with no tasks. Tomato has a valid task with a matching plant_id. The third row has no plant -- it is the task that survived when the Northern Lights plant was deleted six steps earlier via ON DELETE SET NULL.

That NULL did not come from manufactured data or a deliberately broken seed. It came from a schema decision made at the beginning: tasks.plant_id is nullable, and deleting a plant should preserve the task as a historical care record rather than cascade-deleting it or blocking the deletion entirely. The FULL OUTER JOIN surfaced exactly what the design was built to produce.

That is the version of referential integrity worth understanding. It is not just about blocking bad inserts. It is about what your schema says should happen when the relationships between things change.

One other thing worth noting: RLS failures in PostgREST return 200 with an empty array, not 403. That is by design. If a PATCH returns 200 with zero affected rows and you are staring at it wondering why the data did not change, check your policies before assuming the query is wrong. The database enforced ownership silently. That is what you wanted.

---

## Repository

https://github.com/givecoffee/firstfrostmvp

Built with PostgreSQL, Supabase, and respect for the first frost of the season.
