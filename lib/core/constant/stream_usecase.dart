import 'package:equatable/equatable.dart';

abstract class StreamUseCase<Type, Params> {
  Stream<Type> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
