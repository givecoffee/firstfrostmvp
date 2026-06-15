<p align="center">
  <img width="80%" alt="FirstFrost Banner" src="/assets/FirstFrost-StockBanner.png">
</p>

<p align="center">
  <sub> Stock Images (left to right) credits: Maya Schwarzer and Benjamin Combs. </sub>
</p>

<h2 align="center">
  FirstFrost
</h2>

<p align="center">
  Environmental intelligence for gardeners, growers, and small-scale food producers. 
</p>

<p align="center">
  Check out the Wiki: https://github.com/givecoffee/firstfrostmvp/wiki  
</p>

<p align="center">
  <img src="https://img.shields.io/badge/PostgreSQL-16+-316192?logo=postgresql&logoColor=white">
  <img src="https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase&logoColor=white">
  <img src="https://img.shields.io/badge/PostgREST-API-orange">
  <img src="https://img.shields.io/badge/Auth-JWT-success">
  <img src="https://img.shields.io/badge/Security-RLS-red">
  <img src="https://img.shields.io/badge/Status-MVP-blue">
</p>

---

## Overview

FirstFrost is a garden intelligence platform built to help growers organize plants, monitor environmental conditions, and make better seasonal decisions.

The platform combines structured plant tracking, environmental measurements, and task management into a single system designed around real growing workflows.

This repository contains the backend implementation including:

* PostgreSQL schema design
* Supabase configuration
* Row-Level Security policies
* Database automation and triggers
* Seed data
* Postman API test suite

---

## Why FirstFrost?

Successful growing depends on timing.

Gardeners constantly balance:

* Frost dates
* Seasonal changes
* Growth stages
* Environmental measurements
* Watering schedules
* Harvest timing

Most gardening tools focus on reminders.

FirstFrost focuses on environmental awareness.

The long-term goal is to create an offline-capable gardening platform that helps growers understand not only what is happening, but why.

---

## Core Features

### Space Management

Track multiple growing environments:

* Raised beds
* Greenhouses
* Grow tents
* Hydroponic systems
* Indoor gardens
* Container gardens

### Plant Tracking

Monitor plants through every stage of growth:

```text
Seed
 ↓
Seedling
 ↓
Vegetative
 ↓
Flowering
 ↓
Fruiting
 ↓
Harvest
```

### Environmental Logging

Store measurements such as:

* pH
* EC
* Temperature
* Humidity
* Custom metrics

### Care Management

Organize:

* Watering
* Fertilization
* Pruning
* Pest control
* Harvest schedules

---

## Architecture

```text
auth.users
    └── profiles
            └── spaces
                    ├── plants
                    │      └── data_logs
                    │
                    └── tasks
```

### Core Tables

| Table     | Purpose                       |
| --------- | ----------------------------- |
| profiles  | User profile information      |
| spaces    | Growing environments          |
| plants    | Plants within a space         |
| data_logs | Environmental readings        |
| tasks     | Care activities and reminders |

### Key Design Decisions

| Decision | Choice | Reason |
|----------|--------|--------|
| Primary keys | UUID v4 | No sequential IDs exposed |
| Sensor values | NUMERIC | Exact decimal precision, no float rounding |
| Timestamps | TIMESTAMPTZ | Timezone-aware, stored in UTC |
| Planted date | DATE | Calendar date only, no false time precision |
| tasks.plant_id | Nullable, ON DELETE SET NULL | Deleting a plant preserves task history |
| data_logs | Append-only, no UPDATE policy | Sensor readings are immutable facts |
| completed_at | Set by trigger, not client | Timestamp is trustworthy, not spoofable |

---

## Technology Stack

| Layer          | Technology     |
| -------------- | -------------- |
| Database       | PostgreSQL     |
| Backend        | Supabase       |
| API            | PostgREST      |
| Authentication | Supabase Auth  |
| Authorization  | PostgreSQL RLS |
| Testing        | Postman        |
| Storage        | JSONB          |
| Identifiers    | UUID v4        |

---

## Security

Security is enforced directly at the database layer.

Every user can only access data they own through Row-Level Security policies.

Protected resources include:

* Profiles
* Spaces
* Plants
* Tasks
* Data logs

No application-side filtering required.

RLS failures return 200 with an empty array, not 403. This is PostgREST behavior by design — the database enforces ownership silently.

---

## Setup

### Prerequisites

* Supabase account (free tier)
* Postman

### Steps

1. Create a new Supabase project
2. Open the SQL Editor and run each file in `sql/` in numbered order
3. Copy your Project URL and anon key from Settings → API
4. Import `postman/firstfrost.postman_collection.json` into Postman
5. Import `postman/firstfrost.environment.json` and fill in `baseUrl` and `anonKey`
6. Run `Auth: Sign In` to populate the access token
7. Run remaining requests in order

Do not enable RLS through the Supabase UI during table creation. RLS is enabled by `sql/07_rls.sql` with the full policy set in place.

---

## Repository Structure

```text
firstfrostmvp/
│
├── sql/
│   ├── 01_enums.sql           — four custom ENUM types
│   ├── 02_tables.sql          — five core tables in dependency order
│   ├── 03_demo_ddl.sql        — ALTER TABLE, TRUNCATE vs DROP demo
│   ├── 04_seed.sql            — baseline test data
│   ├── 05_integrity_tests.sql — FK violation, CASCADE, SET NULL tests
│   ├── 06_triggers.sql        — three trigger functions
│   ├── 07_rls.sql             — RLS enable and 15 policies
│   ├── 08_verify.sql          — schema verification queries
│   ├── 09_seed_perf.sql       — 100K data_logs rows for EXPLAIN ANALYZE
│   ├── 10_indexes.sql         — B-Tree and GIN indexes
│   ├── 11_jsonb.sql           — JSONB metadata column and GIN index
│   └── 12_queries.sql         — filtering, JOIN, and aggregation queries
│
├── postman/
│   ├── firstfrost.postman_collection.json
│   └── firstfrost.environment.json
│
├── docs/
│   └── design-decisions.md
│
├── DEVLOG.md
├── CHANGELOG.md
└── README.md
```

---

## Development Roadmap

### Current 

* [x] Schema design
* [x] Foreign key architecture
* [x] RLS implementation
* [x] Trigger automation
* [x] Seed data
* [x] Postman testing
* [x] JSONB metadata with GIN index
* [x] B-Tree index with EXPLAIN ANALYZE verification

### Planned 

* [ ] Flutter mobile app
* [ ] Offline synchronization
* [ ] Frost alerts
* [ ] Weather integrations
* [ ] Plant encyclopedia

---

## Documentation

| Document                 | Description                         |
| ------------------------ | ----------------------------------- |
| docs/design-decisions.md | Database and architecture rationale |
| DEVLOG.md                | Development journal                 |
| CHANGELOG.md             | Release history                     |

---

## Vision

FirstFrost is being designed as a practical environmental intelligence platform for growers.

By combining weather awareness, plant tracking, environmental monitoring, and offline-first mobile technology, the goal is to help gardeners make better decisions before conditions become problems.

Built with PostgreSQL, Supabase, and respect for the first frost of the season.
