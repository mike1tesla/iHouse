import 'package:smart_iot/data/data_source/led/led_firebase_database_service.dart';
import 'package:smart_iot/domain/entities/led/RGB.dart';
import 'package:smart_iot/domain/repository/led/led_repo.dart';

import '../../../service_locator.dart';

class LedRepositoryImpl extends LedRepository {
  @override
  Future<void> setDataLedAirCondition({required bool digitalAir}) async {
    return await sl<LedFirebaseDatabaseService>().setDataLedAirCondition(digitalAir: digitalAir);
  }

  @override
  Future<void> setDataLedAnalog({required double analog}) async {
    return await sl<LedFirebaseDatabaseService>().setDataLedAnalog(analog: analog);
  }

  @override
  Future<void> setDataLedDigital({required bool digital}) async {
    return await sl<LedFirebaseDatabaseService>().setDataLedDigital(digital: digital);
  }

  @override
  Future<void> setDataLedRGB({required RGBEntity rgb}) async {
    return await sl<LedFirebaseDatabaseService>().setDataLedRGB(rgbModel: rgb.toModel());
  }
}
