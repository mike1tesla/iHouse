import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:smart_iot/domain/entities/lockdoor/lockdoor.dart';
import 'package:smart_iot/domain/usecase/lockdoor/streamLockdoor.dart';

import '../../../service_locator.dart';


class StreamLockdoorCubit extends Cubit<Either<Exception, List<LockdoorEntity>>> {

  StreamLockdoorCubit() : super(const Right([])) {
    _loadData();
  }

  void _loadData() {
    sl<StreamLockdoorsUseCase>().call().listen(emit);
  }
}
