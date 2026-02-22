part of 'detail_bloc.dart';

abstract class DetailState extends Equatable {
  const DetailState();
  @override
  List<Object?> get props => [];
}

class DetailInitial extends DetailState {}

class DetailLoading extends DetailState {}

class DetailLoaded extends DetailState {
  final MovieDetailEntity detail;
  const DetailLoaded(this.detail);
  @override
  List<Object?> get props => [detail];
}

class DetailError extends DetailState {
  final String message;
  const DetailError(this.message);
  @override
  List<Object?> get props => [message];
}
