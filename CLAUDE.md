# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Cuber Timer is a Flutter mobile application for timing Rubik's cube solves with support for multiple cube types, records tracking, scramble generation, and premium subscription features.

**Current Version:** 4.0.4+27

## Development Commands

### Flutter Version Management
This project uses FVM (Flutter Version Manager) to manage Flutter versions:
- **Flutter version:** 3.35.3 (specified in `.fvmrc`)
- Run commands with `fvm flutter` instead of `flutter` to ensure correct version

### Common Commands
```bash
# Install dependencies
fvm flutter pub get

# Run code generation (for MobX and Injectable)
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for code generation during development
fvm flutter pub run build_runner watch --delete-conflicting-outputs

# Run the app
fvm flutter run

# Build APK (Android)
fvm flutter build apk

# Build iOS
fvm flutter build ios

# Run linter
fvm flutter analyze

# Run tests
fvm flutter test

# Generate launcher icons
fvm flutter pub run flutter_launcher_icons
```

## Architecture

### Core Structure
The app follows a modular architecture with clean architecture principles:

```
lib/app/
├── core/           # Core infrastructure and shared domain logic
├── modules/        # Feature modules (home, timer, config, splash, etc.)
├── shared/         # Shared UI components, themes, and utilities
└── di/             # Dependency injection configuration
```

### Key Architectural Patterns

**State Management:** MobX is used throughout the app
- Controllers end with `_controller.dart` and have corresponding `.g.dart` generated files
- Use `@observable`, `@computed`, and `@action` annotations
- Run build_runner after modifying observables

**Dependency Injection:** Injectable + GetIt
- Configuration in `lib/app/di/dependency_injection.dart`
- Use `@Injectable()` for regular dependencies, `@singleton` for singletons
- Register modules in `dependency_injection.config.dart` (auto-generated)
- Run build_runner after adding new injectables

**Database:** Drift (SQL database)
- Database definition in `lib/app/core/data/clients/local_database/drift_database.dart`
- Main table: `Records` for storing solve times
- Uses SQLite via `sqlite3_flutter_libs`
- Define tables extending Drift's `Table` class and run build_runner for schema changes
- Service implementation in `drift_service.dart` using `DriftService`

**Navigation:** Custom route system
- Routes defined in `lib/app/core/domain/entities/named_routes.dart`
- Route mapping in `lib/app/core/routes/app_routes.dart`
- Supports custom page transitions

**Internationalization:** Custom i18n system
- Translation files: `assets/i18n/en_US.yaml` and `assets/i18n/pt_BR.yaml`
- Access translations via `translate('key.path')` function
- Supported locales: Portuguese (pt_BR) and English (en_US)

### Key Modules

**Timer Module** (`lib/app/modules/timer/`)
- Main timing functionality with StopWatchTimer
- Scramble generation for different cube types (3x3, 4x4, 5x5, etc.)
- Timer states: Stop, Running, Pause
- Integrates with records tracking and beat record detection

**Home Module** (`lib/app/modules/home/`)
- Displays records grouped by cube type
- Record management (view, delete)
- Uses super_sliver_list for performance

**Config Module** (`lib/app/modules/config/`)
- App settings and preferences
- In-app purchase handling via PurchaseService
- Subscription plans: weekly, monthly, annual
- Platform-specific product IDs (Android vs iOS)

### Important Services

**AdService** (`lib/app/shared/services/ad_service.dart`)
- Google Mobile Ads integration
- Premium users don't see ads

**PurchaseService** (`lib/app/modules/config/presenter/services/purchase_service.dart`)
- In-app purchase management
- Handles subscription state across app restarts
- Different product IDs for iOS and Android
- Disabled in debug mode by default

**AppGlobal** (`lib/app/core/domain/entities/app_global.dart`)
- Singleton for global app state
- Manages premium subscription status

**LocalStorage:** SharedPreferences wrapper
- Interface: `ILocalStorageService`
- Implementation: `SharedPreferencesService`

## Important Notes

### Code Generation
After modifying files with annotations (@observable, @Injectable, @collection), always run:
```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

### Platform-Specific Considerations
- In-app purchases have different product IDs for Android and iOS
- Purchase service is disabled in debug mode by default (see `dependency_injection.dart:34`)
- Icon generation uses different settings per platform (see `pubspec.yaml` flutter_icons section)

### Data Migration
The app includes migration logic in `dependency_injection.dart`:
- `_checkRecordsWithoutGroupAndSetGroupDefault()` handles old records without group assignment
- Debug records are inserted in development mode for testing

### Value Objects (VOs)
The app uses Value Object pattern for domain validation:
- Located in `lib/app/core/domain/vos/`
- Examples: TextVO, IntVO, DateTimeVO, etc.
- Extend `ValueObject` base class

### Theming
- Light and dark themes defined in `lib/app/shared/themes/theme.dart`
- Color schemes in `lib/app/shared/themes/color_schemes.g.dart`
- App defaults to dark mode (`ThemeMode.dark`)
