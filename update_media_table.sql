-- ============================================================
-- M.A.G.K GROUPS — UPDATE project_media TABLE
-- Run this in Supabase SQL Editor
-- Only run once
-- ============================================================

alter table project_media
  add column if not exists file_category text default 'photo',
  add column if not exists client_visible boolean default true;
