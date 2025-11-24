// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'tmdb_models.g.dart';

@JsonSerializable(createToJson: false)
class SearchResponse {
  final int page;
  final int total_pages;
  final List<SearchResult> results;

  SearchResponse(this.page, this.total_pages, this.results);

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class SearchResult {
  final int id;
  final String title;
  final String release_date;
  final String? poster_path;

  SearchResult(this.id, this.title, this.release_date, this.poster_path);

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);
}

@JsonSerializable(createToJson: false)
class MovieDetailsResponse {
  final String title;
  final String? overview;
  final int? runtime;
  final String? release_date;
  final List<Genre>? genres;
  final String? poster_path;
  final String? backdrop_path;

  MovieDetailsResponse(
    this.title,
    this.overview,
    this.runtime,
    this.genres,
    this.poster_path,
    this.backdrop_path,
    this.release_date,
  );

  factory MovieDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class Genre {
  final int id;
  final String name;

  Genre(this.id, this.name);

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);
}
