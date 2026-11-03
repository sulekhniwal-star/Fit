-- ============================================================================
-- FITKARMA DATABASE SCHEMA MIGRATION
-- Migration: 20261103000001_whatsapp_interactions.sql
-- Purpose: WhatsApp AI Logging interactions, audit log, and RLS policies
-- ============================================================================

create table if not exists public.whatsapp_interactions (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references auth.users(id) on delete cascade,
    wa_message_id text unique not null,
    phone_number text not null,
    message_type text not null, -- 'text', 'audio', 'interactive'
    raw_input text,
    candidate_items jsonb default '[]'::jsonb,
    total_calories numeric(6, 1) default 0.0,
    total_protein numeric(5, 1) default 0.0,
    total_carbs numeric(5, 1) default 0.0,
    total_fat numeric(5, 1) default 0.0,
    status text not null default 'pending', -- 'pending', 'confirmed', 'cancelled', 'unlinked_user', 'expired'
    metadata jsonb default '{}'::jsonb,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

-- Indexes for performance & deduplication
create index if not exists idx_wa_interactions_user_id on public.whatsapp_interactions(user_id);
create index if not exists idx_wa_interactions_wa_msg_id on public.whatsapp_interactions(wa_message_id);
create index if not exists idx_wa_interactions_phone on public.whatsapp_interactions(phone_number);
create index if not exists idx_wa_interactions_created_at on public.whatsapp_interactions(created_at desc);

-- Enable Row Level Security
alter table public.whatsapp_interactions enable row level security;

-- RLS Policies
create policy "Users can select own whatsapp interactions" on public.whatsapp_interactions
    for select using (auth.uid() = user_id);

create policy "Users can insert own whatsapp interactions" on public.whatsapp_interactions
    for insert with check (auth.uid() = user_id);

create policy "Users can update own whatsapp interactions" on public.whatsapp_interactions
    for update using (auth.uid() = user_id);

-- Update DPDP Erasure procedure to include whatsapp_interactions
create or replace function public.delete_user_data(target_user_id uuid)
returns void
language plpgsql
security definer
as $$
begin
    if auth.uid() <> target_user_id and current_setting('role') <> 'service_role' then
        raise exception 'Unauthorized deletion request';
    end if;

    delete from public.whatsapp_interactions where user_id = target_user_id;
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

    insert into public.audit_deletion_operations (user_id, operation_type, status, details)
    values (target_user_id, 'erasure', 'completed', jsonb_build_object('timestamp', now()));
end;
$$;

