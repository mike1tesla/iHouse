part of 'lockdoor_cubit.dart';

abstract class LockdoorState {}

class LockdoorInitial extends LockdoorState {}

class LockdoorLoading extends LockdoorState {}

class LockdoorLoaded extends LockdoorState {
  final List<LockdoorEntity> lockdoors;

  LockdoorLoaded(this.lockdoors);
}

class LockdoorError extends LockdoorState {
  final String message;

  LockdoorError(this.message);
}
