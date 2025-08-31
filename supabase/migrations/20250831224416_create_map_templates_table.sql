-- Create map templates table
-- Stores reusable garden layout templates

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