-- ============================================================
-- M.A.G.K GROUPS — LABOUR FORCE INTELLIGENCE SETUP
-- Run in Supabase SQL Editor after setup.sql
-- ============================================================

-- 1. WORKFORCE TABLE (registered workers)
create table if not exists workforce (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now(),
  name text not null,
  phone text not null,
  national_id text,
  age integer,
  location text,
  experience text,
  availability text default 'immediate',
  work_type text,
  skills text[] default '{}',
  daily_rate text,
  bio text,
  file_url text,
  status text default 'active',
  rating integer default 0,
  admin_notes text,
  times_hired integer default 0,
  last_hired date
);

-- 2. JOB POSTINGS TABLE (jobs you post)
create table if not exists job_postings (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now(),
  title text not null,
  description text,
  location text,
  job_type text default 'contract',
  required_skills text[] default '{}',
  rate text,
  start_date date,
  duration text,
  is_active boolean default true,
  filled boolean default false,
  applicant_count integer default 0
);

-- 3. JOB APPLICATIONS TABLE
create table if not exists job_applications (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now(),
  job_id uuid references job_postings(id) on delete cascade,
  name text not null,
  phone text not null,
  message text,
  status text default 'new'
);

-- ── ROW LEVEL SECURITY ────────────────────────────────────────

alter table workforce enable row level security;
alter table job_postings enable row level security;
alter table job_applications enable row level security;

-- Workforce: anyone can register, only admin can read/update
create policy "Anyone can register as worker"
  on workforce for insert with check (true);

create policy "Admin manages workforce"
  on workforce for all
  using (auth.role() = 'authenticated');

-- Job postings: anyone can read active jobs, admin manages all
create policy "Anyone can view active jobs"
  on job_postings for select
  using (is_active = true);

create policy "Admin manages job postings"
  on job_postings for all
  using (auth.role() = 'authenticated');

-- Applications: anyone can apply, admin reads all
create policy "Anyone can apply to job"
  on job_applications for insert with check (true);

create policy "Admin reads all applications"
  on job_applications for all
  using (auth.role() = 'authenticated');

-- ── STORAGE BUCKET NOTE ───────────────────────────────────────
-- Also create a storage bucket named: worker-files
-- Set it to PUBLIC in Supabase Storage settings
-- This stores CVs, certificates, and ID uploads from workers
