import os
from contextlib import contextmanager
from typing import Annotated

import psycopg
from fastapi import Depends, FastAPI, HTTPException, status
from psycopg.rows import dict_row
from pydantic import BaseModel, Field


DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://cinemind:cinemind@localhost:5432/cinemind",
)

app = FastAPI(title="CineMind API", version="0.5.0")


class MovieIn(BaseModel):
    title: str = Field(min_length=1, max_length=200)
    release_year: int = Field(ge=1900, le=2100)
    description: str = ""
    rating: float = Field(default=0, ge=0, le=10)
    maturity: str = "12+"
    runtime: str = "2h"
    poster_key: str = "endgame"
    trailer_title: str = ""
    trailer_url: str = ""
    director: str = ""
    studio: str = ""
    language: str = "English"
    mood: str = ""
    best_moment: str = ""
    ai_hook: str = ""
    source: str = "FastAPI"
    genres: list[str] = Field(default_factory=list)
    actors: list[str] = Field(default_factory=list)


class Movie(MovieIn):
    id: int


class UserIn(BaseModel):
    name: str = Field(min_length=1, max_length=120)
    email: str = Field(min_length=3, max_length=180)


class User(UserIn):
    id: int


class RatingIn(BaseModel):
    rating: int = Field(ge=1, le=5)


class CommentIn(BaseModel):
    text: str = Field(min_length=1, max_length=1000)


class CommentOut(CommentIn):
    id: int
    user_id: int
    movie_id: int
    created_at: str


class RecommendationRequest(BaseModel):
    genres: list[str] = Field(default_factory=list)
    favorites: list[int] = Field(default_factory=list)
    watched: list[int] = Field(default_factory=list)
    limit: int = Field(default=10, ge=1, le=50)


class AiRequest(RecommendationRequest):
    prompt: str = Field(default="", max_length=1000)


class AiResponse(BaseModel):
    answer: str
    confidence: int
    movies: list[Movie]


@contextmanager
def db_connection():
    with psycopg.connect(DATABASE_URL, row_factory=dict_row) as conn:
        yield conn


def get_db():
    with db_connection() as conn:
        yield conn


Db = Annotated[psycopg.Connection, Depends(get_db)]


def movie_from_row(row: dict, genres: list[str], actors: list[str]) -> Movie:
    return Movie(
        id=row["id"],
        title=row["title"],
        release_year=row["release_year"],
        description=row["description"] or "",
        rating=float(row["rating"] or 0),
        maturity=row["maturity"] or "12+",
        runtime=row["runtime"] or "2h",
        poster_key=row["poster_key"] or "endgame",
        trailer_title=row["trailer_title"] or "",
        trailer_url=row["trailer_url"] or "",
        director=row["director"] or "",
        studio=row["studio"] or "",
        language=row["language"] or "English",
        mood=row["mood"] or "",
        best_moment=row["best_moment"] or "",
        ai_hook=row["ai_hook"] or "",
        source=row["source"] or "PostgreSQL",
        genres=genres,
        actors=actors,
    )


def load_movie(conn: psycopg.Connection, movie_id: int) -> Movie:
    row = conn.execute("SELECT * FROM movies WHERE id = %s", (movie_id,)).fetchone()
    if row is None:
        raise HTTPException(status_code=404, detail="Movie not found")
    genres = [
        item["genre"]
        for item in conn.execute(
            "SELECT genre FROM movie_genres WHERE movie_id = %s ORDER BY genre",
            (movie_id,),
        )
    ]
    actors = [
        item["actor"]
        for item in conn.execute(
            "SELECT actor FROM movie_actors WHERE movie_id = %s ORDER BY actor",
            (movie_id,),
        )
    ]
    return movie_from_row(row, genres, actors)


def ensure_user_and_movie(conn: psycopg.Connection, user_id: int, movie_id: int) -> None:
    user_exists = conn.execute("SELECT 1 FROM users WHERE id = %s", (user_id,)).fetchone()
    if user_exists is None:
        raise HTTPException(status_code=404, detail="User not found")
    load_movie(conn, movie_id)


@app.get("/health")
def health(conn: Db):
    try:
        conn.execute("SELECT 1").fetchone()
        return {"status": "ok", "database": "connected"}
    except psycopg.Error as exc:
        raise HTTPException(status_code=503, detail=str(exc)) from exc


@app.get("/movies", response_model=list[Movie])
def list_movies(conn: Db):
    rows = conn.execute("SELECT id FROM movies ORDER BY id").fetchall()
    return [load_movie(conn, row["id"]) for row in rows]


@app.get("/movies/{movie_id}", response_model=Movie)
def get_movie(movie_id: int, conn: Db):
    return load_movie(conn, movie_id)


@app.post("/movies", response_model=Movie, status_code=status.HTTP_201_CREATED)
def create_movie(payload: MovieIn, conn: Db):
    row = conn.execute(
        """
        INSERT INTO movies
            (title, release_year, description, rating, maturity, runtime, poster_key,
             trailer_title, trailer_url, director, studio, language, mood, best_moment, ai_hook, source)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        RETURNING id
        """,
        (
            payload.title,
            payload.release_year,
            payload.description,
            payload.rating,
            payload.maturity,
            payload.runtime,
            payload.poster_key,
            payload.trailer_title,
            payload.trailer_url,
            payload.director,
            payload.studio,
            payload.language,
            payload.mood,
            payload.best_moment,
            payload.ai_hook,
            payload.source,
        ),
    ).fetchone()
    movie_id = row["id"]
    for genre in payload.genres:
        conn.execute(
            "INSERT INTO movie_genres (movie_id, genre) VALUES (%s, %s) ON CONFLICT DO NOTHING",
            (movie_id, genre),
        )
    for actor in payload.actors:
        conn.execute(
            "INSERT INTO movie_actors (movie_id, actor) VALUES (%s, %s) ON CONFLICT DO NOTHING",
            (movie_id, actor),
        )
    conn.commit()
    return load_movie(conn, movie_id)


@app.post("/users", response_model=User, status_code=status.HTTP_201_CREATED)
def upsert_user(payload: UserIn, conn: Db):
    row = conn.execute(
        """
        INSERT INTO users (name, email)
        VALUES (%s, %s)
        ON CONFLICT (email) DO UPDATE SET name = EXCLUDED.name
        RETURNING id, name, email
        """,
        (payload.name, payload.email),
    ).fetchone()
    conn.commit()
    return User(**row)


@app.post("/users/{user_id}/favorites/{movie_id}", status_code=status.HTTP_204_NO_CONTENT)
def add_favorite(user_id: int, movie_id: int, conn: Db):
    ensure_user_and_movie(conn, user_id, movie_id)
    conn.execute(
        "INSERT INTO favorites (user_id, movie_id) VALUES (%s, %s) ON CONFLICT DO NOTHING",
        (user_id, movie_id),
    )
    conn.commit()


@app.post("/users/{user_id}/watch-later/{movie_id}", status_code=status.HTTP_204_NO_CONTENT)
def add_watch_later(user_id: int, movie_id: int, conn: Db):
    ensure_user_and_movie(conn, user_id, movie_id)
    conn.execute(
        "INSERT INTO watch_later (user_id, movie_id) VALUES (%s, %s) ON CONFLICT DO NOTHING",
        (user_id, movie_id),
    )
    conn.commit()


@app.post("/users/{user_id}/watched/{movie_id}", status_code=status.HTTP_204_NO_CONTENT)
def mark_watched(user_id: int, movie_id: int, conn: Db):
    ensure_user_and_movie(conn, user_id, movie_id)
    conn.execute(
        "INSERT INTO watched_movies (user_id, movie_id) VALUES (%s, %s) ON CONFLICT DO NOTHING",
        (user_id, movie_id),
    )
    conn.commit()


@app.put("/users/{user_id}/ratings/{movie_id}", status_code=status.HTTP_204_NO_CONTENT)
def rate_movie(user_id: int, movie_id: int, payload: RatingIn, conn: Db):
    ensure_user_and_movie(conn, user_id, movie_id)
    conn.execute(
        """
        INSERT INTO user_ratings (user_id, movie_id, rating)
        VALUES (%s, %s, %s)
        ON CONFLICT (user_id, movie_id) DO UPDATE SET rating = EXCLUDED.rating
        """,
        (user_id, movie_id, payload.rating),
    )
    conn.commit()


@app.get("/users/{user_id}/comments/{movie_id}", response_model=list[CommentOut])
def list_comments(user_id: int, movie_id: int, conn: Db):
    ensure_user_and_movie(conn, user_id, movie_id)
    rows = conn.execute(
        """
        SELECT id, user_id, movie_id, text, created_at::text AS created_at
        FROM movie_comments
        WHERE user_id = %s AND movie_id = %s
        ORDER BY created_at DESC
        """,
        (user_id, movie_id),
    ).fetchall()
    return [CommentOut(**row) for row in rows]


@app.post(
    "/users/{user_id}/comments/{movie_id}",
    response_model=CommentOut,
    status_code=status.HTTP_201_CREATED,
)
def add_comment(user_id: int, movie_id: int, payload: CommentIn, conn: Db):
    ensure_user_and_movie(conn, user_id, movie_id)
    row = conn.execute(
        """
        INSERT INTO movie_comments (user_id, movie_id, text)
        VALUES (%s, %s, %s)
        RETURNING id, user_id, movie_id, text, created_at::text AS created_at
        """,
        (user_id, movie_id, payload.text),
    ).fetchone()
    conn.execute(
        "INSERT INTO watched_movies (user_id, movie_id) VALUES (%s, %s) ON CONFLICT DO NOTHING",
        (user_id, movie_id),
    )
    conn.commit()
    return CommentOut(**row)


@app.post("/recommendations", response_model=list[Movie])
def recommendations(payload: RecommendationRequest, conn: Db):
    movies = list_movies(conn)

    def score(movie: Movie) -> float:
        genre_score = len(set(movie.genres) & set(payload.genres)) * 18
        year_score = 8 if movie.release_year >= 2018 else 0
        rating_score = movie.rating
        favorite_bonus = 6 if movie.id in payload.favorites else 0
        watched_penalty = -9 if movie.id in payload.watched else 0
        return genre_score + year_score + rating_score + favorite_bonus + watched_penalty

    return sorted(movies, key=score, reverse=True)[: payload.limit]


@app.post("/ai/recommend", response_model=AiResponse)
def ai_recommend(payload: AiRequest, conn: Db):
    picks = recommendations(payload, conn)
    top = picks[:3]
    titles = ", ".join(movie.title for movie in top)
    confidence = 60 if not top else min(99, int(top[0].rating * 10))
    genre_text = ", ".join(payload.genres) if payload.genres else "усі жанри"
    answer = (
        f"CineMind AI рекомендує: {titles}. "
        f"Враховано запит '{payload.prompt}', жанри {genre_text}, "
        "обране, переглянуті фільми та рейтинг у каталозі."
    )
    return AiResponse(answer=answer, confidence=confidence, movies=top)
