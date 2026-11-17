-- INTIQ retailer sign-up: run once in Supabase → SQL Editor

-- 1) Table for form entries
create table if not exists public.retailer_kyc (
  id                    uuid primary key,
  created_at            timestamptz not null default now(),
  shop_name             text,
  gst_number            text,
  pan_number            text,
  aadhaar_front_path    text,
  aadhaar_back_path     text,
  gst_certificate_path  text,
  pan_card_path         text
);

alter table public.retailer_kyc enable row level security;

-- Visitors can only ADD a row. They cannot read, edit or delete anything.
create policy "public can submit"
  on public.retailer_kyc for insert to anon
  with check (true);

-- 2) Private bucket for Aadhaar / GST / PAN files (max 10 MB, images + PDF only)
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('kyc-documents', 'kyc-documents', false, 10485760,
        array['image/jpeg','image/png','image/webp','image/heic','application/pdf'])
on conflict (id) do nothing;

-- Visitors can only UPLOAD into this bucket. They cannot list or download files.
create policy "public can upload kyc docs"
  on storage.objects for insert to anon
  with check (bucket_id = 'kyc-documents');

-- Your team views entries in Supabase → Table Editor → retailer_kyc,
-- and files in Storage → kyc-documents (folder name = row id).
