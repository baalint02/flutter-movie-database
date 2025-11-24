import 'package:film_database/data_model.dart';
import 'package:film_database/local_db.dart';
import 'package:film_database/view/film_details.dart';
import 'package:film_database/view/film_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  late LocalDatabase _localDb;
  late Future<List<Film>> _watchlistFuture;

  @override
  void initState() {
    super.initState();
    _localDb = context.read<LocalDatabase>();
    _watchlistFuture = _localDb.getWatchlist();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          crossAxisAlignment: .center,
          spacing: 0.0,
          children: [
            Padding(
              padding: const .only(top: 8),
              child: Text(
                "Watchlist",
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(fontWeight: .w700),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder(
                future: _watchlistFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final films = snapshot.data!;

                    if (films.isEmpty) {
                      return Center(child: Text("No films added yet."));
                    }

                    return FilmListWidget(
                      films: films,
                      onTapCallback: (film) async {
                        _openFilmDetailsPage(context, film.id);
                      },
                    );
                  }
                  if (snapshot.hasError) {
                    debugPrint(snapshot.error.toString());
                    return Center(child: Text("Error loading watchlist."));
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFilmDetailsPage(BuildContext context, int filmId) async {
    await Navigator.push(
      context,
      CupertinoPageRoute<void>(
        builder: (context) => FilmDetailsPage(filmId: filmId),
      ),
    );
    setState(() {
      _watchlistFuture = _localDb.getWatchlist();
    });
  }
}
