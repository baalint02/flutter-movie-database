import 'package:film_database/data_model.dart';
import 'package:film_database/film_repository.dart';
import 'package:film_database/local_db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class FilmDetailsPage extends StatefulWidget {
  final int filmId;

  const FilmDetailsPage({super.key, required this.filmId});

  @override
  State<FilmDetailsPage> createState() => _FilmDetailsPageState();
}

class _FilmDetailsPageState extends State<FilmDetailsPage> {
  late final LocalDatabase _localDb;
  late final Future<FilmWithDetails> _filmDetailsFuture;
  late final Future<bool> _initialIsInWatchlistFuture;

  bool? _isInWatchlist;

  @override
  void initState() {
    super.initState();
    final repository = context.read<FilmRepository>();
    _filmDetailsFuture = repository.getFilmDetails(id: widget.filmId);

    _localDb = context.read<LocalDatabase>();
    _initialIsInWatchlistFuture = _localDb.isInWatchlist(widget.filmId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([_filmDetailsFuture, _initialIsInWatchlistFuture]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final FilmWithDetails filmData = snapshot.data![0] as FilmWithDetails;
          final bool initialIsInWatchlist = snapshot.data![1] as bool;

          return Scaffold(
            appBar: AppBar(
              actionsPadding: EdgeInsets.symmetric(horizontal: 12),
              actions: [
                _buildWatchlistIconButton(
                  added: _isInWatchlist ?? initialIsInWatchlist,
                  addOperation: () => _localDb.addToWatchlist(filmData.film),
                  removeOperation: () =>
                      _localDb.removeFromWatchlist(widget.filmId),
                ),
              ],
            ),
            body: _FilmDetails(filmData),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text("Error loading film details")),
          );
        } else {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _buildWatchlistIconButton({
    required bool added,
    required Future<void> Function() addOperation,
    required Future<void> Function() removeOperation,
  }) {
    if (added) {
      return IconButton(
        icon: Icon(Icons.bookmark_added),
        onPressed: () async {
          await removeOperation();
          if (!mounted) return;
          setState(() {
            _isInWatchlist = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Removed from watchlist."),
                duration: Duration(milliseconds: 1000),
              ),
            );
          });
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.bookmark_outline),
        onPressed: () async {
          await addOperation();
          if (!mounted) return;
          setState(() {
            _isInWatchlist = true;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Added to watchlist."),
                duration: Duration(milliseconds: 1000),
              ),
            );
          });
        },
      );
    }
  }
}

class _FilmDetails extends StatelessWidget {
  final FilmWithDetails filmData;

  const _FilmDetails(this.filmData);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 22, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              filmData.film.title,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                letterSpacing: -1.0,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "${filmData.film.year} • ${filmData.genres}  • ${filmData.runtime} min",
            ),

            SizedBox(height: 16),

            Row(
              spacing: 16,
              children: [
                _buildPoster(),
                Expanded(
                  child: Text(
                    filmData.overview ?? "No description.",
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),

            // SizedBox(height: 16),

            // Text(
            //   "Francis Ford Coppola",
            //   style: Theme.of(
            //     context,
            //   ).textTheme.titleMedium!.copyWith(letterSpacing: 0.0),
            // ),
            // Text("Director, Screenplay"),

            // SizedBox(height: 24),

            // Text(
            //   "Mario Puzo",
            //   style: Theme.of(
            //     context,
            //   ).textTheme.titleMedium!.copyWith(letterSpacing: 0.0),
            // ),
            // Text("Screenplay"),
          ],
        ),
      ),
    );
  }

  Widget _buildPoster() {
    final posterUrl = filmData.posterUrl;

    if (posterUrl != null) {
      return FadeInImage(
        fadeInDuration: Durations.short4,
        width: 120,
        placeholder: MemoryImage(kTransparentImage),
        image: NetworkImage(posterUrl),
      );
    } else {
      return Image(height: 80, image: MemoryImage(kTransparentImage));
    }
  }
}
