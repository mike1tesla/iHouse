import 'package:dartz/dartz.dart';
import 'package:smart_iot/domain/entities/lockdoor/lockdoor.dart';

abstract class LockdoorRepository {
  Stream<Either<Exception, List<LockdoorEntity>>> streamLockdoor();

  Future<List<LockdoorEntity>> fetchLockdoors();
}