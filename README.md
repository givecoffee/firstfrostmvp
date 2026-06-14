<p align="center">
  <img width="80%" alt="FirstFrost Banner" src="/assets/FirstFrost-StockBanner.png">
  <sub> Stock Images (left to right) credits Maya Schwarzer, and Benjamin Combs. </sub>
</p>



<h3 align="center">
  FirstFrost
</h3>

<p align="center">
  Environmental intelligence for gardeners, growers, and small-scale food producers.
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

---

## Repository Structure

```text
firstfrostmvp/
│
├── sql/
├── postman/
├── docs/
├── DEVLOG.md
├── CHANGELOG.md
└── README.md
```

---

## Development Roadmap

### Current 

* [ ] Schema design
* [ ] Foreign key architecture
* [ ] RLS implementation
* [ ] Trigger automation
* [ ] Seed data
* [ ] Postman testing

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
