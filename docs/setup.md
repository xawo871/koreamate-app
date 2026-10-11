# Setup local development

This guide explains how to run KoreaMate locally for Phase 0 and the initial MVP dictionary flow.

## 1. Prerequisites

Before running the project, install:

- Python 3.11+
- Flutter SDK 3.3+
- Git
- A code editor such as VS Code
- Android Studio or Chrome for app testing

## 2. Clone and open the repository

```bash
git clone https://github.com/xawo871/koreamate-app.git
cd koreamate-app
```

## 3. Backend setup

Create a Python virtual environment and install backend dependencies.

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Create a local environment file from the template.

```bash
cp ../.env.example ../.env
```

Edit `.env` and keep the values safe.

For local development without the official Krdict provider configured, the backend will use a secure mock fallback for testing.

```dotenv
APP_ENV=development
APP_PORT=8000
KRDICT_API_KEY=your_key_if_available
KRDICT_BASE_URL=https://your-provider.example.com/krdict
REQUEST_TIMEOUT_SECONDS=15
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080
```

Important:
- Never commit `.env` to Git.
- Do not place API keys in Flutter code.
- Do not push secret values to GitHub.

Start the backend.

```bash
uvicorn app:app --reload --host 0.0.0.0 --port 8000
```

Verify the backend is running:

```bash
curl http://localhost:8000/health
```

Expected result:

```json
{"status":"ok"}
```

## 4. Flutter app setup

Open a second terminal.

```bash
cd apps/mobile
flutter pub get
```

Run the app.

For Chrome:

```bash
flutter run -d chrome
```

For Android emulator/device:

```bash
flutter devices
flutter run -d <device-id>
```

## 5. Test the dictionary flow

Open the app and go to the Kamus tab.

Try searching for:

- 사랑
- 공부
- 한국어

The app calls:

```text
http://localhost:8000/api/dictionary/search?q=사랑
```

If the official Krdict provider is not configured, the backend falls back to a safe local mock dataset for development.

## 6. Troubleshooting

### Backend fails to start

Check:

- Python environment is activated
- dependencies were installed
- `.env` file exists and has valid values

### Flutter cannot connect to backend

Check:

- backend is running on port 8000
- app is pointing to `http://localhost:8000`
- no firewall or local networking issue

### Dictionary results are not official

That is expected in current Phase 0 / MVP testing.
The app is intentionally designed so the real Krdict integration can be swapped in server-side later without changing the client UI.

## 7. Recommended next tasks

- implement onboarding flow
- add home dashboard and progress cards
- add flashcard review flow
- connect real dictionary provider once official API docs are available
- build the backend auth and learning APIs
