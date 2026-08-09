-- ===== สคีมาฐานข้อมูลแอปจดบันทึกบัตรเครดิต =====
-- วิธีใช้: Supabase Dashboard → SQL Editor → วางทั้งไฟล์นี้ → Run

-- ตารางบัตรเครดิต
create table if not exists public.cards (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name text not null,
  color text not null default '#5b6ee8',
  statement_day int check (statement_day between 1 and 31),
  created_at timestamptz not null default now()
);

-- ตารางรายการใช้จ่าย
create table if not exists public.transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  card_id uuid not null references public.cards(id) on delete cascade,
  tx_date date not null default current_date,
  name text not null,
  amount numeric(12,2) not null,
  place text,
  category text not null default 'other',
  paid boolean not null default false,
  created_at timestamptz not null default now()
);

-- สำหรับฐานข้อมูลที่สร้างไว้ก่อนหน้า: เพิ่มคอลัมน์หมวดหมู่ (รันซ้ำได้)
alter table public.transactions add column if not exists category text not null default 'other';

create index if not exists idx_cards_user on public.cards(user_id);
create index if not exists idx_tx_user on public.transactions(user_id);
create index if not exists idx_tx_card_date on public.transactions(card_id, tx_date);

-- Row Level Security: แต่ละคนเห็นเฉพาะข้อมูลของตัวเอง
alter table public.cards enable row level security;
alter table public.transactions enable row level security;

drop policy if exists "cards_select_own" on public.cards;
drop policy if exists "cards_insert_own" on public.cards;
drop policy if exists "cards_update_own" on public.cards;
drop policy if exists "cards_delete_own" on public.cards;
create policy "cards_select_own" on public.cards for select using (auth.uid() = user_id);
create policy "cards_insert_own" on public.cards for insert with check (auth.uid() = user_id);
create policy "cards_update_own" on public.cards for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "cards_delete_own" on public.cards for delete using (auth.uid() = user_id);

drop policy if exists "tx_select_own" on public.transactions;
drop policy if exists "tx_insert_own" on public.transactions;
drop policy if exists "tx_update_own" on public.transactions;
drop policy if exists "tx_delete_own" on public.transactions;
create policy "tx_select_own" on public.transactions for select using (auth.uid() = user_id);
create policy "tx_insert_own" on public.transactions for insert with check (auth.uid() = user_id);
create policy "tx_update_own" on public.transactions for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "tx_delete_own" on public.transactions for delete using (auth.uid() = user_id);
