-- ============================================================================
-- SEEDFY DATABASE MIGRATION - COMPLETE SCHEMA
-- ============================================================================
-- Application: Seedfy - Garden Management System
-- Description: Complete database schema for managing farms, plots, beds, 
--              plantings, tasks, and collaborations
-- Database: PostgreSQL with Supabase
-- ============================================================================

-- ============================================================================
-- 00001_enable_extensions.sql
-- Enable necessary PostgreSQL extensions for Seedfy application
-- ============================================================================

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

-- ============================================================================
-- 00002_create_profiles_table.sql
-- Create profiles table - Extends Supabase auth.users with additional user information
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.profiles (
  -- Primary key linked to Supabase auth
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  
  -- User information
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT NOT NULL,
  
  -- Localization
  locale TEXT NOT NULL DEFAULT 'pt-BR' CHECK (locale IN ('pt-BR', 'en-US')),
  
  -- Location data
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX idx_profiles_email ON public.profiles(email);
CREATE INDEX idx_profiles_locale ON public.profiles(locale);

-- Enable RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own profile" 
  ON public.profiles FOR SELECT 
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" 
  ON public.profiles FOR UPDATE 
  USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" 
  ON public.profiles FOR INSERT 
  WITH CHECK (auth.uid() = id);

-- Comment on table
COMMENT ON TABLE public.profiles IS 'User profiles extending Supabase auth.users';
COMMENT ON COLUMN public.profiles.locale IS 'User language preference: pt-BR for Portuguese (Brazil), en-US for English (US)';

-- ============================================================================
-- 00003_create_farms_table.sql
-- Create farms table - Represents a farm or garden owned by a user
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.farms (
  -- Primary key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Foreign keys
  owner_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  
  -- Farm information
  name TEXT NOT NULL,
  description TEXT,
  
  -- Location (optional, for future features)
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  address TEXT,
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes
CREATE INDEX idx_farms_owner_id ON public.farms(owner_id);
CREATE INDEX idx_farms_created_at ON public.farms(created_at DESC);

-- Enable RLS
ALTER TABLE public.farms ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own farms" 
  ON public.farms FOR SELECT 
  USING (auth.uid() = owner_id);

CREATE POLICY "Users can insert own farms" 
  ON public.farms FOR INSERT 
  WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Users can update own farms" 
  ON public.farms FOR UPDATE 
  USING (auth.uid() = owner_id);

CREATE POLICY "Users can delete own farms" 
  ON public.farms FOR DELETE 
  USING (auth.uid() = owner_id);

-- Note: Policy for collaborators will be added after creating collaborators table

-- Comments
COMMENT ON TABLE public.farms IS 'Farms or gardens owned by users';
COMMENT ON COLUMN public.farms.latitude IS 'Optional GPS latitude for farm location';
COMMENT ON COLUMN public.farms.longitude IS 'Optional GPS longitude for farm location';

-- ============================================================================
-- 00004_create_plots_table.sql
-- Create plots table - Represents cultivation areas within a farm
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.plots (
  -- Primary key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Foreign keys
  farm_id UUID NOT NULL REFERENCES public.farms(id) ON DELETE CASCADE,
  
  -- Plot information
  label TEXT NOT NULL DEFAULT 'Área Principal',
  description TEXT,
  
  -- Dimensions (in meters)
  length_m NUMERIC(10, 2) NOT NULL CHECK (length_m > 0),
  width_m NUMERIC(10, 2) NOT NULL CHECK (width_m > 0),
  
  -- Path configuration
  path_gap_m NUMERIC(5, 2) NOT NULL DEFAULT 0.4 CHECK (path_gap_m >= 0),
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes
CREATE INDEX idx_plots_farm_id ON public.plots(farm_id);

-- Enable RLS
ALTER TABLE public.plots ENABLE ROW LEVEL SECURITY;

-- RLS Policies (inherit permissions from farms)
CREATE POLICY "Users can view plots in accessible farms" 
  ON public.plots FOR SELECT 
  USING (
    farm_id IN (
      SELECT id FROM public.farms 
      WHERE owner_id = auth.uid()
    )
  );

CREATE POLICY "Users can manage plots in owned farms" 
  ON public.plots FOR ALL 
  USING (
    farm_id IN (
      SELECT id FROM public.farms 
      WHERE owner_id = auth.uid()
    )
  );

-- Comments
COMMENT ON TABLE public.plots IS 'Cultivation areas within farms';
COMMENT ON COLUMN public.plots.length_m IS 'Plot length in meters';
COMMENT ON COLUMN public.plots.width_m IS 'Plot width in meters';
COMMENT ON COLUMN public.plots.path_gap_m IS 'Width of paths between beds in meters';

-- ============================================================================
-- 00005_create_beds_table.sql
-- Create beds table - Represents individual cultivation beds in a grid layout
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.beds (
  -- Primary key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Foreign keys
  plot_id UUID NOT NULL REFERENCES public.plots(id) ON DELETE CASCADE,
  
  -- Grid position
  x INTEGER NOT NULL CHECK (x >= 0),
  y INTEGER NOT NULL CHECK (y >= 0),
  
  -- Dimensions (in meters)
  width_m NUMERIC(5, 2) NOT NULL CHECK (width_m > 0),
  height_m NUMERIC(5, 2) NOT NULL CHECK (height_m > 0),
  
  -- Bed properties
  is_active BOOLEAN DEFAULT true,
  soil_type TEXT,
  notes TEXT,
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Ensure unique position within a plot
  UNIQUE(plot_id, x, y)
);

-- Create indexes
CREATE INDEX idx_beds_plot_id ON public.beds(plot_id);
CREATE INDEX idx_beds_position ON public.beds(plot_id, x, y);
CREATE INDEX idx_beds_active ON public.beds(is_active) WHERE is_active = true;

-- Enable RLS
ALTER TABLE public.beds ENABLE ROW LEVEL SECURITY;

-- RLS Policies (inherit permissions from plots)
CREATE POLICY "Users can view beds in accessible plots" 
  ON public.beds FOR SELECT 
  USING (
    plot_id IN (
      SELECT p.id FROM public.plots p
      JOIN public.farms f ON p.farm_id = f.id
      WHERE f.owner_id = auth.uid()
    )
  );

CREATE POLICY "Users can manage beds in owned farms" 
  ON public.beds FOR ALL 
  USING (
    plot_id IN (
      SELECT p.id FROM public.plots p
      JOIN public.farms f ON p.farm_id = f.id
      WHERE f.owner_id = auth.uid()
    )
  );

-- Comments
COMMENT ON TABLE public.beds IS 'Individual cultivation beds within plot grids';
COMMENT ON COLUMN public.beds.x IS 'X coordinate in the plot grid (0-based)';
COMMENT ON COLUMN public.beds.y IS 'Y coordinate in the plot grid (0-based)';
COMMENT ON COLUMN public.beds.is_active IS 'Whether the bed is currently in use';

-- ============================================================================
-- 00006_create_crops_catalog_table.sql
-- Create crops catalog table - Master table for crop varieties and their characteristics
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.crops_catalog (
  -- Primary key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Crop names (multilingual support)
  name_pt TEXT NOT NULL,
  name_en TEXT NOT NULL,
  scientific_name TEXT,
  
  -- Visual
  image_url TEXT NOT NULL,
  color_hex TEXT,
  
  -- Cultivation parameters
  row_spacing_m NUMERIC(5, 2) NOT NULL CHECK (row_spacing_m > 0),
  plant_spacing_m NUMERIC(5, 2) NOT NULL CHECK (plant_spacing_m > 0),
  
  -- Growth cycle
  cycle_days INTEGER NOT NULL CHECK (cycle_days > 0),
  germination_days INTEGER CHECK (germination_days > 0),
  
  -- Productivity
  yield_per_m2 NUMERIC(10, 2) CHECK (yield_per_m2 IS NULL OR yield_per_m2 > 0),
  yield_unit TEXT DEFAULT 'kg',
  
  -- Categories
  category TEXT CHECK (category IN ('leafy', 'fruit', 'root', 'herb', 'flower', 'other')),
  season TEXT CHECK (season IN ('spring', 'summer', 'fall', 'winter', 'all')),
  
  -- Companion planting
  companion_crops TEXT[], -- Array of crop IDs that grow well together
  antagonist_crops TEXT[], -- Array of crop IDs that should not be planted together
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes
CREATE INDEX idx_crops_catalog_category ON public.crops_catalog(category);
CREATE INDEX idx_crops_catalog_season ON public.crops_catalog(season);
CREATE INDEX idx_crops_catalog_name_pt ON public.crops_catalog(name_pt);
CREATE INDEX idx_crops_catalog_name_en ON public.crops_catalog(name_en);

-- No RLS needed - public read access
ALTER TABLE public.crops_catalog ENABLE ROW LEVEL SECURITY;

-- Allow all authenticated users to read
CREATE POLICY "Anyone can view crops catalog" 
  ON public.crops_catalog FOR SELECT 
  TO authenticated 
  USING (true);

-- Only admins can modify (implement admin check as needed)
CREATE POLICY "Only admins can modify crops catalog" 
  ON public.crops_catalog FOR ALL 
  USING (false); -- Will be updated when admin system is implemented

-- Comments
COMMENT ON TABLE public.crops_catalog IS 'Master catalog of available crops and their characteristics';
COMMENT ON COLUMN public.crops_catalog.companion_crops IS 'Array of crop IDs that grow well with this crop';
COMMENT ON COLUMN public.crops_catalog.antagonist_crops IS 'Array of crop IDs that should not be planted near this crop';

-- ============================================================================
-- 00007_create_plantings_table.sql
-- Create plantings table - Records of crops planted in beds
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.plantings (
  -- Primary key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Foreign keys
  bed_id UUID NOT NULL REFERENCES public.beds(id) ON DELETE CASCADE,
  crop_id UUID NOT NULL REFERENCES public.crops_catalog(id) ON DELETE RESTRICT,
  
  -- Custom cultivation parameters (override catalog defaults)
  custom_cycle_days INTEGER CHECK (custom_cycle_days IS NULL OR custom_cycle_days > 0),
  custom_row_spacing_m NUMERIC(5, 2) CHECK (custom_row_spacing_m IS NULL OR custom_row_spacing_m > 0),
  custom_plant_spacing_m NUMERIC(5, 2) CHECK (custom_plant_spacing_m IS NULL OR custom_plant_spacing_m > 0),
  
  -- Planting dates
  sowing_date DATE NOT NULL,
  transplant_date DATE,
  harvest_estimate DATE NOT NULL,
  actual_harvest_date DATE,
  
  -- Quantity and yield
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  expected_yield NUMERIC(10, 2),
  actual_yield NUMERIC(10, 2),
  
  -- Intercropping support
  intercrop_of UUID REFERENCES public.plantings(id) ON DELETE SET NULL,
  is_companion BOOLEAN DEFAULT false,
  
  -- Status
  status TEXT DEFAULT 'planned' CHECK (status IN ('planned', 'planted', 'growing', 'harvested', 'failed')),
  health_status TEXT DEFAULT 'healthy' CHECK (health_status IN ('healthy', 'warning', 'critical')),
  
  -- Notes and observations
  notes TEXT,
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Constraints
  CHECK (harvest_estimate >= sowing_date),
  CHECK (actual_harvest_date IS NULL OR actual_harvest_date >= sowing_date)
);

-- Create indexes
CREATE INDEX idx_plantings_bed_id ON public.plantings(bed_id);
CREATE INDEX idx_plantings_crop_id ON public.plantings(crop_id);
CREATE INDEX idx_plantings_sowing_date ON public.plantings(sowing_date);
CREATE INDEX idx_plantings_harvest_estimate ON public.plantings(harvest_estimate);
CREATE INDEX idx_plantings_status ON public.plantings(status);
CREATE INDEX idx_plantings_intercrop ON public.plantings(intercrop_of) WHERE intercrop_of IS NOT NULL;

-- Enable RLS
ALTER TABLE public.plantings ENABLE ROW LEVEL SECURITY;

-- RLS Policies (inherit permissions from beds)
CREATE POLICY "Users can view plantings in accessible beds" 
  ON public.plantings FOR SELECT 
  USING (
    bed_id IN (
      SELECT b.id FROM public.beds b
      JOIN public.plots p ON b.plot_id = p.id
      JOIN public.farms f ON p.farm_id = f.id
      WHERE f.owner_id = auth.uid()
    )
  );

CREATE POLICY "Users can manage plantings in owned farms" 
  ON public.plantings FOR ALL 
  USING (
    bed_id IN (
      SELECT b.id FROM public.beds b
      JOIN public.plots p ON b.plot_id = p.id
      JOIN public.farms f ON p.farm_id = f.id
      WHERE f.owner_id = auth.uid()
    )
  );

-- Comments
COMMENT ON TABLE public.plantings IS 'Records of crops planted in beds';
COMMENT ON COLUMN public.plantings.intercrop_of IS 'References the main planting if this is an intercrop';
COMMENT ON COLUMN public.plantings.is_companion IS 'Whether this is a companion planting';
COMMENT ON COLUMN public.plantings.status IS 'Current status of the planting';

-- ============================================================================
-- 00008_create_tasks_table.sql
-- Create tasks table - Cultivation tasks for plantings
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.tasks (
  -- Primary key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Foreign keys
  planting_id UUID NOT NULL REFERENCES public.plantings(id) ON DELETE CASCADE,
  assigned_to UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  
  -- Task information
  type TEXT NOT NULL CHECK (type IN (
    'water', 'fertilize', 'transplant', 'harvest', 
    'prune', 'pest_control', 'disease_control', 
    'weed', 'mulch', 'other'
  )),
  title TEXT NOT NULL,
  description TEXT,
  
  -- Scheduling
  due_date DATE NOT NULL,
  reminder_date DATE,
  
  -- Status
  done BOOLEAN DEFAULT false,
  completed_at TIMESTAMPTZ,
  completed_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  
  -- Priority and effort
  priority TEXT DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
  estimated_minutes INTEGER CHECK (estimated_minutes > 0),
  actual_minutes INTEGER CHECK (actual_minutes > 0),
  
  -- Notes
  notes TEXT,
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes
CREATE INDEX idx_tasks_planting_id ON public.tasks(planting_id);
CREATE INDEX idx_tasks_due_date ON public.tasks(due_date);
CREATE INDEX idx_tasks_done ON public.tasks(done);
CREATE INDEX idx_tasks_priority ON public.tasks(priority);
CREATE INDEX idx_tasks_assigned_to ON public.tasks(assigned_to) WHERE assigned_to IS NOT NULL;
CREATE INDEX idx_tasks_upcoming ON public.tasks(due_date) WHERE done = false;

-- Enable RLS
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

-- RLS Policies (inherit permissions from plantings)
CREATE POLICY "Users can view tasks in accessible plantings" 
  ON public.tasks FOR SELECT 
  USING (
    planting_id IN (
      SELECT pl.id FROM public.plantings pl
      JOIN public.beds b ON pl.bed_id = b.id
      JOIN public.plots p ON b.plot_id = p.id
      JOIN public.farms f ON p.farm_id = f.id
      WHERE f.owner_id = auth.uid()
    )
  );

CREATE POLICY "Users can manage tasks in owned farms" 
  ON public.tasks FOR ALL 
  USING (
    planting_id IN (
      SELECT pl.id FROM public.plantings pl
      JOIN public.beds b ON pl.bed_id = b.id
      JOIN public.plots p ON b.plot_id = p.id
      JOIN public.farms f ON p.farm_id = f.id
      WHERE f.owner_id = auth.uid()
    )
  );

-- Comments
COMMENT ON TABLE public.tasks IS 'Cultivation and maintenance tasks for plantings';
COMMENT ON COLUMN public.tasks.type IS 'Type of cultivation task';
COMMENT ON COLUMN public.tasks.priority IS 'Task priority level';
COMMENT ON COLUMN public.tasks.estimated_minutes IS 'Estimated time to complete in minutes';

-- ============================================================================
-- 00009_create_collaborators_table.sql
-- Create collaborators table - Manages farm access permissions for multiple users
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.collaborators (
  -- Primary key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Foreign keys
  farm_id UUID NOT NULL REFERENCES public.farms(id) ON DELETE CASCADE,
  profile_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  
  -- Permissions
  role TEXT NOT NULL CHECK (role IN ('viewer', 'editor', 'manager')),
  
  -- Invitation tracking
  invited_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  accepted_at TIMESTAMPTZ,
  
  -- Status
  is_active BOOLEAN DEFAULT true,
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Ensure unique collaboration per farm-user pair
  UNIQUE(farm_id, profile_id)
);

-- Create indexes
CREATE INDEX idx_collaborators_farm_id ON public.collaborators(farm_id);
CREATE INDEX idx_collaborators_profile_id ON public.collaborators(profile_id);
CREATE INDEX idx_collaborators_role ON public.collaborators(role);
CREATE INDEX idx_collaborators_active ON public.collaborators(is_active) WHERE is_active = true;

-- Enable RLS
ALTER TABLE public.collaborators ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view collaborations they are part of" 
  ON public.collaborators FOR SELECT 
  USING (
    profile_id = auth.uid() OR
    farm_id IN (
      SELECT id FROM public.farms 
      WHERE owner_id = auth.uid()
    )
  );

CREATE POLICY "Farm owners can manage collaborators" 
  ON public.collaborators FOR ALL 
  USING (
    farm_id IN (
      SELECT id FROM public.farms 
      WHERE owner_id = auth.uid()
    )
  );

-- Now we can add the collaboration policy to farms table
CREATE POLICY "Collaborators can view farms" 
  ON public.farms FOR SELECT 
  USING (
    EXISTS (
      SELECT 1 FROM public.collaborators 
      WHERE collaborators.farm_id = farms.id 
      AND collaborators.profile_id = auth.uid()
      AND collaborators.is_active = true
    )
  );

-- Comments
COMMENT ON TABLE public.collaborators IS 'Manages collaborative access to farms';
COMMENT ON COLUMN public.collaborators.role IS 'viewer: read-only, editor: can modify, manager: full access except delete';
COMMENT ON COLUMN public.collaborators.invited_by IS 'Profile ID of the user who sent the invitation';

-- ============================================================================
-- 00010_create_invitations_table.sql
-- Create invitations table - Manages pending collaboration invitations
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.invitations (
  -- Primary key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Farm and inviter information
  farm_id UUID NOT NULL REFERENCES public.farms(id) ON DELETE CASCADE,
  farm_name TEXT NOT NULL,
  inviter_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  inviter_name TEXT NOT NULL,
  inviter_email TEXT NOT NULL,
  
  -- Invitee information
  invitee_email TEXT NOT NULL,
  
  -- Invitation details
  role TEXT NOT NULL CHECK (role IN ('viewer', 'editor', 'manager')),
  message TEXT,
  
  -- Status tracking
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'declined', 'expired', 'cancelled')),
  
  -- Security
  token TEXT UNIQUE DEFAULT gen_random_uuid()::TEXT,
  
  -- Expiration
  expires_at TIMESTAMPTZ DEFAULT (NOW() + INTERVAL '7 days'),
  
  -- Response tracking
  responded_at TIMESTAMPTZ,
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes
CREATE INDEX idx_invitations_farm_id ON public.invitations(farm_id);
CREATE INDEX idx_invitations_invitee_email ON public.invitations(invitee_email);
CREATE INDEX idx_invitations_inviter_id ON public.invitations(inviter_id);
CREATE INDEX idx_invitations_status ON public.invitations(status);
CREATE INDEX idx_invitations_token ON public.invitations(token);
CREATE INDEX idx_invitations_expires_at ON public.invitations(expires_at) WHERE status = 'pending';

-- Enable RLS
ALTER TABLE public.invitations ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view invitations sent to them" 
  ON public.invitations FOR SELECT 
  USING (
    invitee_email = (
      SELECT email FROM public.profiles 
      WHERE id = auth.uid()
    )
  );

CREATE POLICY "Farm owners can view invitations for their farms" 
  ON public.invitations FOR SELECT 
  USING (
    farm_id IN (
      SELECT id FROM public.farms 
      WHERE owner_id = auth.uid()
    )
  );

CREATE POLICY "Farm owners can create invitations" 
  ON public.invitations FOR INSERT 
  WITH CHECK (
    farm_id IN (
      SELECT id FROM public.farms 
      WHERE owner_id = auth.uid()
    ) AND 
    inviter_id = auth.uid()
  );

CREATE POLICY "Users can update invitations sent to them" 
  ON public.invitations FOR UPDATE 
  USING (
    invitee_email = (
      SELECT email FROM public.profiles 
      WHERE id = auth.uid()
    )
  );

CREATE POLICY "Farm owners can delete invitations" 
  ON public.invitations FOR DELETE 
  USING (
    farm_id IN (
      SELECT id FROM public.farms 
      WHERE owner_id = auth.uid()
    )
  );

-- Comments
COMMENT ON TABLE public.invitations IS 'Pending collaboration invitations for farms';
COMMENT ON COLUMN public.invitations.token IS 'Unique token for invitation URL';
COMMENT ON COLUMN public.invitations.expires_at IS 'Invitation expiration timestamp';

-- ============================================================================
-- 00011_create_map_templates_table.sql
-- Create map templates table - Stores reusable garden layout templates
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.map_templates (
  -- Primary key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Owner
  owner_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  
  -- Template information
  title TEXT NOT NULL,
  description TEXT,
  
  -- Template data (JSON structure)
  payload JSONB NOT NULL,
  
  -- Sharing settings
  is_public BOOLEAN DEFAULT false,
  is_featured BOOLEAN DEFAULT false,
  
  -- Usage tracking
  usage_count INTEGER DEFAULT 0,
  
  -- Categories and tags
  category TEXT CHECK (category IN ('small', 'medium', 'large', 'urban', 'rural', 'greenhouse', 'other')),
  tags TEXT[],
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes
CREATE INDEX idx_map_templates_owner_id ON public.map_templates(owner_id);
CREATE INDEX idx_map_templates_public ON public.map_templates(is_public) WHERE is_public = true;
CREATE INDEX idx_map_templates_featured ON public.map_templates(is_featured) WHERE is_featured = true;
CREATE INDEX idx_map_templates_category ON public.map_templates(category);
CREATE INDEX idx_map_templates_tags ON public.map_templates USING gin(tags);

-- Enable RLS
ALTER TABLE public.map_templates ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own templates" 
  ON public.map_templates FOR SELECT 
  USING (
    owner_id = auth.uid() OR 
    is_public = true
  );

CREATE POLICY "Users can manage own templates" 
  ON public.map_templates FOR ALL 
  USING (owner_id = auth.uid());

-- Comments
COMMENT ON TABLE public.map_templates IS 'Reusable garden layout templates';
COMMENT ON COLUMN public.map_templates.payload IS 'JSON structure containing plot dimensions, bed layouts, and crop placements';
COMMENT ON COLUMN public.map_templates.is_public IS 'Whether the template is shared with the community';
COMMENT ON COLUMN public.map_templates.is_featured IS 'Whether the template is featured (admin-curated)';

-- ============================================================================
-- 00012_create_functions.sql
-- Database functions and triggers
-- ============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to automatically create user profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (
    id, 
    name, 
    email, 
    phone, 
    locale, 
    city, 
    state
  )
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'name', 'User'),
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'phone', ''),
    COALESCE(NEW.raw_user_meta_data->>'locale', 'pt-BR'),
    COALESCE(NEW.raw_user_meta_data->>'city', ''),
    COALESCE(NEW.raw_user_meta_data->>'state', '')
  );
  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Log error but don't fail user creation
    RAISE WARNING 'Failed to create profile for user %: %', NEW.id, SQLERRM;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to automatically generate tasks when planting is created
CREATE OR REPLACE FUNCTION public.generate_planting_tasks()
RETURNS TRIGGER AS $$
DECLARE
  v_cycle_days INTEGER;
  v_crop_name TEXT;
  v_water_interval INTEGER := 3; -- Water every 3 days
  i INTEGER;
BEGIN
  -- Get cycle days (custom or from catalog)
  IF NEW.custom_cycle_days IS NOT NULL THEN
    v_cycle_days := NEW.custom_cycle_days;
  ELSE
    SELECT c.cycle_days, c.name_pt 
    INTO v_cycle_days, v_crop_name
    FROM public.crops_catalog c
    WHERE c.id = NEW.crop_id;
  END IF;
  
  -- Generate water tasks (every 3 days during growth)
  FOR i IN 1..CEIL(v_cycle_days::float / v_water_interval) LOOP
    INSERT INTO public.tasks (
      planting_id, 
      type, 
      title,
      due_date,
      priority
    )
    VALUES (
      NEW.id,
      'water',
      'Regar plantação',
      NEW.sowing_date + (i * v_water_interval),
      CASE 
        WHEN i <= 3 THEN 'high'  -- First week is critical
        ELSE 'medium'
      END
    );
  END LOOP;
  
  -- Generate fertilize task (middle of cycle)
  INSERT INTO public.tasks (
    planting_id, 
    type, 
    title,
    due_date,
    priority
  )
  VALUES (
    NEW.id,
    'fertilize',
    'Adubar plantação',
    NEW.sowing_date + (v_cycle_days / 2),
    'medium'
  );
  
  -- Generate transplant task (if needed, early in cycle)
  IF v_cycle_days > 30 THEN
    INSERT INTO public.tasks (
      planting_id, 
      type,
      title, 
      due_date,
      priority
    )
    VALUES (
      NEW.id,
      'transplant',
      'Transplantar mudas',
      NEW.sowing_date + 14,
      'high'
    );
  END IF;
  
  -- Generate harvest task
  INSERT INTO public.tasks (
    planting_id, 
    type,
    title,
    due_date,
    priority
  )
  VALUES (
    NEW.id,
    'harvest',
    'Colher ' || COALESCE(v_crop_name, 'plantação'),
    NEW.harvest_estimate,
    'high'
  );
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to expire old invitations
CREATE OR REPLACE FUNCTION public.expire_old_invitations()
RETURNS INTEGER AS $$
DECLARE
  v_count INTEGER;
BEGIN
  UPDATE public.invitations 
  SET status = 'expired'
  WHERE status = 'pending' 
    AND expires_at IS NOT NULL 
    AND expires_at < NOW();
  
  GET DIAGNOSTICS v_count = ROW_COUNT;
  RETURN v_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to calculate bed area
CREATE OR REPLACE FUNCTION public.calculate_bed_area(
  p_width_m NUMERIC,
  p_height_m NUMERIC
)
RETURNS NUMERIC AS $$
BEGIN
  RETURN ROUND(p_width_m * p_height_m, 2);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Function to calculate plant count for a bed
CREATE OR REPLACE FUNCTION public.calculate_plant_count(
  p_bed_width_m NUMERIC,
  p_bed_height_m NUMERIC,
  p_row_spacing_m NUMERIC,
  p_plant_spacing_m NUMERIC
)
RETURNS INTEGER AS $$
DECLARE
  v_rows INTEGER;
  v_plants_per_row INTEGER;
BEGIN
  -- Calculate number of rows
  v_rows := FLOOR(p_bed_height_m / p_row_spacing_m);
  
  -- Calculate plants per row
  v_plants_per_row := FLOOR(p_bed_width_m / p_plant_spacing_m);
  
  -- Return total plant count
  RETURN GREATEST(v_rows * v_plants_per_row, 1);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Comments
COMMENT ON FUNCTION public.update_updated_at_column() IS 'Automatically updates the updated_at timestamp';
COMMENT ON FUNCTION public.handle_new_user() IS 'Creates a user profile when a new auth user is created';
COMMENT ON FUNCTION public.generate_planting_tasks() IS 'Automatically generates cultivation tasks for new plantings';
COMMENT ON FUNCTION public.expire_old_invitations() IS 'Marks expired invitations as expired';
COMMENT ON FUNCTION public.calculate_bed_area() IS 'Calculates the area of a bed in square meters';
COMMENT ON FUNCTION public.calculate_plant_count() IS 'Estimates the number of plants that fit in a bed';

-- ============================================================================
-- 00013_create_triggers.sql
-- Database triggers
-- ============================================================================

-- Trigger to create profile on user signup
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW 
  EXECUTE FUNCTION public.handle_new_user();

-- Triggers for updated_at columns
CREATE TRIGGER update_profiles_updated_at 
  BEFORE UPDATE ON public.profiles 
  FOR EACH ROW 
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_farms_updated_at 
  BEFORE UPDATE ON public.farms 
  FOR EACH ROW 
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_plots_updated_at 
  BEFORE UPDATE ON public.plots 
  FOR EACH ROW 
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_beds_updated_at 
  BEFORE UPDATE ON public.beds 
  FOR EACH ROW 
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_crops_catalog_updated_at 
  BEFORE UPDATE ON public.crops_catalog 
  FOR EACH ROW 
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_plantings_updated_at 
  BEFORE UPDATE ON public.plantings 
  FOR EACH ROW 
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_tasks_updated_at 
  BEFORE UPDATE ON public.tasks 
  FOR EACH ROW 
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_collaborators_updated_at 
  BEFORE UPDATE ON public.collaborators 
  FOR EACH ROW 
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_invitations_updated_at 
  BEFORE UPDATE ON public.invitations 
  FOR EACH ROW 
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_map_templates_updated_at 
  BEFORE UPDATE ON public.map_templates 
  FOR EACH ROW 
  EXECUTE FUNCTION public.update_updated_at_column();

-- Trigger to generate tasks on planting creation
DROP TRIGGER IF EXISTS on_planting_created ON public.plantings;
CREATE TRIGGER on_planting_created
  AFTER INSERT ON public.plantings
  FOR EACH ROW 
  EXECUTE FUNCTION public.generate_planting_tasks();

-- Comments
COMMENT ON TRIGGER on_auth_user_created ON auth.users IS 'Creates user profile on signup';
COMMENT ON TRIGGER on_planting_created ON public.plantings IS 'Generates tasks when a planting is created';

-- ============================================================================
-- 00014_insert_seed_data.sql
-- Insert seed data for crops catalog
-- ============================================================================

INSERT INTO public.crops_catalog (
  name_pt, 
  name_en, 
  scientific_name,
  image_url, 
  row_spacing_m, 
  plant_spacing_m, 
  cycle_days, 
  germination_days,
  yield_per_m2,
  category,
  season
) VALUES
  ('Alface', 'Lettuce', 'Lactuca sativa', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f957.svg', 0.3, 0.25, 45, 7, 4.0, 'leafy', 'all'),
  ('Tomate', 'Tomato', 'Solanum lycopersicum', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f345.svg', 0.8, 0.5, 90, 10, 8.0, 'fruit', 'summer'),
  ('Cenoura', 'Carrot', 'Daucus carota', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f955.svg', 0.2, 0.05, 75, 14, 3.0, 'root', 'all'),
  ('Rúcula', 'Arugula', 'Eruca vesicaria', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f96c.svg', 0.2, 0.15, 30, 5, 2.5, 'leafy', 'all'),
  ('Brócolis', 'Broccoli', 'Brassica oleracea', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f966.svg', 0.5, 0.4, 80, 7, 3.5, 'other', 'fall'),
  ('Couve', 'Kale', 'Brassica oleracea var. acephala', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f96c.svg', 0.4, 0.3, 60, 7, 3.0, 'leafy', 'all'),
  ('Pepino', 'Cucumber', 'Cucumis sativus', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f952.svg', 1.0, 0.3, 65, 7, 6.0, 'fruit', 'summer'),
  ('Pimentão', 'Bell Pepper', 'Capsicum annuum', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1fad1.svg', 0.6, 0.4, 85, 14, 5.0, 'fruit', 'summer'),
  ('Manjericão', 'Basil', 'Ocimum basilicum', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f33f.svg', 0.3, 0.2, 50, 7, 2.0, 'herb', 'summer'),
  ('Salsa', 'Parsley', 'Petroselinum crispum', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f33f.svg', 0.2, 0.1, 40, 21, 1.5, 'herb', 'all'),
  ('Beterraba', 'Beet', 'Beta vulgaris', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f957.svg', 0.3, 0.1, 60, 10, 3.5, 'root', 'all'),
  ('Espinafre', 'Spinach', 'Spinacia oleracea', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f96c.svg', 0.25, 0.15, 40, 7, 2.0, 'leafy', 'fall'),
  ('Abobrinha', 'Zucchini', 'Cucurbita pepo', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f952.svg', 1.0, 0.8, 60, 7, 5.0, 'fruit', 'summer'),
  ('Rabanete', 'Radish', 'Raphanus sativus', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f957.svg', 0.15, 0.05, 25, 5, 2.0, 'root', 'all'),
  ('Coentro', 'Cilantro', 'Coriandrum sativum', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f33f.svg', 0.2, 0.1, 35, 7, 1.5, 'herb', 'all')
ON CONFLICT DO NOTHING;

-- Comments
COMMENT ON TABLE public.crops_catalog IS 'Seed data for crops catalog - basic vegetables and herbs';

-- ============================================================================
-- 00015_grant_permissions.sql
-- Grant necessary permissions
-- ============================================================================

-- Grant usage on public schema
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO anon;

-- Grant permissions on all tables
GRANT ALL ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO anon;

-- Grant permissions on all sequences
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO authenticated;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO anon;

-- Grant permissions on all functions
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO authenticated;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO anon;

-- Comments
COMMENT ON SCHEMA public IS 'Seedfy application schema with garden management tables';

-- ============================================================================
-- 00016_update_collaboration_policies.sql
-- Update collaboration policies for better access control
-- ============================================================================

-- Add editor permissions for plots
CREATE POLICY "Editors can modify plots they have access to" 
  ON public.plots FOR ALL 
  USING (
    farm_id IN (
      SELECT farm_id FROM public.collaborators 
      WHERE profile_id = auth.uid() 
      AND role IN ('editor', 'manager')
      AND is_active = true
    )
  );

-- Add editor permissions for beds
CREATE POLICY "Editors can modify beds they have access to" 
  ON public.beds FOR ALL 
  USING (
    plot_id IN (
      SELECT p.id FROM public.plots p
      JOIN public.farms f ON p.farm_id = f.id
      WHERE f.id IN (
        SELECT farm_id FROM public.collaborators 
        WHERE profile_id = auth.uid() 
        AND role IN ('editor', 'manager')
        AND is_active = true
      )
    )
  );

-- Add editor permissions for plantings
CREATE POLICY "Editors can modify plantings they have access to" 
  ON public.plantings FOR ALL 
  USING (
    bed_id IN (
      SELECT b.id FROM public.beds b
      JOIN public.plots p ON b.plot_id = p.id
      JOIN public.farms f ON p.farm_id = f.id
      WHERE f.id IN (
        SELECT farm_id FROM public.collaborators 
        WHERE profile_id = auth.uid() 
        AND role IN ('editor', 'manager')
        AND is_active = true
      )
    )
  );

-- Add editor permissions for tasks
CREATE POLICY "Editors can modify tasks they have access to" 
  ON public.tasks FOR ALL 
  USING (
    planting_id IN (
      SELECT pl.id FROM public.plantings pl
      JOIN public.beds b ON pl.bed_id = b.id
      JOIN public.plots p ON b.plot_id = p.id
      JOIN public.farms f ON p.farm_id = f.id
      WHERE f.id IN (
        SELECT farm_id FROM public.collaborators 
        WHERE profile_id = auth.uid() 
        AND role IN ('editor', 'manager')
        AND is_active = true
      )
    )
  );

-- Comments
COMMENT ON POLICY "Editors can modify plots they have access to" ON public.plots IS 'Allows editors and managers to modify plots';
COMMENT ON POLICY "Editors can modify beds they have access to" ON public.beds IS 'Allows editors and managers to modify beds';
COMMENT ON POLICY "Editors can modify plantings they have access to" ON public.plantings IS 'Allows editors and managers to modify plantings';
COMMENT ON POLICY "Editors can modify tasks they have access to" ON public.tasks IS 'Allows editors and managers to modify tasks';

-- ============================================================================
-- END OF MIGRATION
-- ============================================================================