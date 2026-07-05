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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0E7C7B),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F8F7),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      home: const CineMindRoot(),
    );
  }
}

class Movie {
  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.genres,
    required this.actors,
    required this.description,
    required this.accent,
  });

  final int id;
  final String title;
  final int year;
  final List<String> genres;
  final List<String> actors;
  final String description;
  final Color accent;
}

final List<Movie> initialMovies = [
  Movie(
    id: 1,
    title: 'Interstellar',
    year: 2014,
    genres: ['Фантастика', 'Драма', 'Пригоди'],
    actors: ['Matthew McConaughey', 'Anne Hathaway'],
    description:
        'Подорож крізь космос у пошуках нового дому для людства. Фільм добре підходить тим, хто любить наукову фантастику та емоційні історії.',
    accent: const Color(0xFF155E75),
  ),
  Movie(
    id: 2,
    title: 'Avengers: Endgame',
    year: 2019,
    genres: ['Marvel', 'Бойовик', 'Фантастика'],
    actors: ['Robert Downey Jr.', 'Chris Evans'],
    description:
        'Фінальна битва Месників за майбутнє світу. Рекомендовано фанатам супергероїки, Marvel та масштабних бойовиків.',
    accent: const Color(0xFF7C2D12),
  ),
  Movie(
    id: 3,
    title: 'Inception',
    year: 2010,
    genres: ['Фантастика', 'Трилер', 'Драма'],
    actors: ['Leonardo DiCaprio', 'Tom Hardy'],
    description:
        'Команда проникає у сни людей, щоб змінювати ідеї. Це вибір для користувачів, яким подобаються складні сюжети та напруга.',
    accent: const Color(0xFF4338CA),
  ),
  Movie(
    id: 4,
    title: 'John Wick',
    year: 2014,
    genres: ['Бойовик', 'Кримінал', 'Трилер'],
    actors: ['Keanu Reeves', 'Ian McShane'],
    description:
        'Динамічний бойовик про найманця, який повертається до небезпечного світу. Підійде тим, хто шукає екшн і стильну постановку.',
    accent: const Color(0xFF374151),
  ),
  Movie(
    id: 5,
    title: 'The Martian',
    year: 2015,
    genres: ['Фантастика', 'Пригоди', 'Комедія'],
    actors: ['Matt Damon', 'Jessica Chastain'],
    description:
        'Астронавт намагається вижити на Марсі, використовуючи науку та винахідливість. Гарний варіант для любителів оптимістичної фантастики.',
    accent: const Color(0xFFB45309),
  ),
  Movie(
    id: 6,
    title: 'Spider-Man: No Way Home',
    year: 2021,
    genres: ['Marvel', 'Пригоди', 'Фантастика'],
    actors: ['Tom Holland', 'Zendaya'],
    description:
        'Супергеройська історія про вибір, відповідальність і мультивсесвіт. Підходить фанатам Marvel та пригодницьких фільмів.',
    accent: const Color(0xFFBE123C),
  ),
];

class CineMindRoot extends StatefulWidget {
  const CineMindRoot({super.key});

  @override
  State<CineMindRoot> createState() => _CineMindRootState();
}

class _CineMindRootState extends State<CineMindRoot> {
  bool isSignedIn = false;
  bool preferencesReady = false;
  String userName = 'Іван';
  final Set<String> preferences = {'Фантастика', 'Marvel'};
  final Set<int> favorites = {};
  final Map<int, int> ratings = {};
  final List<Movie> movies = List<Movie>.from(initialMovies);

  void signIn(String name) {
    setState(() {
      userName = name.trim().isEmpty ? 'Користувач' : name.trim();
      isSignedIn = true;
    });
  }

  void savePreferences(Set<String> selected) {
    setState(() {
      preferences
        ..clear()
        ..addAll(selected);
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

  void rateMovie(Movie movie, int rating) {
    setState(() => ratings[movie.id] = rating);
  }

  void addMovie(Movie movie) {
    setState(() => movies.add(movie));
  }

  void deleteMovie(Movie movie) {
    setState(() {
      movies.removeWhere((item) => item.id == movie.id);
      favorites.remove(movie.id);
      ratings.remove(movie.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isSignedIn) {
      return AuthScreen(onSignIn: signIn);
    }

    if (!preferencesReady) {
      return PreferencesScreen(
        initialSelection: preferences,
        onSave: savePreferences,
      );
    }

    return MainShell(
      userName: userName,
      preferences: preferences,
      movies: movies,
      favorites: favorites,
      ratings: ratings,
      onToggleFavorite: toggleFavorite,
      onRate: rateMovie,
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
  bool registerMode = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.movie_filter_rounded,
                    size: 70,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'CineMind',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Персональні рекомендації фільмів за твоїми смаками',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
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
                    selected: {registerMode},
                    onSelectionChanged: (value) {
                      setState(() => registerMode = value.first);
                    },
                  ),
                  const SizedBox(height: 16),
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
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.mail_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => widget.onSignIn(nameController.text),
                    icon: Icon(registerMode ? Icons.check : Icons.login),
                    label: Text(registerMode ? 'Створити профіль' : 'Увійти'),
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
  late final Set<String> selected = Set<String>.from(widget.initialSelection);
  final genres = [
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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Обери жанри та теми',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'CineMind використає ці дані, щоб сформувати персональні рекомендації.',
            ),
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
                    onSelected: (isSelected) {
                      setState(() {
                        isSelected
                            ? selected.add(genre)
                            : selected.remove(genre);
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: selected.isEmpty
                  ? null
                  : () => widget.onSave(selected),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Показати рекомендації'),
            ),
          ],
        ),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.userName,
    required this.preferences,
    required this.movies,
    required this.favorites,
    required this.ratings,
    required this.onToggleFavorite,
    required this.onRate,
    required this.onAddMovie,
    required this.onDeleteMovie,
    required this.onEditPreferences,
  });

  final String userName;
  final Set<String> preferences;
  final List<Movie> movies;
  final Set<int> favorites;
  final Map<int, int> ratings;
  final ValueChanged<Movie> onToggleFavorite;
  final void Function(Movie movie, int rating) onRate;
  final ValueChanged<Movie> onAddMovie;
  final ValueChanged<Movie> onDeleteMovie;
  final VoidCallback onEditPreferences;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        userName: widget.userName,
        preferences: widget.preferences,
        movies: widget.movies,
        favorites: widget.favorites,
        ratings: widget.ratings,
        onToggleFavorite: widget.onToggleFavorite,
        onRate: widget.onRate,
        onEditPreferences: widget.onEditPreferences,
      ),
      FavoritesScreen(
        movies: widget.movies
            .where((movie) => widget.favorites.contains(movie.id))
            .toList(),
        favorites: widget.favorites,
        ratings: widget.ratings,
        onToggleFavorite: widget.onToggleFavorite,
        onRate: widget.onRate,
      ),
      AiAssistantScreen(preferences: widget.preferences, movies: widget.movies),
      AdminScreen(
        movies: widget.movies,
        onAddMovie: widget.onAddMovie,
        onDeleteMovie: widget.onDeleteMovie,
      ),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Головна',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            label: 'Обране',
          ),
          NavigationDestination(
            icon: Icon(Icons.smart_toy_outlined),
            label: 'AI',
          ),
          NavigationDestination(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Адмін',
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
    required this.preferences,
    required this.movies,
    required this.favorites,
    required this.ratings,
    required this.onToggleFavorite,
    required this.onRate,
    required this.onEditPreferences,
  });

  final String userName;
  final Set<String> preferences;
  final List<Movie> movies;
  final Set<int> favorites;
  final Map<int, int> ratings;
  final ValueChanged<Movie> onToggleFavorite;
  final void Function(Movie movie, int rating) onRate;
  final VoidCallback onEditPreferences;

  @override
  Widget build(BuildContext context) {
    final recommended = movies.where((movie) {
      return movie.genres.any(preferences.contains);
    }).toList();
    final popular = movies.where((movie) => movie.year >= 2015).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('CineMind'),
        actions: [
          IconButton(
            tooltip: 'Змінити вподобання',
            onPressed: onEditPreferences,
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeroPanel(userName: userName, preferences: preferences),
          const SizedBox(height: 20),
          _SectionTitle(
            title: 'Персональні рекомендації',
            subtitle: 'Підібрано за твоїми жанрами та темами',
          ),
          const SizedBox(height: 10),
          for (final movie in recommended)
            MovieCard(
              movie: movie,
              isFavorite: favorites.contains(movie.id),
              rating: ratings[movie.id],
              onToggleFavorite: () => onToggleFavorite(movie),
              onOpen: () => _openDetails(context, movie),
            ),
          const SizedBox(height: 14),
          _SectionTitle(
            title: 'Добірка тижня',
            subtitle: 'Фільми, які легко порадити більшості глядачів',
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: popular.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final movie = popular[index];
                return MiniMovieTile(
                  movie: movie,
                  onTap: () => _openDetails(context, movie),
                );
              },
            ),
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
          isFavorite: favorites.contains(movie.id),
          rating: ratings[movie.id],
          onToggleFavorite: () => onToggleFavorite(movie),
          onRate: (rating) => onRate(movie, rating),
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({
    super.key,
    required this.movies,
    required this.favorites,
    required this.ratings,
    required this.onToggleFavorite,
    required this.onRate,
  });

  final List<Movie> movies;
  final Set<int> favorites;
  final Map<int, int> ratings;
  final ValueChanged<Movie> onToggleFavorite;
  final void Function(Movie movie, int rating) onRate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Обране')),
      body: movies.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Тут з’являться фільми, які ти додаси до обраного.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final movie in movies)
                  MovieCard(
                    movie: movie,
                    isFavorite: favorites.contains(movie.id),
                    rating: ratings[movie.id],
                    onToggleFavorite: () => onToggleFavorite(movie),
                    onOpen: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MovieDetailsScreen(
                            movie: movie,
                            isFavorite: favorites.contains(movie.id),
                            rating: ratings[movie.id],
                            onToggleFavorite: () => onToggleFavorite(movie),
                            onRate: (rating) => onRate(movie, rating),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
    );
  }
}

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({
    super.key,
    required this.preferences,
    required this.movies,
  });

  final Set<String> preferences;
  final List<Movie> movies;

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final questionController = TextEditingController(
    text: 'Порадь фільм на вечір',
  );
  String answer =
      'Запитай мене про фільм, жанр або настрій, і я сформую рекомендацію.';

  @override
  void dispose() {
    questionController.dispose();
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
                    'Питання до CineMind AI',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: questionController,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Наприклад: що подивитися після Marvel?',
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _generateAnswer,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Отримати відповідь'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.smart_toy_outlined),
                  const SizedBox(width: 12),
                  Expanded(child: Text(answer)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _generateAnswer() {
    final query = questionController.text.toLowerCase();
    final matched = widget.movies.where((movie) {
      final text = '${movie.title} ${movie.genres.join(' ')}'.toLowerCase();
      return movie.genres.any(widget.preferences.contains) ||
          query
              .split(' ')
              .any((word) => word.length > 3 && text.contains(word));
    }).toList();
    final movie = matched.isEmpty ? widget.movies.first : matched.first;
    setState(() {
      answer =
          'Рекомендую "${movie.title}" (${movie.year}). Він підходить, бо має жанри: ${movie.genres.join(', ')}. '
          'У повній версії AI-сервіс аналізував би твої оцінки, обране, переглянуті фільми та дані з API.';
    });
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
  final titleController = TextEditingController();
  final yearController = TextEditingController();
  final genreController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    yearController.dispose();
    genreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Адмін-панель')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Додати фільм до каталогу',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Назва'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: yearController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Рік'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: genreController,
                    decoration: const InputDecoration(
                      labelText: 'Жанри через кому',
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _addMovie,
                    icon: const Icon(Icons.add),
                    label: const Text('Додати'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Каталог фільмів',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          for (final movie in widget.movies)
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: movie.accent,
                  child: const Icon(Icons.movie, color: Colors.white),
                ),
                title: Text(movie.title),
                subtitle: Text('${movie.year} • ${movie.genres.join(', ')}'),
                trailing: IconButton(
                  tooltip: 'Видалити',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => widget.onDeleteMovie(movie),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _addMovie() {
    final title = titleController.text.trim();
    final year = int.tryParse(yearController.text.trim()) ?? 2026;
    final genres = genreController.text
        .split(',')
        .map((genre) => genre.trim())
        .where((genre) => genre.isNotEmpty)
        .toList();

    if (title.isEmpty || genres.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заповни назву та хоча б один жанр.')),
      );
      return;
    }

    widget.onAddMovie(
      Movie(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        year: year,
        genres: genres,
        actors: const ['Невідомо'],
        description:
            'Новий фільм у каталозі CineMind. У майбутній версії адміністратор зможе додавати постер, опис, акторів та посилання на API.',
        accent: const Color(0xFF0E7C7B),
      ),
    );

    titleController.clear();
    yearController.clear();
    genreController.clear();
  }
}

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({
    super.key,
    required this.movie,
    required this.isFavorite,
    required this.rating,
    required this.onToggleFavorite,
    required this.onRate,
  });

  final Movie movie;
  final bool isFavorite;
  final int? rating;
  final VoidCallback onToggleFavorite;
  final ValueChanged<int> onRate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 210,
            decoration: BoxDecoration(
              color: movie.accent,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.local_movies, color: Colors.white, size: 42),
                const Spacer(),
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '${movie.year} • ${movie.genres.join(', ')}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onToggleFavorite,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  label: Text(isFavorite ? 'В обраному' : 'Додати в обране'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Опис',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(movie.description),
          const SizedBox(height: 18),
          Text(
            'Актори',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final actor in movie.actors) Chip(label: Text(actor)),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Оціни фільм',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var value = 1; value <= 5; value++)
                IconButton(
                  tooltip: '$value',
                  onPressed: () => onRate(value),
                  icon: Icon(
                    value <= (rating ?? 0) ? Icons.star : Icons.star_border,
                    color: const Color(0xFFF59E0B),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.movie,
    required this.isFavorite,
    required this.rating,
    required this.onToggleFavorite,
    required this.onOpen,
  });

  final Movie movie;
  final bool isFavorite;
  final int? rating;
  final VoidCallback onToggleFavorite;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 78,
                height: 104,
                decoration: BoxDecoration(
                  color: movie.accent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.movie, color: Colors.white, size: 36),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('${movie.year} • ${movie.genres.join(', ')}'),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 18,
                          color: Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 4),
                        Text(rating == null ? 'не оцінено' : '$rating / 5'),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: isFavorite ? 'Прибрати з обраного' : 'Додати в обране',
                onPressed: onToggleFavorite,
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MiniMovieTile extends StatelessWidget {
  const MiniMovieTile({super.key, required this.movie, required this.onTap});

  final Movie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: movie.accent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 34,
            ),
            const Spacer(),
            Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${movie.year}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.userName, required this.preferences});

  final String userName;
  final Set<String> preferences;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0E7C7B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Привіт, $userName',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Сьогодні CineMind підбере фільми за твоїми вподобаннями.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final preference in preferences)
                Chip(
                  avatar: Icon(_genreIcon(preference), size: 18),
                  label: Text(preference),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        Text(subtitle),
      ],
    );
  }
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
