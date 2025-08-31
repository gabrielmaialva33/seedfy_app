-- Create beds table
-- Represents individual cultivation beds in a grid layout

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