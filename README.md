# Event Finder

A Flutter mobile app that helps users discover and explore nearby events such as concerts, meetups, sports, and lifestyle gatherings. Built as the submission for the Event Finder internship assignment.

---

## 1. Screens implemented

Two screens are required; this submission ships **both recommended screens** plus extra polish.

### Home Screen
- Custom rounded search bar with prefix icon, soft shadow, and clear button.
- Section title (`Nearby Events` / `Results for "<query>"`).
- Scrollable list of event cards rendered from API data.
- Pull-to-refresh, loading spinner, error state with retry, empty state, and a dedicated "no results" state for searches.

### Event Detail Screen
- Hero-animated banner image with a fade-in load.
- Title, category chip, date and time row, location row with distance.
- Full description block.
- Sticky bottom **Get Tickets** CTA with a purple-to-pink gradient and shadow.
- Heart toggle in the AppBar that stays in sync with the home list.

---

## 2. Key features

| Area | Detail |
|---|---|
| API integration | `http` GET request, JSON parsed into a typed `Event` model, status-code checking, timeout, typed `HttpException` |
| State management | Single `EventProvider extends ChangeNotifier`, exposed via a tiny `InheritedNotifier` (no extra packages) |
| Favorites | Toggleable on home and detail; persisted across app restarts via `shared_preferences` |
| Search | Live filter on title / category / location, case-insensitive, with a clear button |
| UX | Pull-to-refresh, animated heart (elastic scale + fade), card scale-down on press, ripple effects, Hero image transition, fade-in image load |
| States | Distinct loading / error / empty / no-results UIs |
| Theming | Material 3, deep-purple seed, `#F5F5F5` scaffold, rounded 16-radius cards with elevation |
| Architecture | Clean separation: `models / services / providers / screens / widgets` |

---

## 3. Project structure

```
lib/
 ├── main.dart                       # App root, theme, EventProviderScope
 ├── models/
 │   └── event_model.dart            # Event data model + JSON parsing
 ├── services/
 │   └── api_service.dart            # HTTP client + bundled mock fallback
 ├── providers/
 │   └── event_provider.dart         # ChangeNotifier: events, favorites, search
 ├── screens/
 │   ├── home_screen.dart
 │   └── event_detail_screen.dart
 └── widgets/
     ├── event_card.dart             # Stack-based premium card
     └── search_bar.dart             # Reusable rounded search input
```

---

## 4. API

### Mock endpoint
The app expects a JSON `GET` returning a list of events. To plug in your own Mocky / Beeceptor / JSONPlaceholder URL, edit [lib/services/api_service.dart](lib/services/api_service.dart) and replace `_defaultEventsUrl`:

```dart
static const String _defaultEventsUrl =
    'https://run.mocky.io/v3/REPLACE-WITH-YOUR-MOCKY-ID';
```

While the URL still contains `REPLACE-WITH-YOUR-MOCKY-ID`, the service falls back to a bundled mock dataset (six realistic events) so the app runs end-to-end out of the box.

### Sample JSON shape
```json
[
  {
    "id": "1",
    "title": "Sunset Indie Music Fest",
    "category": "Music",
    "date": "Sat, May 9",
    "time": "6:00 PM",
    "location": "Riverside Amphitheatre",
    "distance": "1.2 km",
    "imageUrl": "https://images.unsplash.com/photo-1459749411175-04bf5292ceea",
    "description": "An open-air evening of indie acts, food trucks, and local art..."
  }
]
```

The full sample payload used by the bundled fallback lives in `_seedJson` inside [lib/services/api_service.dart](lib/services/api_service.dart) — copy it into your Mocky response body verbatim.

---

## 5. Getting started

```bash
flutter pub get
flutter run
```

> **Windows desktop only:** building plugins on Windows needs Developer Mode. Run `start ms-settings:developers` once and toggle it on. Android, iOS, and web are unaffected.

To run the analyzer / tests:
```bash
flutter analyze
flutter test
```

### Download a pre-built APK
A GitHub Actions workflow ([.github/workflows/build-apk.yml](.github/workflows/build-apk.yml)) builds a release APK on every push to `main`/`master` (and on manual trigger).

1. Go to the repo's **Actions** tab.
2. Open the latest successful **Build Android APK** run.
3. Scroll to the **Artifacts** section at the bottom and download `event-finder-apk`.
4. Unzip — `event-finder-<sha>.apk` is inside.

To trigger a build manually without pushing, use **Actions → Build Android APK → Run workflow**.

---

## 6. Dependencies

```yaml
dependencies:
  http: ^1.2.2                    # GET request
  shared_preferences: ^2.5.5      # Persist favorite IDs
```
No state-management packages — `EventProvider` uses Flutter's built-in `ChangeNotifier` + `InheritedNotifier`.

---

## 7. Submission summary (≤150 words)

Implemented the **Home** and **Event Detail** screens of the Event Finder app in Flutter. The home screen fetches events from a mock API via `http`, renders them as Stack-based cards with a gradient overlay, category chip, animated heart, and Hero-tagged image, and supports pull-to-refresh. A live search bar filters by title, category, or location through a centralized `EventProvider` (`ChangeNotifier` exposed via `InheritedNotifier`), which also persists favorites with `shared_preferences`. Tapping a card transitions to a detail screen with a Hero banner, gradient CTA button, and a synced favorite toggle. Loading, error, empty, and no-results states are all handled. Architecture follows clean separation across `models`, `services`, `providers`, `screens`, and `widgets`. The biggest challenge was keeping favorite state consistent across both screens after a refresh — solved by keying on event IDs and merging the stored set onto every new fetch.
