import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hikkingapp/constant/editable_card.dart';
import 'package:hikkingapp/model/users.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController firstnameController;
  late TextEditingController lastnameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController crewnameController;
  late TextEditingController roleController;

  @override
  void initState() {
    super.initState();
    firstnameController = TextEditingController(text: widget.user.firstname);
    lastnameController = TextEditingController(text: widget.user.lastname);
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: widget.user.phone);
    crewnameController = TextEditingController(text: widget.user.crewname);
    roleController = TextEditingController(text: widget.user.roles);
  }

  Future<void> updateUserProfile() async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.user.id)
          .update({
        "Firstname": firstnameController.text.trim(),
        "Lastname": lastnameController.text.trim(),
        "Phone": phoneController.text.trim(),
        "Crewname": crewnameController.text.trim(),
        "Roles": roleController.text.trim(),
        // Email & password are usually not updated here
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true); // go back to profile
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:
            const Text("Edit Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            EditableCard(
                label: "First Name",
                controller: firstnameController,
                icon: Icons.person),
            EditableCard(
                label: "Last Name",
                controller: lastnameController,
                icon: Icons.person_outline),
            EditableCard(
                label: "Phone", controller: phoneController, icon: Icons.phone),
            EditableCard(
                label: "Crew Name",
                controller: crewnameController,
                icon: Icons.group),
            EditableCard(
                label: "Role", controller: roleController, icon: Icons.badge),
            EditableCard(
                label: "Email",
                controller: emailController,
                icon: Icons.email,
                enabled: false),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: updateUserProfile,
              icon: const Icon(Icons.save),
              label: const Text("Save Changes"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
