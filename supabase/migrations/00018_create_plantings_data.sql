-- Create realistic plantings data for seed users
-- This migration adds current and historical plantings to demonstrate the app's functionality

-- Add plantings for each user's beds
INSERT INTO public.plantings (
  id,
  bed_id,
  crop_catalog_id,
  planting_date,
  expected_harvest_date,
  actual_harvest_date,
  quantity_planted,
  quantity_harvested,
  notes,
  status,
  created_at,
  updated_at
) VALUES
  -- Maria's Urban Garden Plantings (São Paulo)
  -- Current active plantings
  ('dddd0001-1111-1111-1111-111111111111', 'cccc0001-1111-1111-1111-111111111111', 
   (SELECT id FROM crops_catalog WHERE name_pt = 'Alface' LIMIT 1),
   NOW() - INTERVAL '30 days', NOW() + INTERVAL '15 days', NULL,
   20, NULL, 'Plantio de inverno, desenvolvimento excelente', 'growing', 
   NOW() - INTERVAL '30 days', NOW()),
   
  ('dddd0002-1111-1111-1111-111111111111', 'cccc0001-1111-1111-1111-111111111111',
   (SELECT id FROM crops_catalog WHERE name_pt = 'Rúcula' LIMIT 1),
   NOW() - INTERVAL '20 days', NOW() + INTERVAL '10 days', NULL,
   30, NULL, 'Segunda sucessão, crescimento rápido', 'growing',
   NOW() - INTERVAL '20 days', NOW()),
   
  ('dddd0003-1111-1111-1111-111111111111', 'cccc0003-1111-1111-1111-111111111111',
   (SELECT id FROM crops_catalog WHERE name_pt = 'Manjericão' LIMIT 1),
   NOW() - INTERVAL '25 days', NOW() + INTERVAL '25 days', NULL,
   8, NULL, 'Variedade Genovês, para pesto caseiro', 'growing',
   NOW() - INTERVAL '25 days', NOW()),
   
  -- Historical successful harvests
  ('dddd0004-1111-1111-1111-111111111111', 'cccc0002-1111-1111-1111-111111111111',
   (SELECT id FROM crops_catalog WHERE name_pt = 'Tomate' LIMIT 1),
   NOW() - INTERVAL '120 days', NOW() - INTERVAL '30 days', NOW() - INTERVAL '25 days',
   6, 18.5, 'Excelente produção de tomate cereja, 3kg colhidos', 'harvested',
   NOW() - INTERVAL '120 days', NOW() - INTERVAL '25 days'),

  -- João's Small Farm Plantings (Belo Horizonte)
  -- Large scale rotation crops
  ('dddd0005-2222-2222-2222-222222222222', 'cccc0004-2222-2222-2222-222222222222',
   (SELECT id FROM crops_catalog WHERE name_pt = 'Couve' LIMIT 1),
   NOW() - INTERVAL '40 days', NOW() + INTERVAL '20 days', NULL,
   200, NULL, 'Plantio principal para venda na feira', 'growing',
   NOW() - INTERVAL '40 days', NOW()),
   
  ('dddd0006-2222-2222-2222-222222222222', 'cccc0005-2222-2222-2222-222222222222',
   (SELECT id FROM crops_catalog WHERE name_pt = 'Brócolis' LIMIT 1),
   NOW() - INTERVAL '50 days', NOW() + INTERVAL '30 days', NULL,
   80, NULL, 'Mudas próprias, variedade Ramoso', 'growing',
   NOW() - INTERVAL '50 days', NOW()),
   
  ('dddd0007-2222-2222-2222-222222222222', 'cccc0006-2222-2222-2222-222222222222',
   (SELECT id FROM crops_catalog WHERE name_pt = 'Cenoura' LIMIT 1),
   NOW() - INTERVAL '60 days', NOW() + INTERVAL '15 days', NULL,
   500, NULL, 'Plantio direto, variedade Kuroda', 'growing',
   NOW() - INTERVAL '60 days', NOW()),
   
  -- Historical harvest records
  ('dddd0008-2222-2222-2222-222222222222', 'cccc0004-2222-2222-2222-222222222222',
   (SELECT id FROM crops_catalog WHERE name_pt = 'Alface' LIMIT 1),
   NOW() - INTERVAL '90 days', NOW() - INTERVAL '45 days', NOW() - INTERVAL '40 days',
   300, 180, 'Boa produção, vendeu tudo na feira', 'harvested',
   NOW() - INTERVAL '90 days', NOW() - INTERVAL '40 days'),

  -- Ana's Community Garden Plantings (Rio de Janeiro)
  -- Educational and community focused
  ('dddd0009-3333-3333-3333-333333333333', 'cccc0007-3333-3333-3333-333333333333',
   (SELECT id FROM crops_catalog WHERE name_pt = 'Salsa' LIMIT 1),
   NOW() - INTERVAL '35 days', NOW() + INTERVAL '5 days', NULL,
   50, NULL, 'Projeto educativo com crianças da comunidade', 'growing',
   NOW() - INTERVAL '35 days', NOW()),
   
  ('dddd0010-3333-3333-3333-333333333333', 'cccc0007-3333-3333-3333-333333333333',
   (SELECT id FROM crops_catalog WHERE name_pt = 'Coentro' LIMIT 1),
   NOW() - INTERVAL '30 days', NOW() + INTERVAL '5 days', NULL,
   40, NULL, 'Muito procurado pelas famílias', 'growing',
   NOW() - INTERVAL '30 days', NOW()),
   
  ('dddd0011-3333-3333-3333-333333333333', 'cccc0008-3333-3333-3333-333333333333',
   (SELECT id FROM crops_catalog WHERE name_pt = 'Rabanete' LIMIT 1),
   NOW() - INTERVAL '20 days', NOW() + INTERVAL '5 days', NULL,
   60, NULL, 'Crescimento rápido para mostrar às crianças', 'growing',
   NOW() - INTERVAL '20 days', NOW()),

  -- Pedro's Beginner Garden Plantings (Fortaleza)
  -- Simple crops for learning
  ('dddd0012-4444-4444-4444-444444444444', 'cccc0009-4444-4444-4444-444444444444',
   (SELECT id FROM crops_catalog WHERE name_pt = 'Manjericão' LIMIT 1),
   NOW() - INTERVAL '45 days', NOW() + INTERVAL '5 days', NULL,
   4, NULL, 'Primeira tentativa, indo bem!', 'growing',
   NOW() - INTERVAL '45 days', NOW()),
   
  ('dddd0013-4444-4444-4444-444444444444', 'cccc0009-4444-4444-4444-444444444444',
   (SELECT id FROM crops_catalog WHERE name_pt = 'Salsa' LIMIT 1),
   NOW() - INTERVAL '35 days', NOW() + INTERVAL '5 days', NULL,
   6, NULL, 'Seguindo tutorial do YouTube', 'growing',
   NOW() - INTERVAL '35 days', NOW()),
   
  ('dddd0014-4444-4444-4444-444444444444', 'cccc0010-4444-4444-4444-444444444444',
   (SELECT id FROM crops_catalog WHERE name_pt = 'Alface' LIMIT 1),
   NOW() - INTERVAL '25 days', NOW() + INTERVAL '20 days', NULL,
   8, NULL, 'Segundo plantio, aprendendo com o primeiro', 'growing',
   NOW() - INTERVAL '25 days', NOW()),
   
  -- Some learning mistakes (failed plantings)
  ('dddd0015-4444-4444-4444-444444444444', 'cccc0009-4444-4444-4444-444444444444',
   (SELECT id FROM crops_catalog WHERE name_pt = 'Tomate' LIMIT 1),
   NOW() - INTERVAL '60 days', NOW() - INTERVAL '10 days', NULL,
   3, NULL, 'Não desenvolveu bem, excesso de água', 'failed',
   NOW() - INTERVAL '60 days', NOW() - INTERVAL '10 days'),

  -- Lúcia's Tech Farm Plantings (Florianópolis)
  -- Automated and experimental
  ('dddd0016-5555-5555-5555-555555555555', 'cccc0011-5555-5555-5555-555555555555',
   (SELECT id FROM crops_catalog WHERE name_pt = 'Pimentão' LIMIT 1),
   NOW() - INTERVAL '70 days', NOW() + INTERVAL '15 days', NULL,
   100, NULL, 'Sistema IoT monitorando umidade e pH', 'growing',
   NOW() - INTERVAL '70 days', NOW()),
   
  ('dddd0017-5555-5555-5555-555555555555', 'cccc0011-5555-5555-5555-555555555555',
   (SELECT id FROM crops_catalog WHERE name_pt = 'Pepino' LIMIT 1),
   NOW() - INTERVAL '55 days', NOW() + INTERVAL '10 days', NULL,
   80, NULL, 'Irrigação automatizada por sensores', 'growing',
   NOW() - INTERVAL '55 days', NOW()),
   
  ('dddd0018-5555-5555-5555-555555555555', 'cccc0012-5555-5555-5555-555555555555',
   (SELECT id FROM crops_catalog WHERE name_pt = 'Alface' LIMIT 1),
   NOW() - INTERVAL '30 days', NOW() + INTERVAL '15 days', NULL,
   120, NULL, 'Sistema hidropônico NFT', 'growing',
   NOW() - INTERVAL '30 days', NOW()),
   
  ('dddd0019-5555-5555-5555-555555555555', 'cccc0013-5555-5555-5555-555555555555',
   (SELECT id FROM crops_catalog WHERE name_pt = 'Abobrinha' LIMIT 1),
   NOW() - INTERVAL '45 days', NOW() + INTERVAL '15 days', NULL,
   40, NULL, 'Teste de nova variedade resistente', 'growing',
   NOW() - INTERVAL '45 days', NOW()),
   
  -- Experimental harvest data
  ('dddd0020-5555-5555-5555-555555555555', 'cccc0011-5555-5555-5555-555555555555',
   (SELECT id FROM crops_catalog WHERE name_pt = 'Tomate' LIMIT 1),
   NOW() - INTERVAL '130 days', NOW() - INTERVAL '40 days', NOW() - INTERVAL '35 days',
   60, 180, 'Produtividade 50% maior com automação', 'harvested',
   NOW() - INTERVAL '130 days', NOW() - INTERVAL '35 days')
ON CONFLICT (id) DO NOTHING;

COMMENT ON TABLE public.plantings IS 'Realistic planting data showing different stages and outcomes across user types';