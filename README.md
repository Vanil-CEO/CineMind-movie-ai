# CineMind Movie AI

**CineMind** is a Netflix-style Flutter mobile app prototype for personalized movie recommendations.

The project uses the technology stack selected in the practice report: **Flutter**, **Dart**, **Python**, **FastAPI**, **PostgreSQL**, **Content-Based Filtering**, and an AI assistant concept based on **GPT-4o Mini** or **Gemini 2.5 Flash**.

## Current App Design

- Dark Netflix-inspired interface.
- Large hero banner.
- Poster-style movie cards.
- Horizontal movie collections.
- Animated poster press effects.
- Search by title, genre, or actor.
- Favorites, watched movies, and user ratings.
- Content-Based Filtering match percentage.
- AI assistant screen.
- User profile with statistics.
- Admin screen for catalog changes.

## Project Goal

Create a convenient Android-first mobile application that helps users quickly find interesting movies and receive personal recommendations based on their own tastes.

## Technology Stack

- **Frontend:** Flutter, Dart.
- **Backend prototype:** Python, FastAPI.
- **Database schema:** PostgreSQL.
- **Recommendation algorithm:** Content-Based Filtering.
- **AI assistant concept:** GPT-4o Mini / Gemini 2.5 Flash.

## Project Structure

- `lib/main.dart` - Flutter client.
- `backend/` - FastAPI backend prototype and PostgreSQL schema.
- `test/` - Flutter widget tests.
- `docs/progress/` - daily progress documentation.
- `docs/reports/` - weekly reports and screenshots.

## Run Flutter App

```bash
flutter pub get
flutter run
```

For web preview:

```bash
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 5254
```

## Run Backend Prototype

```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --reload
```

## Verification

```bash
flutter analyze
flutter test
```

## Progress

- [3-week plan](docs/progress/three-week-plan.md)
- [Daily progress log](docs/progress/daily-progress.md)
- [Week 3 summary](docs/progress/week-3-summary.md)

## GitHub

Repository: https://github.com/Vanil-CEO/CineMind-movie-ai
