# Rails Job Application Tracker

A small Ruby on Rails 7 + Hotwire app for tracking your own job search: companies, roles, application status, and notes — with inline status changes powered by Turbo Frames/Streams instead of full page reloads.

## Problem

Job searches sprawl across spreadsheets, email threads, and sticky notes. This app is a single, scoped-per-user place to log every application and see, at a glance, how many are sitting in each stage of the pipeline (applied, screening, interview, offer, rejected).

## Architecture

```
                 ┌──────────────┐
                 │   Browser    │
                 │ (HTML + Turbo)│
                 └──────┬───────┘
                        │ HTTP / Turbo Frame & Stream requests
                        ▼
        ┌───────────────────────────────┐
        │        Rails controller        │
        │  ApplicationsController,       │
        │  DashboardController,          │
        │  SessionsController            │
        └───────────────┬────────────────┘
                        │ scoped queries: current_user.applications
                        ▼
              ┌───────────────────┐
              │   ActiveRecord     │
              │  User, Application │
              └─────────┬──────────┘
                        │ SQL
                        ▼
                 ┌──────────────┐
                 │  PostgreSQL   │
                 └──────────────┘
```

Changing an application's status (via the dropdown on the applications list) submits a Turbo Frame request. The controller updates the record and responds with a Turbo Stream that replaces just that `<tr>` — the rest of the page, and the rest of the table, never reload.

## Features

- Email/password auth via Rails' built-in `has_secure_password` (bcrypt) — no Devise, no external auth service
- Applications are scoped to `current_user` at the query level (`current_user.applications.find(...)`), so one user can never view or mutate another's records — a controller test asserts this returns 404
- Status enum (`applied → screening → interview → offer → rejected`) with inline, no-reload status changes via a real Turbo Stream template (`update_status.turbo_stream.erb`), not a static view
- Dashboard with per-status counts and a "most recent applications" list
- Full CRUD for applications (new/edit/show/delete), delete also renders a Turbo Stream (`turbo_stream.remove`)
- Minitest coverage for the enum status transitions, per-user scoping, and the Turbo Stream response of the inline status update

## Project layout

```
app/
  controllers/
    application_controller.rb    # session-based current_user / require_login
    sessions_controller.rb       # login/logout
    registrations_controller.rb  # signup
    dashboard_controller.rb      # counts-by-status + recent applications
    applications_controller.rb   # CRUD + update_status (Turbo Stream)
  models/
    user.rb                      # has_secure_password, has_many :applications
    application.rb               # belongs_to :user, status enum, scopes
  views/
    dashboard/index.html.erb
    applications/
      index.html.erb
      _application.html.erb      # turbo_frame_tag row w/ inline status <select>
      update_status.turbo_stream.erb
      _form.html.erb, new/edit/show.html.erb
    sessions/new.html.erb
    registrations/new.html.erb
    layouts/application.html.erb
  javascript/                    # Stimulus + Turbo via importmap (no Node build step)
  assets/stylesheets/application.css
config/
  routes.rb, database.yml, application.rb, environments/
db/
  migrate/                       # create_users, create_applications
  schema.rb, seeds.rb
test/
  models/application_test.rb     # status transitions, scopes, validations
  models/user_test.rb            # auth, uniqueness, counts-by-status
  controllers/applications_controller_test.rb  # scoping + Turbo Stream response
docker-compose.yml                # local Postgres only
```

## Setup (once you have a working Ruby 3.2+ / Rails 7.1 environment)

```bash
bundle install
docker compose up -d postgres     # or point config/database.yml at your own Postgres
bin/rails db:create db:migrate db:seed
bin/rails server
```

Then visit `http://localhost:3000`, sign up, or log in with the seeded demo account: `demo@example.com` / `password123`.

Run the test suite with:

```bash
bin/rails test
```

## Honest verification notes

This repository was built in a sandboxed environment that only had **Ruby 2.6.10** available locally (too old to run Rails 7 or Bundler's modern resolver), and Docker-based generation (`ruby:3.2` container + `rails new` + `bundle install`) was cut short for time before it completed a full `bundle install`.

As a result:

- **This code was hand-written directly** (models, controllers, views, migrations, tests, config) to be idiomatic Rails 7.1 + Hotwire, following the exact file layout `rails new` would produce — but it has **not been executed**: no `bundle install`, no `rails db:migrate`, no `rails server`, no `rails test` run in this environment.
- There is no `Gemfile.lock` in this repo, since it was never generated by a real `bundle install`.
- The Turbo Stream/Frame wiring, enum usage, scoping, and Minitest assertions are written against the actual Rails 7.1 API as documented, and I'm confident in the logic, but they are unverified by an actual test run here.
- If you clone this with a real Ruby 3.2+ toolchain, `bundle install && bin/rails db:create db:migrate db:seed && bin/rails test` should be the first thing to run to confirm everything boots — please open an issue if something doesn't.
