-- Create crops catalog table
-- Master table for crop varieties and their characteristics

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