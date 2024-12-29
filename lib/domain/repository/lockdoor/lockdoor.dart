import 'package:dartz/dartz.dart';
import 'package:smart_iot/domain/entities/lockdoor/lockdoor.dart';

abstract class LockdoorRepository {
  Stream<Either<Exception, List<LockdoorEntity>>> streamLockdoor();

  Future<List<LockdoorEntity>> fetchLockdoors();
  Future<void> saveLockdoors(List<LockdoorEntity> lockdoors);
  Future<List<LockdoorEntity>> getHistoryLockdoors();
  Future<LockdoorEntity?> getLatestLockdoor();
}