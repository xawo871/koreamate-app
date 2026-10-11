# KoreaMate Docker quick start

This project can be run locally with Docker Compose.

## Requirements

- Docker
- Docker Compose

## Start everything

```bash
docker-compose up --build
```

## Stop everything

```bash
docker-compose down
```

## Access the app

- Backend: http://localhost:8000/health
- Flutter Web app: http://localhost:8080

## Notes

- The backend uses a local mock fallback when Krdict credentials are not configured.
- Keep real secrets in `.env` and never commit them to Git.
- The app should still use the backend proxy model in production, even when the provider is eventually connected.
