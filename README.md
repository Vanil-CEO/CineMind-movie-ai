# CineMind Movie AI

**CineMind** is a Flutter mobile app prototype for personalized movie recommendations.

The app helps users choose films based on their preferences: favorite genres, Marvel/sci-fi/action interests, actors, watched films, favorites, and ratings. The current version is a working educational prototype with local demo data and a simulated AI assistant.

## Project Goal

Create a convenient Android-first mobile application that helps users quickly find interesting movies and receive personal recommendations based on their own tastes.

## Implemented Features

- User registration / login screen.
- Preference selection screen.
- Personalized movie recommendations.
- Movie collections on the home screen.
- Movie details page.
- Favorites.
- Movie rating.
- AI assistant prototype.
- Admin panel for managing the movie catalog.
- Flutter tests and screenshot generation for progress reports.

## Main Roles

- **User**: searches movies, selects preferences, receives recommendations, adds favorites, rates movies.
- **Administrator**: manages the movie catalog.
- **AI / recommendation service**: analyzes user preferences and forms recommendations.
- **API / database**: planned data source for real movie information.

## Project Structure

- `lib/main.dart` - main Flutter application code.
- `test/` - widget tests and report screenshot test.
- `docs/progress/` - daily progress log for 3 weeks.
- `docs/reports/` - weekly report materials and screenshots.
- `outputs/` - generated Word report.

## Weekly Progress

- [3-week plan](docs/progress/three-week-plan.md)
- [Daily progress log](docs/progress/daily-progress.md)
- [Week 3 summary](docs/progress/week-3-summary.md)

## Run Locally

```bash
flutter pub get
flutter run
```

For web preview:

```bash
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 5252
```

## Verification

```bash
flutter analyze
flutter test
```

## Current Status

The project is a working Flutter prototype. The next planned improvements are persistent storage, integration with a real movie API, and replacing the local AI demo logic with an external recommendation or AI service.
