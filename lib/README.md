# FitKarma Layered Architecture & Dependency Rules

This architecture adheres strictly to `Brain/architecture.md`.

## Layers & Dependency Directions

```text
Presentation Layer (lib/features/*/presentation, lib/shared/widgets)
       ↓ (depends on)
 Domain Layer (lib/features/*/domain)
       ↑ (implements)
  Data Layer (lib/features/*/data)
       ↓ (uses)
  Core Layer (lib/core/)
```

### Core Invariants
1. **Domain Isolation**: `domain/` contains pure Dart entities, repository interfaces, and use cases. It MUST NOT import Flutter widgets or data-layer concrete implementations.
2. **Data Layer**: `data/` implements repository interfaces defined in `domain/` and handles network (Supabase) and local persistence (Drift).
3. **Presentation Layer**: `presentation/` consumes domain models and exposes Riverpod state notifiers and widgets.
4. **Core Layer**: `lib/core/` houses foundational cross-cutting primitives (config, errors, logging, providers, network utilities).
5. **Shared Layer**: `lib/shared/` contains reusable UI components, themes, and design system tokens.
