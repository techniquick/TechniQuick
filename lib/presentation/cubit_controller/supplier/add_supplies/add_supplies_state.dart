part of 'add_supplies_cubit.dart';

abstract class ControlSuppliesState {}

class ControlSuppliesInitial extends ControlSuppliesState {}

class ControlSuppliesSuccess extends ControlSuppliesState {}

class ControlSuppliesLoading extends ControlSuppliesState {}

class ControlSuppliesError extends ControlSuppliesState {
  final String message;
  ControlSuppliesError({required this.message});
}
