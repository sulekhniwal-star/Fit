# FitKarma Greenfield Repository Audit

> Generated as part of **TASK 001** (Phase 0: Repository Initialization & Engineering Foundation).  
> Audit Date: 2026-11-03  
> Authoritative sources: `FitKarma_Master_Documentation_v1.0.md`, `.agent/skills/SKILL.md`, `Brain/master_rules.md`, `Brain/trd.md`, `Brain/architecture.md`, `Brain/decisions.md`.

---

## 1. Executive Summary

A complete greenfield repository and environment audit was conducted on 2026-11-03.

**Key Finding**: Contrary to the initial greenfield assumption that no application code exists, repository inspection proves that a substantial Flutter application shell, modular architecture, Drift/SQLite database layer, 51 test suites (250 passing tests), and Supabase backend migrations/Edge Functions **already exist** in the repository.

However, several critical gaps, toolchain constraints, and discrepancies were identified:
- CI configuration (`.github/workflows/`) is completely absent.
- `supabase` CLI and `deno` are not installed in the Windows system PATH.
- The master documentation file on disk is named `FitKarma_Master_Documentation_v1.0.md`, whereas prompts and scripts frequently reference `FitKarma_Master_Documentation_v1.md`.
- 1 static analysis warning exists (`unused_import` in `lib/app/router/app_router.dart`).
- 1 widget smoke test fails (`test/widget_test.dart`) due to an obsolete widget text expectation.
- Local iOS builds are impossible on the Windows host and require macOS CI runners.

---

## 2. Inventory of What Actually Exists

| Category | Path / Files | Details & Status |
|---|---|---|
| **Root Docs & Specs** | `FitKarma_Master_Documentation_v1.0.md`<br>`Todo.md`<br>`README.md`<br>`CLAUDE.md` | Authoritative v1.0 master specification (438 lines), v1.1 Greenfield Build Plan with 24 phases (4,777 lines), and GSD project context. |
| **Agent Skill** | `.agent/skills/SKILL.md`<br>`.agent/skills/SKILLS.md` | Authoritative AI coding-agent operating rules, architecture boundaries, security, and offline-first guidelines. |
| **Domain Specs** | `Brain/` (19 markdown files) | Complete domain specification set (`master_rules`, `pdr`, `trd`, `architecture`, `decisions`, `data_model`, `api_contract`, `data_sources`, `ui_spec`, `security`, `error_handling`, `testing`, `production_checklist`, `github_actions`, `admob_spec`, `scrapping_spec`, `changelog`, `microtasks`, `implementation_audit`). |
| **Flutter Project Shell** | `pubspec.yaml`<br>`pubspec.lock`<br>`analysis_options.yaml` | Flutter project `fitkarma` configured for Dart `^3.13.7` with Riverpod, GoRouter, Logger, SharedPreferences, Supabase Flutter, Drift, SQLite3, Path Provider. Strict analysis options enabled. |
| **Application Code** | `lib/` (80+ Dart source files) | • `lib/app/`: Router (`GoRouter`) and route definitions.<br>• `lib/core/`: Config (`AppConfig`, feature flags, remote config), Drift DB (`AppDatabase` with 8 table schemas, encryption key provider), errors (`Failures`, `Result` with `FK-xxxx` codes), localization (`AppLocalizations` EN/HI), logging (`AppLogger`, `PiiRedactor`), DI providers, Supabase service, and offline Sync engine (`SyncCoordinator`, outbox queue, conflict resolution).<br>• `lib/shared/`: Design system tokens (`AppColors`, `AppMotion`, `AppRadii`, `AppSpacing`, `AppTheme`, `AppTypography`), accessibility helpers, Bento cards, metric cards, action buttons, offline banners.<br>• `lib/features/`: Modules for `ai`, `auth`, `brain` (DIP rule engine), `cultural` (AQI and fasting/festivals), `health`, `nutrition`, `onboarding`, `os_health` (Health Connect / Apple Health adapters), `profile`, and `workout`.<br>• `lib/main.dart`: App bootstrap entrypoint. |
| **Platform Targets** | `android/`<br>`ios/` | • `android/`: Gradle 8.x Kotlin/Java build structure targeting Android SDK 37.0.0.<br>• `ios/`: Runner Xcode project structure with Podfile/configuration. |
| **Automated Tests** | `test/` (51 test files) | 251 test cases across unit, widget, and architecture domains (250 passing, 1 failing smoke test in `test/widget_test.dart`). |
| **Backend & Supabase** | `supabase/` | • `supabase/config.toml` (`project_id = "fitkarma"`).<br>• Migrations: `20261102000001_baseline_schema_and_rls.sql` (15 baseline tables with universal default-deny RLS), `20261103000001_whatsapp_interactions.sql`.<br>• Edge Functions: `ai-gateway`, `health-check`, `whatsapp-webhook`, and shared envelope utilities. |
| **Environment & Secrets** | `.env.example`<br>`.gitignore` | Safe environment template separating client config (`SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SENTRY_DSN`) from private secrets. Strict `.gitignore` rules for `.env*`, keys, keystores, and credentials. |
| **Version Control** | `.git/` | Clean working tree on branch `master`. Five recent commits up to `189ee20`. |

---

## 3. Inventory of What is Missing

| Component | Expected Location | Impact & Severity |
|---|---|---|
| **CI/CD Pipeline** | `.github/workflows/*.yml` | **High**: No automated testing, linting, or build verification in GitHub Actions. |
| **Supabase CLI** | System PATH | **Medium**: Cannot run local Supabase stack or automated migration tests via CLI on host. |
| **Deno Runtime** | System PATH | **Medium**: Cannot run or test Edge Functions locally outside containerized environments. |
| **File Naming Parity** | `FitKarma_Master_Documentation_v1.md` | **Low**: File is named `FitKarma_Master_Documentation_v1.0.md` on disk; causes path resolution errors if scripts look for `v1.md`. |
| **Desktop C++ Tools** | Visual Studio Build Tools | **Low / Negligible**: Only affects Windows desktop target; Android and iOS targets are unaffected. |
| **macOS/Xcode Host** | Local machine | **Known Constraint**: Local host is Windows 11; iOS builds must be delegated to remote macOS CI runners. |

---

## 4. Environment & Toolchain Inspection

| Tool / Environment | Detected Version | Details & Constraints |
|---|---|---|
| **Host Operating System** | Windows 11 (26H2, build 26340.9843) | Host environment, locale `en-IN`. |
| **Flutter SDK** | **3.47.9** (channel stable) | Installed at `C:\Users\JSK\develop\flutter`. Engine `89c39edfdf`, Framework `c197ca5199`. |
| **Dart SDK** | **3.13.7** | DevTools `2.60.0`. |
| **Android SDK** | **37.0.0** (platform android-37.0) | Located at `C:\Users\JSK\AppData\Local\Android\sdk`. Build-tools `37.0.0`. Emulator `37.2.13.0`. |
| **Android JDK** | OpenJDK Runtime 25.0.4 | Bundled with Android Studio (`C:\Program Files\Android\Android Studio\jbr\bin\java`). All Android licenses accepted. |
| **Node.js** | **v24.22.1** | Available in system PATH. |
| **npm** | **11.19.1** | Available in system PATH. |
| **Git** | **2.45.1.windows.1** | Clean working tree on branch `master`. |
| **Supabase CLI** | Not found in PATH | Requires manual installation or container execution for local backend tasks. |
| **Deno** | Not found in PATH | Required for local TypeScript Edge Function verification. |
| **iOS Toolchain** | Not available on Windows | Per `Brain/github_actions.md`, iOS compilation is delegated to GitHub Actions macOS runners. |

---

## 5. Immediate Blockers & Technical Debt

1. **Static Analysis Warning**:
   - `lib/app/router/app_router.dart:4:8`: `unused_import: '../../core/config/app_config.dart'`.
   - Blocks zero-warning gate for strict CI checks.
2. **Failing Smoke Test**:
   - `test/widget_test.dart`: Expects `'FitKarma Health OS'`, but `FitKarmaApp` currently routes to unauthenticated welcome/dashboard screens without rendering that specific text.
3. **Master Document Naming**:
   - `FitKarma_Master_Documentation_v1.md` referenced in Todo.md and prompts is stored as `FitKarma_Master_Documentation_v1.0.md`. A symlink or alias is recommended in TASK 001A.
4. **Sandbox Path Isolation**:
   - Flutter binaries in `C:\Users\JSK\develop\flutter` are outside the IDE sandbox workspace, requiring bypass permissions when running Flutter CLI directly.

---

## 6. Recommended Bootstrap Sequence

Following `Todo.md` ordering rules:

1. **TASK 001A (Documentation Wiring & Doc-Lint Gate)**:
   - Create documentation alias/symlink for `FitKarma_Master_Documentation_v1.md` -> `FitKarma_Master_Documentation_v1.0.md`.
   - Add doc link-checking and doc-lint scripts (`DOC-001`, `DOC-002`).
   - Validate that all 19 `Brain/` documents resolve.
   - Re-confirm source-reported baselines as unverified until reproduced.
2. **TASK 002 (Bootstrap Flutter Application & Smoke Test Fix)**:
   - Reconcile `test/widget_test.dart` and remove unused import in `app_router.dart` to establish 0 analyzer warnings and 100% passing tests (251/251).
3. **TASK 003–008**:
   - Audit and confirm Git ignore boundaries, folder structure, Riverpod providers, GoRouter navigation, error codes, and logging redaction against existing implementation.
4. **CI Setup**:
   - Establish `.github/workflows/` with automated Flutter test/analyzer and Supabase migration linting jobs.
