import 'package:dio/dio.dart';
import '../../domain/entity/movie_entity.dart';
import '../../domain/entity/movie_detail_entity.dart';
import '../../domain/repository/movie_repository.dart';
import '../model/movie_model.dart';
import '../model/movie_detail_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/ru_translator.dart';

class MovieRepositoryImpl implements MovieRepository {
  final ApiClient _apiClient;
  final RuTranslator _translator;

  MovieRepositoryImpl(this._apiClient, {RuTranslator? translator})
      : _translator = translator ?? RuTranslator();

  @override
  Future<Map<String, List<MovieEntity>>> getMoviesByGenres(
    Map<String, int> genreIds,
  ) async {
    // TVMaze: load multiple pages and group by genre
    final allShows = <Map<String, dynamic>>[];

    // Fetch first 3 pages (~60 shows)
    await Future.wait(
      List.generate(3, (page) async {
        try {
          final response = await _apiClient.dio.get<List<dynamic>>('/shows',
              queryParameters: {'page': page});
          final shows = response.data ?? [];
          allShows.addAll(shows.cast<Map<String, dynamic>>());
        } on DioException {
          // ignore page errors
        }
      }),
    );

    // Group by genre
    final result = <String, List<MovieEntity>>{};
    for (final genreName in genreIds.keys) {
      final movies = allShows
          .where((show) {
            final genres = show['genres'] as List<dynamic>? ?? [];
            return genres.contains(genreName);
          })
          .map((show) => MovieModel.fromJson(show))
          .where((m) => m.bannerUrl.isNotEmpty)
          .take(20)
          .toList();

      result[genreName] = await Future.wait(
        movies.map((m) async {
          final ruTitle = await _translator.translateToRu(m.title);
          return MovieEntity(
            id: m.id,
            title: ruTitle,
            bannerUrl: m.bannerUrl,
            genre: m.genre,
          );
        }),
      );
    }

    return result;
  }

  @override
  Future<MovieDetailEntity> getMovieDetail(int movieId) async {
    final results = await Future.wait([
      _apiClient.dio.get<Map<String, dynamic>>('/shows/$movieId'),
      _apiClient.dio.get<List<dynamic>>('/shows/$movieId/cast'),
    ]);

    final show = (results[0] as Response<Map<String, dynamic>>).data!;
    final cast = (results[1] as Response<List<dynamic>>).data ?? [];
    final detail = MovieDetailModel.fromShowAndCast(show, cast);

    final translatedTitle = await _translator.translateToRu(detail.title);
    final translatedOverview = await _translator.translateToRu(detail.overview);

    return MovieDetailEntity(
      id: detail.id,
      title: translatedTitle,
      overview: translatedOverview,
      voteAverage: detail.voteAverage,
      voteCount: detail.voteCount,
      releaseDate: detail.releaseDate,
      runtime: detail.runtime,
      genres: detail.genres,
      backdropPath: detail.backdropPath,
      posterPath: detail.posterPath,
      cast: detail.cast,
      backdrops: detail.backdrops,
    );
  }
}
