import 'package:smart_iot/domain/entities/lockdoor/lockdoor.dart';

abstract class LatestLockdoorState {}

class LatestLockdoorInitial extends LatestLockdoorState {}

class LatestLockdoorLoading extends LatestLockdoorState {}

class LatestLockdoorLoaded extends LatestLockdoorState {
  final LockdoorEntity? latestLockdoor;

  LatestLockdoorLoaded(this.latestLockdoor);
}

class LatestLockdoorError extends LatestLockdoorState {
  final String message;

  LatestLockdoorError(this.message);
}
