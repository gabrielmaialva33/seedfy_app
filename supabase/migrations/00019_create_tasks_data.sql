-- Create comprehensive task data for seed users
-- This migration adds realistic agricultural tasks and schedules

-- Add task templates and actual tasks for each user
INSERT INTO public.tasks (
  id,
  planting_id,
  assigned_to,
  type,
  title,
  description,
  due_date,
  done,
  completed_at,
  priority,
  estimated_minutes,
  actual_minutes,
  notes,
  created_at,
  updated_at
) VALUES
  -- Maria's Urban Garden Tasks (São Paulo)
  -- Daily maintenance tasks
  ('eeee0001-1111-1111-1111-111111111111', 'dddd0001-1111-1111-1111-111111111111',
   '11111111-1111-1111-1111-111111111111', 'harvest',
   'Colheita de Alface', 'Colher folhas externas da alface, deixando o miolo', 
   NOW() - INTERVAL '1 day', true, NOW() - INTERVAL '1 day',
   'high', 30, 25, 'Colheu 800g de alface crespa', NOW() - INTERVAL '2 days', NOW() - INTERVAL '1 day'),

  ('eeee0002-1111-1111-1111-111111111111', 'dddd0003-1111-1111-1111-111111111111',
   '11111111-1111-1111-1111-111111111111', 'water',
   'Irrigação Manual', 'Regar manjericão - sistema de gotejamento com problema',
   NOW() + INTERVAL '1 day', false, NULL,
   'medium', 15, NULL, NULL, NOW(), NOW()),

  ('eeee0003-1111-1111-1111-111111111111', 'dddd0003-1111-1111-1111-111111111111',
   '11111111-1111-1111-1111-111111111111', 'other',
   'Manutenção do Sistema de Irrigação', 'Verificar e limpar bicos do gotejamento para o manjericão',
   NOW(), false, NULL,
   'high', 60, NULL, 'Já identifiquei 3 bicos entupidos', NOW() - INTERVAL '1 hour', NOW()),

  -- João's Farm Tasks (Belo Horizonte)
  -- Large scale operations
  ('eeee0004-2222-2222-2222-222222222222', 'dddd0005-2222-2222-2222-222222222222',
   '22222222-2222-2222-2222-222222222222', 'pest_control',
   'Controle de Pragas na Couve', 'Aplicar óleo de neem contra pulgões',
   NOW() - INTERVAL '3 days', true, NOW() - INTERVAL '3 days',
   'high', 90, 85, 'Aplicação bem sucedida, pulgões controlados', NOW() - INTERVAL '4 days', NOW() - INTERVAL '3 days'),

  ('eeee0005-2222-2222-2222-222222222222', 'dddd0006-2222-2222-2222-222222222222',
   '22222222-2222-2222-2222-222222222222', 'other',
   'Preparação de Mudas', 'Semear 100 mudas de brócolis para próximo ciclo',
   NOW() + INTERVAL '5 days', false, NULL,
   'medium', 120, NULL, NULL, NOW(), NOW()),

  ('eeee0006-2222-2222-2222-222222222222', 'dddd0007-2222-2222-2222-222222222222',
   '22222222-2222-2222-2222-222222222222', 'other',
   'Desbaste de Cenoura', 'Fazer desbaste deixando espaçamento de 3cm',
   NOW() + INTERVAL '2 days', false, NULL,
   'medium', 60, NULL, NULL, NOW(), NOW()),

  ('eeee0007-2222-2222-2222-222222222222', NULL,
   '22222222-2222-2222-2222-222222222222', 'other',
   'Análise de Solo', 'Coletar amostras para análise de pH e nutrientes',
   NOW() - INTERVAL '7 days', false, NULL,
   'low', 45, NULL, 'Precisa reagendar com laboratório', NOW() - INTERVAL '10 days', NOW() - INTERVAL '7 days'),

  -- Ana's Community Garden Tasks (Rio de Janeiro)
  -- Educational and community activities
  ('eeee0008-3333-3333-3333-333333333333', NULL,
   '33333333-3333-3333-3333-333333333333', 'other',
   'Oficina de Compostagem', 'Ensinar as famílias sobre compostagem doméstica',
   NOW() - INTERVAL '5 days', true, NOW() - INTERVAL '5 days',
   'medium', 120, 130, '15 pessoas participaram, muito interesse!', NOW() - INTERVAL '7 days', NOW() - INTERVAL '5 days'),

  ('eeee0009-3333-3333-3333-333333333333', 'dddd0009-3333-3333-3333-333333333333',
   '33333333-3333-3333-3333-333333333333', 'harvest',
   'Colheita Comunitária', 'Organizar colheita coletiva de salsa e coentro',
   NOW() + INTERVAL '3 days', false, NULL,
   'high', 90, NULL, NULL, NOW(), NOW()),

  ('eeee0010-3333-3333-3333-333333333333', NULL,
   '33333333-3333-3333-3333-333333333333', 'other',
   'Reunião Mensal', 'Planejamento das atividades do próximo mês',
   NOW() + INTERVAL '7 days', false, NULL,
   'medium', 60, NULL, NULL, NOW(), NOW()),

  -- Pedro's Learning Tasks (Fortaleza)
  -- Beginner guidance and learning
  ('eeee0011-4444-4444-4444-444444444444', 'dddd0012-4444-4444-4444-444444444444',
   '44444444-4444-4444-4444-444444444444', 'prune',
   'Primeira Poda do Manjericão', 'Podar flores para manter folhas tenras',
   NOW() + INTERVAL '2 days', false, NULL,
   'low', 15, NULL, NULL, NOW(), NOW()),

  ('eeee0012-4444-4444-4444-444444444444', 'dddd0014-4444-4444-4444-444444444444',
   '44444444-4444-4444-4444-444444444444', 'water',
   'Monitorar Alface', 'Verificar se alface precisa de mais água',
   NOW() - INTERVAL '1 day', true, NOW() - INTERVAL '1 day',
   'low', 10, 12, 'Solo estava um pouco seco, reguei um pouco', NOW() - INTERVAL '2 days', NOW() - INTERVAL '1 day'),

  ('eeee0013-4444-4444-4444-444444444444', NULL,
   '44444444-4444-4444-4444-444444444444', 'other',
   'Estudar sobre Adubação', 'Pesquisar sobre adubos orgânicos caseiros',
   NOW() + INTERVAL '1 day', false, NULL,
   'low', 30, NULL, 'Já li sobre borra de café e casca de ovo', NOW() - INTERVAL '1 day', NOW()),

  -- Lúcia's Tech Farm Tasks (Florianópolis)
  -- Technology and automation focused
  ('eeee0014-5555-5555-5555-555555555555', NULL,
   '55555555-5555-5555-5555-555555555555', 'other',
   'Calibração dos Sensores IoT', 'Ajustar sensores de umidade e pH do solo',
   NOW() - INTERVAL '2 days', true, NOW() - INTERVAL '2 days',
   'high', 45, 50, 'Sensores calibrados, dados mais precisos agora', NOW() - INTERVAL '3 days', NOW() - INTERVAL '2 days'),

  ('eeee0015-5555-5555-5555-555555555555', 'dddd0018-5555-5555-5555-555555555555',
   '55555555-5555-5555-5555-555555555555', 'other',
   'Análise de Dados Hidropônicos', 'Revisar dados de crescimento da alface hidropônica',
   NOW() + INTERVAL '1 day', false, NULL,
   'medium', 60, NULL, NULL, NOW(), NOW()),

  ('eeee0016-5555-5555-5555-555555555555', NULL,
   '55555555-5555-5555-5555-555555555555', 'other',
   'Backup do Sistema', 'Fazer backup dos dados dos sensores e controles',
   NOW() + INTERVAL '7 days', false, NULL,
   'low', 30, NULL, NULL, NOW(), NOW()),

  ('eeee0017-5555-5555-5555-555555555555', 'dddd0019-5555-5555-5555-555555555555',
   '55555555-5555-5555-5555-555555555555', 'other',
   'Teste de Nova Variedade', 'Documentar crescimento da abobrinha resistente',
   NOW() + INTERVAL '3 days', false, NULL,
   'high', 90, NULL, 'Crescimento 15% mais rápido que variedade comum', NOW() - INTERVAL '2 days', NOW()),

  -- Recurring/Scheduled Tasks for different users
  ('eeee0018-1111-1111-1111-111111111111', NULL,
   '11111111-1111-1111-1111-111111111111', 'other',
   'Verificação Semanal Geral', 'Inspeção geral das plantas e estruturas',
   NOW() + INTERVAL '7 days', false, NULL,
   'medium', 45, NULL, NULL, NOW(), NOW()),

  ('eeee0019-2222-2222-2222-222222222222', NULL,
   '22222222-2222-2222-2222-222222222222', 'other',
   'Planejamento Semanal', 'Planejar atividades da próxima semana',
   NOW() + INTERVAL '2 days', false, NULL,
   'high', 60, NULL, NULL, NOW(), NOW()),

  ('eeee0020-3333-3333-3333-333333333333', NULL,
   '33333333-3333-3333-3333-333333333333', 'other',
   'Limpeza das Ferramentas', 'Limpar e organizar ferramentas compartilhadas',
   NOW() + INTERVAL '3 days', false, NULL,
   'low', 30, NULL, NULL, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

COMMENT ON TABLE public.tasks IS 'Realistic task data showing different agricultural activities and management styles';