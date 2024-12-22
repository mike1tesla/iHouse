import 'package:smart_iot/core/usecase/usecase.dart';
import 'package:smart_iot/domain/entities/led/RGB.dart';
import 'package:smart_iot/domain/repository/led/led_repo.dart';

import '../../../service_locator.dart';

class SetDataLedRGBUseCase implements UseCase<void, RGBEntity> {
  @override
  Future<void> call({RGBEntity? params}) async {
    return await sl<LedRepository>().setDataLedRGB(rgb: params!);
  }
}