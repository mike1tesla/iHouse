// Triển khai các repo ở lớp Domain
// Gọi đến các method làm việc với service trong data_source
// Dependency injection - tránh truyền lại tham số và tạo constructor thì sử dụng get_it
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_iot/data/data_source/auth/auth_firebase_service.dart';
import 'package:smart_iot/data/models/auth/create_user_req.dart';
import 'package:smart_iot/data/models/auth/signin_user_req.dart';
import 'package:smart_iot/domain/repository/auth/auth_repo.dart';

import '../../../service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {


  @override
  Future<Either> signIn(SignInUserReq signInUserReq) async {
    return await sl<AuthFirebaseService>().signIn(signInUserReq);
  }

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    return await sl<AuthFirebaseService>().signup(createUserReq);
  }

  @override
  Future<Either> getUser() async {
    return await sl<AuthFirebaseService>().getUser();
  }

  @override
  Future<void> signOut() async {
    return await sl<AuthFirebaseService>().signOut();
  }

  @override
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
