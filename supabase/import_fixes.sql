-- Dynastie BITULU — import permissions repair
alter table public.media enable row level security;
drop policy if exists "own media" on public.media;
create policy "own media" on public.media for all to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());
drop policy if exists "visible media" on public.media;
create policy "visible media" on public.media for select using (public.can_view(visibility, owner_id, family_unit_id));
alter table public.documents enable row level security;
drop policy if exists "own documents" on public.documents;
create policy "own documents" on public.documents for all to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());
notify pgrst, 'reload schema';
