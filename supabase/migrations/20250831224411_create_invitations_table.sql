-- Create invitations table
-- Manages pending collaboration invitations

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