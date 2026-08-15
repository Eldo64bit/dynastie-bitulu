// Archives de lumière — Supabase client boundary. Public publishable keys are safe only with RLS enabled.
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'https://skizuvrlcrutxnwbmxdi.supabase.co';
const supabaseKey = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY || 'sb_publishable_HGfetgP2Zi8RnYmx4hIYig_h7gtLqOR';

export const supabase = createClient(supabaseUrl, supabaseKey, {
  auth: { persistSession: true, autoRefreshToken: true, detectSessionInUrl: true },
});

export type Visibility = 'PUBLIC' | 'FAMILY' | 'NETWORK' | 'PRIVATE';
