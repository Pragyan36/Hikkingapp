import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hikkingapp/model/users.dart';

class LoginState extends ChangeNotifier {
  bool rememberMe = false;
  String? selectedRole;
  final registeremailcontroller = TextEditingController();
  final registerrolescontroller = TextEditingController();
  final registerpasswordcontroller = TextEditingController();
  final registerconfirmpassword = TextEditingController();
  final registerfirstnamecontroller = TextEditingController();
  final registerlastnamecontroller = TextEditingController();
  final registercrewnamecontroller = TextEditingController();
  final registerphonecontroller = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Future<String?> createUser(UserModel user) async {
    try {
      await _db.collection("users").add(user.toJson());
      return null; // null = success
    } catch (error) {
      return "Error: ${error.toString()}";
    }
  }

  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
}
