-- Dynastie BITULU — profile settings and private profile media
-- Idempotent migration for the existing Supabase project.

alter table public.profiles add column if not exists background_url text;
alter table public.profiles add column if not exists post_name text;
alter table public.profiles add column if not exists nickname text;

create table if not exists public.profile_phone_numbers (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  label text not null default 'Téléphone',
  number text not null,
  is_primary boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists profile_phone_numbers_profile_id_idx on public.profile_phone_numbers(profile_id);
create unique index if not exists profile_phone_numbers_one_primary_idx on public.profile_phone_numbers(profile_id) where is_primary;

alter table public.profile_phone_numbers enable row level security;

drop policy if exists "profile phone read own" on public.profile_phone_numbers;
create policy "profile phone read own" on public.profile_phone_numbers for select to authenticated using (profile_id = auth.uid());
drop policy if exists "profile phone insert own" on public.profile_phone_numbers;
create policy "profile phone insert own" on public.profile_phone_numbers for insert to authenticated with check (profile_id = auth.uid());
drop policy if exists "profile phone update own" on public.profile_phone_numbers;
create policy "profile phone update own" on public.profile_phone_numbers for update to authenticated using (profile_id = auth.uid()) with check (profile_id = auth.uid());
drop policy if exists "profile phone delete own" on public.profile_phone_numbers;
create policy "profile phone delete own" on public.profile_phone_numbers for delete to authenticated using (profile_id = auth.uid());

drop policy if exists "profile update own" on public.profiles;
create policy "profile update own" on public.profiles for update to authenticated using (id = auth.uid()) with check (id = auth.uid());

insert into storage.buckets (id, name, public) values ('profile-media', 'profile-media', false) on conflict (id) do update set public = false;

drop policy if exists "profile media read own" on storage.objects;
create policy "profile media read own" on storage.objects for select to authenticated using (bucket_id = 'profile-media' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "profile media upload own" on storage.objects;
create policy "profile media upload own" on storage.objects for insert to authenticated with check (bucket_id = 'profile-media' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "profile media update own" on storage.objects;
create policy "profile media update own" on storage.objects for update to authenticated using (bucket_id = 'profile-media' and (storage.foldername(name))[1] = auth.uid()::text) with check (bucket_id = 'profile-media' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "profile media delete own" on storage.objects;
create policy "profile media delete own" on storage.objects for delete to authenticated using (bucket_id = 'profile-media' and (storage.foldername(name))[1] = auth.uid()::text);
