# CineMind Backend

FastAPI backend prototype for CineMind.

## Technologies

- Python
- FastAPI
- PostgreSQL
- Content-Based Filtering

## Run

```bash
pip install -r requirements.txt
uvicorn main:app --reload
```

## Endpoints

- `GET /health`
- `GET /movies`
- `POST /recommendations`

The current Flutter client uses local demo data with the same structure, so the application works without a running server while the backend is being prepared.
