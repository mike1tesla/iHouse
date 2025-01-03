import 'package:dartz/dartz.dart';
import 'package:smart_iot/data/data_source/lockdoor/lockdoor_cloud_firestore_service.dart';
import 'package:smart_iot/data/data_source/lockdoor/stream_lockdoor_cloud_service.dart';

import '../../../domain/entities/lockdoor/lockdoor.dart';
import '../../../domain/repository/lockdoor/lockdoor.dart';
import '../../../service_locator.dart';

class LockdoorRepositoryImpl extends LockdoorRepository {
  @override
  Stream<Either<Exception, List<LockdoorEntity>>> streamLockdoor() async* {
    yield* sl<StreamLockdoorCloudService>().streamLockdoor();
  }

  @override
  Future<List<LockdoorEntity>> fetchLockdoors() async {
    return await sl<LockdoorCloudFirestoreService>().fetchLockdoors();
  }
}
