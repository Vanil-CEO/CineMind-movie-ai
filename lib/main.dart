import 'package:flutter/material.dart';

import 'platform_link_stub.dart'
    if (dart.library.html) 'platform_link_web.dart';

void main() => runApp(const CineMindApp());

abstract final class AppColors {
  static const ink = Color(0xFF000000);
  static const inkSoft = Color(0xFF0B0B0F);
  static const panel = Color(0xFF1C1C1E);
  static const panelHigh = Color(0xFF2C2C2E);
  static const jade = Color(0xFF30D158);
  static const coral = Color(0xFFFF453A);
  static const amber = Color(0xFFFFD60A);
  static const violet = Color(0xFFBF5AF2);
  static const blue = Color(0xFF0A84FF);
  static const mint = Color(0xFF66D4CF);
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
        scaffoldBackgroundColor: AppColors.ink,
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: AppColors.blue,
              brightness: Brightness.dark,
            ).copyWith(
              primary: AppColors.blue,
              secondary: AppColors.coral,
              tertiary: AppColors.amber,
              surface: AppColors.panel,
              surfaceContainerHighest: AppColors.panelHigh,
            ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: AppColors.panel,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.panelHigh.withValues(alpha: .74),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: AppColors.blue, width: 1.4),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            foregroundColor: AppColors.ink,
            backgroundColor: AppColors.blue,
            minimumSize: const Size(48, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.inkSoft.withValues(alpha: .92),
          indicatorColor: AppColors.blue.withValues(alpha: .22),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              fontSize: 12,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w800
                  : FontWeight.w600,
            ),
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
    required this.poster,
    required this.palette,
    required this.tagline,
    required this.maturity,
    required this.runtime,
    required this.mood,
    required this.mark,
    required this.trailerTitle,
    required this.trailerUrl,
    required this.director,
    required this.studio,
    required this.language,
    required this.vibeTags,
    required this.facts,
    required this.bestMoment,
    required this.aiHook,
  });

  final int id;
  final String title;
  final int year;
  final List<String> genres;
  final List<String> actors;
  final String description;
  final String poster;
  final List<Color> palette;
  final String tagline;
  final String maturity;
  final String runtime;
  final String mood;
  final String mark;
  final String trailerTitle;
  final String trailerUrl;
  final String director;
  final String studio;
  final String language;
  final List<String> vibeTags;
  final List<String> facts;
  final String bestMoment;
  final String aiHook;
}

class TasteOption {
  const TasteOption({
    required this.genre,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String genre;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

class AiReply {
  const AiReply({
    required this.answer,
    required this.movies,
    required this.confidence,
  });

  final String answer;
  final List<Movie> movies;
  final int confidence;
}

class CineMindAiService {
  const CineMindAiService();

  Future<AiReply> generate({
    required String prompt,
    required List<Movie> movies,
    required Set<String> preferences,
    required Set<int> watched,
    required Map<int, int> ratings,
    required Map<int, List<String>> comments,
    required String userName,
    required String profileBio,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 520));
    final query = prompt.toLowerCase();
    final ranked = _ranked(movies, preferences, ratings, watched);
    final directMatches = ranked.where((movie) {
      final haystack =
          '${movie.title} ${movie.genres.join(' ')} ${movie.actors.join(' ')} ${movie.vibeTags.join(' ')} ${movie.mood}'
              .toLowerCase();
      return query
          .split(RegExp(r'\s+'))
          .where((word) => word.length > 2)
          .any(haystack.contains);
    }).toList();
    final picks = (directMatches.isEmpty ? ranked : directMatches)
        .take(3)
        .toList();
    final titles = picks.map((movie) => movie.title).join(', ');
    String movieTitleById(int id) {
      for (final movie in movies) {
        if (movie.id == id) return movie.title;
      }
      return '';
    }

    final commentText = comments.values
        .expand((items) => items)
        .take(3)
        .join(' | ');
    final liked = ratings.entries
        .where((entry) => entry.value >= 4)
        .map((entry) => movieTitleById(entry.key))
        .where((title) => title.isNotEmpty)
        .join(', ');
    final avoided = ratings.entries
        .where((entry) => entry.value <= 2)
        .map((entry) => movieTitleById(entry.key))
        .where((title) => title.isNotEmpty)
        .join(', ');
    final reasons = picks
        .map(
          (movie) =>
              '${movie.title}: ${recommendationReason(movie, preferences)}',
        )
        .join('\n');
    final confidence = picks.isEmpty
        ? 60
        : recommendationScore(picks.first, preferences, ratings, watched);
    return AiReply(
      confidence: confidence,
      movies: picks,
      answer:
          '$userName, я б зараз зібрав добірку: $titles.\n\n$reasons\n\nПрофіль: $profileBio.\nУлюблене за оцінками: ${liked.isEmpty ? 'ще формується' : liked}.\nКраще не тиснути на: ${avoided.isEmpty ? 'немає явних анти-вподобань' : avoided}.\nКоментарі, які AI врахував: ${commentText.isEmpty ? 'поки немає коментарів' : commentText}.\n\nВідповідь перебудовується після нових зірочок, коментарів, переглядів і vibe-тегів, тому агент більше не поводиться як статична заготовка.',
    );
  }
}

const tasteOptions = [
  TasteOption(
    genre: 'Фантастика',
    title: 'Sci-fi вау-ефект',
    subtitle: 'космос, майбутнє, великі ідеї',
    icon: Icons.rocket_launch_rounded,
    color: Color(0xFF38BDF8),
  ),
  TasteOption(
    genre: 'Marvel',
    title: 'Marvel universe',
    subtitle: 'супергерої, командні арки',
    icon: Icons.shield_rounded,
    color: Color(0xFFE11D48),
  ),
  TasteOption(
    genre: 'Бойовик',
    title: 'Адреналін',
    subtitle: 'бійки, переслідування, темп',
    icon: Icons.bolt_rounded,
    color: Color(0xFFFF6B6B),
  ),
  TasteOption(
    genre: 'Драма',
    title: 'Сильна історія',
    subtitle: 'емоції, персонажі, вибір',
    icon: Icons.theater_comedy_rounded,
    color: Color(0xFFFFC857),
  ),
  TasteOption(
    genre: 'Пригоди',
    title: 'Велика подорож',
    subtitle: 'світи, відкриття, ризик',
    icon: Icons.explore_rounded,
    color: Color(0xFF2DD4BF),
  ),
  TasteOption(
    genre: 'Трилер',
    title: 'Напруга',
    subtitle: 'таємниці, ризик, інтрига',
    icon: Icons.visibility_rounded,
    color: Color(0xFF8B5CF6),
  ),
  TasteOption(
    genre: 'Комедія',
    title: 'Легший вайб',
    subtitle: 'іронія, розрядка, тепло',
    icon: Icons.sentiment_satisfied_alt_rounded,
    color: Color(0xFFF97316),
  ),
  TasteOption(
    genre: 'Кримінал',
    title: 'Темний стиль',
    subtitle: 'правила вулиць, антагоністи',
    icon: Icons.manage_search_rounded,
    color: Color(0xFF94A3B8),
  ),
];

const moviesSeed = [
  Movie(
    id: 1,
    title: 'Interstellar',
    year: 2014,
    genres: ['Фантастика', 'Драма', 'Пригоди'],
    actors: ['Matthew McConaughey', 'Anne Hathaway'],
    description:
        'Космічна історія про пошук нового дому для людства, силу родини та межі науки.',
    poster: 'assets/posters/interstellar.png',
    palette: [Color(0xFF08111F), Color(0xFF0F766E), Color(0xFF38BDF8)],
    tagline: 'Beyond time. Beyond Earth.',
    maturity: '12+',
    runtime: '2h 49m',
    mood: 'Епічний',
    mark: 'IN',
    trailerTitle: 'Interstellar Official Trailer',
    trailerUrl: 'https://www.youtube.com/watch?v=zSWdZVtXT7E',
    director: 'Christopher Nolan',
    studio: 'Paramount Pictures',
    language: 'English',
    vibeTags: ['космос', 'родина', 'наука', 'епік'],
    facts: [
      'Практичні декорації кораблів',
      'Саундтрек Hans Zimmer',
      'Консультації з фізики чорних дір',
    ],
    bestMoment: 'Стикування під напругою та емоційний фінал.',
    aiHook: 'Підійде, коли хочеться великого кіно з наукою і серцем.',
  ),
  Movie(
    id: 2,
    title: 'Avengers: Endgame',
    year: 2019,
    genres: ['Marvel', 'Бойовик', 'Фантастика'],
    actors: ['Robert Downey Jr.', 'Chris Evans'],
    description:
        'Фінальна битва Месників за майбутнє світу і масштабна супергеройська пригода.',
    poster: 'assets/posters/endgame.png',
    palette: [Color(0xFF1E1B4B), Color(0xFFBE123C), Color(0xFFF97316)],
    tagline: 'Whatever it takes.',
    maturity: '12+',
    runtime: '3h 1m',
    mood: 'Динамічний',
    mark: 'AE',
    trailerTitle: 'Avengers: Endgame Official Trailer',
    trailerUrl: 'https://www.youtube.com/watch?v=TcMBFSGVi1c',
    director: 'Anthony Russo, Joe Russo',
    studio: 'Marvel Studios',
    language: 'English',
    vibeTags: ['команда', 'фінал', 'герої', 'битва'],
    facts: [
      'Фінал великої MCU арки',
      'Кросовер десятків героїв',
      'Один з найкасовіших фільмів',
    ],
    bestMoment: 'Кульмінаційний збір героїв перед фінальною битвою.',
    aiHook: 'Сильний вибір для командного екшену і fan-service моментів.',
  ),
  Movie(
    id: 3,
    title: 'Inception',
    year: 2010,
    genres: ['Фантастика', 'Трилер', 'Драма'],
    actors: ['Leonardo DiCaprio', 'Tom Hardy'],
    description:
        'Складний трилер про сни, підсвідомість і команду, яка змінює ідеї.',
    poster: 'assets/posters/inception.png',
    palette: [Color(0xFF111827), Color(0xFF4F46E5), Color(0xFF8B5CF6)],
    tagline: 'Your mind is the scene.',
    maturity: '16+',
    runtime: '2h 28m',
    mood: 'Напружений',
    mark: 'IC',
    trailerTitle: 'Inception Official Trailer',
    trailerUrl: 'https://www.youtube.com/watch?v=YoHD9XEInc0',
    director: 'Christopher Nolan',
    studio: 'Warner Bros.',
    language: 'English',
    vibeTags: ['сни', 'психологія', 'пограбування', 'лабіринт'],
    facts: [
      'Багаторівнева структура снів',
      'Практичні трюки у коридорі',
      'Культовий відкритий фінал',
    ],
    bestMoment: 'Сцена з коридором, що змінює гравітацію.',
    aiHook: 'Добре заходить, якщо хочеться думати після титрів.',
  ),
  Movie(
    id: 4,
    title: 'John Wick',
    year: 2014,
    genres: ['Бойовик', 'Кримінал', 'Трилер'],
    actors: ['Keanu Reeves', 'Ian McShane'],
    description:
        'Стильний екшн про найманця, який повертається у кримінальний світ.',
    poster: 'assets/posters/john_wick.png',
    palette: [Color(0xFF020617), Color(0xFF334155), Color(0xFF94A3B8)],
    tagline: 'No rules. No mercy.',
    maturity: '18+',
    runtime: '1h 41m',
    mood: 'Адреналін',
    mark: 'JW',
    trailerTitle: 'John Wick Official Trailer',
    trailerUrl: 'https://www.youtube.com/watch?v=2AUmvWm5ZDQ',
    director: 'Chad Stahelski',
    studio: 'Lionsgate',
    language: 'English',
    vibeTags: ['неон', 'помста', 'бойові сцени', 'кримінал'],
    facts: [
      'Gun-fu choreography',
      'Створив цілу assassin-міфологію',
      'Мінімалістична мотивація героя',
    ],
    bestMoment: 'Перший великий рейд, де стиль задає весь тон франшизи.',
    aiHook: 'Для вечора, коли потрібен чистий темп і стиль.',
  ),
  Movie(
    id: 5,
    title: 'The Martian',
    year: 2015,
    genres: ['Фантастика', 'Пригоди', 'Комедія'],
    actors: ['Matt Damon', 'Jessica Chastain'],
    description:
        'Астронавт виживає на Марсі завдяки науці, гумору та винахідливості.',
    poster: 'assets/posters/martian.png',
    palette: [Color(0xFF431407), Color(0xFFEA580C), Color(0xFFFFC857)],
    tagline: 'Bring him home.',
    maturity: '12+',
    runtime: '2h 24m',
    mood: 'Оптимістичний',
    mark: 'TM',
    trailerTitle: 'The Martian Official Trailer',
    trailerUrl: 'https://www.youtube.com/watch?v=ej3ioOneTy8',
    director: 'Ridley Scott',
    studio: '20th Century Fox',
    language: 'English',
    vibeTags: ['Марс', 'виживання', 'гумор', 'наука'],
    facts: [
      'За романом Andy Weir',
      'Науково-популярний тон',
      'Оптимістична survival-історія',
    ],
    bestMoment: 'Герой перетворює проблему виживання на інженерний квест.',
    aiHook: 'Підходить, коли хочеться sci-fi без похмурості.',
  ),
  Movie(
    id: 6,
    title: 'Spider-Man: No Way Home',
    year: 2021,
    genres: ['Marvel', 'Пригоди', 'Фантастика'],
    actors: ['Tom Holland', 'Zendaya'],
    description:
        'Супергеройська історія про мультивсесвіт, відповідальність і наслідки рішень.',
    poster: 'assets/posters/spiderman.png',
    palette: [Color(0xFF450A0A), Color(0xFFE11D48), Color(0xFF38BDF8)],
    tagline: 'The multiverse opens.',
    maturity: '12+',
    runtime: '2h 28m',
    mood: 'Пригодницький',
    mark: 'SM',
    trailerTitle: 'Spider-Man: No Way Home Official Trailer',
    trailerUrl: 'https://www.youtube.com/watch?v=JfVOs4VSpmA',
    director: 'Jon Watts',
    studio: 'Marvel Studios',
    language: 'English',
    vibeTags: ['мультивсесвіт', 'герой', 'ностальгія', 'відповідальність'],
    facts: [
      'Мультивсесвіт MCU',
      'Повернення культових персонажів',
      'Емоційне дорослішання героя',
    ],
    bestMoment: 'Командний superhero-момент із сильним ностальгійним ударом.',
    aiHook: 'Ідеально, якщо хочеться Marvel, але з емоційною ставкою.',
  ),
  Movie(
    id: 7,
    title: 'Dune',
    year: 2021,
    genres: ['Фантастика', 'Драма', 'Пригоди'],
    actors: ['Timothee Chalamet', 'Zendaya'],
    description:
        'Масштабна фантастика про владу, пустелю, пророцтва та планету Арракіс.',
    poster: 'assets/posters/dune.png',
    palette: [Color(0xFF1C1917), Color(0xFFA16207), Color(0xFFFFC857)],
    tagline: 'Fear is the mind-killer.',
    maturity: '12+',
    runtime: '2h 35m',
    mood: 'Атмосферний',
    mark: 'DN',
    trailerTitle: 'Dune Official Trailer',
    trailerUrl: 'https://www.youtube.com/watch?v=n9xhJrPXop4',
    director: 'Denis Villeneuve',
    studio: 'Warner Bros.',
    language: 'English',
    vibeTags: ['пустеля', 'політика', 'пророцтво', 'епік'],
    facts: [
      'Екранізація Frank Herbert',
      'Візуальна мова Denis Villeneuve',
      'Потужний sound design',
    ],
    bestMoment: 'Перший контакт з масштабом Арракіса і його правилами.',
    aiHook: 'Для вечора з повільним, величним і дуже атмосферним sci-fi.',
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
  String profilePhotoUrl = '';
  String profileBio = 'Sci-fi, Marvel, smart drama';
  final movies = List<Movie>.from(moviesSeed);
  final preferences = <String>{'Фантастика', 'Marvel'};
  final favorites = <int>{};
  final watchLater = <int>{};
  final watched = <int>{};
  final ratings = <int, int>{};
  final comments = <int, List<String>>{};

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

  void toggle(Set<int> set, int id) {
    setState(() => set.contains(id) ? set.remove(id) : set.add(id));
  }

  void rate(Movie movie, int value) {
    setState(() {
      ratings[movie.id] = value;
      watched.add(movie.id);
    });
  }

  void addComment(Movie movie, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    setState(() {
      comments.putIfAbsent(movie.id, () => <String>[]).insert(0, trimmed);
      watched.add(movie.id);
    });
  }

  void updateProfile({
    required String name,
    required String photoUrl,
    required String bio,
  }) {
    setState(() {
      userName = name.trim().isEmpty ? userName : name.trim();
      profilePhotoUrl = photoUrl.trim();
      profileBio = bio.trim().isEmpty ? profileBio : bio.trim();
    });
  }

  void addMovie(Movie movie) => setState(() => movies.add(movie));

  void deleteMovie(Movie movie) {
    setState(() {
      movies.removeWhere((item) => item.id == movie.id);
      favorites.remove(movie.id);
      watchLater.remove(movie.id);
      watched.remove(movie.id);
      ratings.remove(movie.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!signedIn) return AuthScreen(onSignIn: signIn);
    if (!preferencesReady) {
      return PreferencesScreen(
        initialSelection: preferences,
        onSave: savePreferences,
      );
    }
    return AppShell(
      userName: userName,
      profilePhotoUrl: profilePhotoUrl,
      profileBio: profileBio,
      movies: movies,
      preferences: preferences,
      favorites: favorites,
      watchLater: watchLater,
      watched: watched,
      ratings: ratings,
      comments: comments,
      onFavorite: (movie) => toggle(favorites, movie.id),
      onWatchLater: (movie) => toggle(watchLater, movie.id),
      onWatched: (movie) => toggle(watched, movie.id),
      onRate: rate,
      onComment: addComment,
      onUpdateProfile: updateProfile,
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
      body: PremiumBackdrop(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BrandWordmark(center: true),
                    const SizedBox(height: 28),
                    Text(
                      'Кіно, яке підлаштовується під тебе',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w900, height: 1.05),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Персональна стрічка, красиві афіші та AI-поради без зайвого шуму.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .74),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    GlassPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SegmentedButton<bool>(
                            segments: const [
                              ButtonSegment(
                                value: true,
                                label: Text('Реєстрація'),
                                icon: Icon(Icons.person_add_alt_rounded),
                              ),
                              ButtonSegment(
                                value: false,
                                label: Text('Вхід'),
                                icon: Icon(Icons.login_rounded),
                              ),
                            ],
                            selected: {register},
                            onSelectionChanged: (value) {
                              setState(() => register = value.first);
                            },
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: "Ім'я",
                              prefixIcon: Icon(Icons.badge_outlined),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.alternate_email_rounded),
                            ),
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () =>
                                widget.onSignIn(nameController.text),
                            icon: const Icon(Icons.play_circle_rounded),
                            label: Text(
                              register ? 'Створити профіль' : 'Увійти',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const TechPills(),
                  ],
                ),
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
  late final selected = Set<String>.from(widget.initialSelection);
  String preset = 'cinema';

  void applyPreset(String value) {
    setState(() {
      preset = value;
      selected
        ..clear()
        ..addAll(switch (value) {
          'marvel' => {'Marvel', 'Бойовик', 'Пригоди'},
          'smart' => {'Фантастика', 'Трилер', 'Драма'},
          'light' => {'Комедія', 'Пригоди', 'Фантастика'},
          _ => {'Фантастика', 'Marvel', 'Пригоди'},
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PremiumBackdrop(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const BrandWordmark(),
              const SizedBox(height: 30),
              Text(
                'Збери свій кіносмак',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.04,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Обери не сухі жанри, а вайби перегляду. CineMind перетворить їх у персональну стрічку.',
                style: TextStyle(color: Colors.white.withValues(alpha: .72)),
              ),
              const SizedBox(height: 18),
              SegmentedButton<String>(
                selected: {preset},
                onSelectionChanged: (value) => applyPreset(value.first),
                segments: const [
                  ButtonSegment(
                    value: 'cinema',
                    icon: Icon(Icons.local_movies_rounded),
                    label: Text('Cinema'),
                  ),
                  ButtonSegment(
                    value: 'marvel',
                    icon: Icon(Icons.shield_rounded),
                    label: Text('Marvel'),
                  ),
                  ButtonSegment(
                    value: 'smart',
                    icon: Icon(Icons.psychology_alt_rounded),
                    label: Text('Smart'),
                  ),
                  ButtonSegment(
                    value: 'light',
                    icon: Icon(Icons.wb_sunny_rounded),
                    label: Text('Light'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width > 720 ? 4 : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.35,
                children: [
                  for (final option in tasteOptions)
                    TasteCard(
                      option: option,
                      selected: selected.contains(option.genre),
                      onTap: () {
                        setState(() {
                          selected.contains(option.genre)
                              ? selected.remove(option.genre)
                              : selected.add(option.genre);
                        });
                      },
                    ),
                ],
              ),
              const SizedBox(height: 18),
              GlassPanel(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.amber,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        selected.isEmpty
                            ? 'Обери хоча б один вайб.'
                            : 'AI профіль: ${selected.join(' • ')}',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: selected.isEmpty
                    ? null
                    : () => widget.onSave(selected),
                icon: const Icon(Icons.auto_awesome_rounded),
                label: const Text('Побудувати стрічку'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.userName,
    required this.profilePhotoUrl,
    required this.profileBio,
    required this.movies,
    required this.preferences,
    required this.favorites,
    required this.watchLater,
    required this.watched,
    required this.ratings,
    required this.comments,
    required this.onFavorite,
    required this.onWatchLater,
    required this.onWatched,
    required this.onRate,
    required this.onComment,
    required this.onUpdateProfile,
    required this.onAddMovie,
    required this.onDeleteMovie,
    required this.onEditPreferences,
  });

  final String userName;
  final String profilePhotoUrl;
  final String profileBio;
  final List<Movie> movies;
  final Set<String> preferences;
  final Set<int> favorites;
  final Set<int> watchLater;
  final Set<int> watched;
  final Map<int, int> ratings;
  final Map<int, List<String>> comments;
  final ValueChanged<Movie> onFavorite;
  final ValueChanged<Movie> onWatchLater;
  final ValueChanged<Movie> onWatched;
  final void Function(Movie movie, int value) onRate;
  final void Function(Movie movie, String text) onComment;
  final void Function({
    required String name,
    required String photoUrl,
    required String bio,
  })
  onUpdateProfile;
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
      CinematicHomeScreen(data: widget),
      SearchScreen(data: widget),
      LibraryScreen(data: widget),
      AgentStudioScreen(data: widget),
      SystemOverviewScreen(data: widget),
      EditableProfileScreen(data: widget),
    ];
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        height: 72,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home_rounded),
            icon: Icon(Icons.home_outlined),
            label: 'Головна',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.manage_search_rounded),
            icon: Icon(Icons.search_rounded),
            label: 'Пошук',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bookmarks_rounded),
            icon: Icon(Icons.bookmarks_outlined),
            label: 'Списки',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.auto_awesome_rounded),
            icon: Icon(Icons.auto_awesome_outlined),
            label: 'AI',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.hub_rounded),
            icon: Icon(Icons.hub_outlined),
            label: 'Система',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person_rounded),
            icon: Icon(Icons.person_outline_rounded),
            label: 'Профіль',
          ),
        ],
      ),
    );
  }
}

class CinematicHomeScreen extends StatelessWidget {
  const CinematicHomeScreen({super.key, required this.data});

  final AppShell data;

  @override
  Widget build(BuildContext context) {
    final ranked = _ranked(
      data.movies,
      data.preferences,
      data.ratings,
      data.watched,
    );
    final hero = ranked.first;
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 860;
    final avg = data.ratings.isEmpty
        ? 0.0
        : data.ratings.values.reduce((a, b) => a + b) / data.ratings.length;
    final commentCount = data.comments.values.fold<int>(
      0,
      (sum, items) => sum + items.length,
    );

    return Scaffold(
      body: PremiumBackdrop(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: isWide ? 650 : 720,
              title: const BrandWordmark(compact: true),
              actions: [
                IconButton.filledTonal(
                  tooltip: 'Смаки',
                  onPressed: data.onEditPreferences,
                  icon: const Icon(Icons.tune_rounded),
                ),
                const SizedBox(width: 10),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: CinematicHeroStage(
                  movie: hero,
                  data: data,
                  isWide: isWide,
                  avg: avg,
                  commentCount: commentCount,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  isWide ? 28 : 16,
                  22,
                  isWide ? 28 : 16,
                  110,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommandCenterStrip(
                      data: data,
                      avg: avg,
                      commentCount: commentCount,
                    ),
                    const SizedBox(height: 22),
                    PlatformPipeline(data: data),
                    const SizedBox(height: 24),
                    CinematicPosterGrid(
                      title: 'Персональна премʼєра',
                      subtitle:
                          'AI-рейтинг, оцінки, коментарі та PostgreSQL-каталог',
                      movies: ranked,
                      data: data,
                      large: true,
                    ),
                    const SizedBox(height: 24),
                    CinematicPosterGrid(
                      title: 'Smart sci-fi та Marvel вайб',
                      subtitle:
                          'Добірка показує, що 5 тиждень вже працює як продукт',
                      movies: data.movies
                          .where(
                            (movie) =>
                                movie.genres.contains('Фантастика') ||
                                movie.genres.contains('Marvel') ||
                                movie.vibeTags.any(
                                  (tag) => tag.toLowerCase().contains('епік'),
                                ),
                          )
                          .toList(),
                      data: data,
                    ),
                    const SizedBox(height: 24),
                    AiPreviewConsole(
                      data: data,
                      movies: ranked.take(3).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CinematicHeroStage extends StatelessWidget {
  const CinematicHeroStage({
    super.key,
    required this.movie,
    required this.data,
    required this.isWide,
    required this.avg,
    required this.commentCount,
  });

  final Movie movie;
  final AppShell data;
  final bool isWide;
  final double avg;
  final int commentCount;

  @override
  Widget build(BuildContext context) {
    final score = recommendationScore(
      movie,
      data.preferences,
      data.ratings,
      data.watched,
    );
    final poster = Hero(
      tag: 'poster-${movie.id}',
      child: PosterArtwork(
        movie: movie,
        width: isWide ? 286 : 232,
        height: isWide ? 406 : 328,
      ),
    );
    final copy = Column(
      crossAxisAlignment: isWide
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: isWide ? WrapAlignment.start : WrapAlignment.center,
          children: const [
            TechPill('Flutter UI'),
            TechPill('FastAPI'),
            TechPill('PostgreSQL'),
            TechPill('AI Agent'),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          movie.title,
          textAlign: isWide ? TextAlign.left : TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
            height: .96,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${movie.year} • ${movie.maturity} • ${movie.runtime} • $score% match',
          textAlign: isWide ? TextAlign.left : TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: .76),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          movie.aiHook,
          textAlign: isWide ? TextAlign.left : TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white.withValues(alpha: .82),
            height: 1.25,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton.icon(
              onPressed: () => openTrailer(context, movie),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Трейлер'),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(
              onPressed: () => _openMovie(context, movie, data),
              icon: const Icon(Icons.movie_filter_rounded),
              label: const Text('Деталі'),
            ),
          ],
        ),
      ],
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            movie.palette.last.withValues(alpha: .92),
            AppColors.ink.withValues(alpha: .95),
            AppColors.ink,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            isWide ? 44 : 18,
            84,
            isWide ? 44 : 18,
            28,
          ),
          child: isWide
              ? Row(
                  children: [
                    Expanded(flex: 5, child: copy),
                    const SizedBox(width: 30),
                    Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          poster,
                          const SizedBox(height: 16),
                          MatchMeter(value: score, label: 'AI match'),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Expanded(child: Center(child: poster)),
                    copy,
                  ],
                ),
        ),
      ),
    );
  }
}

class CommandCenterStrip extends StatelessWidget {
  const CommandCenterStrip({
    super.key,
    required this.data,
    required this.avg,
    required this.commentCount,
  });

  final AppShell data;
  final double avg;
  final int commentCount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 760 ? 4 : 2;
        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: constraints.maxWidth > 760 ? 2.25 : 1.62,
          children: [
            SignalTile(
              icon: Icons.storage_rounded,
              label: 'PostgreSQL каталог',
              value: '${data.movies.length}',
              accent: AppColors.blue,
            ),
            SignalTile(
              icon: Icons.auto_awesome_rounded,
              label: 'AI смаків',
              value: '${data.preferences.length}',
              accent: AppColors.violet,
            ),
            SignalTile(
              icon: Icons.star_rounded,
              label: 'Середня оцінка',
              value: avg.toStringAsFixed(1),
              accent: AppColors.amber,
            ),
            SignalTile(
              icon: Icons.mode_comment_rounded,
              label: 'Коментарі',
              value: '$commentCount',
              accent: AppColors.mint,
            ),
          ],
        );
      },
    );
  }
}

class SignalTile extends StatelessWidget {
  const SignalTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: .16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white.withValues(alpha: .68)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlatformPipeline extends StatelessWidget {
  const PlatformPipeline({super.key, required this.data});

  final AppShell data;

  @override
  Widget build(BuildContext context) {
    final steps = [
      (
        'Flutter',
        'iPhone-style інтерфейс',
        Icons.phone_iphone_rounded,
        AppColors.blue,
      ),
      ('FastAPI', 'API для каталогу й AI', Icons.api_rounded, AppColors.mint),
      (
        'PostgreSQL',
        '${data.movies.length} фільмів у схемі',
        Icons.storage_rounded,
        AppColors.jade,
      ),
      (
        'AI Agent',
        'оцінки + коментарі + смаки',
        Icons.psychology_rounded,
        AppColors.violet,
      ),
    ];
    return GlassPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Технологічний ланцюг',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 760;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final step in steps)
                    SizedBox(
                      width: wide
                          ? (constraints.maxWidth - 30) / 4
                          : constraints.maxWidth,
                      child: PipelineStep(
                        title: step.$1,
                        subtitle: step.$2,
                        icon: step.$3,
                        color: step.$4,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class PipelineStep extends StatelessWidget {
  const PipelineStep({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .055),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: .28)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: .64),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CinematicPosterGrid extends StatelessWidget {
  const CinematicPosterGrid({
    super.key,
    required this.title,
    required this.subtitle,
    required this.movies,
    required this.data,
    this.large = false,
  });

  final String title;
  final String subtitle;
  final List<Movie> movies;
  final AppShell data;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title, subtitle: subtitle),
        const SizedBox(height: 12),
        SizedBox(
          height: large ? 326 : 286,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final movie = movies[index];
              return SizedBox(
                width: large ? 184 : 154,
                child: PremiumMovieTile(movie: movie, data: data, large: large),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PremiumMovieTile extends StatelessWidget {
  const PremiumMovieTile({
    super.key,
    required this.movie,
    required this.data,
    required this.large,
  });

  final Movie movie;
  final AppShell data;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final score = recommendationScore(
      movie,
      data.preferences,
      data.ratings,
      data.watched,
    );
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => _openMovie(context, movie, data),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PosterArtwork(
            movie: movie,
            width: double.infinity,
            height: large ? 244 : 208,
            onTap: () => _openMovie(context, movie, data),
          ),
          const SizedBox(height: 10),
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Icon(Icons.bolt_rounded, color: AppColors.jade, size: 16),
              const SizedBox(width: 3),
              Text(
                '$score% match',
                style: const TextStyle(
                  color: AppColors.jade,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AiPreviewConsole extends StatelessWidget {
  const AiPreviewConsole({super.key, required this.data, required this.movies});

  final AppShell data;
  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    final best = movies.isEmpty ? null : movies.first;
    return GlassPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, color: AppColors.amber),
              const SizedBox(width: 8),
              Text(
                'AI агент сьогодні',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            best == null
                ? 'AI чекає на оцінки та коментарі.'
                : 'Найсильніша рекомендація: ${best.title}. Причина: ${recommendationReason(best, data.preferences)}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: .78),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final pref in data.preferences.take(5))
                Chip(
                  avatar: const Icon(Icons.memory_rounded, size: 16),
                  label: Text(pref),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class AgentStudioScreen extends StatefulWidget {
  const AgentStudioScreen({super.key, required this.data});

  final AppShell data;

  @override
  State<AgentStudioScreen> createState() => _AgentStudioScreenState();
}

class _AgentStudioScreenState extends State<AgentStudioScreen> {
  final controller = TextEditingController(
    text: 'Підбери фільм на вечір з вау-ефектом і сильним фіналом',
  );
  final service = const CineMindAiService();
  AiReply? reply;
  bool loading = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> askAi() async {
    setState(() => loading = true);
    final result = await service.generate(
      prompt: controller.text,
      movies: widget.data.movies,
      preferences: widget.data.preferences,
      watched: widget.data.watched,
      ratings: widget.data.ratings,
      comments: widget.data.comments,
      userName: widget.data.userName,
      profileBio: widget.data.profileBio,
    );
    if (!mounted) return;
    setState(() {
      reply = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ranked = _ranked(
      widget.data.movies,
      widget.data.preferences,
      widget.data.ratings,
      widget.data.watched,
    );
    final comments = widget.data.comments.values.fold<int>(
      0,
      (sum, items) => sum + items.length,
    );
    return Scaffold(
      body: PremiumBackdrop(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 110),
            children: [
              const BrandWordmark(compact: true),
              const SizedBox(height: 22),
              Text(
                'AI Agent Studio',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: .96,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Агент читає профіль, оцінки, коментарі, PostgreSQL-каталог і повертає добірку під запит.',
                style: TextStyle(color: Colors.white.withValues(alpha: .72)),
              ),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth > 780;
                  final console = AgentPromptConsole(
                    controller: controller,
                    loading: loading,
                    onAsk: askAi,
                    reply: reply,
                  );
                  final memory = AgentMemoryPanel(
                    data: widget.data,
                    catalog: widget.data.movies.length,
                    comments: comments,
                  );
                  return wide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 6, child: console),
                            const SizedBox(width: 14),
                            Expanded(flex: 4, child: memory),
                          ],
                        )
                      : Column(
                          children: [
                            console,
                            const SizedBox(height: 14),
                            memory,
                          ],
                        );
                },
              ),
              const SizedBox(height: 18),
              if (reply != null) ...[
                MatchMeter(value: reply!.confidence, label: 'AI confidence'),
                const SizedBox(height: 14),
                CinematicPosterGrid(
                  title: 'Рішення агента',
                  subtitle:
                      'Добірка перебудовується після нових оцінок і коментарів',
                  movies: reply!.movies,
                  data: widget.data,
                ),
              ] else
                CinematicPosterGrid(
                  title: 'Швидкий старт агента',
                  subtitle: 'Перші варіанти з персонального рейтингу',
                  movies: ranked.take(5).toList(),
                  data: widget.data,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AgentPromptConsole extends StatelessWidget {
  const AgentPromptConsole({
    super.key,
    required this.controller,
    required this.loading,
    required this.onAsk,
    required this.reply,
  });

  final TextEditingController controller;
  final bool loading;
  final VoidCallback onAsk;
  final AiReply? reply;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_alt_rounded, color: AppColors.amber),
              const SizedBox(width: 8),
              Text(
                'Запит до агента',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Що хочеш подивитися?',
            style: TextStyle(
              color: Colors.white.withValues(alpha: .72),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            minLines: 3,
            maxLines: 5,
            textAlignVertical: TextAlignVertical.top,
            style: const TextStyle(
              fontSize: 16,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
            decoration: const InputDecoration(
              hintText: 'Наприклад: фільм на вечір з вау-ефектом',
              alignLabelWithHint: true,
              contentPadding: EdgeInsets.fromLTRB(18, 16, 18, 16),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: loading ? null : onAsk,
            icon: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.auto_awesome_rounded),
            label: Text(loading ? 'AI аналізує...' : 'Згенерувати рішення'),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .26),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: .08)),
            ),
            child: Text(
              reply?.answer ??
                  'AI ще не запускався. Після запиту тут буде персональна відповідь з причинами, врахованими оцінками і коментарями.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: .82),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AgentMemoryPanel extends StatelessWidget {
  const AgentMemoryPanel({
    super.key,
    required this.data,
    required this.catalog,
    required this.comments,
  });

  final AppShell data;
  final int catalog;
  final int comments;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Памʼять агента',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          MemoryLine(
            icon: Icons.storage_rounded,
            label: 'PostgreSQL movies',
            value: '$catalog',
            accent: AppColors.blue,
          ),
          const SizedBox(height: 10),
          MemoryLine(
            icon: Icons.star_rounded,
            label: 'Оцінки користувача',
            value: '${data.ratings.length}',
            accent: AppColors.amber,
          ),
          const SizedBox(height: 10),
          MemoryLine(
            icon: Icons.mode_comment_rounded,
            label: 'Коментарі',
            value: '$comments',
            accent: AppColors.mint,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final pref in data.preferences)
                Chip(
                  avatar: const Icon(Icons.tips_and_updates_rounded, size: 16),
                  label: Text(pref),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class MemoryLine extends StatelessWidget {
  const MemoryLine({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: accent),
        const SizedBox(width: 10),
        Expanded(child: Text(label)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
      ],
    );
  }
}

class SystemOverviewScreen extends StatelessWidget {
  const SystemOverviewScreen({super.key, required this.data});

  final AppShell data;

  @override
  Widget build(BuildContext context) {
    final commentCount = data.comments.values.fold<int>(
      0,
      (sum, items) => sum + items.length,
    );
    final syncItems = [
      (
        'Flutter',
        'екрани, анімації, профіль, трейлери',
        Icons.phone_iphone_rounded,
        AppColors.blue,
      ),
      (
        'FastAPI',
        'REST endpoint-и для каталогу, оцінок, списків і AI',
        Icons.api_rounded,
        AppColors.mint,
      ),
      (
        'PostgreSQL',
        'таблиці movies, users, ratings, comments, favorites',
        Icons.storage_rounded,
        AppColors.jade,
      ),
      (
        'AI Agent',
        'аналізує запит, смаки, оцінки, перегляди й коментарі',
        Icons.psychology_alt_rounded,
        AppColors.violet,
      ),
    ];
    final endpoints = const [
      'GET /health',
      'GET /movies',
      'POST /users',
      'PUT /users/{id}/ratings/{movie_id}',
      'POST /users/{id}/comments/{movie_id}',
      'POST /recommendations',
      'POST /ai/recommend',
    ];
    final tables = const [
      'users',
      'movies',
      'movie_genres',
      'movie_actors',
      'favorites',
      'watch_later',
      'watched_movies',
      'user_ratings',
      'movie_comments',
    ];

    return Scaffold(
      body: PremiumBackdrop(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 108),
            children: [
              const BrandWordmark(compact: true),
              const SizedBox(height: 22),
              Text(
                'Система CineMind',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: .96,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Окремий екран для захисту: видно, як мобільний інтерфейс, API, база даних і AI-логіка працюють як один продукт.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .72),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth > 820;
                  return GridView.count(
                    crossAxisCount: wide ? 4 : 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: wide ? 1.24 : 1.06,
                    children: [
                      for (final item in syncItems)
                        SystemNodeCard(
                          title: item.$1,
                          subtitle: item.$2,
                          icon: item.$3,
                          color: item.$4,
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 18),
              GlassPanel(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.account_tree_rounded,
                          color: AppColors.amber,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Потік даних',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const SystemFlow(),
                    const SizedBox(height: 14),
                    Text(
                      'Користувач оцінює фільм або залишає коментар. Flutter оновлює стан профілю, FastAPI приймає дію, PostgreSQL зберігає запис, а AI Agent використовує ці сигнали для наступної рекомендації.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .76),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth > 820;
                  final left = SystemListPanel(
                    title: 'FastAPI endpoint-и',
                    icon: Icons.route_rounded,
                    items: endpoints,
                  );
                  final right = SystemListPanel(
                    title: 'PostgreSQL таблиці',
                    icon: Icons.table_chart_rounded,
                    items: tables,
                  );
                  return wide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: left),
                            const SizedBox(width: 12),
                            Expanded(child: right),
                          ],
                        )
                      : Column(
                          children: [left, const SizedBox(height: 12), right],
                        );
                },
              ),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth > 760;
                  return GridView.count(
                    crossAxisCount: wide ? 4 : 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: wide ? 2.15 : 1.48,
                    children: [
                      StatCard(
                        title: 'Фільмів',
                        value: '${data.movies.length}',
                        icon: Icons.movie_filter_rounded,
                      ),
                      StatCard(
                        title: 'Оцінок',
                        value: '${data.ratings.length}',
                        icon: Icons.star_rounded,
                      ),
                      StatCard(
                        title: 'Коментарів',
                        value: '$commentCount',
                        icon: Icons.mode_comment_rounded,
                      ),
                      StatCard(
                        title: 'AI сигналів',
                        value:
                            '${data.preferences.length + data.ratings.length + commentCount}',
                        icon: Icons.auto_awesome_rounded,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SystemNodeCard extends StatelessWidget {
  const SystemNodeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: .68),
              fontSize: 12,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class SystemFlow extends StatelessWidget {
  const SystemFlow({super.key});

  @override
  Widget build(BuildContext context) {
    final nodes = const [
      ('Flutter UI', Icons.phone_iphone_rounded),
      ('FastAPI', Icons.api_rounded),
      ('PostgreSQL', Icons.storage_rounded),
      ('AI Agent', Icons.psychology_alt_rounded),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < nodes.length; i++) ...[
            Container(
              width: 150,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .075),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: .10)),
              ),
              child: Column(
                children: [
                  Icon(nodes[i].$2, color: AppColors.blue),
                  const SizedBox(height: 8),
                  Text(
                    nodes[i].$1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
            if (i != nodes.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward_rounded, color: AppColors.mint),
              ),
          ],
        ],
      ),
    );
  }
}

class SystemListPanel extends StatelessWidget {
  const SystemListPanel({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
  });

  final String title;
  final IconData icon;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.jade),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 17,
                    color: AppColors.mint,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.data});

  final AppShell data;

  @override
  Widget build(BuildContext context) {
    final ranked = _ranked(
      data.movies,
      data.preferences,
      data.ratings,
      data.watched,
    );
    final hero = ranked.first;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 540,
            title: const BrandWordmark(compact: true),
            actions: [
              IconButton.filledTonal(
                tooltip: 'Вподобання',
                onPressed: data.onEditPreferences,
                icon: const Icon(Icons.tune_rounded),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: HeroHeader(movie: hero, data: data),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatsStrip(data: data),
                  const SizedBox(height: 22),
                  MovieRail(
                    title: 'Топ для тебе',
                    subtitle: 'Відсортовано за Content-Based Filtering',
                    movies: ranked,
                    data: data,
                  ),
                  MovieRail(
                    title: "Прем'єрний настрій",
                    subtitle: 'Свіжіші та динамічніші варіанти',
                    movies: data.movies
                        .where((movie) => movie.year >= 2015)
                        .toList(),
                    data: data,
                  ),
                  MovieRail(
                    title: 'Для довгого вечора',
                    subtitle: 'Фантастика, пригоди і сильна атмосфера',
                    movies: data.movies
                        .where((movie) => movie.genres.contains('Фантастика'))
                        .toList(),
                    data: data,
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

class HeroHeader extends StatelessWidget {
  const HeroHeader({super.key, required this.movie, required this.data});

  final Movie movie;
  final AppShell data;

  @override
  Widget build(BuildContext context) {
    final score = recommendationScore(
      movie,
      data.preferences,
      data.ratings,
      data.watched,
    );
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            movie.palette[1].withValues(alpha: .92),
            AppColors.inkSoft,
            AppColors.ink,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 74, 20, 28),
          child: Column(
            children: [
              Expanded(
                child: Hero(
                  tag: 'poster-${movie.id}',
                  child: PosterArtwork(movie: movie, width: 214, height: 304),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                movie.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.02,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${movie.year} • ${movie.maturity} • ${movie.runtime} • $score% match',
                style: TextStyle(color: Colors.white.withValues(alpha: .78)),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => openTrailer(context, movie),
                      icon: const Icon(Icons.play_circle_rounded),
                      label: const Text('Трейлер'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: () => _openMovie(context, movie, data),
                    icon: const Icon(Icons.info_outline_rounded),
                    label: const Text('Деталі'),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filledTonal(
                    tooltip: 'Дивитись пізніше',
                    onPressed: () => data.onWatchLater(movie),
                    icon: Icon(
                      data.watchLater.contains(movie.id)
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
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

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.data});

  final AppShell data;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';
  String genre = 'Усі';

  @override
  Widget build(BuildContext context) {
    final genres = {
      'Усі',
      for (final movie in widget.data.movies) ...movie.genres,
    }.toList();
    final results = widget.data.movies.where((movie) {
      final text =
          '${movie.title} ${movie.genres.join(' ')} ${movie.actors.join(' ')} ${movie.mood}'
              .toLowerCase();
      return (query.isEmpty || text.contains(query.toLowerCase())) &&
          (genre == 'Усі' || movie.genres.contains(genre));
    }).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Пошук')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            onChanged: (value) => setState(() => query = value.trim()),
            decoration: const InputDecoration(
              labelText: 'Назва, актор, жанр або настрій',
              prefixIcon: Icon(Icons.manage_search_rounded),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final item in genres)
                ChoiceChip(
                  selected: genre == item,
                  label: Text(item),
                  avatar: item == 'Усі'
                      ? null
                      : Icon(_genreIcon(item), size: 16),
                  onSelected: (_) => setState(() => genre = item),
                ),
            ],
          ),
          const SizedBox(height: 18),
          SectionHeader(
            title: 'Знайдено: ${results.length}',
            subtitle: 'Фільтр працює за локальним каталогом',
          ),
          const SizedBox(height: 10),
          for (final movie in results)
            MovieListCard(movie: movie, data: widget.data),
        ],
      ),
    );
  }
}

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key, required this.data});

  final AppShell data;

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = data.movies
        .where((movie) => data.favorites.contains(movie.id))
        .toList();
    final laterMovies = data.movies
        .where((movie) => data.watchLater.contains(movie.id))
        .toList();
    final watchedMovies = data.movies
        .where((movie) => data.watched.contains(movie.id))
        .toList();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Мої списки'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.favorite_rounded), text: 'Обране'),
              Tab(icon: Icon(Icons.schedule_rounded), text: 'Пізніше'),
              Tab(icon: Icon(Icons.visibility_rounded), text: 'Переглянуто'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CollectionList(
              movies: favoriteMovies,
              data: data,
              empty: 'Додай фільми в обране.',
            ),
            CollectionList(
              movies: laterMovies,
              data: data,
              empty: 'Список на вечір поки порожній.',
            ),
            CollectionList(
              movies: watchedMovies,
              data: data,
              empty: 'Познач фільм як переглянутий.',
            ),
          ],
        ),
      ),
    );
  }
}

class AiScreen extends StatefulWidget {
  const AiScreen({super.key, required this.data});

  final AppShell data;

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final controller = TextEditingController(text: 'Що подивитися після Marvel?');
  final service = const CineMindAiService();
  AiReply? reply;
  bool loading = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> askAi() async {
    setState(() => loading = true);
    final result = await service.generate(
      prompt: controller.text,
      movies: widget.data.movies,
      preferences: widget.data.preferences,
      watched: widget.data.watched,
      ratings: widget.data.ratings,
      comments: widget.data.comments,
      userName: widget.data.userName,
      profileBio: widget.data.profileBio,
    );
    if (!mounted) return;
    setState(() {
      reply = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ranked = _ranked(
      widget.data.movies,
      widget.data.preferences,
      widget.data.ratings,
      widget.data.watched,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('AI-помічник')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GlassPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.amber,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'CineMind AI Service',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Вбудований сервіс аналізує запит, твої смаки, оцінки, перегляди і mood-теги фільмів.',
                  style: TextStyle(color: Colors.white.withValues(alpha: .72)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Запит до AI'),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: loading ? null : askAi,
                  icon: loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.bolt_rounded),
                  label: Text(loading ? 'AI думає...' : 'Згенерувати добірку'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GlassPanel(
            child: Text(
              reply?.answer ?? 'AI-помічник готовий сформувати добірку.',
            ),
          ),
          if (reply != null) ...[
            const SizedBox(height: 14),
            MatchMeter(value: reply!.confidence, label: 'AI confidence'),
            const SizedBox(height: 12),
            for (final movie in reply!.movies)
              MovieListCard(movie: movie, data: widget.data),
          ],
          const SizedBox(height: 18),
          SectionHeader(
            title: 'Швидкі AI-підказки',
            subtitle: 'Перші три позиції рекомендаційного рейтингу',
          ),
          const SizedBox(height: 10),
          for (final movie in ranked.take(3))
            MovieListCard(movie: movie, data: widget.data),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.data});

  final AppShell data;

  @override
  Widget build(BuildContext context) {
    final avg = data.ratings.isEmpty
        ? 0.0
        : data.ratings.values.reduce((a, b) => a + b) / data.ratings.length;
    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GlassPanel(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.jade,
                  child: Text(
                    data.userName.characters.first.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.userName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(data.preferences.join(' • ')),
                    ],
                  ),
                ),
              ],
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
                value: '${data.favorites.length}',
                icon: Icons.favorite_rounded,
              ),
              StatCard(
                title: 'Пізніше',
                value: '${data.watchLater.length}',
                icon: Icons.schedule_rounded,
              ),
              StatCard(
                title: 'Переглянуто',
                value: '${data.watched.length}',
                icon: Icons.visibility_rounded,
              ),
              StatCard(
                title: 'Середня',
                value: avg.toStringAsFixed(1),
                icon: Icons.analytics_rounded,
              ),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: data.onEditPreferences,
            icon: const Icon(Icons.tune_rounded),
            label: const Text('Редагувати вподобання'),
          ),
        ],
      ),
    );
  }
}

class EditableProfileScreen extends StatelessWidget {
  const EditableProfileScreen({super.key, required this.data});

  final AppShell data;

  @override
  Widget build(BuildContext context) {
    final avg = data.ratings.isEmpty
        ? 0.0
        : data.ratings.values.reduce((a, b) => a + b) / data.ratings.length;
    final commentCount = data.comments.values.fold<int>(
      0,
      (sum, items) => sum + items.length,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        children: [
          GlassPanel(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                ProfileAvatar(
                  name: data.userName,
                  photoUrl: data.profilePhotoUrl,
                  radius: 42,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.userName,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.profileBio,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .72),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final pref in data.preferences.take(4))
                            Chip(label: Text(pref)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 760;
              return GridView.count(
                crossAxisCount: wide ? 4 : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: wide ? 2.25 : 1.55,
                children: [
                  StatCard(
                    title: 'Оцінок',
                    value: '${data.ratings.length}',
                    icon: Icons.star_rounded,
                  ),
                  StatCard(
                    title: 'Коментарів',
                    value: '$commentCount',
                    icon: Icons.mode_comment_rounded,
                  ),
                  StatCard(
                    title: 'Переглянуто',
                    value: '${data.watched.length}',
                    icon: Icons.visibility_rounded,
                  ),
                  StatCard(
                    title: 'Середня',
                    value: avg.toStringAsFixed(1),
                    icon: Icons.analytics_rounded,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          GlassPanel(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Профіль впливає на рекомендації',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    TechPill('Фото профілю'),
                    TechPill('AI memory'),
                    TechPill('Ratings'),
                    TechPill('Comments'),
                    TechPill('PostgreSQL'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => showEditProfileSheet(context, data),
            icon: const Icon(Icons.edit_rounded),
            label: const Text('Редагувати профіль і фото'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: data.onEditPreferences,
            icon: const Icon(Icons.tune_rounded),
            label: const Text('Переналаштувати смаки'),
          ),
        ],
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.name,
    required this.photoUrl,
    this.radius = 28,
  });

  final String name;
  final String photoUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl.trim().isNotEmpty;
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.blue,
      backgroundImage: hasPhoto ? NetworkImage(photoUrl.trim()) : null,
      child: hasPhoto
          ? null
          : Text(
              name.characters.first.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: radius * .62,
              ),
            ),
    );
  }
}

void showEditProfileSheet(BuildContext context, AppShell data) {
  final nameController = TextEditingController(text: data.userName);
  final photoController = TextEditingController(text: data.profilePhotoUrl);
  final bioController = TextEditingController(text: data.profileBio);
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: AppColors.panel,
    builder: (context) => SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 18,
          right: 18,
          top: 8,
          bottom: MediaQuery.of(context).viewInsets.bottom + 18,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Ім'я"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: photoController,
              decoration: const InputDecoration(
                labelText: 'Посилання на своє фото',
                hintText: 'https://...',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bioController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Про мій смак'),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: () {
                data.onUpdateProfile(
                  name: nameController.text,
                  photoUrl: photoController.text,
                  bio: bioController.text,
                );
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.check_rounded),
              label: const Text('Зберегти'),
            ),
          ],
        ),
      ),
    ),
  );
}

class MovieRail extends StatelessWidget {
  const MovieRail({
    super.key,
    required this.title,
    required this.subtitle,
    required this.movies,
    required this.data,
  });

  final String title;
  final String subtitle;
  final List<Movie> movies;
  final AppShell data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title, subtitle: subtitle),
        const SizedBox(height: 10),
        SizedBox(
          height: 255,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                PosterTile(movie: movies[index], data: data),
          ),
        ),
        const SizedBox(height: 22),
      ],
    );
  }
}

class PosterTile extends StatelessWidget {
  const PosterTile({super.key, required this.movie, required this.data});

  final Movie movie;
  final AppShell data;

  @override
  Widget build(BuildContext context) {
    final score = recommendationScore(
      movie,
      data.preferences,
      data.ratings,
      data.watched,
    );
    return SizedBox(
      width: 134,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openMovie(context, movie, data),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PosterArtwork(
              movie: movie,
              width: 134,
              height: 196,
              onTap: () => _openMovie(context, movie, data),
            ),
            const SizedBox(height: 8),
            Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            Text(
              '$score% match',
              style: TextStyle(color: Colors.white.withValues(alpha: .7)),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieListCard extends StatelessWidget {
  const MovieListCard({super.key, required this.movie, required this.data});

  final Movie movie;
  final AppShell data;

  @override
  Widget build(BuildContext context) {
    final score = recommendationScore(
      movie,
      data.preferences,
      data.ratings,
      data.watched,
    );
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openMovie(context, movie, data),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              PosterArtwork(
                movie: movie,
                width: 76,
                height: 112,
                compact: true,
                onTap: () => _openMovie(context, movie, data),
              ),
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
                    Text(
                      '${movie.year} • ${movie.genres.join(', ')}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text('$score% match • ${movie.mood}'),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => data.onFavorite(movie),
                icon: Icon(
                  data.favorites.contains(movie.id)
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                ),
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
    required this.data,
  });

  final Movie movie;
  final AppShell data;

  @override
  Widget build(BuildContext context) {
    final score = recommendationScore(
      movie,
      data.preferences,
      data.ratings,
      data.watched,
    );
    final isFavorite = data.favorites.contains(movie.id);
    final isLater = data.watchLater.contains(movie.id);
    final isWatched = data.watched.contains(movie.id);
    final rating = data.ratings[movie.id];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 448,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      movie.palette[1].withValues(alpha: .92),
                      AppColors.ink,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Center(
                    child: Hero(
                      tag: 'poster-${movie.id}',
                      child: PosterArtwork(
                        movie: movie,
                        width: 232,
                        height: 326,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      height: 1.02,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${movie.year} • ${movie.maturity} • ${movie.runtime} • $score% match',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .76),
                    ),
                  ),
                  const SizedBox(height: 14),
                  MatchMeter(value: score, label: 'Personal match'),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FilledButton.icon(
                        onPressed: () => openTrailer(context, movie),
                        icon: const Icon(Icons.play_circle_rounded),
                        label: const Text('Дивитись трейлер'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => data.onFavorite(movie),
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                        ),
                        label: Text(isFavorite ? 'В обраному' : 'Обране'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => data.onWatchLater(movie),
                        icon: Icon(
                          isLater
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                        ),
                        label: Text(isLater ? 'Заплановано' : 'Пізніше'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => data.onWatched(movie),
                        icon: Icon(
                          isWatched
                              ? Icons.visibility_rounded
                              : Icons.visibility_outlined,
                        ),
                        label: Text(isWatched ? 'Переглянуто' : 'Переглянути'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  TrailerPanel(movie: movie),
                  const SizedBox(height: 18),
                  GlassPanel(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.psychology_alt_rounded,
                          color: AppColors.amber,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'AI hook: ${movie.aiHook}\n\n${recommendationReason(movie, data.preferences)}',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(movie.description),
                  const SizedBox(height: 18),
                  InfoGrid(movie: movie),
                  const SizedBox(height: 18),
                  SectionHeader(
                    title: 'Фішки фільму',
                    subtitle: movie.bestMoment,
                  ),
                  const SizedBox(height: 10),
                  for (final fact in movie.facts)
                    FeatureRow(icon: Icons.check_circle_rounded, text: fact),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final tag in movie.vibeTags)
                        Chip(
                          avatar: const Icon(
                            Icons.auto_awesome_rounded,
                            size: 16,
                          ),
                          label: Text(tag),
                        ),
                      for (final genre in movie.genres)
                        Chip(
                          avatar: Icon(_genreIcon(genre), size: 16),
                          label: Text(genre),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text('Актори', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final actor in movie.actors)
                        Chip(label: Text(actor)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text('Оцінка', style: Theme.of(context).textTheme.titleLarge),
                  AnimatedRatingBar(
                    value: rating ?? 0,
                    onRate: (value) => data.onRate(movie, value),
                  ),
                  const SizedBox(height: 18),
                  MovieComments(movie: movie, data: data),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedRatingBar extends StatefulWidget {
  const AnimatedRatingBar({
    super.key,
    required this.value,
    required this.onRate,
  });

  final int value;
  final ValueChanged<int> onRate;

  @override
  State<AnimatedRatingBar> createState() => _AnimatedRatingBarState();
}

class _AnimatedRatingBarState extends State<AnimatedRatingBar> {
  int pulse = 0;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          for (var value = 1; value <= 5; value++)
            AnimatedScale(
              scale: pulse == value ? 1.34 : 1,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutBack,
              child: IconButton(
                tooltip: '$value / 5',
                onPressed: () {
                  setState(() => pulse = value);
                  widget.onRate(value);
                  Future<void>.delayed(const Duration(milliseconds: 220), () {
                    if (mounted) setState(() => pulse = 0);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Оцінка збережена: $value/5'),
                      duration: const Duration(milliseconds: 900),
                    ),
                  );
                },
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    value <= widget.value
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    key: ValueKey('${widget.value}-$value'),
                    color: AppColors.amber,
                    size: 32,
                  ),
                ),
              ),
            ),
          const Spacer(),
          Text(
            widget.value == 0 ? 'ще без оцінки' : '${widget.value}/5',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class MovieComments extends StatefulWidget {
  const MovieComments({super.key, required this.movie, required this.data});

  final Movie movie;
  final AppShell data;

  @override
  State<MovieComments> createState() => _MovieCommentsState();
}

class _MovieCommentsState extends State<MovieComments> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comments = widget.data.comments[widget.movie.id] ?? const <String>[];
    return GlassPanel(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.mode_comment_rounded, color: AppColors.mint),
              const SizedBox(width: 8),
              Text('Коментарі', style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            minLines: 2,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Напиши враження після перегляду',
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: () {
                widget.data.onComment(widget.movie, controller.text);
                controller.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Коментар додано і передано AI-профілю'),
                    duration: Duration(milliseconds: 1100),
                  ),
                );
              },
              icon: const Icon(Icons.send_rounded),
              label: const Text('Додати'),
            ),
          ),
          const SizedBox(height: 12),
          if (comments.isEmpty)
            Text(
              'Поки немає коментарів. Перший коментар одразу вплине на AI-рекомендації.',
              style: TextStyle(color: Colors.white.withValues(alpha: .68)),
            )
          else
            for (final comment in comments)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.panelHigh.withValues(alpha: .72),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(comment),
              ),
        ],
      ),
    );
  }
}

class PosterArtwork extends StatefulWidget {
  const PosterArtwork({
    super.key,
    required this.movie,
    required this.width,
    required this.height,
    this.compact = false,
    this.onTap,
  });

  final Movie movie;
  final double width;
  final double height;
  final bool compact;
  final VoidCallback? onTap;

  @override
  State<PosterArtwork> createState() => _PosterArtworkState();
}

class _PosterArtworkState extends State<PosterArtwork> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => pressed = true),
      onTapCancel: () => setState(() => pressed = false),
      onTapUp: (_) => setState(() => pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: pressed ? .965 : 1,
        duration: const Duration(milliseconds: 140),
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.compact ? 10 : 18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.movie.palette,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.movie.palette[1].withValues(alpha: .42),
                blurRadius: widget.compact ? 14 : 30,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.compact ? 10 : 18),
            child: Image.asset(widget.movie.poster, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}

class CollectionList extends StatelessWidget {
  const CollectionList({
    super.key,
    required this.movies,
    required this.data,
    required this.empty,
  });

  final List<Movie> movies;
  final AppShell data;
  final String empty;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return EmptyState(text: empty);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final movie in movies) MovieListCard(movie: movie, data: data),
      ],
    );
  }
}

class StatsStrip extends StatelessWidget {
  const StatsStrip({super.key, required this.data});

  final AppShell data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatMini(label: 'Обране', value: '${data.favorites.length}'),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StatMini(label: 'Пізніше', value: '${data.watchLater.length}'),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StatMini(
            label: 'Переглянуто',
            value: '${data.watched.length}',
          ),
        ),
      ],
    );
  }
}

class StatMini extends StatelessWidget {
  const StatMini({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          Text(label, textAlign: TextAlign.center),
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
            Icon(icon, color: AppColors.coral),
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

class PremiumBackdrop extends StatelessWidget {
  const PremiumBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF02040A), AppColors.ink, Color(0xFF101015)],
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(child: CustomPaint(painter: BackdropPainter())),
        ),
        child,
      ],
    );
  }
}

class BackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = Colors.white.withValues(alpha: .035)
      ..strokeWidth = 1.2;
    for (var i = -2; i < 12; i++) {
      final y = i * 82.0 + 24;
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 42), line);
    }
    final glow = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.blue.withValues(alpha: .26),
              AppColors.violet.withValues(alpha: .10),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * .78, 12),
              radius: size.width * .65,
            ),
          );
    canvas.drawRect(Offset.zero & size, glow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.panel.withValues(alpha: .78),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: .10)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x99000000),
            blurRadius: 34,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: child,
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, required this.subtitle});

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
        Text(
          subtitle,
          style: TextStyle(color: Colors.white.withValues(alpha: .68)),
        ),
      ],
    );
  }
}

class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, this.compact = false, this.center = false});

  final bool compact;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final logo = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 28 : 36,
          height: compact ? 28 : 36,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.blue, AppColors.mint],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.local_movies_rounded,
            color: Colors.white,
            size: compact ? 17 : 21,
          ),
        ),
        const SizedBox(width: 9),
        Text(
          'CineMind',
          style: TextStyle(
            fontSize: compact ? 21 : 30,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
    return center ? Center(child: logo) : logo;
  }
}

class TechPills extends StatelessWidget {
  const TechPills({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: const [
        TechPill('Flutter'),
        TechPill('FastAPI'),
        TechPill('PostgreSQL'),
        TechPill('AI'),
      ],
    );
  }
}

class TechPill extends StatelessWidget {
  const TechPill(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}

class TasteCard extends StatelessWidget {
  const TasteCard({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final TasteOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? option.color.withValues(alpha: .18)
              : AppColors.panel.withValues(alpha: .82),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? option.color.withValues(alpha: .82)
                : Colors.white.withValues(alpha: .08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(option.icon, color: option.color),
                const Spacer(),
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.add_circle_outline_rounded,
                  color: selected
                      ? option.color
                      : Colors.white.withValues(alpha: .45),
                ),
              ],
            ),
            const Spacer(),
            Text(
              option.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 3),
            Text(
              option.subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: .68),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MatchMeter extends StatelessWidget {
  const MatchMeter({super.key, required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
              const Spacer(),
              Text('$value%', style: const TextStyle(color: AppColors.jade)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: value / 100,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: .08),
              valueColor: const AlwaysStoppedAnimation(AppColors.jade),
            ),
          ),
        ],
      ),
    );
  }
}

class TrailerPanel extends StatelessWidget {
  const TrailerPanel({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => openTrailer(context, movie),
      child: GlassPanel(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  gradient: LinearGradient(colors: movie.palette),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(child: CustomPaint(painter: DotsPainter())),
                    const Center(
                      child: CircleAvatar(
                        radius: 34,
                        backgroundColor: AppColors.blue,
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: AppColors.ink,
                          size: 40,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 14,
                      child: Text(
                        movie.trailerTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                movie.trailerUrl,
                style: TextStyle(color: Colors.white.withValues(alpha: .68)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoGrid extends StatelessWidget {
  const InfoGrid({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.9,
      children: [
        InfoTile(
          icon: Icons.movie_creation_rounded,
          label: 'Режисер',
          value: movie.director,
        ),
        InfoTile(
          icon: Icons.apartment_rounded,
          label: 'Студія',
          value: movie.studio,
        ),
        InfoTile(
          icon: Icons.language_rounded,
          label: 'Мова',
          value: movie.language,
        ),
        InfoTile(icon: Icons.mood_rounded, label: 'Настрій', value: movie.mood),
      ],
    );
  }
}

class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.jade),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .62),
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureRow extends StatelessWidget {
  const FeatureRow({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.jade, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class DotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: .16);
    for (var row = 0; row < 6; row++) {
      for (var col = 0; col < 7; col++) {
        final radius = 3.0 + row * .8;
        canvas.drawCircle(
          Offset(size.width - 118 + col * 16, 26 + row * 18),
          radius,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void showTrailerSheet(BuildContext context, Movie movie) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: AppColors.panel,
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TrailerPanel(movie: movie),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () => openTrailer(context, movie),
            icon: const Icon(Icons.open_in_new_rounded),
            label: const Text('Відкрити трейлер на YouTube'),
          ),
          const SizedBox(height: 12),
          Text('Trailer link', style: Theme.of(context).textTheme.titleMedium),
          SelectableText(movie.trailerUrl),
        ],
      ),
    ),
  );
}

Future<void> openTrailer(BuildContext context, Movie movie) async {
  final opened = await openExternalUrl(movie.trailerUrl);
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Посилання на трейлер: ${movie.trailerUrl}')),
    );
  }
}

void _openMovie(BuildContext context, Movie movie, AppShell data) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => MovieDetailsScreen(movie: movie, data: data),
    ),
  );
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
  score += ratings[movie.id] != null ? ratings[movie.id]! * 3 : 0;
  score -= watched.contains(movie.id) ? 10 : 0;
  return score.clamp(0, 99);
}

String recommendationReason(Movie movie, Set<String> preferences) {
  final matches = movie.genres.where(preferences.contains).toList();
  if (matches.isEmpty) {
    return 'Фільм розширює стрічку за настроєм: ${movie.mood}.';
  }
  return 'Збіг за інтересами: ${matches.join(', ')}. Додатково враховано рік, оцінки та перегляди.';
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
