part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
  @override
  List<Object?> get props => [];
}

class FavoriteWatch extends FavoriteEvent {
  const FavoriteWatch();
}

class FavoriteAdd extends FavoriteEvent {
  final MovieEntity movie;
  const FavoriteAdd(this.movie);
  @override
  List<Object?> get props => [movie.id];
}

class FavoriteRemove extends FavoriteEvent {
  final int movieId;
  const FavoriteRemove(this.movieId);
  @override
  List<Object?> get props => [movieId];
}

// Internal event
class _FavoritesUpdated extends FavoriteEvent {
  final List<MovieEntity> movies;
  const _FavoritesUpdated(this.movies);
  @override
  List<Object?> get props => [movies];
}
