# Unia

Unia is an Android-first Flutter app for building and maintaining a personal university timetable manually. It focuses on the essentials: lessons, exams, notifications, widgets, and an optional AI assistant that can reason over the schedule data you create.

## Highlights

- Manual weekly timetable with recurring lessons
- Manual exams with import/export support
- English and Slovak localization
- Home screen widget updates
- Current lesson and daily briefing notifications
- Optional AI assistant with Gemini, OpenAI, Mistral, or a custom compatible endpoint
- Local-first storage for timetable, exams, settings, and API keys

## Privacy

Unia stores schedule data locally on the device. There is no analytics package and no tracking code in this project.

Network requests are limited to:

- The selected AI provider, only when AI features are configured and used
- GitHub Releases, when update checks are enabled

## Installation

Download the latest APK from:

https://github.com/Kpyruy/Unia/releases

Install it on an Android device, open Unia, and start the manual timetable setup.

## Development

Install Flutter dependencies:

```bash
flutter pub get
```

Run on a connected Android device:

```bash
flutter run
```

Build a debug APK:

```bash
flutter build apk --debug
```

Build a release APK:

```bash
flutter build apk --release
```

## Project Structure

- `lib/main.dart` - app entry point and main UI surfaces
- `lib/l10n.dart` - English and Slovak localization strings
- `lib/screens/onboarding_flow.dart` - onboarding and manual timetable setup
- `lib/screens/main_navigation_screen.dart` - bottom navigation
- `lib/services/manual_schedule_service.dart` - manual timetable persistence and week generation
- `lib/services/background_service.dart` - background refresh, notifications, and update checks
- `lib/services/notification_service.dart` - notification integration and actions
- `lib/services/widget_service.dart` - home screen widget update bridge

## License

This project is released under the MIT License. See [LICENSE](LICENSE).
