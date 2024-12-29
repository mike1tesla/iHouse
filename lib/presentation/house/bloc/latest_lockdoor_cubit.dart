import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_iot/domain/entities/lockdoor/lockdoor.dart';
import 'package:smart_iot/domain/usecase/lockdoor/getLatestLockdoor.dart';

import '../../../service_locator.dart';
import 'latest_lockdoor_state.dart';


class LatestLockdoorCubit extends Cubit<LatestLockdoorState> {
  LatestLockdoorCubit() : super(LatestLockdoorInitial());

  Future<void> fetchLatestLockdoor() async {
    try {
      emit(LatestLockdoorLoading());
      LockdoorEntity? latestLockdoor = await sl<GetLatestLockdoorUseCase>().call();
      emit(LatestLockdoorLoaded(latestLockdoor));
    } catch (e) {
      emit(LatestLockdoorError(e.toString()));
    }
  }
}
