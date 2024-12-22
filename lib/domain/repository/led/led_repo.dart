import '../../entities/led/RGB.dart';

abstract class LedRepository {
  Future<void> setDataLedAnalog({required double analog});

  Future<void> setDataLedDigital({required bool digital});

  Future<void> setDataLedAirCondition({required bool digitalAir});

  Future<void> setDataLedRGB({required RGBEntity rgb});

}
