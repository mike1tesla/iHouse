import 'package:smart_iot/core/usecase/usecase.dart';
import 'package:smart_iot/domain/repository/led/led_repo.dart';

import '../../../service_locator.dart';

class SetDataLedAnalogUseCase implements UseCase<void, double> {
  @override
  Future<void> call({double? params}) async {
    return await sl<LedRepository>().setDataLedAnalog(analog: params!);
  }
}
