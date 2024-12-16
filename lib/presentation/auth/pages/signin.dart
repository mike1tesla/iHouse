import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_iot/data/models/auth/signin_user_req.dart';
import 'package:smart_iot/domain/usecase/auth/signin.dart';
import 'package:smart_iot/presentation/auth/pages/signup.dart';

import '../../../common/widgets/appbar/app_bar.dart';
import '../../../common/widgets/button/basic_app_button.dart';
import '../../../core/configs/assets/app_vectors.dart';
import '../../../service_locator.dart';
import '../../home/pages/home.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: SvgPicture.asset(AppVectors.logo, height: 110),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _signInText(),
              const SizedBox(height: 20),
              _userNameOrEmailField(context),
              const SizedBox(height: 20),
              _passwordField(context),
              const SizedBox(height: 20),
              BasicAppButton(
                onPressed: () async {
                  var isValid = _formKey.currentState?.validate() ?? false;
                  if (isValid) {
                    var result = await sl<SignInUseCase>().call(
                      params: SignInUserReq(
                        email: _email.text,
                        password: _password.text,
                      ),
                    );
                    result.fold(
                      (l) {
                        var snackBar = SnackBar(content: Text(l));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      (r) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const HomePage()),
                          (route) => false,
                        );
                      },
                    );
                  } else {
                    //   Không làm gì
                  }
                },
                title: "Sign In",
              ),
              const SizedBox(height: 50),
              _signupText(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInText() {
    return const Text("Sign In", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold));
  }

  Widget _userNameOrEmailField(context) {
    return TextFormField(
      cursorColor: Colors.green,
      controller: _email,
      decoration: const InputDecoration(
        hintText: "Enter Username or Email",
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
      validator: (value) {
        final RegExp _emailRegExp = RegExp(
          r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
        );
        if (value == null || value.isEmpty) {
          return "Username can not empty";
        } else if (_emailRegExp.hasMatch(value)) {
          return null;
        } else {
          return "Format email invalid";
        }
      },
    );
  }

  Widget _passwordField(context) {
    return TextFormField(
      cursorColor: Colors.green,
      controller: _password,
      decoration: InputDecoration(
        hintText: "Password",
        suffixIcon: GestureDetector(
          onTap: _toggle,
          child: Icon(
            _obscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
            size: 15,
          ),
        ),
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
      obscureText: _obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password can not empty';
        }
        if (value.length < 6) {
          return "Password too short";
        }
        return null;
      },
    );
  }

  Widget _signupText(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Not A Member ? ",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SignupPage()),
            );
          },
          child: const Text("Register Now",
              style: TextStyle(color: Color(0xFF278CE8), fontSize: 14, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
