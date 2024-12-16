import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_iot/core/configs/assets/app_vectors.dart';
import 'package:smart_iot/presentation/splash/bloc/splash_cubit.dart';

import '../../home/pages/home.dart';
import '../../intro/pages/get_started.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashCubit>(
      create: (context) =>
      SplashCubit()
        ..appStarted(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const GetStartedPage()),
            );
          }

          if (state is Authenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        },
        child: Scaffold(
          body: Center(
            child: SvgPicture.asset(AppVectors.logo),
          ),
        ),
      ),
    );
  }
}
