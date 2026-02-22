part of 'detail_bloc.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();
  @override
  List<Object?> get props => [];
}

class DetailFetch extends DetailEvent {
  final int movieId;
  const DetailFetch(this.movieId);
  @override
  List<Object?> get props => [movieId];
}
