import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_iot/common/widgets/button/basic_app_button.dart';
import 'package:smart_iot/core/configs/assets/app_images.dart';
import 'package:smart_iot/core/configs/assets/app_vectors.dart';
import 'package:smart_iot/presentation/auth/pages/signin.dart';
import 'package:smart_iot/presentation/auth/pages/signup_or_signin.dart';

import '../../../core/configs/theme/app_colors.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      AppImages.introBG,
                    ))),
          ),
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(AppVectors.logo),
                ),
                const Spacer(),
                const Text(
                  'The technology that touches life.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 23),
                ),
                const SizedBox(
                  height: 21,
                ),
                const Text(
                  'Smart connectivity, easy device management, optimizing life. The future is in your hands.',
                  style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.grey, fontSize: 17),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                BasicAppButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (BuildContext context) => const SignupOrSignInPage()));
                    },
                    title: 'Get Started'),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
