from typing import List

from fastapi import FastAPI
from pydantic import BaseModel


app = FastAPI(title="CineMind API", version="0.1.0")


class Movie(BaseModel):
    id: int
    title: str
    year: int
    genres: List[str]
    rating: float


class RecommendationRequest(BaseModel):
    genres: List[str]
    favorites: List[int] = []
    watched: List[int] = []


MOVIES = [
    Movie(id=1, title="Interstellar", year=2014, genres=["Фантастика", "Драма"], rating=8.7),
    Movie(id=2, title="Avengers: Endgame", year=2019, genres=["Marvel", "Бойовик"], rating=8.4),
    Movie(id=3, title="Inception", year=2010, genres=["Фантастика", "Трилер"], rating=8.8),
    Movie(id=4, title="John Wick", year=2014, genres=["Бойовик", "Кримінал"], rating=7.4),
    Movie(id=5, title="Dune", year=2021, genres=["Фантастика", "Пригоди"], rating=8.0),
]


@app.get("/health")
def health():
    return {"status": "ok", "service": "cinemind-api"}


@app.get("/movies", response_model=List[Movie])
def list_movies():
    return MOVIES


@app.post("/recommendations", response_model=List[Movie])
def recommendations(request: RecommendationRequest):
    def score(movie: Movie) -> float:
        genre_score = len(set(movie.genres) & set(request.genres)) * 10
        year_score = 3 if movie.year >= 2018 else 0
        rating_score = movie.rating
        watched_penalty = -8 if movie.id in request.watched else 0
        favorite_bonus = 5 if movie.id in request.favorites else 0
        return genre_score + year_score + rating_score + watched_penalty + favorite_bonus

    return sorted(MOVIES, key=score, reverse=True)
