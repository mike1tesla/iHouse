import 'package:dartz/dartz.dart';
import 'package:smart_iot/domain/repository/lockdoor/lockdoor.dart';

import '../../../service_locator.dart';
import '../../entities/lockdoor/lockdoor.dart';

class StreamLockdoorsUseCase {
  Stream<Either<Exception, List<LockdoorEntity>>> call(){
    return sl<LockdoorRepository>().streamLockdoor();
  }
}