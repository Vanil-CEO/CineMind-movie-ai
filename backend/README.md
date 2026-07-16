# CineMind Backend

FastAPI + PostgreSQL backend for CineMind.

## Technologies

- Python
- FastAPI
- PostgreSQL
- psycopg
- Content-Based Filtering

## Start PostgreSQL

```bash
cd backend
docker compose up -d
```

`schema.sql` creates tables and seed data automatically on first container start.

## Run API

```bash
cd backend
pip install -r requirements.txt
set DATABASE_URL=postgresql://cinemind:cinemind@localhost:5432/cinemind
uvicorn main:app --reload
```

## Endpoints

- `GET /health`
- `GET /movies`
- `GET /movies/{movie_id}`
- `POST /movies`
- `POST /users`
- `POST /users/{user_id}/favorites/{movie_id}`
- `POST /users/{user_id}/watch-later/{movie_id}`
- `POST /users/{user_id}/watched/{movie_id}`
- `PUT /users/{user_id}/ratings/{movie_id}`
- `GET /users/{user_id}/comments/{movie_id}`
- `POST /users/{user_id}/comments/{movie_id}`
- `POST /recommendations`
- `POST /ai/recommend`

## Example Recommendation Request

```json
{
  "prompt": "Що подивитися після Marvel?",
  "genres": ["Фантастика", "Marvel"],
  "favorites": [2],
  "watched": [1],
  "limit": 5
}
```

## Example Comment Request

```json
{
  "text": "Сильний фінал, хочу більше sci-fi з емоційною історією."
}
```
