# KoreaMate

KoreaMate is a premium Korean learning app with AI tutoring, vocabulary practice, OCR-based import, subscription management, and admin operations. This repository is the initial foundation for the project and follows the project blueprint defined in the product specification.

## Repository structure

- `apps/mobile` – Flutter app for Android and Web
- `backend` – backend service and API stubs
- `database` – schema and ERD notes
- `docs` – product, security, and roadmap documents
- `scripts` – automation and validation helpers

## Current phase

Phase 0: Foundation

This repo sets up the project skeleton, developer guidance, and the baseline architecture for the upcoming MVP phases.

## Core principles from the blueprint

- Security and privacy are mandatory foundations.
- AI features must be constrained by permissions and budget checks.
- Data integrity and user isolation must be preserved.
- Features must be built and verified incrementally.
- Monetization and AI operations come after the learning app is stable.

## Recommended next steps

1. Install Flutter SDK and open `apps/mobile` in a local environment or Codespace.
2. Run `flutter pub get` and `flutter test` once the toolchain is installed.
3. Implement the core onboarding, home, and dictionary flows.
4. Build the backend contracts for auth, profiles, learning sessions, and progress.
5. Move to Phase 1: MVP Learning App.

## Status

This repository currently contains the Phase 0 scaffold, not the full product implementation.
