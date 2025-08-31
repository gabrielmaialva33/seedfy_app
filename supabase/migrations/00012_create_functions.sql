-- Database functions and triggers

-- First, ensure we can create functions
-- Function to calculate bed area (ESSENTIAL - needed immediately)
CREATE OR REPLACE FUNCTION public.calculate_bed_area(
  p_width_m NUMERIC,
  p_height_m NUMERIC
)
RETURNS NUMERIC AS $$
BEGIN
  RETURN ROUND(p_width_m * p_height_m, 2);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Function to calculate plant count for a bed
CREATE OR REPLACE FUNCTION public.calculate_plant_count(
  p_bed_width_m NUMERIC,
  p_bed_height_m NUMERIC,
  p_row_spacing_m NUMERIC,
  p_plant_spacing_m NUMERIC
)
RETURNS INTEGER AS $$
DECLARE
  v_rows INTEGER;
  v_plants_per_row INTEGER;
BEGIN
  -- Calculate number of rows
  v_rows := FLOOR(p_bed_height_m / p_row_spacing_m);
  
  -- Calculate plants per row
  v_plants_per_row := FLOOR(p_bed_width_m / p_plant_spacing_m);
  
  -- Return total plant count
  RETURN GREATEST(v_rows * v_plants_per_row, 1);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to automatically create user profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (
    id, 
    name, 
    email, 
    phone, 
    locale, 
    city, 
    state
  )
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'name', 'User'),
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'phone', ''),
    COALESCE(NEW.raw_user_meta_data->>'locale', 'pt-BR'),
    COALESCE(NEW.raw_user_meta_data->>'city', ''),
    COALESCE(NEW.raw_user_meta_data->>'state', '')
  );
  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Log error but don't fail user creation
    RAISE WARNING 'Failed to create profile for user %: %', NEW.id, SQLERRM;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to automatically generate tasks when planting is created
CREATE OR REPLACE FUNCTION public.generate_planting_tasks()
RETURNS TRIGGER AS $$
DECLARE
  v_cycle_days INTEGER;
  v_crop_name TEXT;
  v_water_interval INTEGER := 3; -- Water every 3 days
  i INTEGER;
BEGIN
  -- Get cycle days (custom or from catalog)
  IF NEW.custom_cycle_days IS NOT NULL THEN
    v_cycle_days := NEW.custom_cycle_days;
  ELSE
    SELECT c.cycle_days, c.name_pt 
    INTO v_cycle_days, v_crop_name
    FROM public.crops_catalog c
    WHERE c.id = NEW.crop_id;
  END IF;
  
  -- Generate water tasks (every 3 days during growth)
  FOR i IN 1..CEIL(v_cycle_days::float / v_water_interval) LOOP
    INSERT INTO public.tasks (
      planting_id, 
      type, 
      title,
      due_date,
      priority
    )
    VALUES (
      NEW.id,
      'water',
      'Regar plantação',
      NEW.sowing_date + (i * v_water_interval),
      CASE 
        WHEN i <= 3 THEN 'high'  -- First week is critical
        ELSE 'medium'
      END
    );
  END LOOP;
  
  -- Generate fertilize task (middle of cycle)
  INSERT INTO public.tasks (
    planting_id, 
    type, 
    title,
    due_date,
    priority
  )
  VALUES (
    NEW.id,
    'fertilize',
    'Adubar plantação',
    NEW.sowing_date + (v_cycle_days / 2),
    'medium'
  );
  
  -- Generate transplant task (if needed, early in cycle)
  IF v_cycle_days > 30 THEN
    INSERT INTO public.tasks (
      planting_id, 
      type,
      title, 
      due_date,
      priority
    )
    VALUES (
      NEW.id,
      'transplant',
      'Transplantar mudas',
      NEW.sowing_date + 14,
      'high'
    );
  END IF;
  
  -- Generate harvest task
  INSERT INTO public.tasks (
    planting_id, 
    type,
    title,
    due_date,
    priority
  )
  VALUES (
    NEW.id,
    'harvest',
    'Colher ' || COALESCE(v_crop_name, 'plantação'),
    NEW.harvest_estimate,
    'high'
  );
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to expire old invitations
CREATE OR REPLACE FUNCTION public.expire_old_invitations()
RETURNS INTEGER AS $$
DECLARE
  v_count INTEGER;
BEGIN
  UPDATE public.invitations 
  SET status = 'expired'
  WHERE status = 'pending' 
    AND expires_at IS NOT NULL 
    AND expires_at < NOW();
  
  GET DIAGNOSTICS v_count = ROW_COUNT;
  RETURN v_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- Comments
COMMENT ON FUNCTION public.update_updated_at_column() IS 'Automatically updates the updated_at timestamp';
COMMENT ON FUNCTION public.handle_new_user() IS 'Creates a user profile when a new auth user is created';
COMMENT ON FUNCTION public.generate_planting_tasks() IS 'Automatically generates cultivation tasks for new plantings';
COMMENT ON FUNCTION public.expire_old_invitations() IS 'Marks expired invitations as expired';
COMMENT ON FUNCTION public.calculate_bed_area() IS 'Calculates the area of a bed in square meters';
COMMENT ON FUNCTION public.calculate_plant_count() IS 'Estimates the number of plants that fit in a bed';