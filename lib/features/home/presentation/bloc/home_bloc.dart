import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entity/movie_entity.dart';
import '../../domain/repository/movie_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

// TVMaze genre names (case-sensitive, must match exactly)
const _genres = {
  'Drama': 0,
  'Comedy': 0,
  'Action': 0,
  'Horror': 0,
  'Thriller': 0,
  'Romance': 0,
};

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MovieRepository _repository;

  HomeBloc(this._repository) : super(HomeInitial()) {
    on<HomeFetchMovies>(_onFetchMovies);
  }

  Future<void> _onFetchMovies(
    HomeFetchMovies event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final movies = await _repository.getMoviesByGenres(_genres);
      // Remove empty genres
      movies.removeWhere((_, list) => list.isEmpty);
      emit(HomeLoaded(movies));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
