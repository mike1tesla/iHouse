import 'package:smart_iot/core/usecase/usecase.dart';
import 'package:smart_iot/domain/repository/led/led_repo.dart';

import '../../../service_locator.dart';

class SetDataLedAirConditionUseCase implements UseCase<void, bool> {
  @override
  Future<void> call({bool? params}) async {
    return await sl<LedRepository>().setDataLedAirCondition(digitalAir: params!);
  }
}