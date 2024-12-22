part of 'bed_room_cubit.dart';

class BedRoomState {
  bool isAirSwitched;
  double currentValueAnalog;

  BedRoomState({
    required this.isAirSwitched,
    required this.currentValueAnalog,
  });

  BedRoomState copyWith({
    bool? isAirSwitched,
    double? currentValueAnalog,
  }) {
    return BedRoomState(
      isAirSwitched: isAirSwitched ?? this.isAirSwitched,
      currentValueAnalog: currentValueAnalog ?? this.currentValueAnalog,
    );
  }
}
