import 'package:film_database/data_model.dart';
import 'package:film_database/film_repository.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class FilmDetailsPage extends StatelessWidget {
  final int filmId;

  FilmDetailsPage({super.key, required this.filmId});

  //todo
  final FilmRepository repository = FilmRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.symmetric(horizontal: 12),
        actions: [
          IconButton(onPressed: () => {}, icon: Icon(Icons.library_add)),
        ],
      ),
      body: FutureBuilder(
        future: repository.getFilmDetails(id: filmId),
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
