import 'package:smart_iot/core/usecase/usecase.dart';
import 'package:smart_iot/domain/repository/lockdoor/lockdoor.dart';

import '../../../service_locator.dart';
import '../../entities/lockdoor/lockdoor.dart';

class GetLatestLockdoorUseCase implements UseCase<LockdoorEntity, dynamic> {
  @override
  Future<LockdoorEntity?> call({params}) async {
    return await sl<LockdoorRepository>().getLatestLockdoor();
  }
}