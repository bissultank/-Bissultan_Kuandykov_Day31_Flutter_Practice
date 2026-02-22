import '../entity/movie_entity.dart';
import '../entity/movie_detail_entity.dart';

abstract class MovieRepository {
  /// genreIds map: key = genre name, value = unused (kept for interface compat)
  Future<Map<String, List<MovieEntity>>> getMoviesByGenres(
    Map<String, int> genreIds,
  );

  Future<MovieDetailEntity> getMovieDetail(int movieId);
}
