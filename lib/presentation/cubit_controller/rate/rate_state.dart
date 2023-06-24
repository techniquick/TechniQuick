part of 'rate_cubit.dart';

abstract class RateState extends Equatable {
  const RateState();

  @override
  List<Object> get props => [];
}

class RateInitial extends RateState {}

class RateSuccess extends RateState {}

class RateLoading extends RateState {}

class RateError extends RateState {
  const RateError({required this.message});
  final String message;
}
