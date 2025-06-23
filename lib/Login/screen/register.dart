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
import 'package:hikkingapp/provider/controller/login_state.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool rememberMe = false;
  String? selectedRole;

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final height = SizeUtils.height;
  final width = SizeUtils.width;
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(builder: (context, registercontroller, child) {
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
                        controller: registercontroller
                            .registerrolescontroller, // custom param we'll add
                        items: ['Guide', 'Member'],
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value!;
                            registercontroller.registerrolescontroller.text =
                                value; // manually sync
                          });
                        },
                      ),
                      LoginCustomTextField(
                        controller:
                            registercontroller.registerfirstnamecontroller,
                        title: "First Name",
                        textInputType: TextInputType.text,
                      ),
                      LoginCustomTextField(
                        controller:
                            registercontroller.registerlastnamecontroller,
                        title: "Last Name",
                        textInputType: TextInputType.text,
                      ),
                      LoginCustomTextField(
                        controller:
                            registercontroller.registercrewnamecontroller,
                        title: "Crew Name",
                        textInputType: TextInputType.text,
                      ),

                      LoginCustomTextField(
                        controller: registercontroller.registerphonecontroller,
                        title: "Phone",
                        textInputType: TextInputType.number,
                      ),
                      LoginCustomTextField(
                        controller: registercontroller.registeremailcontroller,
                        title: "Email",
                        textInputType: TextInputType.emailAddress,
                      ),
                      CustomPasswordField(
                        controller:
                            registercontroller.registerpasswordcontroller,
                        title: "Password",
                        hintText: "Password",
                      ),
                      CustomPasswordField(
                        controller:
                            registercontroller.registerpasswordcontroller,
                        title: "Confirm Password",
                        hintText: "Password",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value !=
                              registercontroller
                                  .registerpasswordcontroller.text) {
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
                                await registercontroller.auth
                                    .createUserWithEmailAndPassword(
                                  email: registercontroller
                                      .registeremailcontroller.text
                                      .trim(),
                                  password: registercontroller
                                      .registerpasswordcontroller.text
                                      .trim(),
                                );

                                // Create user model
                                final user = UserModel(
                                  firstname: registercontroller.capitalize(
                                      registercontroller
                                          .registerfirstnamecontroller.text
                                          .trim()),
                                  lastname: registercontroller.capitalize(
                                      registercontroller
                                          .registerlastnamecontroller.text
                                          .trim()),
                                  crewname: registercontroller.capitalize(
                                      registercontroller
                                          .registercrewnamecontroller.text
                                          .trim()),
                                  phone: registercontroller
                                      .registerphonecontroller.text
                                      .trim(),
                                  email: registercontroller
                                      .registeremailcontroller.text
                                      .trim(),
                                  password: registercontroller
                                      .registerpasswordcontroller.text
                                      .trim(),
                                  roles: registercontroller.capitalize(
                                      registercontroller
                                          .registerrolescontroller.text
                                          .trim()),
                                );

                                // Store user in Firestore
                                final error =
                                    await registercontroller.createUser(user);
                                if (error == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Success, your account has been created"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(error),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }

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
    });
  }
}
