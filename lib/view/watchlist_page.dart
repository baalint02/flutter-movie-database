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
  late final LocalDatabase _localDb;
  List<Film>? _films;
  bool error = false;

  @override
  void initState() {
    super.initState();
    _localDb = context.read<LocalDatabase>();

    _loadFilmsList();
  }

  Future<void> _loadFilmsList() async {
    try {
      final films = await _localDb.getWatchlist();
      if (!mounted) return;
      setState(() {
        _films = films;
      });
    } catch (e, st) {
      if (!mounted) return;
      debugPrint(e.toString());
      debugPrint(st.toString());
      setState(() => error = true);
    }
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
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final films = _films;
    if (films != null) {
      if (films.isEmpty) {
        return Center(child: Text("No films added yet."));
      }
      return FilmListDismissibleWidget(
        films: films,
        onTapCallback: (film) async {
          await _openFilmDetailsPage(context, film.id);
          _loadFilmsList();
        },
        onDismissedCallback: (index) {
          _localDb.removeFromWatchlist(films[index].id);
          setState(() => _films?.removeAt(index));
        },
      );
    } else if (error) {
      return Center(child: Text("Error loading watchlist."));
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Future<void> _openFilmDetailsPage(BuildContext context, int filmId) async {
    await Navigator.push(
      context,
      CupertinoPageRoute<void>(
        builder: (context) => FilmDetailsPage(filmId: filmId),
      ),
    );
  }
}
