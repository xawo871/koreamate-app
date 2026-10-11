# KoreaMate backend

This backend is intentionally a secure, server-side foundation for KoreaMate features.

## Security rules

- Keep all external API secrets in environment variables or a proper secret manager.
- Never expose API keys to Flutter or browser users.
- Use backend-only endpoints for dictionary, AI, billing, and admin operations.
- Log only minimal metadata needed for debugging and auditing.
- Restrict CORS in production; do not allow all origins in real deployments.

## Krdict integration

The dictionary service is designed to proxy requests from Flutter to the backend.
The mobile app does not call the remote dictionary provider directly.

### Required environment variables

- `KRDICT_API_KEY`
- `KRDICT_BASE_URL`
- `REQUEST_TIMEOUT_SECONDS` (optional)
- `ALLOWED_ORIGINS` (optional, use only in non-local envs)

### Recommended backend flow

1. Flutter sends a search request to `GET /api/dictionary/search?q=...`
2. Backend validates the query and user permissions
3. Backend calls the official Krdict provider using the secret key on the server
4. Backend normalizes the response and returns a safe subset to the app
5. Backend logs only metadata and never returns raw secret material

### Integration contract

The exact Krdict endpoint and payload mapping must match the provider's official documentation.
This scaffold is intentionally generic so it cannot break if the API contract changes slightly.

## Current phase

This folder contains a secure scaffold and integration contract for the dictionary feature.
The official provider endpoint and response mapping must be validated against the Krdict docs before production usage.
