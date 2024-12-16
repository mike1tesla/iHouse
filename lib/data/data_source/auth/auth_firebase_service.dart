// dependency inversion - Trừu tượng hóa data_source nên repository sẽ không phu thuộc vào các Service
// Làm việc trực tiếp với FirebaseService
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_iot/core/constants/app_urls.dart';
import 'package:smart_iot/data/models/auth/create_user_req.dart';
import 'package:smart_iot/data/models/auth/signin_user_req.dart';
import 'package:smart_iot/data/models/auth/user.dart';
import 'package:smart_iot/domain/entities/auth/user.dart';

abstract class AuthFirebaseService {
  Future<Either> signup(CreateUserReq createUserReq);
  Future<Either> signIn(SignInUserReq signInUserReq);
  Future<Either> getUser();
  Future<void> signOut();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either> signIn(SignInUserReq signInUserReq) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: signInUserReq.email,
        password: signInUserReq.password,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', userCredential.user!.uid);

      return const Right("Sign In was successful");
    } on FirebaseAuthException catch (e) {
      String message = "Signup Failed";

      if (e.code == "invalid-email") {
        message = "Not user found for that email ";
      } else if (e.code == 'email-already-in-use'){
        message = "The account already exists for that email";
      } else if (e.code == "invalid-credential") {
        message = "Wrong password provider for that user";
      }
      return Left(message);
    }
  }

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    try {
      // Đăng kí người dùng FirebaseAuth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: createUserReq.email,
        password: createUserReq.password,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', userCredential.user!.uid);

      // Lưu thông tin người dùng vào collection FirebaseFirestore và đặt field ID cho từng Users
      FirebaseFirestore.instance.collection("Users").doc(userCredential.user?.uid).set({
        'name': createUserReq.fullName,
        'email': userCredential.user?.email,
      });

      return const Right("Signup was successful");
    } on FirebaseAuthException catch (e) {
      String message = "Signup Failed";

      if (e.code == "weak-password") {
        message = "The password provided is too weak";
      } else if (e.code == "email-already-in-use") {
        message = "An account already exists with that email";
      }
      return Left(message);
    }
  }

  @override
  Future<Either> getUser() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      var user = await firebaseFirestore.collection('Users').doc(firebaseAuth.currentUser?.uid).get();
      // print("USERfromJson: ${user.data()}");
      UserModel userModel = UserModel.fromJson(user.data()!);

      userModel.imageURL = firebaseAuth.currentUser?.photoURL ?? AppURLs.defaultImage;
      // print("ImageURL: ${userModel.imageURL}");

      UserEntity userEntity = userModel.toEntity();
      return Right(userEntity);
    } catch (e) {
      print("getUserInfo $e");
      return const Left("An error occurred");
    }
  }

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('Đã đăng xuất');
  }
}
