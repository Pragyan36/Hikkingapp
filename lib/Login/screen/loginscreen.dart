import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hikkingapp/Login/screen/register.dart';
import 'package:hikkingapp/constant/custom_password_field.dart';
import 'package:hikkingapp/constant/custom_round_buttom.dart';
import 'package:hikkingapp/constant/imagedirectory.dart';
import 'package:hikkingapp/constant/login_common_text_field.dart';
import 'package:hikkingapp/constant/size.utils.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  bool rememberMe = false;
  String maskPhoneNumber(String number) {
    final String firstTwo = number.substring(0, 2);
    final String lastTwo = number.substring(number.length - 2);
    final String masked = firstTwo + "**" + lastTwo;

    return masked;
  }

  final ValueNotifier<bool> _hasExistingLoginSaved = ValueNotifier(false);
  String _existingPhoneNumber = "";
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final height = SizeUtils.height;
  final width = SizeUtils.width;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Center(
              child: Image(
                image: AssetImage(AppImage.logo),
                fit: BoxFit.fill,
                height: 100,
                width: 100,
              ),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _loginFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.01),
                    Text(
                      "Login",
                      style: TextStyle(
                          fontFamily: "popinbold",
                          fontWeight: FontWeight.bold,
                          fontSize: 26.sp,
                          color: Colors.black),
                    ),
                    SizedBox(height: height * 0.02),
                    LoginCustomTextField(
                      title: "Mobile Number",
                      readOnly: rememberMe && _existingPhoneNumber.isNotEmpty,
                      hintText: rememberMe && _existingPhoneNumber.isNotEmpty
                          ? maskPhoneNumber(_existingPhoneNumber)
                          : "Mobile Number",
                      textInputType: TextInputType.phone,
                    ),
                    CustomPasswordField(
                      title: "Password",
                      hintText: "Password",
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _hasExistingLoginSaved,
                      builder: (context, val, _) {
                        return Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              activeColor: Colors.blue,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = !rememberMe;
                                });
                              },
                            ),
                            const Text("Remember Me"),
                          ],
                        );
                      },
                    ),
                    CustomRoundedButtom(title: "Login", onPressed: () {}),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Not a member? ",
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "Register here",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Navigate to SignUpPage or RegisterPage
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
