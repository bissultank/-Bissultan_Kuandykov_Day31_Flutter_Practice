import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../home/domain/entity/movie_detail_entity.dart';
import '../../../home/domain/repository/movie_repository.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final MovieRepository _repository;

  DetailBloc(this._repository) : super(DetailInitial()) {
    on<DetailFetch>(_onFetch);
  }

  Future<void> _onFetch(DetailFetch event, Emitter<DetailState> emit) async {
    emit(DetailLoading());
    try {
      final detail = await _repository.getMovieDetail(event.movieId);
      emit(DetailLoaded(detail));
    } catch (e) {
      emit(DetailError(e.toString()));
    }
  }
}
