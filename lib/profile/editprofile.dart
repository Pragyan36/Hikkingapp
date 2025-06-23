import 'package:flutter/material.dart';
import 'package:hikkingapp/constant/editable_card.dart';
import 'package:hikkingapp/model/users.dart';
import 'package:hikkingapp/provider/controller/user_state.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<UserdetailsState>(context, listen: false);
      provider.initialize(widget.user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserdetailsState>(builder: (context, updatestate, child) {
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
                  controller: updatestate.firstnameController,
                  icon: Icons.person),
              EditableCard(
                  label: "Last Name",
                  controller: updatestate.lastnameController,
                  icon: Icons.person_outline),
              EditableCard(
                  label: "Phone",
                  controller: updatestate.phoneController,
                  icon: Icons.phone),
              EditableCard(
                  label: "Crew Name",
                  controller: updatestate.crewnameController,
                  icon: Icons.group),
              EditableCard(
                  label: "Role",
                  controller: updatestate.roleController,
                  icon: Icons.badge),
              EditableCard(
                  label: "Email",
                  controller: updatestate.emailController,
                  icon: Icons.email,
                  enabled: false),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => updatestate.updateUserProfile(context),
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
    });
  }
}
