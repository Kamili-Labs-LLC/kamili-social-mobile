# Kamili Social Mobile

Flutter mobile app (iOS + Android) for the Kamili Social platform.

## Tech Stack
- **Flutter 3.41.6** (Dart 3.11.4)
- **State Management**: Riverpod (flutter_riverpod)
- **Navigation**: go_router
- **GraphQL**: graphql_flutter (connects to existing backend at kamili-social)
- **Auth**: JWT with flutter_secure_storage
- **CI/CD**: GitHub Actions + Fastlane

## Project Structure
- `lib/config/` — Theme (KamiliColors), environment config, constants
- `lib/graphql/` — GraphQL client, queries, mutations (ported from web frontend)
- `lib/models/` — Dart model classes matching backend GraphQL types
- `lib/providers/` — Riverpod state providers
- `lib/services/` — Auth, media upload, AI generation (REST services)
- `lib/screens/` — All app screens organized by feature
- `lib/widgets/` — Reusable widget library (KamiliButton, KamiliTextField, PostCard, etc.)
- `lib/router/` — GoRouter config with auth redirect
- `scripts/build.sh` — Build utility with version bumping
- `.github/workflows/` — CI/CD for develop (internal testing) and production

## Key Commands
```bash
flutter pub get          # Install dependencies
flutter analyze          # Check for errors
flutter test             # Run tests
flutter run              # Run on connected device/emulator
./scripts/build.sh --help  # Build utility usage
```

## Bundle ID
- Android: `com.kamililabs.kamili_social`
- iOS: `com.kamililabs.kamiliSocial`

## Backend
The app connects to the GraphQL API at the kamili-social backend (same API the web app uses).
Media uploads and AI generation use REST endpoints (not GraphQL).

## Branding Colors
- Primary: #2088C6 | Dark: #1A6FA3 | Accent: #5BADD6
- CTA Red: #E03035 | Background: #FAFBFC | Text: #1D2327
