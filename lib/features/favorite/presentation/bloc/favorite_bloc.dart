import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../home/domain/entity/movie_entity.dart';
import '../../domain/repository/favorite_repository.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository _repository;
  StreamSubscription<List<MovieEntity>>? _subscription;

  FavoriteBloc(this._repository) : super(FavoriteInitial()) {
    on<FavoriteWatch>(_onWatch);
    on<FavoriteAdd>(_onAdd);
    on<FavoriteRemove>(_onRemove);
    on<_FavoritesUpdated>(_onUpdated);
  }

  Future<void> _onWatch(FavoriteWatch event, Emitter<FavoriteState> emit) async {
    await _subscription?.cancel();
    _subscription = _repository.watchFavorites().listen((movies) {
      add(_FavoritesUpdated(movies));
    });
  }

  void _onUpdated(_FavoritesUpdated event, Emitter<FavoriteState> emit) {
    emit(FavoriteLoaded(event.movies));
  }

  Future<void> _onAdd(FavoriteAdd event, Emitter<FavoriteState> emit) async {
    await _repository.addFavorite(event.movie);
  }

  Future<void> _onRemove(FavoriteRemove event, Emitter<FavoriteState> emit) async {
    await _repository.removeFavorite(event.movieId);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
