# Developer workflow

This workflow follows the KoreaMate blueprint.

## Phase 0 workflow

1. Read the blueprint and product requirements.
2. Inspect repository state before changes.
3. Make small, focused updates.
4. Validate only the necessary app, backend, or tests.
5. Fix the issues caused by your changes.
6. Keep secrets out of source control.
7. Document the change and the next task.

## Recommended team flow

- Frontend: Flutter app under `apps/mobile`
- Backend: FastAPI under `backend`
- Data model: docs and schema under `database`
- Product / roadmap: docs under `docs`

## Quality gates

Before considering a feature complete:

- the UI matches the intended flow
- loading, empty, success, and error states are handled
- input validation is enforced
- business rules and permissions are respected
- backend integration works when required
- relevant tests are run
- secrets are not exposed
- no existing features are broken
