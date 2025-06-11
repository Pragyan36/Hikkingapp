import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String email;
  final String password;
  final String roles;

  const UserModel(
      {this.id,
      required this.email,
      required this.password,
      required this.roles});

  toJson() {
    return {
      "Email": email,
      "Password": password,
      "Roles": roles,
    };
  }

  //fetching data
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        id: document.id,
        email: data["Email"],
        password: data["Password"],
        roles: data["Roles"]);
  }
}
