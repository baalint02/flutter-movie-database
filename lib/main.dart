import 'package:film_database/film_repository.dart';
import 'package:film_database/local_db.dart';
import 'package:film_database/view/search_page.dart';
import 'package:film_database/view/watchlist_page.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => FilmRepository()),
        Provider(create: (_) => LocalDatabase()),
      ],
      child: const FilmDatabaseApp(),
    ),
  );
}

class FilmDatabaseApp extends StatefulWidget {
  const FilmDatabaseApp({super.key});

  @override
  State<FilmDatabaseApp> createState() => _FilmDatabaseAppState();
}

class _FilmDatabaseAppState extends State<FilmDatabaseApp> {
  int _selectedPageIdx = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [const SearchPage(), const WatchlistPage()];

    return MaterialApp(
      title: 'FilmDatabase',
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.dark,
        ),
      ),
      home: Scaffold(
        body: pages[_selectedPageIdx],
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (value) =>
              setState(() => _selectedPageIdx = value),
          selectedIndex: _selectedPageIdx,
          destinations: const [
            NavigationDestination(
              label: "Search",
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search),
            ),
            NavigationDestination(
              label: "Watchlist",
              icon: Icon(Icons.local_movies_outlined),
              selectedIcon: Icon(Icons.local_movies),
            ),
          ],
        ),
      ),
    );
  }
}
