import 'package:film_database/configuration.dart';
import 'package:film_database/data_model.dart';
import 'package:film_database/service/tmdb_service.dart';

class FilmRepository {
  final _tmdbService = TMDBService(apiKey: Configuration.tmdbApiKey);

  Future<List<Film>> searchFilms({required String query}) async {
    final response = await _tmdbService.getSearchResults(query: query);
    final results = response.results.map((result) {
      final year = result.release_date.isNotEmpty
          ? int.tryParse(result.release_date.split('-')[0])
          : null;

      final posterUrl = result.poster_path != null
          ? _tmdbService.getPosterUrlSmall(result.poster_path!)
          : null;

      return Film(
        id: result.id,
        title: result.title,
        year: year,
        posterUrl: posterUrl,
      );
    }).toList();
    return results;
  }

  Future<FilmWithDetails> getFilmDetails({required int id}) async {
    final response = await _tmdbService.getMovieDetails(id: id);
    final year = response.release_date != null || response.release_date!.isEmpty
        ? int.tryParse(response.release_date!.split('-')[0])
        : null;

    final posterUrl = response.poster_path != null
        ? _tmdbService.getPosterUrlLarge(response.poster_path!)
        : null;

    final backdropUrl = response.backdrop_path != null
        ? _tmdbService.getBackdropUrl(response.poster_path!)
        : null;

    final genres = response.genres?.map((genre) => genre.name).join(", ");

    return FilmWithDetails(
      film: Film(
        id: id,
        title: response.title,
        year: year,
        posterUrl: posterUrl,
      ),
      overview: response.overview,
      runtime: response.runtime,
      genres: genres,
      posterUrl: posterUrl,
      backdropUrl: backdropUrl,
    );
  }
}
