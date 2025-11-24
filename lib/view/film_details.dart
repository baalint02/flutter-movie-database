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
  late final Future<FilmWithDetails> _filmDetailsFuture;

  @override
  void initState() {
    super.initState();
    final repository = context.read<FilmRepository>();
    _filmDetailsFuture = repository.getFilmDetails(id: widget.filmId);
  }

  @override
  Widget build(BuildContext context) {
    final repository = context.read<FilmRepository>();

    return FutureBuilder(
      future: _filmDetailsFuture,
      builder: (context, asyncSnapshot) {
        return Scaffold(
          appBar: AppBar(
            actionsPadding: EdgeInsets.symmetric(horizontal: 12),
            actions: [
              // FutureBuilder(child),
              IconButton(onPressed: () => {}, icon: Icon(Icons.library_add)),
            ],
          ),
          body: FutureBuilder(
            future: repository.getFilmDetails(id: widget.filmId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _FilmDetails(snapshot.data!);
              } else if (snapshot.hasError) {
                return Center(child: Text("Error loading film data"));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
      },
    );
  }
}

class _WatchListButton extends StatefulWidget {
  final int filmId;

  const _WatchListButton({required this.filmId});

  @override
  State<_WatchListButton> createState() => __WatchListButtonState();
}

class __WatchListButtonState extends State<_WatchListButton> {
  late final Future<bool> _isInWatchlistFuture;

  @override
  void initState() {
    super.initState();
    final db = context.read<LocalDatabase>();
    _isInWatchlistFuture = db.isInWatchlist(widget.filmId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isInWatchlistFuture,
      builder: (context, snapshot) {
        final isInWatchlist = snapshot.data;
        if (isInWatchlist == null) {
          return const IconButton(
            onPressed: null,
            icon: Icon(Icons.library_add),
          );
        }

        if (isInWatchlist) {
          return IconButton(
            onPressed: () {
              // localDb.removeFromWatchlist(filmId);
            },
            icon: Icon(Icons.library_add_check),
          );
        }

        return IconButton(
          onPressed: () {
            // localDb.removeFromWatchlist(filmId);
          },
          icon: Icon(Icons.library_add),
        );
      },
    );
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
            //   style: Theme.of(context).textTheme.titleMedium!.copyWith(
            //     fontWeight: .bold,
            //     letterSpacing: 0.0,
            //   ),
            // ),
            // Text("Director, Screenplay"),

            // SizedBox(height: 16),

            // Text(
            //   "Mario Puzo",
            //   style: Theme.of(context).textTheme.titleMedium!.copyWith(
            //     fontWeight: .bold,
            //     letterSpacing: 0.0,
            //   ),
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
