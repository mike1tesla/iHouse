import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_iot/domain/entities/led/RGB.dart';
import 'package:smart_iot/domain/usecase/led/setDataLedDigital.dart';
import 'package:smart_iot/domain/usecase/led/setDataLedRGB.dart';

import '../../../service_locator.dart';

part 'set_led_living_state.dart';

class SetLedLivingCubit extends Cubit<SetLedLivingState> {
  SetLedLivingCubit()
      : super(const SetLedLivingState(
          isSwitched: false,
          brightness: 0,
          numbersLed: 0,
          red: 0,
          green: 0,
          blue: 0,
        ));

  Future<void> setDataLedDigital({required bool digital}) async {
    try {
      // Gọi use case để gửi dữ liệu
      await sl<SetDataLedDigitalUseCase>().call(params: digital);
      // Cập nhật trạng thái mới
      emit(state.copyWith(isSwitched: digital));
    } catch (e) {
      print('Error setting led digital: $e');
    }
  }

  Future<void> setDataLedRGB({required RGBEntity rgb}) async {
    try {
      // Gọi use case để gửi dữ liệu
      await sl<SetDataLedRGBUseCase>().call(params: rgb);
      emit(state.copyWith(
        brightness: rgb.brightness,
        numbersLed: rgb.numbersLed,
        red: rgb.red,
        green: rgb.green,
        blue: rgb.blue,
      ));
    } catch (e) {
      print('Error setting led digital: $e');
    }
  }

  void updateBrightness(double value) {
    emit(state.copyWith(brightness: value));
  }

  void updateNumbersLed(double value) {
    emit(state.copyWith(numbersLed: value));
  }

  void updateColors({double? red, double? green, double? blue}) {
    emit(state.copyWith(
      red: red ?? state.red,
      green: green ?? state.green,
      blue: blue ?? state.blue,
    ));
  }
}
