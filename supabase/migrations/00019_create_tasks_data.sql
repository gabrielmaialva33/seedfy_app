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
  ('eeee0001-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111',
   'aaaa0001-1111-1111-1111-111111111111', 'bbbb0001-1111-1111-1111-111111111111',
   'cccc0001-1111-1111-1111-111111111111', 'dddd0001-1111-1111-1111-111111111111',
   'Colheita de Alface', 'Colher folhas externas da alface, deixando o miolo', 
   'harvest', 'high', 'completed', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day',
   30, 25, 'Colheu 800g de alface crespa', NOW() - INTERVAL '2 days', NOW() - INTERVAL '1 day'),

  ('eeee0002-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111',
   'aaaa0001-1111-1111-1111-111111111111', 'bbbb0002-1111-1111-1111-111111111111',
   'cccc0003-1111-1111-1111-111111111111', 'dddd0003-1111-1111-1111-111111111111',
   'Irrigação Manual', 'Regar manjericão - sistema de gotejamento com problema',
   'irrigation', 'medium', 'pending', NOW() + INTERVAL '1 day', NULL,
   15, NULL, NULL, NOW(), NOW()),

  ('eeee0003-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111',
   'aaaa0001-1111-1111-1111-111111111111', NULL, NULL, NULL,
   'Manutenção do Sistema de Irrigação', 'Verificar e limpar bicos do gotejamento',
   'maintenance', 'high', 'in_progress', NOW(), NULL,
   60, NULL, 'Já identifiquei 3 bicos entupidos', NOW() - INTERVAL '1 hour', NOW()),

  -- João's Farm Tasks (Belo Horizonte)
  -- Large scale operations
  ('eeee0004-2222-2222-2222-222222222222', '22222222-2222-2222-2222-222222222222',
   'aaaa0002-2222-2222-2222-222222222222', 'bbbb0004-2222-2222-2222-222222222222',
   'cccc0004-2222-2222-2222-222222222222', 'dddd0005-2222-2222-2222-222222222222',
   'Controle de Pragas na Couve', 'Aplicar óleo de neem contra pulgões',
   'pest_control', 'high', 'completed', NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days',
   90, 85, 'Aplicação bem sucedida, pulgões controlados', NOW() - INTERVAL '4 days', NOW() - INTERVAL '3 days'),

  ('eeee0005-2222-2222-2222-222222222222', '22222222-2222-2222-2222-222222222222',
   'aaaa0002-2222-2222-2222-222222222222', 'bbbb0005-2222-2222-2222-222222222222',
   NULL, NULL,
   'Preparação de Mudas', 'Semear 100 mudas de brócolis para próximo ciclo',
   'seeding', 'medium', 'pending', NOW() + INTERVAL '5 days', NULL,
   120, NULL, NULL, NOW(), NOW()),

  ('eeee0006-2222-2222-2222-222222222222', '22222222-2222-2222-2222-222222222222',
   'aaaa0002-2222-2222-2222-222222222222', 'bbbb0006-2222-2222-2222-222222222222',
   'cccc0006-2222-2222-2222-222222222222', 'dddd0007-2222-2222-2222-222222222222',
   'Desbaste de Cenoura', 'Fazer desbaste deixando espaçamento de 3cm',
   'cultivation', 'medium', 'pending', NOW() + INTERVAL '2 days', NULL,
   60, NULL, NULL, NOW(), NOW()),

  ('eeee0007-2222-2222-2222-222222222222', '22222222-2222-2222-2222-222222222222',
   'aaaa0002-2222-2222-2222-222222222222', NULL, NULL, NULL,
   'Análise de Solo', 'Coletar amostras para análise de pH e nutrientes',
   'soil_management', 'low', 'overdue', NOW() - INTERVAL '7 days', NULL,
   45, NULL, 'Precisa reagendar com laboratório', NOW() - INTERVAL '10 days', NOW() - INTERVAL '7 days'),

  -- Ana's Community Garden Tasks (Rio de Janeiro)
  -- Educational and community activities
  ('eeee0008-3333-3333-3333-333333333333', '33333333-3333-3333-3333-333333333333',
   'aaaa0003-3333-3333-3333-333333333333', 'bbbb0008-3333-3333-3333-333333333333',
   NULL, NULL,
   'Oficina de Compostagem', 'Ensinar as famílias sobre compostagem doméstica',
   'education', 'medium', 'completed', NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days',
   120, 130, '15 pessoas participaram, muito interesse!', NOW() - INTERVAL '7 days', NOW() - INTERVAL '5 days'),

  ('eeee0009-3333-3333-3333-333333333333', '33333333-3333-3333-3333-333333333333',
   'aaaa0003-3333-3333-3333-333333333333', 'bbbb0007-3333-3333-3333-333333333333',
   'cccc0007-3333-3333-3333-333333333333', 'dddd0009-3333-3333-3333-333333333333',
   'Colheita Comunitária', 'Organizar colheita coletiva de salsa e coentro',
   'harvest', 'high', 'pending', NOW() + INTERVAL '3 days', NULL,
   90, NULL, NULL, NOW(), NOW()),

  ('eeee0010-3333-3333-3333-333333333333', '33333333-3333-3333-3333-333333333333',
   'aaaa0003-3333-3333-3333-333333333333', NULL, NULL, NULL,
   'Reunião Mensal', 'Planejamento das atividades do próximo mês',
   'planning', 'medium', 'pending', NOW() + INTERVAL '7 days', NULL,
   60, NULL, NULL, NOW(), NOW()),

  -- Pedro's Learning Tasks (Fortaleza)
  -- Beginner guidance and learning
  ('eeee0011-4444-4444-4444-444444444444', '44444444-4444-4444-4444-444444444444',
   'aaaa0004-4444-4444-4444-444444444444', 'bbbb0009-4444-4444-4444-444444444444',
   'cccc0009-4444-4444-4444-444444444444', 'dddd0012-4444-4444-4444-444444444444',
   'Primeira Poda do Manjericão', 'Podar flores para manter folhas tenras',
   'cultivation', 'low', 'pending', NOW() + INTERVAL '2 days', NULL,
   15, NULL, NULL, NOW(), NOW()),

  ('eeee0012-4444-4444-4444-444444444444', '44444444-4444-4444-4444-444444444444',
   'aaaa0004-4444-4444-4444-444444444444', 'bbbb0010-4444-4444-4444-444444444444',
   'cccc0010-4444-4444-4444-444444444444', 'dddd0014-4444-4444-4444-444444444444',
   'Monitorar Alface', 'Verificar se alface precisa de mais água',
   'monitoring', 'low', 'completed', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day',
   10, 12, 'Solo estava um pouco seco, reguei um pouco', NOW() - INTERVAL '2 days', NOW() - INTERVAL '1 day'),

  ('eeee0013-4444-4444-4444-444444444444', '44444444-4444-4444-4444-444444444444',
   'aaaa0004-4444-4444-4444-444444444444', NULL, NULL, NULL,
   'Estudar sobre Adubação', 'Pesquisar sobre adubos orgânicos caseiros',
   'learning', 'low', 'in_progress', NOW() + INTERVAL '1 day', NULL,
   30, NULL, 'Já li sobre borra de café e casca de ovo', NOW() - INTERVAL '1 day', NOW()),

  -- Lúcia's Tech Farm Tasks (Florianópolis)
  -- Technology and automation focused
  ('eeee0014-5555-5555-5555-555555555555', '55555555-5555-5555-5555-555555555555',
   'aaaa0005-5555-5555-5555-555555555555', 'bbbb0011-5555-5555-5555-555555555555',
   'cccc0011-5555-5555-5555-555555555555', NULL,
   'Calibração dos Sensores IoT', 'Ajustar sensores de umidade e pH do solo',
   'technology', 'high', 'completed', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days',
   45, 50, 'Sensores calibrados, dados mais precisos agora', NOW() - INTERVAL '3 days', NOW() - INTERVAL '2 days'),

  ('eeee0015-5555-5555-5555-555555555555', '55555555-5555-5555-5555-555555555555',
   'aaaa0005-5555-5555-5555-555555555555', 'bbbb0012-5555-5555-5555-555555555555',
   'cccc0013-5555-5555-5555-555555555555', 'dddd0018-5555-5555-5555-555555555555',
   'Análise de Dados Hidropônicos', 'Revisar dados de crescimento da alface hidropônica',
   'analysis', 'medium', 'pending', NOW() + INTERVAL '1 day', NULL,
   60, NULL, NULL, NOW(), NOW()),

  ('eeee0016-5555-5555-5555-555555555555', '55555555-5555-5555-5555-555555555555',
   'aaaa0005-5555-5555-5555-555555555555', NULL, NULL, NULL,
   'Backup do Sistema', 'Fazer backup dos dados dos sensores e controles',
   'technology', 'low', 'pending', NOW() + INTERVAL '7 days', NULL,
   30, NULL, NULL, NOW(), NOW()),

  ('eeee0017-5555-5555-5555-555555555555', '55555555-5555-5555-5555-555555555555',
   'aaaa0005-5555-5555-5555-555555555555', 'bbbb0013-5555-5555-5555-555555555555',
   'cccc0013-5555-5555-5555-555555555555', 'dddd0019-5555-5555-5555-555555555555',
   'Teste de Nova Variedade', 'Documentar crescimento da abobrinha resistente',
   'research', 'high', 'in_progress', NOW() + INTERVAL '3 days', NULL,
   90, NULL, 'Crescimento 15% mais rápido que variedade comum', NOW() - INTERVAL '2 days', NOW()),

  -- Recurring/Scheduled Tasks for different users
  ('eeee0018-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111',
   'aaaa0001-1111-1111-1111-111111111111', NULL, NULL, NULL,
   'Verificação Semanal Geral', 'Inspeção geral das plantas e estruturas',
   'monitoring', 'medium', 'pending', NOW() + INTERVAL '7 days', NULL,
   45, NULL, NULL, NOW(), NOW()),

  ('eeee0019-2222-2222-2222-222222222222', '22222222-2222-2222-2222-222222222222',
   'aaaa0002-2222-2222-2222-222222222222', NULL, NULL, NULL,
   'Planejamento Semanal', 'Planejar atividades da próxima semana',
   'planning', 'high', 'pending', NOW() + INTERVAL '2 days', NULL,
   60, NULL, NULL, NOW(), NOW()),

  ('eeee0020-3333-3333-3333-333333333333', '33333333-3333-3333-3333-333333333333',
   'aaaa0003-3333-3333-3333-333333333333', NULL, NULL, NULL,
   'Limpeza das Ferramentas', 'Limpar e organizar ferramentas compartilhadas',
   'maintenance', 'low', 'pending', NOW() + INTERVAL '3 days', NULL,
   30, NULL, NULL, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Add some task dependencies (sequential tasks)
INSERT INTO public.task_dependencies (
  id,
  task_id,
  depends_on_task_id,
  created_at
) VALUES
  ('ffff0001-1111-1111-1111-111111111111', 'eeee0002-1111-1111-1111-111111111111', 'eeee0003-1111-1111-1111-111111111111', NOW()),
  ('ffff0002-2222-2222-2222-222222222222', 'eeee0006-2222-2222-2222-222222222222', 'eeee0005-2222-2222-2222-222222222222', NOW()),
  ('ffff0003-5555-5555-5555-555555555555', 'eeee0015-5555-5555-5555-555555555555', 'eeee0014-5555-5555-5555-555555555555', NOW())
ON CONFLICT (id) DO NOTHING;

COMMENT ON TABLE public.tasks IS 'Realistic task data showing different agricultural activities and management styles';
COMMENT ON TABLE public.task_dependencies IS 'Task dependency relationships for sequential operations';