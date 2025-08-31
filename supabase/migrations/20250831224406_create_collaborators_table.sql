-- Create collaborators table
-- Manages farm access permissions for multiple users

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