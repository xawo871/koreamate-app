# KoreaMate backend

This backend is intentionally a secure, server-side foundation for KoreaMate features.

## Security rules

- Keep all external API secrets in environment variables or a proper secret manager.
- Never expose API keys to Flutter or browser users.
- Use backend-only endpoints for dictionary, AI, billing, and admin operations.
- Log only minimal metadata needed for debugging and auditing.

## Krdict integration

The dictionary service is designed to proxy requests from Flutter to the backend.
The mobile app does not call the remote dictionary provider directly.

### Required environment variables

- `KRDICT_API_KEY`
- `KRDICT_BASE_URL`

### Recommended backend flow

1. Flutter sends search request to `GET /api/dictionary/search?q=...`
2. Backend validates request and user permissions
3. Backend calls the official Krdict provider using the secret key
4. Backend normalizes the response and returns the data to the app
5. Backend logs only metadata and never returns raw secret material

## Current phase

This folder contains a secure scaffold and integration contract. The exact Krdict endpoint and response mapping should be confirmed against the official API docs before production use.
