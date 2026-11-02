# Phase 02: Design System & UI Foundation - Research

**Researched:** 2026-11-02  
**Domain:** Flutter UI Architecture, Design Tokens, Glassmorphism, Spring Physics, Bilingual Localization & Accessibility  
**Confidence:** HIGH  

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- **Color Tokens**: Primary dark background `#0D0F12`, surface `#161A22`, elevated glass `#1F2430`, neon mint `#00E599`, teal `#00BFA5`, saffron `#FF9933`, tech blue `#38BDF8`, text primary `#F8FAFC`, text secondary `#94A3B8`, error `#EF4444`.
- **Spacing Scale**: `xxs: 2`, `xs: 4`, `sm: 8`, `md: 12`, `lg: 16`, `xl: 24`, `xxl: 32`, `xxxl: 48`.
- **Border Radii**: `xs: 6`, `sm: 10`, `md: 16` (Bento card standard), `lg: 24`, `full: 999`.
- **Motion**: Fast micro-interactions at 150ms (`Curves.easeOutBack`), standard component transitions at 250ms (`Curves.easeOutCubic`).
- **Touch Target**: Strict minimum 48x48dp on all interactive elements.
- **Languages**: English (`en`) and Hindi (`hi`) with runtime toggle and automatic English fallback.

### Claude's Discretion
- Implementation of theme tokens using `ThemeExtension` vs static classes (using static token classes + `ThemeData` integration provides maximum clarity and zero code-gen).
- Internal showcase catalog screen to visualize design system components.
</user_constraints>

<architectural_responsibility_map>
## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| Design Tokens (`AppColors`, `AppSpacing`, etc.) | Shared UI (`lib/shared/theme/`) | — | Single source of truth for all visual values |
| Theming & Glassmorphism | Shared UI (`lib/shared/theme/`) | Material 3 Theme | Configures global ThemeData and custom glass card decorators |
| Localization (`AppLocalizations`) | Core / Shared (`lib/core/localization/`) | Riverpod State | Translates UI labels and broadcasts locale changes |
| Shared UI Primitives (`BentoCard`, `MetricCard`) | Shared UI (`lib/shared/widgets/`) | — | Reusable atomic building blocks across all feature screens |
</architectural_responsibility_map>

<research_summary>
## Summary

Phase 2 builds the sensory layer of FitKarma according to `Brain/ui_spec.md`. The visual signature is dark-mode primary (`#0D0F12`), accented by energetic neon mint (`#00E599`) and cultural saffron gold (`#FF9933`), with subtle glassmorphic elevation (`#1F2430`) and responsive Bento-grid cards.

To ensure consistency and ease of maintenance across features, design tokens are organized into typed static contracts:
- `AppColors`: 10 core semantic colors.
- `AppSpacing`: 8-point geometric spacing scale with 48dp minimum touch target constant.
- `AppRadii`: Corner radii with 16dp standard for Bento cards.
- `AppTypography`: High-contrast typography hierarchy supporting Indian regional script legibility.
- `AppMotion`: Durations and curves calibrated for tactile spring physics.

For localization, a typed key-value localization delegate supports English (`en`) and Hindi (`hi`), coupled with a Riverpod `localeProvider` for instant, restart-free language switching. Accessibility helpers enforce the 48dp touch target rule and ensure that text scaling up to 1.5x renders without RenderFlex overflows.

**Primary recommendation:** Implement tokens and theme extensions first, then the localization delegate, followed by the shared primitives (`BentoCard`, `MetricCard`, `ActionButton`, `AppScaffold`) with rigorous widget tests.
</research_summary>

<standard_stack>
## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| `flutter/material.dart` | SDK | Material 3 foundation | Baseline UI framework with dark theme support |
| `flutter_riverpod` | `^2.5.1` | Locale & theme state | Reactive locale updates across active widget tree |

### UI Design Patterns
- **Glassmorphism**: `ClipRRect(borderRadius: ...)` wrapping a `BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10))` with translucent background `AppColors.surfaceElevated.withValues(alpha: 0.7)` and a 1px border `Colors.white.withValues(alpha: 0.08)`.
- **Bento Card**: Modular card with 16dp border radius, 16dp inner padding, and clean hierarchy (title, subtitle, metric, trailing action).
- **Spring Physics**: Tap feedback scaling down to 0.97 with `AnimatedScale(scale: isPressed ? 0.97 : 1.0, duration: 150ms, curve: Curves.easeOutBack)`.
</standard_stack>

<verification_guidelines>
## Verification Guidelines

1. **Token Correctness**: Verify all hex color codes match `Brain/ui_spec.md` Section 13 exactly.
2. **Locale Switching**: Test switching between English and Hindi; verify that key labels update reactively and missing keys fallback to English.
3. **Accessibility**: Test widget rendering with text scale factor set to 1.5x; ensure zero overflow errors occur.
4. **Touch Target**: Verify interactive buttons enforce `kMinInteractiveDimension` (48dp).
5. **Static Analysis**: Verify `flutter analyze --fatal-infos` passes with 0 issues.
</verification_guidelines>
