# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this
repository.

## Project Overview

Seedfy is a Flutter-based farm management application for small producers and urban gardens. It uses
Supabase for backend services (authentication, PostgreSQL database, storage) and follows Clean
Architecture principles with BLoC pattern for state management.

## Essential Commands

### Development

```bash
# Install dependencies
flutter pub get

# Run code generation (for freezed, json_serializable, injectable)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run -d chrome  # Web development
flutter run            # Mobile device/emulator

# Clean build artifacts
flutter clean
```

### Quality Checks

```bash
# Run static analysis
flutter analyze

# Run tests
flutter test

# Format code
dart format lib/ test/
```

### Build & Deploy

```bash
# Build for production
flutter build web --release
flutter build apk --release
flutter build ios --release
```

## Architecture Patterns

### Clean Architecture Structure

The app follows Clean Architecture with three layers per feature:

- **Presentation**: BLoC pattern, screens, widgets
- **Domain**: Use cases, entities, repository interfaces
- **Data**: Repository implementations, data sources, DTOs

Example feature structure:

```
features/auth/
├── data/
│   ├── datasources/    # Remote/local data sources
│   ├── dto/           # Data transfer objects
│   └── repositories/  # Repository implementations
├── domain/
│   ├── entities/      # Business entities
│   ├── repositories/  # Repository interfaces
│   └── usecases/      # Business logic
└── presentation/
    ├── bloc/          # State management
    ├── screens/       # Page components
    └── widgets/       # Reusable widgets
```

### State Management

- **BLoC Pattern**: Used for complex features (auth, farm management)
- **Provider**: Used for simple state (locale, theme)
- **Dependency Injection**: GetIt with injectable for service location

### Key Services & Integration Points

1. **Supabase Client** (`shared/data/datasources/supabase_service.dart`):
    - Initialized in main.dart
    - Handles auth, database operations, storage
    - Row Level Security (RLS) enabled on all tables

2. **Firebase Services** (`shared/data/datasources/firebase_service.dart`):
    - Used for additional analytics and cloud functions
    - Initialized in main.dart with platform-specific options

3. **Navigation** (GoRouter in `main.dart`):
    - Declarative routing with deep linking support
    - Protected routes based on auth state

4. **Internationalization** (`l10n/`):
    - Supports pt-BR and en-US
    - Generated from ARB files
    - User preference stored in Supabase profile

## Database Schema

The PostgreSQL database (via Supabase) includes these core tables:

- `profiles`: User data extending Supabase auth
- `farms`: Farm/garden entities
- `plots`: Cultivation areas within farms
- `beds`: Individual planting beds
- `crops_catalog`: Crop variety database
- `plantings`: Active crop instances
- `tasks`: Agricultural tasks
- `collaborators`: Farm access control
- `invitations`: Pending collaborations

Migrations are in `supabase/migrations/` and must be run in numerical order.

## Development Workflow

1. **Feature Development**:
    - Create feature folder following Clean Architecture
    - Implement domain layer first (entities, use cases)
    - Add data layer (repositories, data sources)
    - Build presentation layer (BLoC, screens)
    - Register dependencies in `injection_container.dart`

2. **Adding Dependencies**:
    - Add to `pubspec.yaml`
    - Run `flutter pub get`
    - If using code generation, run build_runner

3. **Database Changes**:
    - Create numbered migration file in `supabase/migrations/`
    - Test locally with Supabase CLI
    - Apply to production via Supabase dashboard

4. **Testing**:
    - Unit tests for use cases and repositories
    - Widget tests for UI components
    - Integration tests for critical flows
    - Use mocktail for mocking dependencies

## Common Patterns

### API Calls with Error Handling

```dart
// Use Either type for error handling
final result = await
repository.getData
();result.fold
(
(failure) => emit(ErrorState(failure.message)),
(data) => emit(SuccessState(
data
)
)
,
);
```

### BLoC Event Handling

```dart
// Use freezed for immutable state/events
@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loginRequested({
    required String email,
    required String password,
  }) = _LoginRequested;
}
```

### Dependency Injection

```dart
// Register in injection_container.dart
sl.registerFactory
(
() => YourBloc(repository: sl()));
sl.registerLazySingleton<YourRepository>(
() => YourRepositoryImpl(dataSource: sl())
);
```

## Important Considerations

- Always check network connectivity before remote operations
- Handle Supabase auth state changes globally
- Respect Row Level Security policies in database operations
- Use proper error boundaries and loading states
- Follow Material Design guidelines for UI consistency
- Test on both web and mobile platforms