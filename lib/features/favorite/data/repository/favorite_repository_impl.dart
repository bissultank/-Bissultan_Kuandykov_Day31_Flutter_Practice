import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../home/domain/entity/movie_entity.dart';
import '../../domain/repository/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final AppDatabase _db;

  FavoriteRepositoryImpl(this._db);

  @override
  Stream<List<MovieEntity>> watchFavorites() {
    return _db.watchAllFavorites().map(
          (rows) => rows
              .map((r) => MovieEntity(
                    id: r.id,
                    title: r.title,
                    bannerUrl: r.bannerUrl,
                    genre: r.genre,
                  ))
              .toList(),
        );
  }

  @override
  Future<void> addFavorite(MovieEntity movie) {
    return _db.addFavorite(
      FavoritesCompanion(
        id: Value(movie.id),
        title: Value(movie.title),
        bannerUrl: Value(movie.bannerUrl),
        genre: Value(movie.genre),
      ),
    );
  }

  @override
  Future<void> removeFavorite(int movieId) {
    return _db.removeFavorite(movieId);
  }

  @override
  Future<bool> isFavorite(int movieId) {
    return _db.isFavorite(movieId);
  }
}
