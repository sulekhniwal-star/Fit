<!-- GSD:project-start source:PROJECT.md -->
## Project

**FitKarma**

FitKarma is an India-first Health Operating System designed as an offline-resilient, privacy-centric health companion that works where users are — on mobile and WhatsApp. Built with Flutter 3.x, Supabase, Groq AI, and Razorpay, it delivers intelligent daily health synthesis (Daily Intelligence Package), deep Indian nutrition logging (katori, raw/cooked yields, tadka slider, family recipe splitter), WhatsApp voice/text logging in Hinglish, and full DPDP Act 2023 compliance.

**Core Value:** India's smartest, most private Health OS that combines offline-first local storage, deep Indian cultural/nutritional realities, and zero-friction WhatsApp logging without compromising user data sovereignty.

### Constraints

- **Tech Stack**: Flutter 3.24+ / Dart 3.5+, Riverpod 2.x, Drift + SQLCipher, Supabase (Postgres, Auth, Storage, Edge Functions, Realtime), Groq AI, Razorpay.
- **Security & Privacy**: Complete compliance with DPDP Act 2023; all local user data encrypted at rest with SQLCipher; strict universal Supabase RLS; cascading user data erasure in 28 tables.
- **AI Architecture**: AI calls must execute server-side via Supabase Edge Functions / Groq gateway; client apps never communicate directly with LLM providers or hold provider API keys.
- **Offline First**: All user core health and meal logging must function seamlessly without active network connectivity, queuing changes in a persistent outbox.
<!-- GSD:project-end -->

<!-- GSD:stack-start source:STACK.md -->
## Technology Stack

Technology stack not yet documented. Will populate after codebase mapping or first phase.
<!-- GSD:stack-end -->

<!-- GSD:conventions-start source:CONVENTIONS.md -->
## Conventions

Conventions not yet established. Will populate as patterns emerge during development.
<!-- GSD:conventions-end -->

<!-- GSD:architecture-start source:ARCHITECTURE.md -->
## Architecture

Architecture not yet mapped. Follow existing patterns found in the codebase.
<!-- GSD:architecture-end -->

<!-- GSD:skills-start source:skills/ -->
## Project Skills

No project skills found. Add skills to any of: `.claude/skills/`, `.agents/skills/`, `.cursor/skills/`, `.github/skills/`, or `.codex/skills/` with a `SKILL.md` index file.
<!-- GSD:skills-end -->

<!-- GSD:workflow-start source:GSD defaults -->
## GSD Workflow Enforcement

Before using Edit, Write, or other file-changing tools, start work through a GSD command so planning artifacts and execution context stay in sync.

Use these entry points:
- `/gsd-quick` for small fixes, doc updates, and ad-hoc tasks
- `/gsd-debug` for investigation and bug fixing
- `/gsd-execute-phase` for planned phase work

Do not make direct repo edits outside a GSD workflow unless the user explicitly asks to bypass it.
<!-- GSD:workflow-end -->



<!-- GSD:profile-start -->
## Developer Profile

> Profile not yet configured. Run `/gsd-profile-user` to generate your developer profile.
> This section is managed by `generate-claude-profile` -- do not edit manually.
<!-- GSD:profile-end -->
