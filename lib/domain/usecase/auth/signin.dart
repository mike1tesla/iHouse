import 'package:dartz/dartz.dart';
import 'package:smart_iot/core/usecase/usecase.dart';
import 'package:smart_iot/data/models/auth/signin_user_req.dart';
import 'package:smart_iot/domain/repository/auth/auth_repo.dart';

import '../../../service_locator.dart';

class SignInUseCase implements UseCase<Either, SignInUserReq> {
  @override
  Future<Either> call({SignInUserReq? params}) async {
    return sl<AuthRepository>().signIn(params!);
  }
}