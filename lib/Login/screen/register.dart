import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hikkingapp/constant/custom_password_field.dart';
import 'package:hikkingapp/constant/custom_round_buttom.dart';
import 'package:hikkingapp/constant/dropdown.dart';
import 'package:hikkingapp/constant/imagedirectory.dart';
import 'package:hikkingapp/constant/login_common_text_field.dart';
import 'package:hikkingapp/constant/size.utils.dart';
import 'package:hikkingapp/dashboard/ui/screen/dashboard.dart';
import 'package:hikkingapp/model/users.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _db = FirebaseFirestore.instance;
  createUser(UserModel user) async {
    try {
      await _db.collection("users").add(user.toJson());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Success, your account has been created"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${error.toString()}"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  bool rememberMe = false;
  String? selectedRole;
  String maskPhoneNumber(String number) {
    final String firstTwo = number.substring(0, 2);
    final String lastTwo = number.substring(number.length - 2);
    final String masked = firstTwo + "**" + lastTwo;

    return masked;
  }

  final _emailcontroller = TextEditingController();
  final _rolescontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _confirmpassword = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.01),
                    Text(
                      "Sign Up",
                      style: TextStyle(
                          fontFamily: "popinbold",
                          fontWeight: FontWeight.bold,
                          fontSize: 26.sp,
                          color: Colors.black),
                    ),
                    SizedBox(height: height * 0.02),
                    LoginCustomDropdown(
                      title: "Roles",
                      value: selectedRole,
                      controller: _rolescontroller, // custom param we'll add
                      items: ['Guide', 'Member'],
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value!;
                          _rolescontroller.text = value; // manually sync
                        });
                      },
                    ),

                    LoginCustomTextField(
                      controller: _emailcontroller,
                      title: "Email",
                      readOnly: rememberMe && _existingPhoneNumber.isNotEmpty,
                      textInputType: TextInputType.emailAddress,
                    ),
                    CustomPasswordField(
                      controller: _passwordcontroller,
                      title: "Password",
                      hintText: "Password",
                    ),
                    CustomPasswordField(
                      controller: _confirmpassword,
                      title: "Confirm Password",
                      hintText: "Password",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordcontroller.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomRoundedButtom(
                        title: "Sign up",
                        onPressed: () async {
                          if (_loginFormKey.currentState!.validate()) {
                            try {
                              // Register user with Firebase Auth
                              await _auth.createUserWithEmailAndPassword(
                                email: _emailcontroller.text.trim(),
                                password: _passwordcontroller.text.trim(),
                              );

                              // Create user model
                              final user = UserModel(
                                email: _emailcontroller.text.trim(),
                                password: _passwordcontroller.text.trim(),
                                roles: _rolescontroller.text.trim(),
                              );

                              // Store user in Firestore
                              await createUser(user);

                              // Navigate to Dashboard
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashbaordScreen()),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Registration error: ${e.toString()}"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }),

                    //auth--------------
                    // onPressed: () {
                    //   print(
                    //       "this is email ---------------$_emailcontroller");
                    //   final isvalid =
                    //       _loginFormKey.currentState!.validate();
                    //   _auth
                    //       .createUserWithEmailAndPassword(
                    //           email: _emailcontroller.text,
                    //           password: _passwordcontroller.text)
                    //       .then((value) {
                    //     print(
                    //         "this is email ---------------$_emailcontroller");
                    //     Navigator.pushReplacement(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => DashbaordScreen()),
                    //     );
                    //   });
                    // }),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
