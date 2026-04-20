-- ============================================================
-- M.A.G.K GROUPS — MEDIA UPLOAD SETUP
-- Run this in Supabase SQL Editor AFTER setup.sql
-- ============================================================

-- 1. PROJECT MEDIA TABLE
create table if not exists project_media (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now(),
  project_id uuid references projects(id) on delete cascade,
  project_update_id uuid references project_updates(id) on delete cascade,
  file_url text not null,
  file_name text,
  file_type text default 'image',
  file_size bigint
);

-- 2. ROW LEVEL SECURITY
alter table project_media enable row level security;

-- Admin can do everything
create policy "Admin manages all media"
  on project_media for all
  using (auth.role() = 'authenticated');

-- Client can see media for their own projects
create policy "Client sees own project media"
  on project_media for select
  using (
    project_id in (
      select p.id from projects p
      join clients c on p.client_id = c.id
      where c.auth_user_id = auth.uid()
    )
  );
