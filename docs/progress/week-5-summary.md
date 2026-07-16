# Week 5 Summary

## Main Progress

- Restored the project after the first week 5 visual attempt.
- Rebuilt the interface around a cleaner streaming-style design inspired by modern video platforms, without directly copying a specific product.
- Fixed Ukrainian UI text.
- Reworked the visual system with a teal/jade accent palette, warmer supporting colors, cleaner dark surfaces, and more consistent Material icons.
- Replaced poster artwork with minimalist gradient posters inspired by the provided reference: maturity badges, dotted pattern, large titles, and taglines.
- Rebuilt taste selection as preset-based taste cards instead of simple genre chips.
- Added trailer data for every movie, trailer panels, trailer modal sheets, and richer movie profile details.
- Added a stronger hero header, match-score labels, horizontal recommendation rails, search, lists, AI recommendations, profile statistics, watch-later flow, and refined movie details screen.
- Configured a FastAPI backend for PostgreSQL with seed movies, users, favorites, watch-later, watched movies, ratings, and recommendation endpoints.
- Added an AI recommendation service in Flutter and `/ai/recommend` endpoint in FastAPI.

## Technologies Used

Flutter, Dart, Material 3, Hero, AnimatedScale, Image.asset, Material Icons, Content-Based Filtering, Python, Pillow, FastAPI, PostgreSQL, psycopg, Docker Compose, AI Recommendation Service, GPT-4o Mini, Gemini 2.5 Flash, Flutter Test.

## Verification

- `flutter analyze`
- `flutter test`
- `python -m py_compile backend/main.py`

Both checks passed.
