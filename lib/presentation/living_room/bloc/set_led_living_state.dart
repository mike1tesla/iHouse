part of 'set_led_living_cubit.dart';

class SetLedLivingState {
  final bool isSwitched;
  final double brightness;
  final double numbersLed;
  final double red;
  final double green;
  final double blue;

  const SetLedLivingState({
    required this.isSwitched,
    required this.brightness,
    required this.numbersLed,
    required this.red,
    required this.green,
    required this.blue,
  });

  // Tạo một bản sao của state với các giá trị được cập nhật
  SetLedLivingState copyWith({
    bool? isSwitched,
    double? brightness,
    double? numbersLed,
    double? red,
    double? green,
    double? blue,
  }) {
    return SetLedLivingState(
      isSwitched: isSwitched ?? this.isSwitched,
      brightness: brightness ?? this.brightness,
      numbersLed: numbersLed ?? this.numbersLed,
      red: red ?? this.red,
      green: green ?? this.green,
      blue: blue ?? this.blue,
    );
  }
}

