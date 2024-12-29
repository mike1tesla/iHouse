import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_iot/domain/entities/lockdoor/lockdoor.dart';
import 'package:smart_iot/domain/usecase/lockdoor/fetchLockdoors.dart';
import 'package:smart_iot/domain/usecase/lockdoor/getHistoryLockdoors.dart';

import '../../../service_locator.dart';

part 'lockdoor_state.dart';

class LockdoorCubit extends Cubit<LockdoorState> {
  LockdoorCubit() : super(LockdoorInitial());

  // Future<void> fetchLockdoors() async {
  //   List<LockdoorEntity> lockdoors = await sl<FetchLockdoorsUseCase>().call();
  //   // print(lockdoors);
  // }

  Future<void> showLockdoors() async {
    try {
      emit(LockdoorLoading());
      List<LockdoorEntity> lockdoors = await sl<FetchLockdoorsUseCase>().call();
      emit(LockdoorLoaded(lockdoors));
    } catch (e) {
      emit(LockdoorError(e.toString()));
    }
  }

  // Future<void> loadHistory() async {
  //   try {
  //     emit(LockdoorLoading());
  //     List<LockdoorEntity> lockdoors = await sl<GetHistoryLockdoorsUseCase>().call();
  //     emit(LockdoorLoaded(lockdoors));
  //   } catch (e) {
  //     emit(LockdoorError(e.toString()));
  //   }
  // }
}
