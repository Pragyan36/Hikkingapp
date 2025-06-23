import 'package:cloud_firestore/cloud_firestore.dart';

class UsergroupModel {
  final String? id; // Firestore document ID
  final String groupName;
  final String createdBy;
  final List<Map<String, dynamic>> members;
  final DateTime createdAt;

  const UsergroupModel({
    this.id,
    required this.groupName,
    required this.createdAt,
    required this.createdBy,
    required this.members,
  });
  Map<String, dynamic> toJson() {
    return {
      "groupName": groupName,
      "createdAt": createdAt,
      "createdBy": createdBy,
      "members": members,
    };
  }

  factory UsergroupModel.fromJson(Map<String, dynamic> json, String id) {
    return UsergroupModel(
      id: id,
      groupName: json['groupName'] ?? 'Unnamed Group',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      createdBy: json['createdBy'] ?? '',
      members: json['members'] != null
          ? List<Map<String, dynamic>>.from(json['members'])
          : [],
    );
  }
}
