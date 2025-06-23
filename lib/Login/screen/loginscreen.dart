import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hikkingapp/Login/screen/forget.dart';
import 'package:hikkingapp/Login/screen/register.dart';
import 'package:hikkingapp/constant/custom_password_field.dart';
import 'package:hikkingapp/constant/custom_round_buttom.dart';
import 'package:hikkingapp/constant/imagedirectory.dart';
import 'package:hikkingapp/constant/login_common_text_field.dart';
import 'package:hikkingapp/constant/size.utils.dart';
import 'package:hikkingapp/dashboard/ui/screen/dashboard.dart';
import 'package:hikkingapp/provider/controller/login_state.dart';
import 'package:provider/provider.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool rememberMe = false;

  final ValueNotifier<bool> _hasExistingLoginSaved = ValueNotifier(false);
  String _existingPhoneNumber = "";
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final height = SizeUtils.height;
  final width = SizeUtils.width;
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(builder: (context, loginstate, child) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.01),
                      Text(
                        "Login",
                        style: TextStyle(
                            // fontFamily: "popinbold",
                            fontWeight: FontWeight.bold,
                            fontSize: 26.sp,
                            color: Colors.black),
                      ),
                      SizedBox(height: height * 0.02),
                      LoginCustomTextField(
                        title: "Email",
                        readOnly: rememberMe && _existingPhoneNumber.isNotEmpty,
                        hintText: "Email",
                        textInputType: TextInputType.emailAddress,
                        controller: loginstate.emailcontroller,
                      ),
                      CustomPasswordField(
                        title: "Password",
                        hintText: "Password",
                        controller: loginstate.passwordcontroller,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
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
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPasswordPage()),
                              );
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      CustomRoundedButtom(
                          title: "Login",
                          onPressed: () async {
                            final isValid =
                                _loginFormKey.currentState!.validate();
                            if (!isValid) return;

                            try {
                              print(
                                  "Logging in with email: ${loginstate.emailcontroller.text.trim()}");

                              await _auth.signInWithEmailAndPassword(
                                email: loginstate.emailcontroller.text.trim(),
                                password:
                                    loginstate.passwordcontroller.text.trim(),
                              );

                              // Navigate only if login successful
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashbaordScreen()),
                              );
                            } on FirebaseAuthException catch (e) {
                              String message = "Login failed";
                              if (e.code == 'user-not-found') {
                                message = 'No user found for that email.';
                              } else if (e.code == 'wrong-password') {
                                message = 'Incorrect password.';
                              } else if (e.code == 'invalid-email') {
                                message = 'Invalid email address.';
                              } else if (e.code == 'invalid-credential') {
                                message = 'Invalid credential.';
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(message),
                                    backgroundColor: Colors.red),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Unexpected error: $e"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }),
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
    });
  }
}
