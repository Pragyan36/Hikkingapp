import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hikkingapp/model/users.dart';

class UserdetailsState extends ChangeNotifier {
  Future<UserModel?> getUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final email = _auth.currentUser?.email;

    if (email == null) return null;

    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("Email", isEqualTo: email)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return UserModel.fromSnapshot(snapshot.docs.first);
  }

  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final crewnameController = TextEditingController();
  final roleController = TextEditingController();

  String? userId;

  void initialize(UserModel user) {
    userId = user.id;
    firstnameController.text = user.firstname;
    lastnameController.text = user.lastname;
    emailController.text = user.email;
    phoneController.text = user.phone;
    crewnameController.text = user.crewname;
    roleController.text = user.roles;
  }

  Future<void> updateUserProfile(BuildContext context) async {
    if (userId == null) return;

    try {
      await FirebaseFirestore.instance.collection("users").doc(userId).update({
        "Firstname": firstnameController.text.trim(),
        "Lastname": lastnameController.text.trim(),
        "Phone": phoneController.text.trim(),
        "Crewname": crewnameController.text.trim(),
        "Roles": roleController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error updating profile: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    crewnameController.dispose();
    roleController.dispose();
    super.dispose();
  }
}
