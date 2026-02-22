import '../../../home/domain/entity/movie_entity.dart';

abstract class FavoriteRepository {
  Stream<List<MovieEntity>> watchFavorites();
  Future<void> addFavorite(MovieEntity movie);
  Future<void> removeFavorite(int movieId);
  Future<bool> isFavorite(int movieId);
}
