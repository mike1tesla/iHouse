import 'package:smart_iot/core/usecase/usecase.dart';
import 'package:smart_iot/domain/repository/auth/auth_repo.dart';

import '../../../service_locator.dart';

class IsLoggedInUseCase implements UseCase<bool, dynamic> {
  @override
  Future<bool> call({params}) async {
    return sl<AuthRepository>().isLoggedIn();
  }
}