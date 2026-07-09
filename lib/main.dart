import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const CineMindApp());
}

class CineMindApp extends StatelessWidget {
  const CineMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CineMind',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF08090D),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE50914),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
        cardTheme: CardThemeData(
          elevation: 0,
          color: const Color(0xFF151821),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF151821),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const CineMindRoot(),
    );
  }
}

class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.genres,
    required this.actors,
    required this.description,
    required this.source,
    required this.palette,
    required this.tagline,
    required this.maturity,
    required this.runtime,
  });

  final int id;
  final String title;
  final int year;
  final List<String> genres;
  final List<String> actors;
  final String description;
  final String source;
  final List<Color> palette;
  final String tagline;
  final String maturity;
  final String runtime;
}

const moviesSeed = [
  Movie(
    id: 1,
    title: 'Interstellar',
    year: 2014,
    genres: ['Фантастика', 'Драма', 'Пригоди'],
    actors: ['Matthew McConaughey', 'Anne Hathaway'],
    description:
        'Епічна космічна історія про пошук нового дому для людства, силу родини та межі науки.',
    source: 'PostgreSQL demo',
    palette: [Color(0xFF0F172A), Color(0xFF155E75), Color(0xFF38BDF8)],
    tagline: 'Beyond time. Beyond Earth.',
    maturity: '12+',
    runtime: '2h 49m',
  ),
  Movie(
    id: 2,
    title: 'Avengers: Endgame',
    year: 2019,
    genres: ['Marvel', 'Бойовик', 'Фантастика'],
    actors: ['Robert Downey Jr.', 'Chris Evans'],
    description:
        'Фінальна битва Месників за майбутнє світу і один із наймасштабніших супергеройських фільмів.',
    source: 'FastAPI demo',
    palette: [Color(0xFF1E1B4B), Color(0xFF7C2D12), Color(0xFFF97316)],
    tagline: 'Whatever it takes.',
    maturity: '12+',
    runtime: '3h 1m',
  ),
  Movie(
    id: 3,
    title: 'Inception',
    year: 2010,
    genres: ['Фантастика', 'Трилер', 'Драма'],
    actors: ['Leonardo DiCaprio', 'Tom Hardy'],
    description:
        'Складний трилер про сни, підсвідомість і команду, яка змінює ідеї всередині людського розуму.',
    source: 'PostgreSQL demo',
    palette: [Color(0xFF111827), Color(0xFF4338CA), Color(0xFFA78BFA)],
    tagline: 'Your mind is the scene.',
    maturity: '16+',
    runtime: '2h 28m',
  ),
  Movie(
    id: 4,
    title: 'John Wick',
    year: 2014,
    genres: ['Бойовик', 'Кримінал', 'Трилер'],
    actors: ['Keanu Reeves', 'Ian McShane'],
    description:
        'Стильний екшн про найманця, який повертається у небезпечний кримінальний світ.',
    source: 'FastAPI demo',
    palette: [Color(0xFF020617), Color(0xFF374151), Color(0xFF94A3B8)],
    tagline: 'No rules. No mercy.',
    maturity: '18+',
    runtime: '1h 41m',
  ),
  Movie(
    id: 5,
    title: 'The Martian',
    year: 2015,
    genres: ['Фантастика', 'Пригоди', 'Комедія'],
    actors: ['Matt Damon', 'Jessica Chastain'],
    description:
        'Астронавт виживає на Марсі завдяки науці, гумору та винахідливості.',
    source: 'PostgreSQL demo',
    palette: [Color(0xFF431407), Color(0xFFB45309), Color(0xFFFBBF24)],
    tagline: 'Bring him home.',
    maturity: '12+',
    runtime: '2h 24m',
  ),
  Movie(
    id: 6,
    title: 'Spider-Man: No Way Home',
    year: 2021,
    genres: ['Marvel', 'Пригоди', 'Фантастика'],
    actors: ['Tom Holland', 'Zendaya'],
    description:
        'Супергеройська історія про мультивсесвіт, відповідальність і наслідки рішень.',
    source: 'FastAPI demo',
    palette: [Color(0xFF450A0A), Color(0xFFBE123C), Color(0xFF2563EB)],
    tagline: 'The multiverse opens.',
    maturity: '12+',
    runtime: '2h 28m',
  ),
  Movie(
    id: 7,
    title: 'Dune',
    year: 2021,
    genres: ['Фантастика', 'Драма', 'Пригоди'],
    actors: ['Timothee Chalamet', 'Zendaya'],
    description:
        'Політична, масштабна та візуально сильна фантастика про пустельну планету Арракіс.',
    source: 'PostgreSQL demo',
    palette: [Color(0xFF1C1917), Color(0xFF854D0E), Color(0xFFFACC15)],
    tagline: 'Fear is the mind-killer.',
    maturity: '12+',
    runtime: '2h 35m',
  ),
];

class CineMindRoot extends StatefulWidget {
  const CineMindRoot({super.key});

  @override
  State<CineMindRoot> createState() => _CineMindRootState();
}

class _CineMindRootState extends State<CineMindRoot> {
  bool signedIn = false;
  bool preferencesReady = false;
  String userName = 'Іван';
  final movies = List<Movie>.from(moviesSeed);
  final preferences = <String>{'Фантастика', 'Marvel'};
  final favorites = <int>{};
  final watched = <int>{};
  final ratings = <int, int>{};

  void signIn(String name) {
    setState(() {
      userName = name.trim().isEmpty ? 'Користувач' : name.trim();
      signedIn = true;
    });
  }

  void savePreferences(Set<String> value) {
    setState(() {
      preferences
        ..clear()
        ..addAll(value);
      preferencesReady = true;
    });
  }

  void toggleFavorite(Movie movie) {
    setState(() {
      favorites.contains(movie.id)
          ? favorites.remove(movie.id)
          : favorites.add(movie.id);
    });
  }

  void toggleWatched(Movie movie) {
    setState(() {
      watched.contains(movie.id)
          ? watched.remove(movie.id)
          : watched.add(movie.id);
    });
  }

  void rate(Movie movie, int value) {
    setState(() {
      ratings[movie.id] = value;
      watched.add(movie.id);
    });
  }

  void addMovie(Movie movie) {
    setState(() => movies.add(movie));
  }

  void deleteMovie(Movie movie) {
    setState(() {
      movies.removeWhere((item) => item.id == movie.id);
      favorites.remove(movie.id);
      watched.remove(movie.id);
      ratings.remove(movie.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!signedIn) {
      return AuthScreen(onSignIn: signIn);
    }
    if (!preferencesReady) {
      return PreferencesScreen(
        initialSelection: preferences,
        onSave: savePreferences,
      );
    }
    return AppShell(
      userName: userName,
      movies: movies,
      preferences: preferences,
      favorites: favorites,
      watched: watched,
      ratings: ratings,
      onToggleFavorite: toggleFavorite,
      onToggleWatched: toggleWatched,
      onRate: rate,
      onAddMovie: addMovie,
      onDeleteMovie: deleteMovie,
      onEditPreferences: () => setState(() => preferencesReady = false),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.onSignIn});

  final ValueChanged<String> onSignIn;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final nameController = TextEditingController(text: 'Іван');
  final emailController = TextEditingController(text: 'ivan@example.com');
  bool register = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF260307), Color(0xFF08090D)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CineMindLogo(),
                  const SizedBox(height: 28),
                  Text(
                    'Movie AI для твого вечора',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Flutter + FastAPI + PostgreSQL + Content-Based Filtering',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withValues(alpha: .7)),
                  ),
                  const SizedBox(height: 28),
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(
                        value: true,
                        label: Text('Реєстрація'),
                        icon: Icon(Icons.person_add_alt_1),
                      ),
                      ButtonSegment(
                        value: false,
                        label: Text('Вхід'),
                        icon: Icon(Icons.login),
                      ),
                    ],
                    selected: {register},
                    onSelectionChanged: (value) =>
                        setState(() => register = value.first),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Ім’я',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.mail_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => widget.onSignIn(nameController.text),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(register ? 'Створити профіль' : 'Увійти'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CineMindLogo extends StatelessWidget {
  const CineMindLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            color: const Color(0xFFE50914),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x99E50914),
                blurRadius: 36,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.local_movies_rounded,
            size: 42,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'CineMind',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({
    super.key,
    required this.initialSelection,
    required this.onSave,
  });

  final Set<String> initialSelection;
  final ValueChanged<Set<String>> onSave;

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  late final selected = Set<String>.from(widget.initialSelection);
  final genres = const [
    'Фантастика',
    'Бойовик',
    'Marvel',
    'Драма',
    'Пригоди',
    'Трилер',
    'Комедія',
    'Кримінал',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вподобання')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Що тобі подобається?',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text('CineMind використає жанри для Content-Based Filtering.'),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final genre in genres)
                FilterChip(
                  selected: selected.contains(genre),
                  label: Text(genre),
                  avatar: Icon(_genreIcon(genre), size: 18),
                  onSelected: (value) {
                    setState(() {
                      value ? selected.add(genre) : selected.remove(genre);
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 26),
          FilledButton.icon(
            onPressed: selected.isEmpty ? null : () => widget.onSave(selected),
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Увімкнути рекомендації'),
          ),
        ],
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.userName,
    required this.movies,
    required this.preferences,
    required this.favorites,
    required this.watched,
    required this.ratings,
    required this.onToggleFavorite,
    required this.onToggleWatched,
    required this.onRate,
    required this.onAddMovie,
    required this.onDeleteMovie,
    required this.onEditPreferences,
  });

  final String userName;
  final List<Movie> movies;
  final Set<String> preferences;
  final Set<int> favorites;
  final Set<int> watched;
  final Map<int, int> ratings;
  final ValueChanged<Movie> onToggleFavorite;
  final ValueChanged<Movie> onToggleWatched;
  final void Function(Movie movie, int value) onRate;
  final ValueChanged<Movie> onAddMovie;
  final ValueChanged<Movie> onDeleteMovie;
  final VoidCallback onEditPreferences;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        userName: widget.userName,
        movies: widget.movies,
        preferences: widget.preferences,
        favorites: widget.favorites,
        watched: widget.watched,
        ratings: widget.ratings,
        onToggleFavorite: widget.onToggleFavorite,
        onToggleWatched: widget.onToggleWatched,
        onRate: widget.onRate,
      ),
      SearchScreen(
        movies: widget.movies,
        preferences: widget.preferences,
        favorites: widget.favorites,
        watched: widget.watched,
        ratings: widget.ratings,
        onToggleFavorite: widget.onToggleFavorite,
        onToggleWatched: widget.onToggleWatched,
        onRate: widget.onRate,
      ),
      AiScreen(
        movies: widget.movies,
        preferences: widget.preferences,
        watched: widget.watched,
        ratings: widget.ratings,
      ),
      ProfileScreen(
        userName: widget.userName,
        movies: widget.movies,
        preferences: widget.preferences,
        favorites: widget.favorites,
        watched: widget.watched,
        ratings: widget.ratings,
        onEditPreferences: widget.onEditPreferences,
      ),
      AdminScreen(
        movies: widget.movies,
        onAddMovie: widget.onAddMovie,
        onDeleteMovie: widget.onDeleteMovie,
      ),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF0D0F14),
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.auto_awesome), label: 'AI'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(
            icon: Icon(Icons.dashboard_customize),
            label: 'Admin',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.userName,
    required this.movies,
    required this.preferences,
    required this.favorites,
    required this.watched,
    required this.ratings,
    required this.onToggleFavorite,
    required this.onToggleWatched,
    required this.onRate,
  });

  final String userName;
  final List<Movie> movies;
  final Set<String> preferences;
  final Set<int> favorites;
  final Set<int> watched;
  final Map<int, int> ratings;
  final ValueChanged<Movie> onToggleFavorite;
  final ValueChanged<Movie> onToggleWatched;
  final void Function(Movie movie, int value) onRate;

  @override
  Widget build(BuildContext context) {
    final hero = _ranked(movies, preferences, ratings, watched).first;
    final recommended = _ranked(movies, preferences, ratings, watched);
    final marvel = movies
        .where((movie) => movie.genres.contains('Marvel'))
        .toList();
    final sciFi = movies
        .where((movie) => movie.genres.contains('Фантастика'))
        .toList();
    final fresh = movies.where((movie) => movie.year >= 2018).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HeroBanner(
              userName: userName,
              movie: hero,
              score: recommendationScore(hero, preferences, ratings, watched),
              onOpen: () => _openDetails(context, hero),
            ),
          ),
          SliverToBoxAdapter(
            child: PosterRail(
              title: 'Top picks for you',
              movies: recommended,
              preferences: preferences,
              watched: watched,
              ratings: ratings,
              onOpen: (movie) => _openDetails(context, movie),
            ),
          ),
          SliverToBoxAdapter(
            child: PosterRail(
              title: 'Marvel universe',
              movies: marvel,
              preferences: preferences,
              watched: watched,
              ratings: ratings,
              onOpen: (movie) => _openDetails(context, movie),
            ),
          ),
          SliverToBoxAdapter(
            child: PosterRail(
              title: 'Sci-fi mood',
              movies: sciFi,
              preferences: preferences,
              watched: watched,
              ratings: ratings,
              onOpen: (movie) => _openDetails(context, movie),
            ),
          ),
          SliverToBoxAdapter(
            child: PosterRail(
              title: 'Newer titles',
              movies: fresh,
              preferences: preferences,
              watched: watched,
              ratings: ratings,
              onOpen: (movie) => _openDetails(context, movie),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  void _openDetails(BuildContext context, Movie movie) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MovieDetailsScreen(
          movie: movie,
          isFavorite: favorites.contains(movie.id),
          isWatched: watched.contains(movie.id),
          rating: ratings[movie.id],
          onToggleFavorite: () => onToggleFavorite(movie),
          onToggleWatched: () => onToggleWatched(movie),
          onRate: (value) => onRate(movie, value),
        ),
      ),
    );
  }
}

class HeroBanner extends StatelessWidget {
  const HeroBanner({
    super.key,
    required this.userName,
    required this.movie,
    required this.score,
    required this.onOpen,
  });

  final String userName;
  final Movie movie;
  final int score;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 510,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            movie.palette.first,
            movie.palette[1],
            const Color(0xFF08090D),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'CineMind',
                    style: TextStyle(
                      color: Color(0xFFE50914),
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: .14),
                    child: Text(userName.characters.first.toUpperCase()),
                  ),
                ],
              ),
              const Spacer(),
              Center(
                child: Hero(
                  tag: 'poster-${movie.id}',
                  child: PosterArtwork(movie: movie, width: 210, height: 285),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                movie.title,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${movie.year} • ${movie.maturity} • ${movie.runtime} • Match $score%',
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: onOpen,
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Дивитись'),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: onOpen,
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Деталі'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PosterRail extends StatelessWidget {
  const PosterRail({
    super.key,
    required this.title,
    required this.movies,
    required this.preferences,
    required this.watched,
    required this.ratings,
    required this.onOpen,
  });

  final String title;
  final List<Movie> movies;
  final Set<String> preferences;
  final Set<int> watched;
  final Map<int, int> ratings;
  final ValueChanged<Movie> onOpen;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 238,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final movie = movies[index];
                return PosterTile(
                  movie: movie,
                  score: recommendationScore(
                    movie,
                    preferences,
                    ratings,
                    watched,
                  ),
                  onTap: () => onOpen(movie),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PosterTile extends StatefulWidget {
  const PosterTile({
    super.key,
    required this.movie,
    required this.score,
    required this.onTap,
  });

  final Movie movie;
  final int score;
  final VoidCallback onTap;

  @override
  State<PosterTile> createState() => _PosterTileState();
}

class _PosterTileState extends State<PosterTile> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => pressed = true),
      onTapCancel: () => setState(() => pressed = false),
      onTapUp: (_) => setState(() => pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: pressed ? .96 : 1,
        child: SizedBox(
          width: 142,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'poster-${widget.movie.id}',
                child: PosterArtwork(
                  movie: widget.movie,
                  width: 142,
                  height: 188,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.movie.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 3),
              Text(
                '${widget.score}% match',
                style: const TextStyle(color: Color(0xFF22C55E), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PosterArtwork extends StatelessWidget {
  const PosterArtwork({
    super.key,
    required this.movie,
    required this.width,
    required this.height,
  });

  final Movie movie;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: movie.palette[1].withValues(alpha: .45),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: movie.palette,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              right: -26,
              top: -18,
              child: Icon(
                Icons.blur_on,
                color: Colors.white.withValues(alpha: .16),
                size: width * .85,
              ),
            ),
            Positioned(
              left: 14,
              top: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .45),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  movie.maturity,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title.toUpperCase(),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: max(18, width * .13),
                      fontWeight: FontWeight.w900,
                      height: .95,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.tagline,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .78),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.movies,
    required this.preferences,
    required this.favorites,
    required this.watched,
    required this.ratings,
    required this.onToggleFavorite,
    required this.onToggleWatched,
    required this.onRate,
  });

  final List<Movie> movies;
  final Set<String> preferences;
  final Set<int> favorites;
  final Set<int> watched;
  final Map<int, int> ratings;
  final ValueChanged<Movie> onToggleFavorite;
  final ValueChanged<Movie> onToggleWatched;
  final void Function(Movie movie, int value) onRate;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = TextEditingController();
  String genre = 'Усі';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final genres = [
      'Усі',
      ...{for (final movie in widget.movies) ...movie.genres},
    ];
    final query = controller.text.trim().toLowerCase();
    final filtered = widget.movies.where((movie) {
      final text =
          '${movie.title} ${movie.genres.join(' ')} ${movie.actors.join(' ')}'
              .toLowerCase();
      return (query.isEmpty || text.contains(query)) &&
          (genre == 'Усі' || movie.genres.contains(genre));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Пошук')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: controller,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Назва, жанр або актор',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final item in genres)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(item),
                      selected: genre == item,
                      onSelected: (_) => setState(() => genre = item),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          for (final movie in filtered)
            MovieListCard(
              movie: movie,
              isFavorite: widget.favorites.contains(movie.id),
              isWatched: widget.watched.contains(movie.id),
              rating: widget.ratings[movie.id],
              score: recommendationScore(
                movie,
                widget.preferences,
                widget.ratings,
                widget.watched,
              ),
              onOpen: () => _openDetails(context, movie),
              onToggleFavorite: () => widget.onToggleFavorite(movie),
              onToggleWatched: () => widget.onToggleWatched(movie),
            ),
          if (filtered.isEmpty)
            const EmptyState(
              icon: Icons.search_off,
              title: 'Нічого не знайдено',
              text: 'Спробуй інший запит або жанр.',
            ),
        ],
      ),
    );
  }

  void _openDetails(BuildContext context, Movie movie) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MovieDetailsScreen(
          movie: movie,
          isFavorite: widget.favorites.contains(movie.id),
          isWatched: widget.watched.contains(movie.id),
          rating: widget.ratings[movie.id],
          onToggleFavorite: () => widget.onToggleFavorite(movie),
          onToggleWatched: () => widget.onToggleWatched(movie),
          onRate: (value) => widget.onRate(movie, value),
        ),
      ),
    );
  }
}

class MovieListCard extends StatelessWidget {
  const MovieListCard({
    super.key,
    required this.movie,
    required this.isFavorite,
    required this.isWatched,
    required this.rating,
    required this.score,
    required this.onOpen,
    required this.onToggleFavorite,
    required this.onToggleWatched,
  });

  final Movie movie;
  final bool isFavorite;
  final bool isWatched;
  final int? rating;
  final int score;
  final VoidCallback onOpen;
  final VoidCallback onToggleFavorite;
  final VoidCallback onToggleWatched;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              PosterArtwork(movie: movie, width: 76, height: 106),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text('${movie.year} • ${movie.genres.join(', ')}'),
                    const SizedBox(height: 6),
                    Text(
                      '$score% match • ${rating == null ? 'не оцінено' : '$rating/5'}',
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: onToggleFavorite,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                    ),
                  ),
                  IconButton(
                    onPressed: onToggleWatched,
                    icon: Icon(
                      isWatched ? Icons.visibility : Icons.visibility_outlined,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({
    super.key,
    required this.movie,
    required this.isFavorite,
    required this.isWatched,
    required this.rating,
    required this.onToggleFavorite,
    required this.onToggleWatched,
    required this.onRate,
  });

  final Movie movie;
  final bool isFavorite;
  final bool isWatched;
  final int? rating;
  final VoidCallback onToggleFavorite;
  final VoidCallback onToggleWatched;
  final ValueChanged<int> onRate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 430,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [movie.palette[1], const Color(0xFF08090D)],
                  ),
                ),
                child: SafeArea(
                  child: Center(
                    child: Hero(
                      tag: 'poster-${movie.id}',
                      child: PosterArtwork(
                        movie: movie,
                        width: 230,
                        height: 320,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${movie.year} • ${movie.maturity} • ${movie.runtime} • ${movie.source}',
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: onToggleFavorite,
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                          ),
                          label: Text(isFavorite ? 'В обраному' : 'Обране'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onToggleWatched,
                          icon: Icon(
                            isWatched
                                ? Icons.visibility
                                : Icons.visibility_outlined,
                          ),
                          label: Text(isWatched ? 'Переглянуто' : 'Перегляд'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(movie.description),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final genre in movie.genres)
                        Chip(label: Text(genre)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text('Актори', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final actor in movie.actors)
                        Chip(label: Text(actor)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Оцінка користувача',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Row(
                    children: [
                      for (var value = 1; value <= 5; value++)
                        IconButton(
                          onPressed: () => onRate(value),
                          icon: Icon(
                            value <= (rating ?? 0)
                                ? Icons.star
                                : Icons.star_border,
                            color: const Color(0xFFFACC15),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AiScreen extends StatefulWidget {
  const AiScreen({
    super.key,
    required this.movies,
    required this.preferences,
    required this.watched,
    required this.ratings,
  });

  final List<Movie> movies;
  final Set<String> preferences;
  final Set<int> watched;
  final Map<int, int> ratings;

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final controller = TextEditingController(text: 'Що подивитися після Marvel?');
  String answer = 'AI-помічник готовий сформувати добірку.';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI-помічник')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GPT-4o Mini / Gemini 2.5 Flash',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Питання'),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _answer,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Згенерувати рекомендацію'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(answer),
            ),
          ),
          const TechStackCard(),
        ],
      ),
    );
  }

  void _answer() {
    final ranked = _ranked(
      widget.movies,
      widget.preferences,
      widget.ratings,
      widget.watched,
    );
    final top = ranked.take(3).map((movie) => movie.title).join(', ');
    setState(() {
      answer =
          'Рекомендована добірка: $top. Алгоритм Content-Based Filtering врахував жанри, рік, оцінки, обране та переглянуті фільми.';
    });
  }
}

class TechStackCard extends StatelessWidget {
  const TechStackCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Технології',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
            SizedBox(height: 10),
            Text('Flutter • Dart • Python • FastAPI • PostgreSQL'),
            SizedBox(height: 6),
            Text('Content-Based Filtering • GPT-4o Mini • Gemini 2.5 Flash'),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.userName,
    required this.movies,
    required this.preferences,
    required this.favorites,
    required this.watched,
    required this.ratings,
    required this.onEditPreferences,
  });

  final String userName;
  final List<Movie> movies;
  final Set<String> preferences;
  final Set<int> favorites;
  final Set<int> watched;
  final Map<int, int> ratings;
  final VoidCallback onEditPreferences;

  @override
  Widget build(BuildContext context) {
    final avg = ratings.isEmpty
        ? 0
        : ratings.values.reduce((a, b) => a + b) / ratings.length;
    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFFE50914),
                    child: Text(userName.characters.first.toUpperCase()),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(preferences.join(' • ')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.45,
            children: [
              StatCard(
                title: 'Обране',
                value: '${favorites.length}',
                icon: Icons.favorite,
              ),
              StatCard(
                title: 'Переглянуто',
                value: '${watched.length}',
                icon: Icons.visibility,
              ),
              StatCard(
                title: 'Оцінено',
                value: '${ratings.length}',
                icon: Icons.star,
              ),
              StatCard(
                title: 'Середня',
                value: avg.toStringAsFixed(1),
                icon: Icons.analytics,
              ),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onEditPreferences,
            icon: const Icon(Icons.tune),
            label: const Text('Редагувати вподобання'),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFFE50914)),
            const Spacer(),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}

class AdminScreen extends StatefulWidget {
  const AdminScreen({
    super.key,
    required this.movies,
    required this.onAddMovie,
    required this.onDeleteMovie,
  });

  final List<Movie> movies;
  final ValueChanged<Movie> onAddMovie;
  final ValueChanged<Movie> onDeleteMovie;

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final title = TextEditingController();
  final year = TextEditingController();
  final genres = TextEditingController();

  @override
  void dispose() {
    title.dispose();
    year.dispose();
    genres.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: title,
                    decoration: const InputDecoration(labelText: 'Назва'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: year,
                    decoration: const InputDecoration(labelText: 'Рік'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: genres,
                    decoration: const InputDecoration(
                      labelText: 'Жанри через кому',
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _add,
                    icon: const Icon(Icons.add),
                    label: const Text('Додати'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          for (final movie in widget.movies)
            MovieListCard(
              movie: movie,
              isFavorite: false,
              isWatched: false,
              rating: null,
              score: 0,
              onOpen: () {},
              onToggleFavorite: () {},
              onToggleWatched: () => widget.onDeleteMovie(movie),
            ),
        ],
      ),
    );
  }

  void _add() {
    final movieTitle = title.text.trim();
    final movieGenres = genres.text
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
    if (movieTitle.isEmpty || movieGenres.isEmpty) return;
    widget.onAddMovie(
      Movie(
        id: DateTime.now().millisecondsSinceEpoch,
        title: movieTitle,
        year: int.tryParse(year.text.trim()) ?? 2026,
        genres: movieGenres,
        actors: const ['Admin'],
        description: 'Фільм додано адміністратором через Flutter-клієнт.',
        source: 'FastAPI admin demo',
        palette: const [
          Color(0xFF111827),
          Color(0xFFE50914),
          Color(0xFFF97316),
        ],
        tagline: 'Added by admin.',
        maturity: '12+',
        runtime: '2h',
      ),
    );
    title.clear();
    year.clear();
    genres.clear();
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(icon, size: 54, color: const Color(0xFFE50914)),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(text, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

List<Movie> _ranked(
  List<Movie> movies,
  Set<String> preferences,
  Map<int, int> ratings,
  Set<int> watched,
) {
  return [...movies]..sort(
    (a, b) => recommendationScore(
      b,
      preferences,
      ratings,
      watched,
    ).compareTo(recommendationScore(a, preferences, ratings, watched)),
  );
}

int recommendationScore(
  Movie movie,
  Set<String> preferences,
  Map<int, int> ratings,
  Set<int> watched,
) {
  var score = 48;
  score += movie.genres.where(preferences.contains).length * 17;
  score += movie.year >= 2018 ? 8 : 0;
  score += movie.source.contains('FastAPI') ? 4 : 0;
  score += ratings[movie.id] != null ? ratings[movie.id]! * 3 : 0;
  score -= watched.contains(movie.id) ? 10 : 0;
  return score.clamp(0, 99);
}

IconData _genreIcon(String genre) {
  return switch (genre) {
    'Фантастика' => Icons.rocket_launch_outlined,
    'Бойовик' => Icons.flash_on_outlined,
    'Marvel' => Icons.shield_outlined,
    'Драма' => Icons.theater_comedy_outlined,
    'Пригоди' => Icons.explore_outlined,
    'Трилер' => Icons.visibility_outlined,
    'Комедія' => Icons.sentiment_very_satisfied,
    'Кримінал' => Icons.manage_search,
    _ => Icons.local_movies_outlined,
  };
}
