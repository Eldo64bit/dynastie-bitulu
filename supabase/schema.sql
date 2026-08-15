-- Dynastie BITULU — foundational schema
-- Apply in the Supabase SQL Editor for project skizuvrlcrutxnwbmxdi.

create extension if not exists pgcrypto;

create type public.app_role as enum ('SUPERADMIN','FAMILY_MEMBER','FAMILY_NETWORK','GUEST');
create type public.visibility_level as enum ('PUBLIC','FAMILY','NETWORK','PRIVATE');
create type public.profile_status as enum ('ACTIVE','DECEASED','SUSPENDED');
create type public.death_report_status as enum ('PENDING_VERIFICATION','CONTESTED','AWAITING_FINAL_VALIDATION','VALIDATED','CANCELLED');

create table if not exists public.family_units (
  id uuid primary key default gen_random_uuid(),
  name text not null default 'Dynastie BITULU',
  motto text not null default 'Notre histoire. Nos vies. Notre mémoire.',
  description text,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now()
);

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  family_unit_id uuid references public.family_units(id) on delete set null,
  first_name text not null default '',
  last_name text not null default '',
  display_name text generated always as (trim(first_name || ' ' || last_name)) stored,
  avatar_url text,
  birth_date date,
  birth_place text,
  nationality text,
  profession text,
  biography text,
  phone text,
  email text,
  address text,
  role public.app_role not null default 'FAMILY_NETWORK',
  status public.profile_status not null default 'ACTIVE',
  is_public boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.family_relationships (
  id uuid primary key default gen_random_uuid(),
  family_unit_id uuid not null references public.family_units(id) on delete cascade,
  from_profile_id uuid not null references public.profiles(id) on delete cascade,
  to_profile_id uuid not null references public.profiles(id) on delete cascade,
  relationship_type text not null check (relationship_type in ('PARENT_OF','CHILD_OF','SPOUSE_OF','SIBLING_OF','GRANDPARENT_OF','GRANDCHILD_OF','RELATED_TO')),
  visibility public.visibility_level not null default 'FAMILY',
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  unique(from_profile_id, to_profile_id, relationship_type)
);

create table if not exists public.events (
  id uuid primary key default gen_random_uuid(),
  family_unit_id uuid references public.family_units(id) on delete cascade,
  creator_id uuid not null references auth.users(id) on delete cascade,
  event_type text not null default 'MEMORY',
  title text not null,
  event_date date,
  event_time time,
  location text,
  description text,
  visibility public.visibility_level not null default 'FAMILY',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.event_people (
  event_id uuid not null references public.events(id) on delete cascade,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  primary key(event_id, profile_id)
);

create table if not exists public.stories (
  id uuid primary key default gen_random_uuid(),
  family_unit_id uuid references public.family_units(id) on delete cascade,
  author_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  content text not null,
  story_date date,
  visibility public.visibility_level not null default 'FAMILY',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.albums (
  id uuid primary key default gen_random_uuid(),
  family_unit_id uuid references public.family_units(id) on delete cascade,
  owner_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  description text,
  cover_url text,
  album_date date,
  visibility public.visibility_level not null default 'FAMILY',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.media (
  id uuid primary key default gen_random_uuid(),
  family_unit_id uuid references public.family_units(id) on delete cascade,
  owner_id uuid not null references auth.users(id) on delete cascade,
  album_id uuid references public.albums(id) on delete set null,
  event_id uuid references public.events(id) on delete set null,
  story_id uuid references public.stories(id) on delete set null,
  storage_path text not null,
  media_type text not null,
  title text,
  caption text,
  visibility public.visibility_level not null default 'PRIVATE',
  created_at timestamptz not null default now()
);

create table if not exists public.businesses (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  family_unit_id uuid references public.family_units(id) on delete cascade,
  name text not null,
  sector text,
  description text,
  history text,
  website_url text,
  logo_url text,
  founded_on date,
  visibility public.visibility_level not null default 'PUBLIC',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.education_records (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  institution text not null,
  level text,
  field text,
  started_on date,
  ended_on date,
  diploma text,
  distinction text,
  visibility public.visibility_level not null default 'FAMILY',
  created_at timestamptz not null default now()
);

create table if not exists public.documents (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  family_unit_id uuid references public.family_units(id) on delete cascade,
  document_type text not null default 'OTHER',
  title text not null,
  storage_path text not null,
  mime_type text,
  issued_on date,
  issuer text,
  visibility public.visibility_level not null default 'PRIVATE',
  created_at timestamptz not null default now()
);

create table if not exists public.invitations (
  id uuid primary key default gen_random_uuid(),
  family_unit_id uuid references public.family_units(id) on delete cascade,
  inviter_id uuid not null references auth.users(id) on delete cascade,
  invitee_email text,
  invitee_phone text,
  relationship_type text not null default 'RELATED_TO',
  role public.app_role not null default 'FAMILY_NETWORK',
  status text not null default 'PENDING' check (status in ('PENDING','ACCEPTED','DECLINED','EXPIRED')),
  token text not null unique default encode(gen_random_bytes(24),'hex'),
  expires_at timestamptz not null default (now() + interval '14 days'),
  created_at timestamptz not null default now()
);

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  recipient_id uuid not null references auth.users(id) on delete cascade,
  kind text not null,
  title text not null,
  body text not null,
  link text,
  read_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists public.succession (
  id uuid primary key default gen_random_uuid(),
  current_admin_id uuid not null references auth.users(id) on delete cascade,
  successor_id uuid references auth.users(id) on delete set null,
  status text not null default 'DESIGNATED' check (status in ('DESIGNATED','TRANSFERRED','REVOKED')),
  designated_at timestamptz not null default now(),
  transferred_at timestamptz
);

create table if not exists public.death_reports (
  id uuid primary key default gen_random_uuid(),
  subject_id uuid not null references auth.users(id) on delete cascade,
  reporter_id uuid not null references auth.users(id) on delete cascade,
  certifier_id uuid references auth.users(id) on delete set null,
  status public.death_report_status not null default 'PENDING_VERIFICATION',
  reason text,
  contest_until timestamptz not null default (now() + interval '30 days'),
  contested_at timestamptz,
  validated_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists public.death_certificates (
  id uuid primary key default gen_random_uuid(),
  death_report_id uuid not null references public.death_reports(id) on delete cascade,
  uploaded_by uuid not null references auth.users(id) on delete cascade,
  storage_path text not null,
  issued_on date,
  issuing_authority text,
  document_reference text,
  comment text,
  created_at timestamptz not null default now()
);

create table if not exists public.audit_logs (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid references auth.users(id) on delete set null,
  action text not null,
  object_type text,
  object_id uuid,
  result text not null default 'SUCCESS',
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create or replace function public.is_member_of_family(target_family_id uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.profiles p where p.id = auth.uid() and p.family_unit_id = target_family_id);
$$;

create or replace function public.my_role()
returns public.app_role language sql stable security definer set search_path = public as $$
  select role from public.profiles where id = auth.uid();
$$;

create or replace function public.can_view(target_visibility public.visibility_level, target_owner uuid default null, target_family_id uuid default null)
returns boolean language sql stable security definer set search_path = public as $$
  select case
    when target_visibility = 'PUBLIC' then true
    when auth.uid() is null then false
    when target_visibility = 'PRIVATE' then auth.uid() = target_owner
    when target_visibility = 'FAMILY' then public.is_member_of_family(target_family_id)
    when target_visibility = 'NETWORK' then public.is_member_of_family(target_family_id)
    else false
  end;
$$;

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, first_name, last_name, email) values (new.id, coalesce(new.raw_user_meta_data->>'first_name',''), coalesce(new.raw_user_meta_data->>'last_name',''), new.email) on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();

alter table public.family_units enable row level security;
alter table public.profiles enable row level security;
alter table public.family_relationships enable row level security;
alter table public.events enable row level security;
alter table public.event_people enable row level security;
alter table public.stories enable row level security;
alter table public.albums enable row level security;
alter table public.media enable row level security;
alter table public.businesses enable row level security;
alter table public.education_records enable row level security;
alter table public.documents enable row level security;
alter table public.invitations enable row level security;
alter table public.notifications enable row level security;
alter table public.succession enable row level security;
alter table public.death_reports enable row level security;
alter table public.death_certificates enable row level security;
alter table public.audit_logs enable row level security;

-- Re-runnable policies: remove only policies owned by this migration.
drop policy if exists "public profiles" on public.profiles;
create policy "public profiles" on public.profiles for select using (is_public = true or id = auth.uid() or public.is_member_of_family(family_unit_id));
drop policy if exists "own profile update" on public.profiles;
create policy "own profile update" on public.profiles for update using (id = auth.uid()) with check (id = auth.uid());
drop policy if exists "family units visible" on public.family_units;
create policy "family units visible" on public.family_units for select using (public.is_member_of_family(id));
drop policy if exists "relationships visible to members" on public.family_relationships;
create policy "relationships visible to members" on public.family_relationships for select using (public.is_member_of_family(family_unit_id));
drop policy if exists "relationships managed by family" on public.family_relationships;
create policy "relationships managed by family" on public.family_relationships for insert with check (public.is_member_of_family(family_unit_id) and created_by = auth.uid());
drop policy if exists "visible events" on public.events;
create policy "visible events" on public.events for select using (public.can_view(visibility, creator_id, family_unit_id));
drop policy if exists "own events" on public.events;
create policy "own events" on public.events for all using (creator_id = auth.uid()) with check (creator_id = auth.uid());
drop policy if exists "visible stories" on public.stories;
create policy "visible stories" on public.stories for select using (public.can_view(visibility, author_id, family_unit_id));
drop policy if exists "own stories" on public.stories;
create policy "own stories" on public.stories for all using (author_id = auth.uid()) with check (author_id = auth.uid());
drop policy if exists "visible albums" on public.albums;
create policy "visible albums" on public.albums for select using (public.can_view(visibility, owner_id, family_unit_id));
drop policy if exists "own albums" on public.albums;
create policy "own albums" on public.albums for all using (owner_id = auth.uid()) with check (owner_id = auth.uid());
drop policy if exists "visible businesses" on public.businesses;
create policy "visible businesses" on public.businesses for select using (public.can_view(visibility, owner_id, family_unit_id));
drop policy if exists "own businesses" on public.businesses;
create policy "own businesses" on public.businesses for all using (owner_id = auth.uid()) with check (owner_id = auth.uid());
drop policy if exists "visible education" on public.education_records;
create policy "visible education" on public.education_records for select using (public.can_view(visibility, profile_id, (select family_unit_id from public.profiles where id = profile_id)));
drop policy if exists "own education" on public.education_records;
create policy "own education" on public.education_records for all using (profile_id = auth.uid()) with check (profile_id = auth.uid());
drop policy if exists "own documents" on public.documents;
create policy "own documents" on public.documents for all using (owner_id = auth.uid()) with check (owner_id = auth.uid());
drop policy if exists "visible notifications" on public.notifications;
create policy "visible notifications" on public.notifications for select using (recipient_id = auth.uid());
drop policy if exists "update own notifications" on public.notifications;
create policy "update own notifications" on public.notifications for update using (recipient_id = auth.uid()) with check (recipient_id = auth.uid());
drop policy if exists "own invitations" on public.invitations;
create policy "own invitations" on public.invitations for select using (inviter_id = auth.uid() or invitee_email = (select email from auth.users where id = auth.uid()));
drop policy if exists "create invitations" on public.invitations;
create policy "create invitations" on public.invitations for insert with check (inviter_id = auth.uid());
drop policy if exists "own succession" on public.succession;
create policy "own succession" on public.succession for all using (current_admin_id = auth.uid()) with check (current_admin_id = auth.uid());
drop policy if exists "death reports participants" on public.death_reports;
create policy "death reports participants" on public.death_reports for select using (subject_id = auth.uid() or reporter_id = auth.uid() or certifier_id = auth.uid());
drop policy if exists "death reports by reporter" on public.death_reports;
create policy "death reports by reporter" on public.death_reports for insert with check (reporter_id = auth.uid());
drop policy if exists "certificates by uploader" on public.death_certificates;
create policy "certificates by uploader" on public.death_certificates for all using (uploaded_by = auth.uid()) with check (uploaded_by = auth.uid());
drop policy if exists "audit own" on public.audit_logs;
create policy "audit own" on public.audit_logs for select using (actor_id = auth.uid());

insert into storage.buckets (id, name, public) values ('family-media','family-media',true) on conflict (id) do nothing;
insert into storage.buckets (id, name, public) values ('private-documents','private-documents',false) on conflict (id) do nothing;
insert into storage.buckets (id, name, public) values ('death-certificates','death-certificates',false) on conflict (id) do nothing;

drop policy if exists "family media read" on storage.objects;
create policy "family media read" on storage.objects for select using (bucket_id = 'family-media');
drop policy if exists "family media upload" on storage.objects;
create policy "family media upload" on storage.objects for insert with check (bucket_id = 'family-media' and auth.uid() is not null);
drop policy if exists "private documents own" on storage.objects;
create policy "private documents own" on storage.objects for all using (bucket_id = 'private-documents' and (storage.foldername(name))[1] = auth.uid()::text) with check (bucket_id = 'private-documents' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "death certificates own" on storage.objects;
create policy "death certificates own" on storage.objects for all using (bucket_id = 'death-certificates' and (storage.foldername(name))[1] = auth.uid()::text) with check (bucket_id = 'death-certificates' and (storage.foldername(name))[1] = auth.uid()::text);
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
