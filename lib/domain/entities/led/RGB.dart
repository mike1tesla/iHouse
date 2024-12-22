
import '../../../data/models/led/RGB_model.dart';

class RGBEntity {
  final double brightness;
  final double numbersLed;
  final double red;
  final double green;
  final double blue;

  const RGBEntity({
    required this.brightness,
    required this.numbersLed,
    required this.red,
    required this.green,
    required this.blue,
  });
}

extension RGBEntityX on RGBEntity {
  RGBModel toModel(){
    return RGBModel(
      brightness: brightness,
      numbersLed: numbersLed,
      red: red,
      green: green,
      blue: blue,
    );
  }
}