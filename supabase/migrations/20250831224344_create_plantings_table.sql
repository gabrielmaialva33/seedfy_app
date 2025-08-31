-- Create plantings table
-- Records of crops planted in beds

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