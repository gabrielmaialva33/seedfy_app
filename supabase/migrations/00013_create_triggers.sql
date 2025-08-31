-- Database triggers

-- Note: Trigger on auth.users requires superuser permissions
-- This trigger should be created via Supabase Dashboard > Authentication > Hooks
-- or configured via the Supabase CLI with proper permissions
-- DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
-- CREATE TRIGGER on_auth_user_created
--   AFTER INSERT ON auth.users
--   FOR EACH ROW 
--   EXECUTE FUNCTION public.handle_new_user();

-- Triggers for updated_at columns
CREATE TRIGGER update_profiles_updated_at 
  BEFORE UPDATE ON public.profiles 
  FOR EACH ROW 
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_farms_updated_at 
  BEFORE UPDATE ON public.farms 
  FOR EACH ROW 
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_plots_updated_at 
  BEFORE UPDATE ON public.plots 
  FOR EACH ROW 
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_beds_updated_at 
  BEFORE UPDATE ON public.beds 
  FOR EACH ROW 
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_crops_catalog_updated_at 
  BEFORE UPDATE ON public.crops_catalog 
  FOR EACH ROW 
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_plantings_updated_at 
  BEFORE UPDATE ON public.plantings 
  FOR EACH ROW 
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_tasks_updated_at 
  BEFORE UPDATE ON public.tasks 
  FOR EACH ROW 
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_collaborators_updated_at 
  BEFORE UPDATE ON public.collaborators 
  FOR EACH ROW 
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_invitations_updated_at 
  BEFORE UPDATE ON public.invitations 
  FOR EACH ROW 
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_map_templates_updated_at 
  BEFORE UPDATE ON public.map_templates 
  FOR EACH ROW 
  EXECUTE FUNCTION public.update_updated_at_column();

-- Trigger to generate tasks on planting creation
DROP TRIGGER IF EXISTS on_planting_created ON public.plantings;
CREATE TRIGGER on_planting_created
  AFTER INSERT ON public.plantings
  FOR EACH ROW 
  EXECUTE FUNCTION public.generate_planting_tasks();

-- Comments
-- COMMENT ON TRIGGER on_auth_user_created ON auth.users IS 'Creates user profile on signup';
COMMENT ON TRIGGER on_planting_created ON public.plantings IS 'Generates tasks when a planting is created';