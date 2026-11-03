-- FitKarma Baseline Schema & Universal Row Level Security (RLS)
-- Version: 20261102000001
-- Aligns with Brain/data_model.md & Brain/security.md

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ============================================================================
-- 1. PROFILES
-- ============================================================================
create table if not exists public.profiles (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references auth.users(id) on delete cascade not null unique,
    display_name text,
    phone_number text,
    locale text not null default 'en',
    age int,
    biological_sex text,
    height_cm numeric(5, 2),
    weight_kg numeric(5, 2),
    target_weight_kg numeric(5, 2),
    activity_level text,
    dietary_identity text,
    dosha_profile jsonb,
    has_accepted_dpdp_consent boolean not null default false,
    metadata jsonb default '{}'::jsonb,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

create policy "Users can select own profile" on public.profiles
    for select using (auth.uid() = user_id);

create policy "Users can insert own profile" on public.profiles
    for insert with check (auth.uid() = user_id);

create policy "Users can update own profile" on public.profiles
    for update using (auth.uid() = user_id);

create policy "Users can delete own profile" on public.profiles
    for delete using (auth.uid() = user_id);

-- ============================================================================
-- 2. FOOD CATALOG (Indian foods & system templates)
-- ============================================================================
create table if not exists public.food_catalog (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references auth.users(id) on delete cascade, -- null for system items
    name text not null,
    regional_names jsonb default '{}'::jsonb,
    calories_per_100g numeric(6, 2) not null,
    protein_per_100g numeric(5, 2) not null,
    carbs_per_100g numeric(5, 2) not null,
    fat_per_100g numeric(5, 2) not null,
    fiber_per_100g numeric(5, 2) default 0,
    is_system boolean not null default false,
    metadata jsonb default '{}'::jsonb,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

alter table public.food_catalog enable row level security;

create policy "Users can view system foods or own foods" on public.food_catalog
    for select using (is_system = true or auth.uid() = user_id);

create policy "Users can insert own custom food" on public.food_catalog
    for insert with check (auth.uid() = user_id and is_system = false);

create policy "Users can update own custom food" on public.food_catalog
    for update using (auth.uid() = user_id and is_system = false);

create policy "Users can delete own custom food" on public.food_catalog
    for delete using (auth.uid() = user_id and is_system = false);

-- ============================================================================
-- 3. RECIPES
-- ============================================================================
create table if not exists public.recipes (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references auth.users(id) on delete cascade not null,
    name text not null,
    servings int not null default 1,
    total_calories numeric(7, 2),
    ingredients jsonb not null default '[]'::jsonb,
    metadata jsonb default '{}'::jsonb,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

alter table public.recipes enable row level security;

create policy "Users can manage own recipes" on public.recipes
    for all using (auth.uid() = user_id);

-- ============================================================================
-- 4. COOKING MULTIPLIERS (Raw vs cooked yields)
-- ============================================================================
create table if not exists public.cooking_multipliers (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references auth.users(id) on delete cascade,
    food_name text not null,
    cooking_state text not null,
    yield_factor numeric(4, 2) not null default 1.0,
    is_system boolean not null default false,
    metadata jsonb default '{}'::jsonb,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

alter table public.cooking_multipliers enable row level security;

create policy "Users can view cooking multipliers" on public.cooking_multipliers
    for select using (is_system = true or auth.uid() = user_id);

create policy "Users can manage own cooking multipliers" on public.cooking_multipliers
    for all using (auth.uid() = user_id and is_system = false);

-- ============================================================================
-- 5. HEALTH OBSERVATIONS (Telemetry & Vitals)
-- ============================================================================
create table if not exists public.health_observations (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references auth.users(id) on delete cascade not null,
    metric_type text not null, -- 'weight', 'blood_pressure', 'glucose', 'water', 'sleep'
    observed_at timestamptz not null default now(),
    source text not null default 'manual',
    value_numeric numeric(8, 2),
    value_text text,
    unit text not null,
    metadata jsonb default '{}'::jsonb,
    created_at timestamptz not null default now()
);

alter table public.health_observations enable row level security;

create policy "Users can manage own health observations" on public.health_observations
    for all using (auth.uid() = user_id);

-- ============================================================================
-- 6. FOOD LOGS
-- ============================================================================
create table if not exists public.food_logs (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references auth.users(id) on delete cascade not null,
    logged_at timestamptz not null default now(),
    meal_slot text not null, -- 'breakfast', 'lunch', 'snack', 'dinner'
    food_name text not null,
    portion_quantity numeric(5, 2) not null,
    portion_unit text not null, -- 'katori', 'glass', 'spoon', 'piece', 'grams'
    calories numeric(6, 2) not null,
    protein_grams numeric(5, 2) not null,
    carbs_grams numeric(5, 2) not null,
    fat_grams numeric(5, 2) not null,
    fiber_grams numeric(5, 2) default 0,
    tadka_level text default 'medium',
    metadata jsonb default '{}'::jsonb,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

alter table public.food_logs enable row level security;

create policy "Users can manage own food logs" on public.food_logs
    for all using (auth.uid() = user_id);

-- ============================================================================
-- 7. WORKOUTS
-- ============================================================================
create table if not exists public.workouts (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references auth.users(id) on delete cascade not null,
    title text not null,
    started_at timestamptz not null default now(),
    ended_at timestamptz,
    calories_burned numeric(6, 2),
    source text not null default 'manual',
    metadata jsonb default '{}'::jsonb,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

alter table public.workouts enable row level security;

create policy "Users can manage own workouts" on public.workouts
    for all using (auth.uid() = user_id);

-- ============================================================================
-- 8. SLEEP & RECOVERY LOGS
-- ============================================================================
create table if not exists public.sleep_recovery_logs (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references auth.users(id) on delete cascade not null,
    sleep_date date not null,
    duration_minutes int not null,
    sleep_score int,
    recovery_score int,
    source text not null default 'manual',
    metadata jsonb default '{}'::jsonb,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

alter table public.sleep_recovery_logs enable row level security;

create policy "Users can manage own sleep recovery logs" on public.sleep_recovery_logs
    for all using (auth.uid() = user_id);

-- ============================================================================
-- 9. HABITS
-- ============================================================================
create table if not exists public.habits (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references auth.users(id) on delete cascade not null,
    title text not null,
    frequency text not null default 'daily',
    target_value numeric(6, 2),
    target_unit text,
    is_active boolean not null default true,
    metadata jsonb default '{}'::jsonb,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

alter table public.habits enable row level security;

create policy "Users can manage own habits" on public.habits
    for all using (auth.uid() = user_id);

-- ============================================================================
-- 10. MEDICATIONS
-- ============================================================================
create table if not exists public.medications (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references auth.users(id) on delete cascade not null,
    name text not null,
    dosage text not null,
    frequency text not null,
    instructions text,
    is_active boolean not null default true,
    metadata jsonb default '{}'::jsonb,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

alter table public.medications enable row level security;

create policy "Users can manage own medications" on public.medications
    for all using (auth.uid() = user_id);

-- ============================================================================
-- 11. FAMILY HEALTH RELATIONSHIPS
-- ============================================================================
create table if not exists public.family_health_relationships (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references auth.users(id) on delete cascade not null,
    related_user_id uuid references auth.users(id) on delete cascade not null,
    relationship_type text not null,
    consent_status text not null default 'pending', -- 'pending', 'consented', 'revoked'
    consented_at timestamptz,
    revoked_at timestamptz,
    metadata jsonb default '{}'::jsonb,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

alter table public.family_health_relationships enable row level security;

create policy "Users can manage family relationships they are party to" on public.family_health_relationships
    for all using (auth.uid() = user_id or auth.uid() = related_user_id);

-- ============================================================================
-- 12. ENTITLEMENTS (Subscriptions & Tiers)
-- ============================================================================
create table if not exists public.entitlements (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references auth.users(id) on delete cascade not null,
    plan_code text not null, -- 'yogi_free', 'karma_pro', 'fitkarma_elite'
    status text not null default 'active',
    starts_at timestamptz not null default now(),
    expires_at timestamptz,
    metadata jsonb default '{}'::jsonb,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

alter table public.entitlements enable row level security;

create policy "Users can read own entitlements" on public.entitlements
    for select using (auth.uid() = user_id);

-- ============================================================================
-- 13. PUSH TOKENS
-- ============================================================================
create table if not exists public.push_tokens (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references auth.users(id) on delete cascade not null,
    token text not null unique,
    platform text not null, -- 'android', 'ios'
    device_id text,
    is_active boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

alter table public.push_tokens enable row level security;

create policy "Users can manage own push tokens" on public.push_tokens
    for all using (auth.uid() = user_id);

-- ============================================================================
-- 14. STORAGE ASSETS (Private bucket media records)
-- ============================================================================
create table if not exists public.storage_assets (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references auth.users(id) on delete cascade not null,
    bucket_id text not null default 'private-health-assets',
    storage_path text not null,
    mime_type text not null,
    file_size_bytes bigint,
    metadata jsonb default '{}'::jsonb,
    created_at timestamptz not null default now()
);

alter table public.storage_assets enable row level security;

create policy "Users can manage own storage asset records" on public.storage_assets
    for all using (auth.uid() = user_id);

-- ============================================================================
-- 15. AUDIT DELETION OPERATIONS (DPDP Act Right-to-Erasure Audit Log)
-- ============================================================================
create table if not exists public.audit_deletion_operations (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null, -- Intentionally retained as historical identifier
    operation_type text not null default 'erasure',
    status text not null default 'completed',
    details jsonb default '{}'::jsonb,
    requested_at timestamptz not null default now(),
    completed_at timestamptz not null default now()
);

alter table public.audit_deletion_operations enable row level security;

create policy "Users can read own deletion audits" on public.audit_deletion_operations
    for select using (auth.uid() = user_id);

-- ============================================================================
-- DPDP ACT 2023 CASCADING USER ERASURE PROCEDURE
-- ============================================================================
create or replace function public.delete_user_data(target_user_id uuid)
returns void
language plpgsql
security definer
as $$
begin
    -- Only allow authenticated users to erase themselves or service_role
    if (auth.uid() is null or auth.uid() <> target_user_id) and current_setting('role', true) <> 'service_role' then
        raise exception 'Unauthorized deletion request';
    end if;

    -- Delete cascading records from user-owned tables
    delete from public.food_logs where user_id = target_user_id;
    delete from public.health_observations where user_id = target_user_id;
    delete from public.workouts where user_id = target_user_id;
    delete from public.sleep_recovery_logs where user_id = target_user_id;
    delete from public.habits where user_id = target_user_id;
    delete from public.medications where user_id = target_user_id;
    delete from public.recipes where user_id = target_user_id;
    delete from public.cooking_multipliers where user_id = target_user_id;
    delete from public.food_catalog where user_id = target_user_id;
    delete from public.family_health_relationships where user_id = target_user_id or related_user_id = target_user_id;
    delete from public.entitlements where user_id = target_user_id;
    delete from public.push_tokens where user_id = target_user_id;
    delete from public.storage_assets where user_id = target_user_id;
    delete from public.profiles where user_id = target_user_id;

    -- Record audit trace under DPDP Act obligations
    insert into public.audit_deletion_operations (user_id, operation_type, status, details)
    values (target_user_id, 'erasure', 'completed', jsonb_build_object('timestamp', now()));
end;
$$;

