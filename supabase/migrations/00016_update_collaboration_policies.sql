-- Update collaboration policies for better access control

-- Add editor permissions for plots
CREATE POLICY "Editors can modify plots they have access to" 
  ON public.plots FOR ALL 
  USING (
    farm_id IN (
      SELECT farm_id FROM public.collaborators 
      WHERE profile_id = auth.uid() 
      AND role IN ('editor', 'manager')
      AND is_active = true
    )
  );

-- Add editor permissions for beds
CREATE POLICY "Editors can modify beds they have access to" 
  ON public.beds FOR ALL 
  USING (
    plot_id IN (
      SELECT p.id FROM public.plots p
      JOIN public.farms f ON p.farm_id = f.id
      WHERE f.id IN (
        SELECT farm_id FROM public.collaborators 
        WHERE profile_id = auth.uid() 
        AND role IN ('editor', 'manager')
        AND is_active = true
      )
    )
  );

-- Add editor permissions for plantings
CREATE POLICY "Editors can modify plantings they have access to" 
  ON public.plantings FOR ALL 
  USING (
    bed_id IN (
      SELECT b.id FROM public.beds b
      JOIN public.plots p ON b.plot_id = p.id
      JOIN public.farms f ON p.farm_id = f.id
      WHERE f.id IN (
        SELECT farm_id FROM public.collaborators 
        WHERE profile_id = auth.uid() 
        AND role IN ('editor', 'manager')
        AND is_active = true
      )
    )
  );

-- Add editor permissions for tasks
CREATE POLICY "Editors can modify tasks they have access to" 
  ON public.tasks FOR ALL 
  USING (
    planting_id IN (
      SELECT pl.id FROM public.plantings pl
      JOIN public.beds b ON pl.bed_id = b.id
      JOIN public.plots p ON b.plot_id = p.id
      JOIN public.farms f ON p.farm_id = f.id
      WHERE f.id IN (
        SELECT farm_id FROM public.collaborators 
        WHERE profile_id = auth.uid() 
        AND role IN ('editor', 'manager')
        AND is_active = true
      )
    )
  );

-- Comments
COMMENT ON POLICY "Editors can modify plots they have access to" ON public.plots IS 'Allows editors and managers to modify plots';
COMMENT ON POLICY "Editors can modify beds they have access to" ON public.beds IS 'Allows editors and managers to modify beds';
COMMENT ON POLICY "Editors can modify plantings they have access to" ON public.plantings IS 'Allows editors and managers to modify plantings';
COMMENT ON POLICY "Editors can modify tasks they have access to" ON public.tasks IS 'Allows editors and managers to modify tasks';