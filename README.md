# ✈️ Flight App

[![CI](https://github.com/m4aram/flight_app/actions/workflows/ci.yml/badge.svg)](https://github.com/m4aram/flight_app/actions/workflows/ci.yml)

A flight and hotel booking app built with **Flutter**, following **Clean Architecture** and **Bloc**.
Login and sign up use a real backend (**Supabase**). The project has **47 automated tests** that run on every push.

## 📱 Screenshots

| Splash | Home | Flight Search | Login |
|---|---|---|---|
| <img src="docs/screenshots/splash.png" width="200"> | <img src="docs/screenshots/home.png" width="200"> | <img src="docs/screenshots/flight_search.png" width="200"> | <img src="docs/screenshots/login.png" width="200"> |

## ✨ Features

- Animated splash screen (plane flies left, clouds come down)
- Flight search: one way, round trip and multi-city
- Passengers picker with real rules (max 9 seats, infants ≤ adults)
- Hotel search, explore destinations and travel stories
- Sign up / login / forgot password with **Supabase Auth**
- Personal info, travel documents and preferred payment types

## 🏗️ Architecture

Feature-first folders, each feature split into three layers:

```
lib/
├── core/                 # shared: DI, router, network, errors, theme, widgets
└── features/
    └── auth/
        ├── presentation/ # pages + Blocs (UI state)
        ├── domain/       # entities, use cases, repository interfaces (pure Dart)
        └── data/         # repository implementations, data sources (Supabase, storage)
```

```
UI → Bloc → Use case → Repository (interface) → Data source → Supabase
```

- The **domain** layer does not depend on Flutter, Supabase or any package.
- Swapping the fake backend for Supabase changed **one file + one line** in DI, and all tests still passed.
- Errors flow as `Exception` (data) → `Failure` (domain) → message on screen, using a `Result` type.

## 🧰 Tech stack

| Purpose | Package |
|---|---|
| State management | `flutter_bloc`, `equatable` |
| Dependency injection | `get_it` |
| Navigation | `go_router` |
| Backend / Auth | `supabase_flutter` |
| HTTP client | `dio` (with auth interceptor and error mapper) |
| Secure storage | `flutter_secure_storage` |
| Testing | `flutter_test`, `mocktail`, `bloc_test` |

## 🧪 Testing

```bash
flutter test --coverage
```

**47 tests** across all layers:

| Layer | Examples |
|---|---|
| Unit (domain) | email validator, passenger rules, flight search validation, passport masking |
| Unit (data) | repository maps `AuthException` → `AuthFailure` and never saves a session on failure; Dio error mapper (401, 500, timeout) |
| Bloc | `LoginBloc`: submitting → success (password cleared from memory) / failure / empty form |
| Widget | login errors, password visibility toggle, server error message, passengers counter |

A real bug was found by tests: the email validator accepted `manar..ali@gmail.com`. It was fixed with a test first.

## 🔐 Security

Reviewed against the **OWASP Mobile Top 10 (2024)**:

- Token and passport stored in `flutter_secure_storage`, never `SharedPreferences` (M9)
- Only the Supabase **publishable** key is in the app, never the secret key (M1)
- Input validation, and deep link query parameters are validated in the router (M4)
- HTTPS only (M5)
- Password hidden from logs (`toString`) and cleared from memory after login; passport number masked on screen (M6)
- Same message for wrong email or wrong password, and forgot-password never reveals if an email exists (M3)

## ⚡ Performance

- `context.select` instead of `context.watch`, so widgets rebuild only for the data they use
- `const` widgets wherever possible
- Images decoded at their display size with `cacheWidth`

## 🚀 Getting started

```bash
git clone https://github.com/m4aram/flight_app.git
cd flight_app
flutter pub get
flutter run
```

Built with Flutter 3.47.7.

## 🤖 CI

GitHub Actions runs `flutter analyze` and `flutter test` on every push and pull request.