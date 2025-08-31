-- Create farms table
-- Represents a farm or garden owned by a user

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