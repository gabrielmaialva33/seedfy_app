# Seedfy - Gerenciamento de Hortas Urbanas

App mobile-first para pequenos produtores e hortas urbanas gerenciarem seus canteiros, cultivos e tarefas.

## Funcionalidades

- ✅ Autenticação completa (login/cadastro)
- ✅ Internacionalização (pt-BR/en-US)
- 🔄 Onboarding guiado (em desenvolvimento)
- ⏳ Editor de mapa com grid de canteiros
- ⏳ Sistema de tarefas com status semafórico
- ⏳ Colaboração e exportação CSV

## Configuração

### 1. Supabase Setup

1. Crie um projeto no [Supabase](https://supabase.com)
2. Execute o script SQL em `supabase_setup.sql` no SQL Editor
3. Copie a URL e chave anônima do projeto
4. Atualize `lib/core/app_config.dart` com suas credenciais:

```dart
class AppConfig {
  static const String supabaseUrl = 'https://sua-url.supabase.co';
  static const String supabaseAnonKey = 'sua-chave-anonima';
  // ...
}
```

### 2. Executar o App

```bash
# Instalar dependências
flutter pub get

# Gerar traduções
flutter gen-l10n

# Executar no web
flutter run -d chrome

# Ou no dispositivo móvel
flutter run
```

## Estrutura do Projeto

```
lib/
├── core/
│   ├── app_config.dart
│   └── providers/
├── features/
│   ├── auth/
│   ├── onboarding/
│   ├── map/
│   └── tasks/
├── l10n/
├── models/
├── services/
└── widgets/
```

## Stack Técnica

- **Flutter Web** (mobile-first)
- **Supabase** (backend completo)
- **Provider** (gerenciamento de estado)
- **go_router** (navegação)
- **flutter_localizations** (i18n)
- **Material Design 3**

## Próximos Passos

1. Implementar onboarding completo com seleção de culturas
2. Desenvolver editor de mapa interativo
3. Sistema de tarefas automáticas
4. Colaboração e exportação