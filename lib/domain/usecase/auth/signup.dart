import 'package:dartz/dartz.dart';
import 'package:smart_iot/core/usecase/usecase.dart';
import 'package:smart_iot/data/models/auth/create_user_req.dart';
import 'package:smart_iot/domain/repository/auth/auth_repo.dart';

import '../../../service_locator.dart';

class SignupUseCase implements UseCase<Either, CreateUserReq> {
  @override
  Future<Either> call({CreateUserReq? params}) async {
    return sl<AuthRepository>().signup(params!);
  }
}