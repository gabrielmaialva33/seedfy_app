# Seedfy - App Flutter para Hortas Urbanas

## Status Atual ✅

O app Seedfy foi **criado com sucesso** e está **rodando no localhost:8080**.

### Funcionalidades Implementadas

1. **✅ Projeto Flutter configurado** com estrutura Clean Architecture
2. **✅ Dependências principais** (Supabase, Provider, GoRouter, i18n)
3. **✅ Sistema de roteamento** com autenticação
4. **✅ Editor de mapa interativo** com:
   - Grid visual com pan/zoom (InteractiveViewer)
   - Canteiros coloridos com status semafórico
   - Sistema de coordenadas em metros
   - Visualização de culturas e dias para colheita
5. **✅ Modelos de dados** completos (User, Farm, Plot, Bed, Crop, Planting, Task)
6. **✅ Estrutura de banco Supabase** (SQL script pronto)
7. **✅ Internacionalização** configurada (pt-BR/en-US)

### Como Usar

1. **Configure o Supabase**:
   - Crie projeto em supabase.com
   - Execute `supabase_setup.sql` no SQL Editor
   - Atualize `lib/core/app_config.dart` com URL e chave

2. **Execute o app**:
   ```bash
   cd seedfy_app
   flutter pub get
   flutter run -d chrome  # Para Chrome
   # ou
   flutter run -d web-server --web-port=8080  # Para servidor local
   ```

3. **Acesse**: http://localhost:8080

### Demonstração

O app atualmente mostra:
- **Tela de login** simples com navegação
- **Mapa interativo** com canteiros de exemplo:
  - Alface (verde - saudável, 25 dias)
  - Tomate (laranja - atenção, 15 dias)
  - Cenoura (vermelho - crítico, 5 dias)
- **Pan/zoom** funcional no mapa
- **Clique nos canteiros** mostra detalhes
- **Sistema semafórico** de status

### Próximos Passos

Para completar o MVP:
1. Conectar com Supabase real
2. Implementar telas de cadastro completas
3. Onboarding wizard funcional
4. Sistema de tarefas automáticas
5. Colaboração e exportação CSV

### Arquitetura

```
lib/
├── core/           # Configurações e providers
├── features/       # Funcionalidades por domínio
├── models/         # Modelos de dados
├── services/       # Serviços (Supabase)
└── l10n/          # Internacionalização
```

O app segue padrões Flutter modernos com Material Design 3, Provider para estado e GoRouter para navegação.