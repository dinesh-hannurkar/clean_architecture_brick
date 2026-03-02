# Project Structure

**Last Updated:** 2026-01-23  
**Author:** API Architect

## Overview

Project App uses a **hybrid feature-layer architecture** that combines the benefits of Clean Architecture's layer separation with feature-based modularity for better scalability and maintainability.

## Folder Structure

```
lib/
├── core/                          # Shared code across features
│   ├── domain/
│   │   ├── failures/             # Base failure types
│   │   └── usecases/             # Base UseCase class
│   └── data/
│       ├── network/              # HTTP client, API config
│       └── exceptions/           # Data layer exceptions
│
├── features/                      # Feature modules
│   └── auth/                     # Authentication feature
│       ├── domain/
│       │   ├── entities/         # User, AuthToken
│       │   ├── repositories/     # AuthRepository interface
│       │   └── usecases/         # SignInWithGoogle, etc.
│       ├── data/
│       │   ├── models/           # UserModel, AuthTokenModel
│       │   ├── datasources/      # API and local data sources
│       │   └── repositories/     # AuthRepositoryImpl
│       └── presentation/         # (Future: BLoCs, screens, widgets)
│
└── main.dart
```

## Design Philosophy

### Layer Separation Within Features
Each feature maintains Clean Architecture's three layers:
- **Domain**: Business logic, entities, repository interfaces
- **Data**: Data sources, models, repository implementations
- **Presentation**: UI, BLoC/Cubit, screens, widgets

### Core Module
Shared code used across multiple features:
- Base classes (UseCase, Failure)
- Network infrastructure
- Common utilities

### Feature Independence
- Each feature is self-contained
- Features depend on core, not on each other
- Easy to add, remove, or modify features

## Benefits

| Benefit | Description |
|---------|-------------|
| **Scalability** | Add new features without affecting existing ones |
| **Maintainability** | All related code is in one place |
| **Team Collaboration** | Multiple developers can work on different features |
| **Code Reusability** | Core module contains shared functionality |
| **Clean Architecture** | Maintains layer separation within each feature |

## Adding New Features

To add a new feature (e.g., `profile`):

```bash
mkdir -p lib/features/profile/{domain/{entities,repositories,usecases},data/{models,datasources,repositories},presentation/{bloc,screens,widgets}}
mkdir -p test/features/profile/{domain,data,presentation}
```

Then implement following the same pattern as `features/auth/`.

## Import Conventions

### Core Module
```dart
import 'package:app/core/domain/failures/failure.dart';
import 'package:app/core/domain/usecases/usecase.dart';
import 'package:app/core/data/network/http_client.dart';
```

### Feature Module (Auth)
```dart
import 'package:app/features/auth/domain/entities/user.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/features/auth/data/models/user_model.dart';
```

## Testing Structure

Tests mirror the source structure:

```
test/
├── core/
│   ├── domain/
│   │   └── failures/
│   └── data/
└── features/
    └── auth/
        ├── domain/
        │   ├── entities/
        │   └── usecases/
        └── data/
            ├── models/
            ├── datasources/
            └── repositories/
```

## Dependency Rules

```
Presentation ─depends on─> Domain
Domain       <──────────── Data (implements interfaces)
             ─depends on─> Core (shared utilities)
```

**Key Rules:**
- ✅ Presentation can depend on Domain
- ✅ Data can depend on Domain
- ✅ All layers can depend on Core
- ❌ Domain NEVER depends on Data or Presentation
- ❌ Features NEVER depend on other features

## Migration from Layer-First

This project was migrated from a layer-first structure (`lib/domain`, `lib/data`) to this hybrid approach for better scalability.

See [API-002 Walkthrough](file:///Users/dineshhannurkar/.gemini/antigravity/brain/8f781cc1-44a0-48f9-8233-735a628e11ac/walkthrough.md) for migration details.

## Future Features

As the app grows, new features will be added to `lib/features/`:
- `features/profile/` - User profile management
- `features/orders/` - Order management
- `features/notifications/` - Push notifications
- `features/settings/` - App settings

Each will follow the same domain/data/presentation structure.
