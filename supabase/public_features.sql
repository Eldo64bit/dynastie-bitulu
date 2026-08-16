-- Dynastie BITULU — public vitrine, invitations, targeted visibility and private imports
create table if not exists public.invitations (
  id uuid primary key default gen_random_uuid(),
  family_unit_id uuid references public.family_units(id) on delete cascade,
  inviter_id uuid not null references auth.users(id) on delete cascade,
  invitee_email text,
  invitee_phone text,
  invitee_first_name text,
  invitee_last_name text,
  relationship_type text not null default 'RELATED_TO',
  role public.app_role not null default 'FAMILY_NETWORK',
  status text not null default 'PENDING' check (status in ('PENDING','ACCEPTED','DECLINED','EXPIRED')),
  token text not null unique default encode(gen_random_bytes(24),'hex'),
  expires_at timestamptz not null default (now() + interval '14 days'),
  created_at timestamptz not null default now()
);
alter table public.invitations enable row level security;
drop policy if exists "own invitations" on public.invitations;
create policy "own invitations" on public.invitations for select using (inviter_id = auth.uid());
drop policy if exists "create invitations" on public.invitations;
create policy "create invitations" on public.invitations for insert with check (inviter_id = auth.uid());
drop policy if exists "update own invitations" on public.invitations;
create policy "update own invitations" on public.invitations for update using (inviter_id = auth.uid()) with check (inviter_id = auth.uid());
alter table public.invitations add column if not exists invitee_first_name text;
alter table public.invitations add column if not exists invitee_last_name text;
alter table public.invitations add column if not exists sent_at timestamptz;
alter table public.invitations add column if not exists revoked_at timestamptz;
alter table public.profiles add column if not exists contact_visibility public.visibility_level not null default 'PRIVATE';
alter table public.profiles add column if not exists website_url text;
alter table public.profiles add column if not exists instagram_url text;
alter table public.profiles add column if not exists facebook_url text;
alter table public.profiles add column if not exists linkedin_url text;
alter table public.profiles add column if not exists whatsapp_url text;
alter table public.profiles add column if not exists other_contact text;

create table if not exists public.content_access (
  id uuid primary key default gen_random_uuid(),
  content_kind text not null check (content_kind in ('stories','events','albums','media','documents')),
  content_id uuid not null,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  granted_by uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (content_kind, content_id, profile_id)
);
alter table public.content_access enable row level security;
drop policy if exists "content access own read" on public.content_access;
create policy "content access own read" on public.content_access for select to authenticated using (granted_by = auth.uid() or profile_id = auth.uid());
drop policy if exists "content access own write" on public.content_access;
create policy "content access own write" on public.content_access for all to authenticated using (granted_by = auth.uid()) with check (granted_by = auth.uid());

create table if not exists public.guestbook_entries (
  id uuid primary key default gen_random_uuid(),
  family_unit_id uuid references public.family_units(id) on delete cascade,
  display_name text not null,
  message text not null,
  status text not null default 'PENDING' check (status in ('PENDING','APPROVED','REJECTED')),
  moderated_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now()
);
alter table public.guestbook_entries enable row level security;
drop policy if exists "approved guestbook public read" on public.guestbook_entries;
create policy "approved guestbook public read" on public.guestbook_entries for select using (status = 'APPROVED');
drop policy if exists "guestbook public submit" on public.guestbook_entries;
create policy "guestbook public submit" on public.guestbook_entries for insert to anon, authenticated with check (status = 'PENDING');
drop policy if exists "guestbook moderator update" on public.guestbook_entries;
create policy "guestbook moderator update" on public.guestbook_entries for update to authenticated using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role in ('SUPERADMIN','FAMILY_NETWORK'))) with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role in ('SUPERADMIN','FAMILY_NETWORK')));

insert into storage.buckets (id, name, public) values ('family-media','family-media',false) on conflict (id) do nothing;
drop policy if exists "family media own read" on storage.objects;
create policy "family media own read" on storage.objects for select to authenticated using (bucket_id = 'family-media' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "family media own write" on storage.objects;
create policy "family media own write" on storage.objects for all to authenticated using (bucket_id = 'family-media' and (storage.foldername(name))[1] = auth.uid()::text) with check (bucket_id = 'family-media' and (storage.foldername(name))[1] = auth.uid()::text);
notify pgrst, 'reload schema';


create table if not exists public.profile_contact_points (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  kind text not null check (kind in ('EMAIL','PHONE','WEBSITE','INSTAGRAM','FACEBOOK','LINKEDIN','WHATSAPP','OTHER')),
  label text not null default 'Contact',
  value text not null,
  visibility public.visibility_level not null default 'PRIVATE',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists profile_contact_points_profile_id_idx on public.profile_contact_points(profile_id);
alter table public.profile_contact_points enable row level security;
drop policy if exists "contact points read own" on public.profile_contact_points;
create policy "contact points read own" on public.profile_contact_points for select to authenticated using (profile_id = auth.uid());
drop policy if exists "contact points insert own" on public.profile_contact_points;
create policy "contact points insert own" on public.profile_contact_points for insert to authenticated with check (profile_id = auth.uid());
drop policy if exists "contact points update own" on public.profile_contact_points;
create policy "contact points update own" on public.profile_contact_points for update to authenticated using (profile_id = auth.uid()) with check (profile_id = auth.uid());
drop policy if exists "contact points delete own" on public.profile_contact_points;
create policy "contact points delete own" on public.profile_contact_points for delete to authenticated using (profile_id = auth.uid());


alter table public.albums enable row level security;
drop policy if exists "own albums" on public.albums;
create policy "own albums" on public.albums for all to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());
drop policy if exists "family media read own" on storage.objects;
create policy "family media read own" on storage.objects for select to authenticated using (bucket_id = 'family-media' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "family media upload own" on storage.objects;
create policy "family media upload own" on storage.objects for insert to authenticated with check (bucket_id = 'family-media' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "family media update own" on storage.objects;
create policy "family media update own" on storage.objects for update to authenticated using (bucket_id = 'family-media' and (storage.foldername(name))[1] = auth.uid()::text) with check (bucket_id = 'family-media' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "family media delete own" on storage.objects;
create policy "family media delete own" on storage.objects for delete to authenticated using (bucket_id = 'family-media' and (storage.foldername(name))[1] = auth.uid()::text);
