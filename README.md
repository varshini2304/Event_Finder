# Event Finder App

A Flutter app that fetches and displays events from a mock API.

## Setup

1. Create your mock endpoint on Mocky using the JSON provided.
2. Copy the generated URL.
3. Open `lib/services/api_service.dart` and replace:
   `https://run.mocky.io/v3/REPLACE-WITH-YOUR-MOCKY-ID`
   with your generated Mocky URL.
4. Run:
   - `flutter pub get`
   - `flutter run`

## Architecture

```text
lib/
 +-- main.dart
 +-- models/
 ¦     +-- event_model.dart
 +-- services/
 ¦     +-- api_service.dart
 +-- screens/
 ¦     +-- home_screen.dart
 ¦     +-- event_detail_screen.dart
 +-- widgets/
 ¦     +-- event_card.dart
```

Writing