-- ============================================================
-- M.A.G.K GROUPS — SUPABASE DATABASE SETUP
-- Copy this entire file and paste into Supabase SQL Editor
-- Run it once. Do not run it twice.
-- ============================================================

-- 1. CLIENTS TABLE
create table if not exists clients (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now(),
  name text not null,
  email text unique not null,
  phone text unique not null,
  auth_user_id uuid unique,
  notes text
);

-- 2. ENQUIRIES TABLE (contact form submissions)
create table if not exists enquiries (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now(),
  name text not null,
  phone text not null,
  service text,
  location text,
  description text,
  status text default 'new',
  priority text default 'normal',
  admin_notes text,
  is_converted boolean default false,
  converted_client_id uuid references clients(id)
);

-- 3. PROJECTS TABLE
create table if not exists projects (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now(),
  client_id uuid references clients(id) on delete cascade,
  title text not null,
  description text,
  service_type text,
  location text,
  status text default 'planning',
  progress_percent integer default 0,
  start_date date,
  end_date date,
  budget numeric default 0,
  paid_amount numeric default 0,
  contract_signed boolean default false
);

-- 4. PROJECT UPDATES TABLE (milestone/progress posts)
create table if not exists project_updates (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now(),
  project_id uuid references projects(id) on delete cascade,
  title text not null,
  description text,
  update_type text default 'progress'
);

-- 5. INTELLIGENCE NOTES TABLE (your secret weapon)
create table if not exists intel_notes (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now(),
  category text not null,
  title text not null,
  content text,
  source text,
  tags text[]
);

-- ── ROW LEVEL SECURITY ───────────────────────────────────────

alter table enquiries enable row level security;
alter table clients enable row level security;
alter table projects enable row level security;
alter table project_updates enable row level security;
alter table intel_notes enable row level security;

-- Enquiries: anyone can insert (contact form), only admin can read
create policy "Anyone can submit enquiry"
  on enquiries for insert
  with check (true);

create policy "Admin reads all enquiries"
  on enquiries for select
  using (auth.role() = 'authenticated');

create policy "Admin updates enquiries"
  on enquiries for update
  using (auth.role() = 'authenticated');

-- Clients: admin full access
create policy "Admin manages clients"
  on clients for all
  using (auth.role() = 'authenticated');

-- Projects: admin full access + client sees own projects
create policy "Admin manages all projects"
  on projects for all
  using (
    auth.role() = 'authenticated' and
    auth.uid() not in (select auth_user_id from clients where auth_user_id is not null)
  );

create policy "Client sees own projects"
  on projects for select
  using (
    client_id in (
      select id from clients where auth_user_id = auth.uid()
    )
  );

-- Project updates: admin full access + client sees own
create policy "Admin manages all updates"
  on project_updates for all
  using (
    auth.role() = 'authenticated' and
    auth.uid() not in (select auth_user_id from clients where auth_user_id is not null)
  );

create policy "Client sees own project updates"
  on project_updates for select
  using (
    project_id in (
      select p.id from projects p
      join clients c on p.client_id = c.id
      where c.auth_user_id = auth.uid()
    )
  );

-- Intel notes: admin only
create policy "Admin manages intel"
  on intel_notes for all
  using (auth.role() = 'authenticated');
