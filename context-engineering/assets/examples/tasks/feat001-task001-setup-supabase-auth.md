# feat001-task001: setup-supabase-auth

Status: done

## Goal
Initialize Supabase client and configure auth settings in dashboard.

## Changes
- Added `@supabase/supabase-js` to package.json
- Created `lib/supabase.ts` with client init
- Enabled magic link in Supabase dashboard
- Set redirect URL to `/auth/callback`

## Discoveries
- Supabase requires `NEXT_PUBLIC_` prefix for client-side env vars
- Auth callback must handle both email confirm and magic link

## Blockers
none
