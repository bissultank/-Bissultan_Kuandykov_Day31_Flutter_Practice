part of 'favorite_bloc.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();
  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<MovieEntity> movies;
  const FavoriteLoaded(this.movies);
  @override
  List<Object?> get props => [movies];
}
