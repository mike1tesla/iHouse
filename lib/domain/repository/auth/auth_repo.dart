import 'package:dartz/dartz.dart';
import 'package:smart_iot/data/models/auth/create_user_req.dart';
import 'package:smart_iot/data/models/auth/signin_user_req.dart';

abstract class AuthRepository {
  //   Nơi định nghĩa các hành động của Entity
  Future<Either> signup(CreateUserReq createUserReq);

  Future<Either> signIn(SignInUserReq signInUserReq);

  Future<Either> getUser();

  Future<void> signOut();
  Future<bool> isLoggedIn();
}