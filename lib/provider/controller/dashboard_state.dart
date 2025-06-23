import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hikkingapp/model/users.dart';

class DashboardState extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Get current user's crew name
  Future<String?> _getCurrentUserCrewname() async {
    final email = _auth.currentUser?.email;
    if (email == null) return null;

    final snapshot =
        await _db.collection("users").where("Email", isEqualTo: email).get();

    if (snapshot.docs.isEmpty) return null;

    return snapshot.docs.first.data()["Crewname"];
  }

  // Get users in the same crew
  Future<List<UserModel>> getCrewMembers() async {
    final crewname = await _getCurrentUserCrewname();
    if (crewname == null) return [];

    final snapshot = await _db
        .collection("users")
        .where("Crewname", isEqualTo: crewname)
        .get();

    return snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
  }
}
