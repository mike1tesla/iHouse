import 'package:smart_iot/core/usecase/usecase.dart';
import 'package:smart_iot/domain/repository/lockdoor/lockdoor.dart';

import '../../../service_locator.dart';
import '../../entities/lockdoor/lockdoor.dart';

class FetchLockdoorsUseCase implements UseCase<List<LockdoorEntity>, dynamic> {
  @override
  Future<List<LockdoorEntity>> call({params}) async {
    return await sl<LockdoorRepository>().fetchLockdoors();
  }
}