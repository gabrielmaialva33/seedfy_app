-- Create tasks table
-- Cultivation tasks for plantings

CREATE TABLE IF NOT EXISTS public.tasks (
  -- Primary key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Foreign keys
  planting_id UUID NOT NULL REFERENCES public.plantings(id) ON DELETE CASCADE,
  assigned_to UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  
  -- Task information
  type TEXT NOT NULL CHECK (type IN (
    'water', 'fertilize', 'transplant', 'harvest', 
    'prune', 'pest_control', 'disease_control', 
    'weed', 'mulch', 'other'
  )),
  title TEXT NOT NULL,
  description TEXT,
  
  -- Scheduling
  due_date DATE NOT NULL,
  reminder_date DATE,
  
  -- Status
  done BOOLEAN DEFAULT false,
  completed_at TIMESTAMPTZ,
  completed_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  
  -- Priority and effort
  priority TEXT DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
  estimated_minutes INTEGER CHECK (estimated_minutes > 0),
  actual_minutes INTEGER CHECK (actual_minutes > 0),
  
  -- Notes
  notes TEXT,
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes
CREATE INDEX idx_tasks_planting_id ON public.tasks(planting_id);
CREATE INDEX idx_tasks_due_date ON public.tasks(due_date);
CREATE INDEX idx_tasks_done ON public.tasks(done);
CREATE INDEX idx_tasks_priority ON public.tasks(priority);
CREATE INDEX idx_tasks_assigned_to ON public.tasks(assigned_to) WHERE assigned_to IS NOT NULL;
CREATE INDEX idx_tasks_upcoming ON public.tasks(due_date) WHERE done = false;

-- Enable RLS
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

-- RLS Policies (inherit permissions from plantings)
CREATE POLICY "Users can view tasks in accessible plantings" 
  ON public.tasks FOR SELECT 
  USING (
    planting_id IN (
      SELECT pl.id FROM public.plantings pl
      JOIN public.beds b ON pl.bed_id = b.id
      JOIN public.plots p ON b.plot_id = p.id
      JOIN public.farms f ON p.farm_id = f.id
      WHERE f.owner_id = auth.uid()
    )
  );

CREATE POLICY "Users can manage tasks in owned farms" 
  ON public.tasks FOR ALL 
  USING (
    planting_id IN (
      SELECT pl.id FROM public.plantings pl
      JOIN public.beds b ON pl.bed_id = b.id
      JOIN public.plots p ON b.plot_id = p.id
      JOIN public.farms f ON p.farm_id = f.id
      WHERE f.owner_id = auth.uid()
    )
  );

-- Comments
COMMENT ON TABLE public.tasks IS 'Cultivation and maintenance tasks for plantings';
COMMENT ON COLUMN public.tasks.type IS 'Type of cultivation task';
COMMENT ON COLUMN public.tasks.priority IS 'Task priority level';
COMMENT ON COLUMN public.tasks.estimated_minutes IS 'Estimated time to complete in minutes';