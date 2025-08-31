-- Create plots table
-- Represents cultivation areas within a farm

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