CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(180) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS movies (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    release_year INTEGER NOT NULL,
    description TEXT,
    rating NUMERIC(3, 1) DEFAULT 0,
    maturity VARCHAR(20) DEFAULT '12+',
    runtime VARCHAR(40) DEFAULT '2h',
    poster_key VARCHAR(80) DEFAULT 'endgame',
    trailer_title VARCHAR(220) DEFAULT '',
    trailer_url TEXT DEFAULT '',
    director VARCHAR(180) DEFAULT '',
    studio VARCHAR(180) DEFAULT '',
    language VARCHAR(80) DEFAULT 'English',
    mood VARCHAR(80) DEFAULT '',
    best_moment TEXT DEFAULT '',
    ai_hook TEXT DEFAULT '',
    source VARCHAR(80) DEFAULT 'PostgreSQL',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS movie_genres (
    movie_id INTEGER REFERENCES movies(id) ON DELETE CASCADE,
    genre VARCHAR(80) NOT NULL,
    PRIMARY KEY (movie_id, genre)
);

CREATE TABLE IF NOT EXISTS movie_actors (
    movie_id INTEGER REFERENCES movies(id) ON DELETE CASCADE,
    actor VARCHAR(120) NOT NULL,
    PRIMARY KEY (movie_id, actor)
);

CREATE TABLE IF NOT EXISTS favorites (
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    movie_id INTEGER REFERENCES movies(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, movie_id)
);

CREATE TABLE IF NOT EXISTS watch_later (
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    movie_id INTEGER REFERENCES movies(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, movie_id)
);

CREATE TABLE IF NOT EXISTS watched_movies (
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    movie_id INTEGER REFERENCES movies(id) ON DELETE CASCADE,
    watched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, movie_id)
);

CREATE TABLE IF NOT EXISTS user_ratings (
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    movie_id INTEGER REFERENCES movies(id) ON DELETE CASCADE,
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, movie_id)
);

CREATE TABLE IF NOT EXISTS movie_comments (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    movie_id INTEGER REFERENCES movies(id) ON DELETE CASCADE,
    text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_movie_comments_user_movie
    ON movie_comments (user_id, movie_id, created_at DESC);

INSERT INTO users (id, name, email) VALUES
    (1, 'Іван', 'ivan@example.com')
ON CONFLICT (id) DO NOTHING;

INSERT INTO movies (
    id, title, release_year, description, rating, maturity, runtime, poster_key,
    trailer_title, trailer_url, director, studio, language, mood, best_moment, ai_hook, source
) VALUES
    (1, 'Interstellar', 2014, 'Космічна історія про пошук нового дому для людства, силу родини та межі науки.', 8.7, '12+', '2h 49m', 'interstellar', 'Interstellar Official Trailer', 'https://www.youtube.com/watch?v=zSWdZVtXT7E', 'Christopher Nolan', 'Paramount Pictures', 'English', 'Епічний', 'Стикування під напругою та емоційний фінал.', 'Підійде, коли хочеться великого кіно з наукою і серцем.', 'PostgreSQL'),
    (2, 'Avengers: Endgame', 2019, 'Фінальна битва Месників за майбутнє світу і масштабна супергеройська пригода.', 8.4, '12+', '3h 1m', 'endgame', 'Avengers: Endgame Official Trailer', 'https://www.youtube.com/watch?v=TcMBFSGVi1c', 'Anthony Russo, Joe Russo', 'Marvel Studios', 'English', 'Динамічний', 'Кульмінаційний збір героїв перед фінальною битвою.', 'Сильний вибір для командного екшену і fan-service моментів.', 'PostgreSQL'),
    (3, 'Inception', 2010, 'Складний трилер про сни, підсвідомість і команду, яка змінює ідеї.', 8.8, '16+', '2h 28m', 'inception', 'Inception Official Trailer', 'https://www.youtube.com/watch?v=YoHD9XEInc0', 'Christopher Nolan', 'Warner Bros.', 'English', 'Напружений', 'Сцена з коридором, що змінює гравітацію.', 'Добре заходить, якщо хочеться думати після титрів.', 'PostgreSQL'),
    (4, 'John Wick', 2014, 'Стильний екшн про найманця, який повертається у кримінальний світ.', 7.4, '18+', '1h 41m', 'john_wick', 'John Wick Official Trailer', 'https://www.youtube.com/watch?v=2AUmvWm5ZDQ', 'Chad Stahelski', 'Lionsgate', 'English', 'Адреналін', 'Перший великий рейд, де стиль задає весь тон франшизи.', 'Для вечора, коли потрібен чистий темп і стиль.', 'PostgreSQL'),
    (5, 'The Martian', 2015, 'Астронавт виживає на Марсі завдяки науці, гумору та винахідливості.', 8.0, '12+', '2h 24m', 'martian', 'The Martian Official Trailer', 'https://www.youtube.com/watch?v=ej3ioOneTy8', 'Ridley Scott', '20th Century Fox', 'English', 'Оптимістичний', 'Герой перетворює проблему виживання на інженерний квест.', 'Підходить, коли хочеться sci-fi без похмурості.', 'PostgreSQL'),
    (6, 'Spider-Man: No Way Home', 2021, 'Супергеройська історія про мультивсесвіт, відповідальність і наслідки рішень.', 8.2, '12+', '2h 28m', 'spiderman', 'Spider-Man: No Way Home Official Trailer', 'https://www.youtube.com/watch?v=JfVOs4VSpmA', 'Jon Watts', 'Marvel Studios', 'English', 'Пригодницький', 'Командний superhero-момент із сильним ностальгійним ударом.', 'Ідеально, якщо хочеться Marvel, але з емоційною ставкою.', 'PostgreSQL'),
    (7, 'Dune', 2021, 'Масштабна фантастика про владу, пустелю, пророцтва та планету Арракіс.', 8.0, '12+', '2h 35m', 'dune', 'Dune Official Trailer', 'https://www.youtube.com/watch?v=n9xhJrPXop4', 'Denis Villeneuve', 'Warner Bros.', 'English', 'Атмосферний', 'Перший контакт з масштабом Арракіса і його правилами.', 'Для вечора з повільним, величним і дуже атмосферним sci-fi.', 'PostgreSQL')
ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    release_year = EXCLUDED.release_year,
    description = EXCLUDED.description,
    rating = EXCLUDED.rating,
    maturity = EXCLUDED.maturity,
    runtime = EXCLUDED.runtime,
    poster_key = EXCLUDED.poster_key,
    trailer_title = EXCLUDED.trailer_title,
    trailer_url = EXCLUDED.trailer_url,
    director = EXCLUDED.director,
    studio = EXCLUDED.studio,
    language = EXCLUDED.language,
    mood = EXCLUDED.mood,
    best_moment = EXCLUDED.best_moment,
    ai_hook = EXCLUDED.ai_hook,
    source = EXCLUDED.source;

INSERT INTO movie_genres (movie_id, genre) VALUES
    (1, 'Фантастика'), (1, 'Драма'), (1, 'Пригоди'),
    (2, 'Marvel'), (2, 'Бойовик'), (2, 'Фантастика'),
    (3, 'Фантастика'), (3, 'Трилер'), (3, 'Драма'),
    (4, 'Бойовик'), (4, 'Кримінал'), (4, 'Трилер'),
    (5, 'Фантастика'), (5, 'Пригоди'), (5, 'Комедія'),
    (6, 'Marvel'), (6, 'Пригоди'), (6, 'Фантастика'),
    (7, 'Фантастика'), (7, 'Драма'), (7, 'Пригоди')
ON CONFLICT DO NOTHING;

INSERT INTO movie_actors (movie_id, actor) VALUES
    (1, 'Matthew McConaughey'), (1, 'Anne Hathaway'),
    (2, 'Robert Downey Jr.'), (2, 'Chris Evans'),
    (3, 'Leonardo DiCaprio'), (3, 'Tom Hardy'),
    (4, 'Keanu Reeves'), (4, 'Ian McShane'),
    (5, 'Matt Damon'), (5, 'Jessica Chastain'),
    (6, 'Tom Holland'), (6, 'Zendaya'),
    (7, 'Timothee Chalamet'), (7, 'Zendaya')
ON CONFLICT DO NOTHING;

SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));
SELECT setval('movies_id_seq', (SELECT MAX(id) FROM movies));
