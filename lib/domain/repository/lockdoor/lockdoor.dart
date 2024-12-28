import 'package:smart_iot/domain/entities/lockdoor/lockdoor.dart';

abstract class LockdoorRepository {
  Future<List<LockdoorEntity>> fetchLockdoors();
  Future<void> saveLockdoors(List<LockdoorEntity> lockdoors);
  Future<List<LockdoorEntity>> getHistoryLockdoors();
}