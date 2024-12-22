import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_iot/core/configs/theme/app_theme.dart';
import 'package:smart_iot/firebase_options.dart';
import 'package:smart_iot/presentation/bed_room/bloc/bed_room_cubit.dart';
import 'package:smart_iot/presentation/living_room/bloc/set_led_living_cubit.dart';
import 'package:smart_iot/presentation/splash/pages/splash.dart';
import 'package:smart_iot/service_locator.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // Màu nền trong suốt
    statusBarColor: Colors.transparent, // Làm trong suốt thanh trạng thái (status bar)
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : await getApplicationDocumentsDirectory(),
  );
  await initializeDependencies();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SetLedLivingCubit(),
        ),
        BlocProvider(
          create: (context) => BedRoomCubit(),
        ),
      ],
      child: const IHouseApp(),
    );
  }
}

class IHouseApp extends StatelessWidget {
  const IHouseApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // themeMode: mode,
      themeMode: ThemeMode.system,
      home: const SplashPage(),
    );
  }
}
