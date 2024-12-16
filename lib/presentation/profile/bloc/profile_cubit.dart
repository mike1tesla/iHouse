import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_iot/domain/entities/auth/user.dart';
import 'package:smart_iot/domain/usecase/auth/get_user.dart';

import '../../../service_locator.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileLoading());

  Future<void> getUser() async {
    var user = await sl<GetUserUseCase>().call();
    user.fold(
      (l) {
        emit(ProfileFailure());
      },
      (userEntity) {
        emit(ProfileLoaded(userEntity: userEntity));
      },
    );
  }
}
