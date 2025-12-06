# Project README

Short: Flutter app for managing courses (list/add/edit/delete) with offline cache and remote sync.

Setup:
- Run `flutter pub get`
- Run `flutter run`

Structure (key folders): `lib/models`, `lib/controller`, `lib/screens`, `lib/repository`, `lib/widgets`.

Notes: score = title.length × lessons (forced even when offline). TODO: add retry queue for failed remote operations.

About / How it works
- The app is offline-first: it loads cached courses from `GetStorage` then tries to fetch remote data and overwrite the cache when available.
- Controllers are implemented with GetX. `DashboardController` holds the master course list and filter logic. `AddEditController` manages the add/edit form.
- Persistence: `lib/repository/course_repository.dart` handles local reads/writes and remote CRUD via `APIManager`.
- Score calculation: computed as `title.length * lessons`. When the device is offline (connectivity check fails) the code ensures the stored score is even by adding 1 when it would be odd.

Screens
- Dashboard: list, search, category filters, pull-to-refresh, empty state, per-item edit/delete.
- Add/Edit: form for title, description, category (dropdown), number of lessons, and save button (shows loading state).
- Profile: shows total points (sum of course scores) and static profile info.

Commands
```bash
flutter pub get
flutter analyze
flutter run
```

API
- The project has been tested with: `https://6931b51011a8738467d031c4.mockapi.io/Courses` (configured via `APIManager` / `config`).

Known limitations / next work
- No persistent retry queue yet for failed remote operations (adds/updates/deletes are attempted once). Consider storing a pending-ops queue in `GetStorage` and retrying on connectivity.
- No undo for deletes (recommend snackbar with Undo).
- Profile persistence and edit flow are TODO.
- No automated tests included; add unit tests for controllers and repository.

Contact
- For quick changes, edit files under `lib/` and run the app. If you want, I can implement the retry queue or add undo-delete behavior next.

