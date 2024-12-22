import 'package:get_it/get_it.dart';
import 'package:smart_iot/data/data_source/auth/auth_firebase_service.dart';
import 'package:smart_iot/data/data_source/led/led_firebase_database_service.dart';
import 'package:smart_iot/data/data_source/mess/mess_gemini_service.dart';
import 'package:smart_iot/data/repository/auth/auth_repo_impl.dart';
import 'package:smart_iot/data/repository/led/led_repo_impl.dart';
import 'package:smart_iot/data/repository/mess/mess_repo_impl.dart';
import 'package:smart_iot/domain/repository/auth/auth_repo.dart';
import 'package:smart_iot/domain/repository/led/led_repo.dart';
import 'package:smart_iot/domain/repository/mess/mess_repo.dart';
import 'package:smart_iot/domain/usecase/auth/get_user.dart';
import 'package:smart_iot/domain/usecase/auth/is_logged_in.dart';
import 'package:smart_iot/domain/usecase/auth/signin.dart';
import 'package:smart_iot/domain/usecase/auth/signup.dart';
import 'package:smart_iot/domain/usecase/led/setDataLedAirCondition.dart';
import 'package:smart_iot/domain/usecase/led/setDataLedAnalog.dart';
import 'package:smart_iot/domain/usecase/led/setDataLedDigital.dart';

import 'domain/usecase/auth/signout.dart';
import 'domain/usecase/mess/call_gemini_model.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // data source
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<MessageGeminiService>(MessageGeminiServiceImpl());
  sl.registerSingleton<LedFirebaseDatabaseService>(LedFirebaseDatabaseServiceImpl());

  // repository
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<MessageRepository>(MessageRepositoryImpl());
  sl.registerSingleton<LedRepository>(LedRepositoryImpl());

  // Domain - Use Case
  // auth
  sl.registerSingleton<SignupUseCase>(SignupUseCase());
  sl.registerSingleton<SignInUseCase>(SignInUseCase());
  sl.registerSingleton<IsLoggedInUseCase>(IsLoggedInUseCase());
  sl.registerSingleton<SignOutUseCase>(SignOutUseCase());
  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());
  // mess
  sl.registerSingleton<CallGeminiModelUseCase>(CallGeminiModelUseCase());
  //led
  sl.registerSingleton<SetDataLedAirConditionUseCase>(SetDataLedAirConditionUseCase());
  sl.registerSingleton<SetDataLedAnalogUseCase>(SetDataLedAnalogUseCase());
  sl.registerSingleton<SetDataLedDigitalUseCase>(SetDataLedDigitalUseCase());

}
