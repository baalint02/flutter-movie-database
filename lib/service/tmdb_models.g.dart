// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResponse _$SearchResponseFromJson(Map<String, dynamic> json) =>
    SearchResponse(
      (json['page'] as num).toInt(),
      (json['total_pages'] as num).toInt(),
      (json['results'] as List<dynamic>)
          .map((e) => SearchResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) => SearchResult(
  (json['id'] as num).toInt(),
  json['title'] as String,
  json['release_date'] as String,
  json['poster_path'] as String?,
);

MovieDetailsResponse _$MovieDetailsResponseFromJson(
  Map<String, dynamic> json,
) => MovieDetailsResponse(
  json['title'] as String,
  json['overview'] as String?,
  (json['runtime'] as num?)?.toInt(),
  (json['genres'] as List<dynamic>?)
      ?.map((e) => Genre.fromJson(e as Map<String, dynamic>))
      .toList(),
  json['poster_path'] as String?,
  json['backdrop_path'] as String?,
  json['release_date'] as String?,
);

Genre _$GenreFromJson(Map<String, dynamic> json) =>
    Genre((json['id'] as num).toInt(), json['name'] as String);
