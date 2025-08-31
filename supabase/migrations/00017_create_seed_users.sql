-- Create seed users and comprehensive data
-- This migration creates realistic test users and farm data

-- First, we need to create the users in auth.users table
-- These will be demo users with known credentials

-- Insert demo users into auth.users (this would normally be done through Supabase Auth API)
-- Note: In production, users would be created through the app's signup flow

-- Create auth users first (these would normally be created via Supabase Auth API)
-- Get the current instance_id from auth.instances table
DO $$
DECLARE
    current_instance_id uuid;
BEGIN
    -- Try to get the instance_id from auth.instances
    SELECT id INTO current_instance_id FROM auth.instances LIMIT 1;
    
    -- If no instance found, create a default one
    IF current_instance_id IS NULL THEN
        current_instance_id := gen_random_uuid();
        INSERT INTO auth.instances (id, uuid, raw_base_config) 
        VALUES (current_instance_id, current_instance_id, '{}');
    END IF;
    
    -- Insert demo users
    INSERT INTO auth.users (
        id,
        instance_id,
        aud,
        role,
        email,
        encrypted_password,
        email_confirmed_at,
        recovery_sent_at,
        last_sign_in_at,
        raw_app_meta_data,
        raw_user_meta_data,
        created_at,
        updated_at,
        confirmation_token,
        email_change,
        email_change_token_new,
        recovery_token
    ) VALUES
        ('11111111-1111-1111-1111-111111111111', current_instance_id, 'authenticated', 'authenticated', 
         'maria.silva@seedfy.com', crypt('seedfy123', gen_salt('bf')), NOW(), NULL, NOW(),
         '{"provider": "email", "providers": ["email"]}', '{}', NOW(), NOW(), '', '', '', ''),
        
        ('22222222-2222-2222-2222-222222222222', current_instance_id, 'authenticated', 'authenticated',
         'joao.santos@seedfy.com', crypt('seedfy123', gen_salt('bf')), NOW(), NULL, NOW(),
         '{"provider": "email", "providers": ["email"]}', '{}', NOW(), NOW(), '', '', '', ''),
         
        ('33333333-3333-3333-3333-333333333333', current_instance_id, 'authenticated', 'authenticated',
         'ana.costa@seedfy.com', crypt('seedfy123', gen_salt('bf')), NOW(), NULL, NOW(),
         '{"provider": "email", "providers": ["email"]}', '{}', NOW(), NOW(), '', '', '', ''),
         
        ('44444444-4444-4444-4444-444444444444', current_instance_id, 'authenticated', 'authenticated',
         'pedro.oliveira@seedfy.com', crypt('seedfy123', gen_salt('bf')), NOW(), NULL, NOW(),
         '{"provider": "email", "providers": ["email"]}', '{}', NOW(), NOW(), '', '', '', ''),
         
        ('55555555-5555-5555-5555-555555555555', current_instance_id, 'authenticated', 'authenticated',
         'lucia.fernandes@seedfy.com', crypt('seedfy123', gen_salt('bf')), NOW(), NULL, NOW(),
         '{"provider": "email", "providers": ["email"]}', '{}', NOW(), NOW(), '', '', '', '')
    ON CONFLICT (id) DO NOTHING;
END $$;

-- Create profiles for demo users
INSERT INTO public.profiles (
  id,
  email,
  name,
  phone,
  locale,
  city,
  state,
  created_at,
  updated_at
) VALUES
  -- Demo User 1: Experienced Urban Farmer
  ('11111111-1111-1111-1111-111111111111', 'maria.silva@seedfy.com', 'Maria Silva', '+55 11 99999-1111', 'pt-BR', 'São Paulo', 'SP', NOW(), NOW()),
  
  -- Demo User 2: Small Rural Producer  
  ('22222222-2222-2222-2222-222222222222', 'joao.santos@seedfy.com', 'João Santos', '+55 31 99999-2222', 'pt-BR', 'Belo Horizonte', 'MG', NOW(), NOW()),
  
  -- Demo User 3: Community Garden Manager
  ('33333333-3333-3333-3333-333333333333', 'ana.costa@seedfy.com', 'Ana Costa', '+55 21 99999-3333', 'pt-BR', 'Rio de Janeiro', 'RJ', NOW(), NOW()),
  
  -- Demo User 4: Beginner Gardener
  ('44444444-4444-4444-4444-444444444444', 'pedro.oliveira@seedfy.com', 'Pedro Oliveira', '+55 85 99999-4444', 'pt-BR', 'Fortaleza', 'CE', NOW(), NOW()),
  
  -- Demo User 5: Tech-Savvy Farmer
  ('55555555-5555-5555-5555-555555555555', 'lucia.fernandes@seedfy.com', 'Lúcia Fernandes', '+55 47 99999-5555', 'pt-BR', 'Florianópolis', 'SC', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Create farms for each user
INSERT INTO public.farms (
  id,
  owner_id,
  name,
  description,
  address,
  created_at,
  updated_at
) VALUES
  -- Maria's Urban Rooftop Garden
  ('aaaa0001-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111', 
   'Horta do Terraço', 
   'Horta urbana no terraço com foco em folhosas e ervas aromáticas. Utiliza sistema de irrigação por gotejamento e compostagem própria.',
   'Rua Augusta, 1000 - Vila Madalena, São Paulo/SP',
   NOW() - INTERVAL '6 months', NOW()),
  
  -- João's Small Farm  
  ('aaaa0002-2222-2222-2222-222222222222', '22222222-2222-2222-2222-222222222222',
   'Sítio Boa Esperança',
   'Pequena propriedade rural familiar com produção diversificada de hortaliças orgânicas. Fornece para feira local e CSA.',
   'Estrada Rural, km 15 - Zona Rural, Belo Horizonte/MG',
   NOW() - INTERVAL '2 years', NOW()),
   
  -- Ana's Community Garden
  ('aaaa0003-3333-3333-3333-333333333333', '33333333-3333-3333-3333-333333333333',
   'Horta Comunitária da Vila',
   'Jardim comunitário que atende 15 famílias do bairro. Foca em educação ambiental e segurança alimentar.',
   'Praça da Vila, s/n - Copacabana, Rio de Janeiro/RJ',
   NOW() - INTERVAL '1 year', NOW()),
   
  -- Pedro's Backyard Garden
  ('aaaa0004-4444-4444-4444-444444444444', '44444444-4444-4444-4444-444444444444',
   'Quintinha de Casa',
   'Primeira experiência com cultivo doméstico. Começando com temperos e algumas hortaliças fáceis.',
   'Rua das Flores, 123 - Aldeota, Fortaleza/CE',
   NOW() - INTERVAL '3 months', NOW()),
   
  -- Lúcia's Tech Farm
  ('aaaa0005-5555-5555-5555-555555555555', '55555555-5555-5555-5555-555555555555',
   'AgroTech Sustentável',
   'Fazenda experimental com IoT, sensores automatizados e técnicas de agricultura de precisão.',
   'SC-401, km 12 - Sambaqui, Florianópolis/SC',
   NOW() - INTERVAL '8 months', NOW())
ON CONFLICT (id) DO NOTHING;

-- Create plots for each farm
INSERT INTO public.plots (
  id,
  farm_id,
  label,
  description,
  length_m,
  width_m,
  path_gap_m,
  created_at
) VALUES
  -- Maria's plots (Urban Garden)
  ('bbbb0001-1111-1111-1111-111111111111', 'aaaa0001-1111-1111-1111-111111111111',
   'Canteiros de Folhosas', 'Área principal com alface, rúcula e couve', 5.0, 4.0, 0.3, NOW() - INTERVAL '6 months'),
  ('bbbb0002-1111-1111-1111-111111111111', 'aaaa0001-1111-1111-1111-111111111111', 
   'Jardim de Ervas', 'Canteiro com manjericão, salsa e coentro', 4.0, 3.5, 0.3, NOW() - INTERVAL '5 months'),
  ('bbbb0003-1111-1111-1111-111111111111', 'aaaa0001-1111-1111-1111-111111111111',
   'Área de Tomates', 'Estufa para tomates cereja', 3.0, 3.0, 0.4, NOW() - INTERVAL '4 months'),

  -- João's plots (Small Farm)
  ('bbbb0004-2222-2222-2222-222222222222', 'aaaa0002-2222-2222-2222-222222222222',
   'Canteiro Principal', 'Área grande para rotação de culturas', 50.0, 20.0, 0.5, NOW() - INTERVAL '2 years'),
  ('bbbb0005-2222-2222-2222-222222222222', 'aaaa0002-2222-2222-2222-222222222222',
   'Estufa de Mudas', 'Local protegido para produção de mudas', 15.0, 10.0, 0.4, NOW() - INTERVAL '18 months'),
  ('bbbb0006-2222-2222-2222-222222222222', 'aaaa0002-2222-2222-2222-222222222222',
   'Área de Raízes', 'Especializada em cenoura e beterraba', 20.0, 10.0, 0.4, NOW() - INTERVAL '1 year'),

  -- Ana's plots (Community Garden)  
  ('bbbb0007-3333-3333-3333-333333333333', 'aaaa0003-3333-3333-3333-333333333333',
   'Canteiros das Famílias', 'Área dividida entre as famílias participantes', 10.0, 8.0, 0.4, NOW() - INTERVAL '1 year'),
  ('bbbb0008-3333-3333-3333-333333333333', 'aaaa0003-3333-3333-3333-333333333333',
   'Jardim Educativo', 'Espaço para atividades com crianças', 8.0, 5.0, 0.5, NOW() - INTERVAL '10 months'),

  -- Pedro's plots (Backyard)
  ('bbbb0009-4444-4444-4444-444444444444', 'aaaa0004-4444-4444-4444-444444444444',
   'Canteiro de Temperos', 'Primeiro canteiro com ervas básicas', 3.0, 2.0, 0.3, NOW() - INTERVAL '3 months'),
  ('bbbb0010-4444-4444-4444-444444444444', 'aaaa0004-4444-4444-4444-444444444444',
   'Experimento de Folhosas', 'Teste com alface e rúcula', 2.5, 2.0, 0.3, NOW() - INTERVAL '2 months'),

  -- Lúcia's plots (Tech Farm)
  ('bbbb0011-5555-5555-5555-555555555555', 'aaaa0005-5555-5555-5555-555555555555',
   'Setor A - Automatizado', 'Área com sensores IoT e irrigação inteligente', 20.0, 15.0, 0.5, NOW() - INTERVAL '8 months'),
  ('bbbb0012-5555-5555-5555-555555555555', 'aaaa0005-5555-5555-5555-555555555555',
   'Setor B - Hidroponia', 'Sistema hidropônico experimental', 15.0, 12.0, 0.4, NOW() - INTERVAL '6 months'),
  ('bbbb0013-5555-5555-5555-555555555555', 'aaaa0005-5555-5555-5555-555555555555',
   'Área de Pesquisa', 'Testes com novas variedades e técnicas', 25.0, 12.0, 0.5, NOW() - INTERVAL '4 months')
ON CONFLICT (id) DO NOTHING;

-- Add some beds to the plots
INSERT INTO public.beds (
  id,
  plot_id,
  x,
  y,
  width_m,
  height_m,
  soil_type,
  notes,
  created_at
) VALUES
  -- Maria's beds
  ('cccc0001-1111-1111-1111-111111111111', 'bbbb0001-1111-1111-1111-111111111111', 'Canteiro 1', 4.0, 1.2, NOW() - INTERVAL '6 months'),
  ('cccc0002-1111-1111-1111-111111111111', 'bbbb0001-1111-1111-1111-111111111111', 'Canteiro 2', 4.0, 1.2, NOW() - INTERVAL '6 months'),
  ('cccc0003-1111-1111-1111-111111111111', 'bbbb0002-1111-1111-1111-111111111111', 'Jardim Circular', 2.0, 2.0, NOW() - INTERVAL '5 months'),
  
  -- João's beds
  ('cccc0004-2222-2222-2222-222222222222', 'bbbb0004-2222-2222-2222-222222222222', 'Fileira Norte', 50.0, 1.5, NOW() - INTERVAL '2 years'),
  ('cccc0005-2222-2222-2222-222222222222', 'bbbb0004-2222-2222-2222-222222222222', 'Fileira Sul', 50.0, 1.5, NOW() - INTERVAL '2 years'),
  ('cccc0006-2222-2222-2222-222222222222', 'bbbb0006-2222-2222-2222-222222222222', 'Canteiro de Raízes', 20.0, 1.0, NOW() - INTERVAL '1 year'),
  
  -- Ana's beds
  ('cccc0007-3333-3333-3333-333333333333', 'bbbb0007-3333-3333-3333-333333333333', 'Canteiro Familiar A', 8.0, 1.5, NOW() - INTERVAL '1 year'),
  ('cccc0008-3333-3333-3333-333333333333', 'bbbb0007-3333-3333-3333-333333333333', 'Canteiro Familiar B', 8.0, 1.5, NOW() - INTERVAL '1 year'),
  
  -- Pedro's beds
  ('cccc0009-4444-4444-4444-444444444444', 'bbbb0009-4444-4444-4444-444444444444', 'Vaso Grande', 1.0, 0.8, NOW() - INTERVAL '3 months'),
  ('cccc0010-4444-4444-4444-444444444444', 'bbbb0010-4444-4444-4444-444444444444', 'Jardineira', 3.0, 0.6, NOW() - INTERVAL '2 months'),
  
  -- Lúcia's beds
  ('cccc0011-5555-5555-5555-555555555555', 'bbbb0011-5555-5555-5555-555555555555', 'Setor A1', 20.0, 1.5, NOW() - INTERVAL '8 months'),
  ('cccc0012-5555-5555-5555-555555555555', 'bbbb0011-5555-5555-5555-555555555555', 'Setor A2', 20.0, 1.5, NOW() - INTERVAL '8 months'),
  ('cccc0013-5555-5555-5555-555555555555', 'bbbb0012-5555-5555-5555-555555555555', 'Torre Hidropônica 1', 2.0, 2.0, NOW() - INTERVAL '6 months')
ON CONFLICT (id) DO NOTHING;

COMMENT ON TABLE public.profiles IS 'Demo user profiles with realistic agricultural scenarios';
COMMENT ON TABLE public.farms IS 'Sample farms representing different scales and types of agriculture';
COMMENT ON TABLE public.plots IS 'Plot examples with varied characteristics for testing';
COMMENT ON TABLE public.beds IS 'Individual growing beds within plots for detailed cultivation tracking';