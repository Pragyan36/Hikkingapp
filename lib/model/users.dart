import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String firstname;
  final String lastname;
  final String crewname;
  final String phone;
  final String email;
  final String password;
  final String roles;
  final String? profilePic;

  const UserModel(
      {this.id,
      required this.firstname,
      required this.lastname,
      required this.crewname,
      required this.phone,
      required this.email,
      required this.password,
      required this.roles,
      this.profilePic});

  toJson() {
    return {
      "Firstname": firstname,
      "Lastname": lastname,
      "Crewname": crewname,
      "Phone": phone,
      "Email": email,
      "Password": password,
      "Roles": roles,
      if (profilePic != null) "ProfilePic": profilePic,
    };
  }

  //fetching data
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        id: document.id,
        firstname: data["Firstname"] ?? "",
        lastname: data["Lastname"] ?? "",
        crewname: data["Crewname"] ?? "",
        phone: data["Phone"] ?? "",
        email: data["Email"] ?? "",
        password: data["Password"] ?? "",
        roles: data["Roles"] ?? "",
        profilePic: data["ProfilePic"] ?? "");
  }
}
