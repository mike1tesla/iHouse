
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_iot/domain/usecase/lockdoor/fetchLockdoors.dart';
import 'package:smart_iot/presentation/home/bloc/start_state.dart';

import '../../../domain/entities/lockdoor/lockdoor.dart';
import '../../../service_locator.dart';

class StartCubit extends Cubit<StartState> {
  StartCubit() : super(StartInitial());

  Future<void> fetchStarts() async {
    emit(StartLoading());
    List<LockdoorEntity> lockdoors = await sl<FetchLockdoorsUseCase>().call();
    emit(StartLoaded());
  }
}
