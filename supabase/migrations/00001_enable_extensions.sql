-- Enable necessary PostgreSQL extensions
-- Required for UUID generation and other features

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Enable RLS (Row Level Security) for better data isolation
-- This is a Supabase best practice
ALTER DATABASE postgres SET "app.jwt_secret" TO 'super-secret-jwt-token-with-at-least-32-characters-long';