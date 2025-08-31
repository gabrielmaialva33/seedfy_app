-- Enable necessary PostgreSQL extensions for Seedfy application
-- Must be run as superuser or database owner

-- Enable UUID generation support
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Enable cryptographic functions (for secure random generation)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Enable Row Level Security for all tables
-- This is a Supabase best practice for data isolation
ALTER DATABASE postgres SET statement_timeout = '60s';

-- Set application name for connection identification
ALTER DATABASE postgres SET application_name = 'seedfy_app';

-- Comments for documentation
COMMENT ON EXTENSION "uuid-ossp" IS 'Functions for generating universally unique identifiers (UUIDs)';
COMMENT ON EXTENSION "pgcrypto" IS 'Cryptographic functions for PostgreSQL';