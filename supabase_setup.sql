-- Seedfy - Supabase Database Setup
-- Run this script in your Supabase SQL editor

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create profiles table (extends auth.users)
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT NOT NULL,
  locale TEXT NOT NULL DEFAULT 'pt-BR' CHECK (locale IN ('pt-BR', 'en-US')),
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create farms table
CREATE TABLE IF NOT EXISTS farms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create plots table (areas within farms)
CREATE TABLE IF NOT EXISTS plots (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  farm_id UUID REFERENCES farms(id) ON DELETE CASCADE NOT NULL,
  label TEXT NOT NULL DEFAULT 'Área Principal',
  length_m NUMERIC NOT NULL CHECK (length_m > 0),
  width_m NUMERIC NOT NULL CHECK (width_m > 0),
  path_gap_m NUMERIC NOT NULL DEFAULT 0.4 CHECK (path_gap_m >= 0),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create beds table (individual growing beds in grid)
CREATE TABLE IF NOT EXISTS beds (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  plot_id UUID REFERENCES plots(id) ON DELETE CASCADE NOT NULL,
  x INTEGER NOT NULL CHECK (x >= 0),
  y INTEGER NOT NULL CHECK (y >= 0),
  width_m NUMERIC NOT NULL CHECK (width_m > 0),
  height_m NUMERIC NOT NULL CHECK (height_m > 0),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(plot_id, x, y)
);

-- Create crops catalog table
CREATE TABLE IF NOT EXISTS crops_catalog (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name_pt TEXT NOT NULL,
  name_en TEXT NOT NULL,
  image_url TEXT NOT NULL,
  row_spacing_m NUMERIC NOT NULL CHECK (row_spacing_m > 0),
  plant_spacing_m NUMERIC NOT NULL CHECK (plant_spacing_m > 0),
  cycle_days INTEGER NOT NULL CHECK (cycle_days > 0),
  yield_per_m2 NUMERIC CHECK (yield_per_m2 IS NULL OR yield_per_m2 > 0)
);

-- Create plantings table
CREATE TABLE IF NOT EXISTS plantings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  bed_id UUID REFERENCES beds(id) ON DELETE CASCADE NOT NULL,
  crop_id UUID REFERENCES crops_catalog(id) ON DELETE RESTRICT NOT NULL,
  custom_cycle_days INTEGER CHECK (custom_cycle_days IS NULL OR custom_cycle_days > 0),
  custom_row_spacing_m NUMERIC CHECK (custom_row_spacing_m IS NULL OR custom_row_spacing_m > 0),
  custom_plant_spacing_m NUMERIC CHECK (custom_plant_spacing_m IS NULL OR custom_plant_spacing_m > 0),
  sowing_date DATE NOT NULL,
  harvest_estimate DATE NOT NULL,
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  intercrop_of UUID REFERENCES plantings(id) ON DELETE SET NULL,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CHECK (harvest_estimate >= sowing_date)
);

-- Create tasks table
CREATE TABLE IF NOT EXISTS tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  planting_id UUID REFERENCES plantings(id) ON DELETE CASCADE NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('water', 'fertilize', 'transplant', 'harvest')),
  due_date DATE NOT NULL,
  done BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create collaborators table
CREATE TABLE IF NOT EXISTS collaborators (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  farm_id UUID REFERENCES farms(id) ON DELETE CASCADE NOT NULL,
  profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('editor', 'viewer')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(farm_id, profile_id)
);

-- Create invitations table for collaboration system
CREATE TABLE IF NOT EXISTS invitations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  farm_id UUID REFERENCES farms(id) ON DELETE CASCADE NOT NULL,
  farm_name TEXT NOT NULL,
  inviter_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  inviter_name TEXT NOT NULL,
  inviter_email TEXT NOT NULL,
  invitee_email TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('editor', 'viewer')),
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'declined', 'expired')),
  token TEXT UNIQUE,
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create map templates table (for future use)
CREATE TABLE IF NOT EXISTS map_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  payload JSONB NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert sample crops data
INSERT INTO crops_catalog (name_pt, name_en, image_url, row_spacing_m, plant_spacing_m, cycle_days, yield_per_m2) VALUES
('Alface', 'Lettuce', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f957.svg', 0.3, 0.25, 45, 4.0),
('Tomate', 'Tomato', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f345.svg', 0.8, 0.5, 90, 8.0),
('Cenoura', 'Carrot', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f955.svg', 0.2, 0.05, 75, 3.0),
('Rúcula', 'Arugula', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f96c.svg', 0.2, 0.15, 30, 2.5),
('Brócolis', 'Broccoli', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f966.svg', 0.5, 0.4, 80, 3.5),
('Couve', 'Kale', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f96c.svg', 0.4, 0.3, 60, 3.0),
('Pepino', 'Cucumber', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f952.svg', 1.0, 0.3, 65, 6.0),
('Pimentão', 'Bell Pepper', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1fad1.svg', 0.6, 0.4, 85, 5.0),
('Manjericão', 'Basil', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f33f.svg', 0.3, 0.2, 50, 2.0),
('Salsa', 'Parsley', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f33f.svg', 0.2, 0.1, 40, 1.5)
ON CONFLICT DO NOTHING;

-- Row Level Security (RLS) Policies

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE farms ENABLE ROW LEVEL SECURITY;
ALTER TABLE plots ENABLE ROW LEVEL SECURITY;
ALTER TABLE beds ENABLE ROW LEVEL SECURITY;
ALTER TABLE plantings ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE collaborators ENABLE ROW LEVEL SECURITY;
ALTER TABLE invitations ENABLE ROW LEVEL SECURITY;
ALTER TABLE map_templates ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Users can view own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- Farms policies
CREATE POLICY "Users can view own farms" ON farms FOR SELECT USING (auth.uid() = owner_id);
CREATE POLICY "Users can view farms they collaborate on" ON farms FOR SELECT USING (
  id IN (SELECT farm_id FROM collaborators WHERE profile_id = auth.uid())
);
CREATE POLICY "Users can insert own farms" ON farms FOR INSERT WITH CHECK (auth.uid() = owner_id);
CREATE POLICY "Users can update own farms" ON farms FOR UPDATE USING (auth.uid() = owner_id);
CREATE POLICY "Users can delete own farms" ON farms FOR DELETE USING (auth.uid() = owner_id);

-- Plots policies (inherit from farms)
CREATE POLICY "Users can view plots in their farms" ON plots FOR SELECT USING (
  farm_id IN (
    SELECT id FROM farms WHERE owner_id = auth.uid() 
    UNION 
    SELECT farm_id FROM collaborators WHERE profile_id = auth.uid()
  )
);
CREATE POLICY "Users can modify plots in owned farms" ON plots FOR ALL USING (
  farm_id IN (SELECT id FROM farms WHERE owner_id = auth.uid())
);
CREATE POLICY "Editors can modify plots" ON plots FOR ALL USING (
  farm_id IN (
    SELECT farm_id FROM collaborators 
    WHERE profile_id = auth.uid() AND role = 'editor'
  )
);

-- Beds policies (inherit from plots)
CREATE POLICY "Users can view beds in accessible plots" ON beds FOR SELECT USING (
  plot_id IN (
    SELECT p.id FROM plots p
    JOIN farms f ON p.farm_id = f.id
    WHERE f.owner_id = auth.uid() 
    OR f.id IN (SELECT farm_id FROM collaborators WHERE profile_id = auth.uid())
  )
);
CREATE POLICY "Users can modify beds in owned farms" ON beds FOR ALL USING (
  plot_id IN (
    SELECT p.id FROM plots p
    JOIN farms f ON p.farm_id = f.id
    WHERE f.owner_id = auth.uid()
  )
);
CREATE POLICY "Editors can modify beds" ON beds FOR ALL USING (
  plot_id IN (
    SELECT p.id FROM plots p
    JOIN farms f ON p.farm_id = f.id
    WHERE f.id IN (
      SELECT farm_id FROM collaborators 
      WHERE profile_id = auth.uid() AND role = 'editor'
    )
  )
);

-- Plantings policies (inherit from beds)
CREATE POLICY "Users can view plantings in accessible beds" ON plantings FOR SELECT USING (
  bed_id IN (
    SELECT b.id FROM beds b
    JOIN plots p ON b.plot_id = p.id
    JOIN farms f ON p.farm_id = f.id
    WHERE f.owner_id = auth.uid() 
    OR f.id IN (SELECT farm_id FROM collaborators WHERE profile_id = auth.uid())
  )
);
CREATE POLICY "Users can modify plantings in owned farms" ON plantings FOR ALL USING (
  bed_id IN (
    SELECT b.id FROM beds b
    JOIN plots p ON b.plot_id = p.id
    JOIN farms f ON p.farm_id = f.id
    WHERE f.owner_id = auth.uid()
  )
);
CREATE POLICY "Editors can modify plantings" ON plantings FOR ALL USING (
  bed_id IN (
    SELECT b.id FROM beds b
    JOIN plots p ON b.plot_id = p.id
    JOIN farms f ON p.farm_id = f.id
    WHERE f.id IN (
      SELECT farm_id FROM collaborators 
      WHERE profile_id = auth.uid() AND role = 'editor'
    )
  )
);

-- Tasks policies (inherit from plantings)
CREATE POLICY "Users can view tasks in accessible plantings" ON tasks FOR SELECT USING (
  planting_id IN (
    SELECT pl.id FROM plantings pl
    JOIN beds b ON pl.bed_id = b.id
    JOIN plots p ON b.plot_id = p.id
    JOIN farms f ON p.farm_id = f.id
    WHERE f.owner_id = auth.uid() 
    OR f.id IN (SELECT farm_id FROM collaborators WHERE profile_id = auth.uid())
  )
);
CREATE POLICY "Users can modify tasks in owned farms" ON tasks FOR ALL USING (
  planting_id IN (
    SELECT pl.id FROM plantings pl
    JOIN beds b ON pl.bed_id = b.id
    JOIN plots p ON b.plot_id = p.id
    JOIN farms f ON p.farm_id = f.id
    WHERE f.owner_id = auth.uid()
  )
);
CREATE POLICY "Editors can modify tasks" ON tasks FOR ALL USING (
  planting_id IN (
    SELECT pl.id FROM plantings pl
    JOIN beds b ON pl.bed_id = b.id
    JOIN plots p ON b.plot_id = p.id
    JOIN farms f ON p.farm_id = f.id
    WHERE f.id IN (
      SELECT farm_id FROM collaborators 
      WHERE profile_id = auth.uid() AND role = 'editor'
    )
  )
);

-- Collaborators policies
CREATE POLICY "Users can view collaborations in their farms" ON collaborators FOR SELECT USING (
  farm_id IN (SELECT id FROM farms WHERE owner_id = auth.uid())
  OR profile_id = auth.uid()
);
CREATE POLICY "Farm owners can manage collaborators" ON collaborators FOR ALL USING (
  farm_id IN (SELECT id FROM farms WHERE owner_id = auth.uid())
);

-- Crops catalog is public read-only
CREATE POLICY "Anyone can view crops catalog" ON crops_catalog FOR SELECT TO authenticated USING (true);

-- Map templates policies
CREATE POLICY "Users can view own templates" ON map_templates FOR SELECT USING (auth.uid() = owner_id);
CREATE POLICY "Users can manage own templates" ON map_templates FOR ALL USING (auth.uid() = owner_id);

-- Function to automatically create user profile on signup
CREATE OR REPLACE FUNCTION handle_new_user() 
RETURNS trigger AS $$
BEGIN
  INSERT INTO profiles (id, name, email, phone, locale, city, state)
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
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create profile on user signup
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Function to automatically generate tasks when planting is created
CREATE OR REPLACE FUNCTION generate_planting_tasks()
RETURNS trigger AS $$
DECLARE
  cycle_days INTEGER;
  water_interval INTEGER := 3; -- Water every 3 days
BEGIN
  -- Get cycle days (custom or from catalog)
  IF NEW.custom_cycle_days IS NOT NULL THEN
    cycle_days := NEW.custom_cycle_days;
  ELSE
    SELECT c.cycle_days INTO cycle_days
    FROM crops_catalog c
    WHERE c.id = NEW.crop_id;
  END IF;
  
  -- Generate water tasks (every 3 days during growth)
  FOR i IN 1..CEIL(cycle_days / water_interval::float) LOOP
    INSERT INTO tasks (planting_id, type, due_date)
    VALUES (
      NEW.id,
      'water',
      NEW.sowing_date + (i * water_interval)
    );
  END LOOP;
  
  -- Generate fertilize task (middle of cycle)
  INSERT INTO tasks (planting_id, type, due_date)
  VALUES (
    NEW.id,
    'fertilize',
    NEW.sowing_date + (cycle_days / 2)
  );
  
  -- Generate transplant task (if needed, early in cycle)
  IF cycle_days > 30 THEN
    INSERT INTO tasks (planting_id, type, due_date)
    VALUES (
      NEW.id,
      'transplant',
      NEW.sowing_date + 14
    );
  END IF;
  
  -- Generate harvest task
  INSERT INTO tasks (planting_id, type, due_date)
  VALUES (
    NEW.id,
    'harvest',
    NEW.harvest_estimate
  );
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to generate tasks on planting creation
DROP TRIGGER IF EXISTS on_planting_created ON plantings;
CREATE TRIGGER on_planting_created
  AFTER INSERT ON plantings
  FOR EACH ROW EXECUTE FUNCTION generate_planting_tasks();

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_farms_owner ON farms(owner_id);
CREATE INDEX IF NOT EXISTS idx_plots_farm ON plots(farm_id);
CREATE INDEX IF NOT EXISTS idx_beds_plot ON beds(plot_id);
CREATE INDEX IF NOT EXISTS idx_beds_position ON beds(plot_id, x, y);
CREATE INDEX IF NOT EXISTS idx_plantings_bed ON plantings(bed_id);
CREATE INDEX IF NOT EXISTS idx_plantings_crop ON plantings(crop_id);
CREATE INDEX IF NOT EXISTS idx_tasks_planting ON tasks(planting_id);
CREATE INDEX IF NOT EXISTS idx_tasks_due_date ON tasks(due_date);
CREATE INDEX IF NOT EXISTS idx_collaborators_farm ON collaborators(farm_id);
CREATE INDEX IF NOT EXISTS idx_collaborators_profile ON collaborators(profile_id);

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO authenticated;

-- Success message
SELECT 'Seedfy database setup completed successfully!' as result;