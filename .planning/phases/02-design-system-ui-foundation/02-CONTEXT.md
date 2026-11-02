# Phase 02: Design System & UI Foundation - Context

**Gathered:** 2026-11-02  
**Status:** Ready for planning  
**Source:** Ingested from `Todo.md` (Tasks 009, 010, 011, 012) & `Brain/ui_spec.md`

<domain>
## Phase Boundary

Phase 2 establishes the complete visual identity, design tokens, localization engine, accessibility helpers, and shared UI component library for FitKarma:
1. **Design System & Theme Tokens** (`AppColors`, `AppSpacing`, `AppRadii`, `AppTypography`, `AppMotion`, dark mode `#0D0F12`, glassmorphism styles).
2. **Bilingual Localization Foundation** (English `en` and Hindi `hi` switching, locale persistence, missing translation fallbacks, separation of static UI strings from dynamic AI coaching).
3. **Accessibility Foundation** (WCAG 2.1 touch target minimum 48dp, high contrast text `#F8FAFC`, dynamic text scaling support, screen reader semantic labels).
4. **Shared UI Component Primitives** (`AppScaffold`, `BentoCard`, `MetricCard`, `ActionButton`, loading skeletons, offline banners, error dialogs, empty states).

Phase Gate: Dark-theme design system, EN/HI localization, accessibility helpers, and shared UI primitives exist with passing widget tests.
</domain>

<decisions>
## Implementation Decisions

### Visual Tokens (Brain/ui_spec.md §13)
- **Scaffold / Primary Dark**: `#0D0F12` (`AppColors.background`)
- **Surface Level 1**: `#161A22` (`AppColors.surface`)
- **Surface Level 2 (Elevated Glass)**: `#1F2430` (`AppColors.surfaceElevated`)
- **Primary Mint Accent**: `#00E599` (`AppColors.primary`)
- **Primary Teal Accent**: `#00BFA5` (`AppColors.primaryAccent`)
- **Saffron Gold (Fasting/Ayurveda)**: `#FF9933` (`AppColors.saffron`)
- **Tech Blue (AI Signals)**: `#38BDF8` (`AppColors.techBlue`)
- **Text Primary**: `#F8FAFC` (`AppColors.textPrimary`)
- **Text Secondary**: `#94A3B8` (`AppColors.textSecondary`)
- **Error Crimson**: `#EF4444` (`AppColors.error`)
- **Spacing Scale**: `xxs: 2`, `xs: 4`, `sm: 8`, `md: 12`, `lg: 16`, `xl: 24`, `xxl: 32`, `xxxl: 48`
- **Border Radii**: `xs: 6`, `sm: 10`, `md: 16` (Bento cards), `lg: 24`, `full: 999`
- **Motion**: 150ms `AppMotion.fast` (`Curves.easeOutBack`) and 250ms `AppMotion.normal` (`Curves.easeOutCubic`)

### Localization (Brain/ui_spec.md §1 & Todo Task 010)
- **Supported Locales**: English (`en`) and Hindi (`hi`).
- **Separation**: Static UI labels live in localized translation maps/delegates; AI coaching/telemetry is handled dynamically and separated from application strings.
- **Fallbacks**: If a key is missing in Hindi, automatically fall back to English with a non-fatal warning.

### Accessibility (Todo Task 011)
- **Touch Target**: Minimum touch target size of 48x48dp for all interactive buttons and chips.
- **Text Scaling**: Components must layout flexibly without overflow when text scale factor is 1.5x.

### Claude's Discretion
- Selection of localization mechanism (Flutter `AppLocalizations` / standard arb / lightweight typed key map).
- Specific component showcase / preview catalog widget.
</decisions>

<canonical_refs>
## Canonical References

- `Brain/ui_spec.md` — Section 13 authoritative design tokens, colors, spacing, and Bento grid rules.
- `Brain/master_rules.md` — UI invariants, touch accessibility, and dark mode primacy.
- `Todo.md` — Tasks 009, 010, 011, 012 prompts and acceptance criteria.
</canonical_refs>

<specifics>
## Specific Tasks Mapped from Todo.md

- **TASK 009**: FitKarma Design System (colors, typography, radii, glassmorphism, spring physics).
- **TASK 010**: Localization Foundation (EN/HI switching, fallbacks, locale provider).
- **TASK 011**: Accessibility Foundation (48dp touch targets, semantics, text scaling).
- **TASK 012**: Shared UI States and Components (AppScaffold, BentoCard, MetricCard, ActionButton, skeletons, offline badge).
</specifics>

<deferred>
## Deferred Ideas

- Supabase backend migrations (Task 012A–012C are scheduled for Phase 3).
- Full product screens (Dashboard, Nutrition, Workout trackers are built in Phases 4–7).
</deferred>

---
*Phase: 02-design-system-ui-foundation*
*Context gathered: 2026-11-02 from Todo.md & Brain/ui_spec.md*

