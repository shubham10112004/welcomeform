# INTIQ Retailer Sign-up

One static page: welcome animation → shop name → Aadhaar (front/back) → GST number + certificate → PAN number + card → review → send.
Every field is optional. Each upload offers **Take photo** (opens the phone camera) and **Choose file** (gallery or PDF).

## Deploy on Vercel
1. Put this folder in a GitHub repo (or drag the folder into vercel.com/new).
2. Framework preset: **Other**. No build command. Output directory: `.` (root).
3. Deploy. That's it; there's nothing to install.

## Connect Supabase
1. Create a Supabase project.
2. SQL Editor → paste `supabase-setup.sql` → Run. This creates the `retailer_kyc` table and a **private** `kyc-documents` bucket.
3. Project Settings → API → copy the **Project URL** and the **anon public** key.
4. In `index.html`, find `const CONFIG` and fill `SUPABASE_URL` and `SUPABASE_ANON_KEY`. Redeploy.

Until those two values are filled, the form runs in preview mode and shows "nothing was saved" on the last screen.

## Good to know
- Visitors can only add entries and upload files. They can't read or list anything (row-level security).
- Phone photos are resized to max 1800px JPEG before upload, so a 6 MB photo becomes roughly 300–600 KB.
- If the GST number is valid, the PAN step pre-fills the PAN from it (GSTIN characters 3–12).
- Text fields are kept on the device if the page is closed midway; files are not.
- Aadhaar is sensitive data. Keep the bucket private, and only give Supabase dashboard access to people who need it.
