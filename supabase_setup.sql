-- Enable Row Level Security
ALTER DATABASE postgres SET "app.jwt_secret" TO 'your-jwt-secret';

-- Create profiles table (1:1 with auth.users)
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  locale TEXT DEFAULT 'pt-BR',
  city TEXT,
  state TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS on profiles
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Users can read own profile" ON profiles 
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles 
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON profiles 
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Create farms table
CREATE TABLE farms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE farms ENABLE ROW LEVEL SECURITY;

-- Create plots table (áreas/canteiros agrupados por propriedade)
CREATE TABLE plots (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  farm_id UUID NOT NULL REFERENCES farms(id) ON DELETE CASCADE,
  label TEXT NOT NULL,
  length_m NUMERIC NOT NULL,
  width_m NUMERIC NOT NULL,
  path_gap_m NUMERIC DEFAULT 0.4,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE plots ENABLE ROW LEVEL SECURITY;

-- Create beds table (canteiros do grid)
CREATE TABLE beds (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  plot_id UUID NOT NULL REFERENCES plots(id) ON DELETE CASCADE,
  x INTEGER NOT NULL,
  y INTEGER NOT NULL,
  width_m NUMERIC NOT NULL,
  height_m NUMERIC NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE beds ENABLE ROW LEVEL SECURITY;

-- Create crops catalog (catálogo base)
CREATE TABLE crops_catalog (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name_pt TEXT NOT NULL,
  name_en TEXT NOT NULL,
  image_url TEXT NOT NULL,
  row_spacing_m NUMERIC NOT NULL,
  plant_spacing_m NUMERIC NOT NULL,
  cycle_days INTEGER NOT NULL,
  yield_per_m2 NUMERIC
);

-- Insert sample crops
INSERT INTO crops_catalog (name_pt, name_en, image_url, row_spacing_m, plant_spacing_m, cycle_days) VALUES
('Alface', 'Lettuce', 'assets/icons/lettuce.png', 0.25, 0.20, 45),
('Tomate', 'Tomato', 'assets/icons/tomato.png', 0.50, 0.40, 90),
('Cenoura', 'Carrot', 'assets/icons/carrot.png', 0.20, 0.05, 70),
('Couve', 'Kale', 'assets/icons/kale.png', 0.30, 0.25, 60),
('Rúcula', 'Arugula', 'assets/icons/arugula.png', 0.15, 0.10, 30),
('Espinafre', 'Spinach', 'assets/icons/spinach.png', 0.20, 0.15, 40),
('Rabanete', 'Radish', 'assets/icons/radish.png', 0.15, 0.05, 25),
('Brócolis', 'Broccoli', 'assets/icons/broccoli.png', 0.40, 0.35, 75);

-- Make crops catalog publicly readable
ALTER TABLE crops_catalog ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read crops catalog" ON crops_catalog 
  FOR SELECT TO authenticated, anon USING (true);

-- Create plantings table
CREATE TABLE plantings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  bed_id UUID NOT NULL REFERENCES beds(id) ON DELETE CASCADE,
  crop_id UUID NOT NULL REFERENCES crops_catalog(id),
  custom_cycle_days INTEGER,
  custom_row_spacing_m NUMERIC,
  custom_plant_spacing_m NUMERIC,
  sowing_date DATE NOT NULL,
  harvest_estimate DATE NOT NULL,
  quantity INTEGER NOT NULL,
  intercrop_of UUID REFERENCES plantings(id),
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE plantings ENABLE ROW LEVEL SECURITY;

-- Create tasks table
CREATE TABLE tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  planting_id UUID NOT NULL REFERENCES plantings(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('water', 'fertilize', 'transplant', 'harvest')),
  due_date DATE NOT NULL,
  done BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

-- Create collaborators table
CREATE TABLE collaborators (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  farm_id UUID NOT NULL REFERENCES farms(id) ON DELETE CASCADE,
  profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('editor', 'viewer')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(farm_id, profile_id)
);

ALTER TABLE collaborators ENABLE ROW LEVEL SECURITY;

-- Farm policies
CREATE POLICY "Users can read own farms" ON farms 
  FOR SELECT USING (auth.uid() = owner_id);

CREATE POLICY "Users can read collaborated farms" ON farms 
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM collaborators 
      WHERE farm_id = farms.id AND profile_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert own farms" ON farms 
  FOR INSERT WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Owners can update own farms" ON farms 
  FOR UPDATE USING (auth.uid() = owner_id);

CREATE POLICY "Owners can delete own farms" ON farms 
  FOR DELETE USING (auth.uid() = owner_id);

-- Plot policies
CREATE POLICY "Users can read own plots" ON plots 
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM farms 
      WHERE farms.id = plots.farm_id AND farms.owner_id = auth.uid()
    )
  );

CREATE POLICY "Users can read collaborated plots" ON plots 
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM farms f
      JOIN collaborators c ON f.id = c.farm_id
      WHERE f.id = plots.farm_id AND c.profile_id = auth.uid()
    )
  );

-- Similar policies for beds, plantings, and tasks...
-- (Truncated for brevity, but following the same pattern)

-- Function to automatically create user profile after signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, name, email)
  VALUES (new.id, new.raw_user_meta_data->>'name', new.email);
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to auto-create profile
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();