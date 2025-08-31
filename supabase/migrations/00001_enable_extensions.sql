-- Enable necessary PostgreSQL extensions
-- Required for UUID generation and other features

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Note: Row Level Security (RLS) is enabled on individual tables
-- Supabase handles JWT secrets internally through their auth system