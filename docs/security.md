# Security notes

KoreaMate must treat secrets as server-side assets only.

## Required rules

- Never place API keys in Flutter source files.
- Never commit `.env` files to Git.
- Never expose dictionary, AI, or payment keys to browser clients.
- Use environment variables or a secret manager in production.
- Keep backend-only endpoints for sensitive services.

## Krdict key handling

The Krdict API key must be kept in the backend environment only.
The device app must call a backend endpoint such as:

```text
GET /api/dictionary/search?q=사랑
```

The backend then calls the official provider using the server-side secret.

## Local development guidance

Use a local `.env` file that is excluded from Git.

```bash
cp .env.example .env
```

If a value is not yet available, leave it unset and allow mock fallback for development.

## Production guidance

Use a proper secret manager or host-level environment configuration such as:

- GitHub Actions secrets
- environment variables in the deploy host
- secret manager from the cloud provider
- Docker/Kubernetes secret injection

Never ship client-side secrets in APK, browser builds, or public repositories.
