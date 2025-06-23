import 'package:flutter/material.dart';
import 'package:hikkingapp/model/users.dart';
import 'package:hikkingapp/profile/editprofile.dart';
import 'package:hikkingapp/provider/controller/user_state.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserdetailsState>(builder: (context, userstate, child) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            "My Profile",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () async {
                final user = await userstate.getUser();
                if (user != null) {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(user: user),
                    ),
                  );

                  if (updated == true) {
                    setState(() {}); // Refresh the profile with updated data
                  }
                }
              },
            ),
          ],
        ),
        body: FutureBuilder<UserModel?>(
          future: userstate.getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.white));
            }

            if (snapshot.hasError) {
              return Center(
                  child: Text("Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.white)));
            }

            final user = snapshot.data;

            if (user == null) {
              return const Center(
                  child: Text("User not found",
                      style: TextStyle(color: Colors.white)));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  buildCard("Full Name", "${user.firstname} ${user.lastname}",
                      Icons.person),
                  buildCard("Email", user.email, Icons.email),
                  buildCard("Phone", user.phone, Icons.phone),
                  buildCard("Crew", user.crewname, Icons.group),
                  buildCard("Role", user.roles, Icons.badge),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget buildCard(String label, String value, IconData icon) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(value, style: const TextStyle(color: Colors.white)),
        subtitle: Text(label, style: const TextStyle(color: Colors.white70)),
      ),
    );
  }
}
