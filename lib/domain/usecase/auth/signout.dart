import 'package:smart_iot/core/usecase/usecase.dart';
import 'package:smart_iot/domain/repository/auth/auth_repo.dart';

import '../../../service_locator.dart';

class SignOutUseCase implements UseCase<void, dynamic> {
  @override
  Future<void> call({params}) async {
    return sl<AuthRepository>().signOut();
  }
}