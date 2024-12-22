import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_iot/domain/usecase/led/setDataLedAirCondition.dart';

import '../../../domain/usecase/led/setDataLedAnalog.dart';
import '../../../service_locator.dart';
part 'bed_room_state.dart';

class BedRoomCubit extends Cubit<BedRoomState> {
  BedRoomCubit() : super(BedRoomState(isAirSwitched: false, currentValueAnalog: 0));

  Future<void> setDataLedAirCondition({required bool digitalAir}) async {
    try {
      await sl<SetDataLedAirConditionUseCase>().call(params: digitalAir);
      emit(state.copyWith(isAirSwitched: digitalAir));
    } catch (e) {
      print('Error setting Air Condition: $e');
    }
  }

  Future<void> setDataLedAnalog({required double analog}) async {
    try {
      await sl<SetDataLedAnalogUseCase>().call(params: analog);
      emit(state.copyWith(currentValueAnalog: analog));
    } catch (e) {
      print('Error setting Air Condition: $e');
    }
  }
}
