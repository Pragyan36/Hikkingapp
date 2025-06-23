import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hikkingapp/model/member_group.dart';
import 'package:hikkingapp/model/users.dart';

class GroupState extends ChangeNotifier {
  Future<void> createGroup({
    required String groupName,
    required String createdBy,
    required List<UserModel> members,
  }) async {
    final memberDetails = members
        .map((user) => user.toJson())
        .toList()
        .cast<Map<String, dynamic>>();

    final group = UsergroupModel(
      groupName: groupName,
      createdAt: DateTime.now(),
      createdBy: createdBy,
      members: memberDetails,
    );

    await FirebaseFirestore.instance.collection('groups').add(group.toJson());
  }

  Future<List<UsergroupModel>> fetchGroups() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('groups').get();

    return snapshot.docs.map((doc) {
      return UsergroupModel.fromJson(doc.data(), doc.id);
    }).toList();
  }
}
