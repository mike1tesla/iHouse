import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_iot/common/helpers/is_dark_mode.dart';
import 'package:smart_iot/common/widgets/appbar/app_bar.dart';
import 'package:smart_iot/common/widgets/button/basic_app_button.dart';
import 'package:smart_iot/core/configs/assets/app_vectors.dart';
import 'package:smart_iot/presentation/auth/pages/signin.dart';
import 'package:smart_iot/presentation/auth/pages/signup.dart';

import '../../../core/configs/theme/app_colors.dart';

class SignupOrSignInPage extends StatelessWidget {
  const SignupOrSignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BasicAppBar(),
          Align(
            alignment: Alignment.topRight,
            child: SvgPicture.asset(AppVectors.topPattern),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset(AppVectors.bottomPattern),
          ),
          // Align(
          //   alignment: Alignment.bottomLeft,
          //   child: Image.asset(AppImages.authBG,  width: 200,),
          // ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 2.5, // Đặt ở dưới cùng
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppVectors.logo),
                  const SizedBox(height: 50),
                  const Text(
                    'The technology that touches life.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Smart connectivity, easy device management, optimizing life. The future is in your hands.',
                    style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.grey, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: BasicAppButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SignupPage(),
                              ),
                            );
                          },
                          title: "Register",
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignInPage(),));
                          },
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(80),
                          ),
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                              color: context.isDarkMode ? Colors.white : Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
