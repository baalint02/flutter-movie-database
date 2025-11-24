class Film {
  final int id;
  final String title;
  final int? year;
  final String? posterUrl;

  Film({
    required this.id,
    required this.title,
    required this.year,
    this.posterUrl,
  });
}

class FilmWithDetails {
  final Film film;
  final String? overview;
  final int? runtime;
  final String? genres;
  final String? posterUrl;
  final String? backdropUrl;

  FilmWithDetails({
    required this.film,
    required this.overview,
    required this.runtime,
    required this.genres,
    required this.posterUrl,
    required this.backdropUrl,
  });
}
