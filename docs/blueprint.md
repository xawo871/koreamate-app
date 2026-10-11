# Project blueprint

## Phase 0: Foundation

This repository begins with the foundational structure for KoreaMate and follows the product blueprint.

### Goals

- establish a clean monorepo shape
- define architecture and guardrails
- create the initial mobile app skeleton
- prepare the backend and data model foundation
- document roadmap and security expectations

### Architecture direction

- App: Flutter
- Target platforms: Android and Web
- Backend: API server based on project needs
- Database: PostgreSQL or equivalent managed service
- Storage: secure object storage
- AI: replaceable model API integration
- OCR: expansion after evaluation
- Scheduler: backend task runner
- Queue: async jobs
- Admin: web dashboard
- Source control: GitHub
- CI/testing: automated validation

### Quality gates

- user privacy and data isolation
- permission checks before AI, payments, or publishing actions
- no secrets in client code
- no fake source verification
- budget guardrails for AI and marketing
- features must be tested before being declared complete

### Roadmap

Phase 0: Foundation
Phase 1: MVP Learning App
Phase 2: Learning Engine
Phase 3: EPS-TOPIK
Phase 4: OCR & Import
Phase 5: Monetization
Phase 6: Admin Dashboard
Phase 7: AI Operations
Phase 8: AI Marketing
Phase 9: Autonomous Operations
