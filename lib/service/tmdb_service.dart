import 'package:dio/dio.dart';
import 'package:film_database/service/tmdb_models.dart';
import 'package:flutter/widgets.dart';

class TMDBService {
  final _dio = Dio();

  TMDBService({required String apiKey}) {
    _dio.options.baseUrl = "https://api.themoviedb.org/3/";
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers["Authorization"] = "Bearer $apiKey";
          options.headers["accept"] = "application/json";
          handler.next(options);
        },
      ),
    );
    _dio.interceptors.add(LogInterceptor());
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          debugPrint(error.message);
          handler.next(error);
        },
      ),
    );
  }

  String getPosterUrlSmall(String imagePath) =>
      "https://image.tmdb.org/t/p/w500$imagePath";

  String getPosterUrlLarge(String imagePath) =>
      "https://image.tmdb.org/t/p/w780$imagePath";

  String getBackdropUrl(String imagePath) =>
      "https://image.tmdb.org/t/p/w1280$imagePath";

  Future<SearchResponse> getSearchResults({required String query}) async {
    var response = await _dio.get(
      "search/movie",
      queryParameters: {"query": query},
    );
    return SearchResponse.fromJson(response.data);
  }

  Future<MovieDetailsResponse> getMovieDetails({required int id}) async {
    var response = await _dio.get("movie/$id");
    return MovieDetailsResponse.fromJson(response.data);
  }
}
