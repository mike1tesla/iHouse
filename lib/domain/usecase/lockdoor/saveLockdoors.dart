import 'package:smart_iot/core/usecase/usecase.dart';
import 'package:smart_iot/domain/repository/lockdoor/lockdoor.dart';

import '../../../service_locator.dart';
import '../../entities/lockdoor/lockdoor.dart';

class SaveLockdoorsUseCase implements UseCase<void, List<LockdoorEntity>> {
  @override
  Future<void> call({List<LockdoorEntity>? params}) async {
    return await sl<LockdoorRepository>().saveLockdoors(params!);
  }
}