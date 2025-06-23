import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hikkingapp/constant/appbar.dart';
import 'package:hikkingapp/model/users.dart';
import 'package:hikkingapp/provider/controller/dashboard_state.dart';
import 'package:provider/provider.dart';

class CrewScreen extends StatefulWidget {
  const CrewScreen({super.key});

  @override
  State<CrewScreen> createState() => _CrewScreenState();
}

class _CrewScreenState extends State<CrewScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardState>(builder: (context, dashboardstate, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              const Appbar(),
              Expanded(
                child: FutureBuilder<List<UserModel>>(
                  future: dashboardstate.getCrewMembers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text("Error: ${snapshot.error}",
                              style: const TextStyle(color: Colors.white)));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("No crew members found",
                            style: TextStyle(color: Colors.white)),
                      );
                    }

                    final users = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Card(
                          color: Colors.grey[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(
                              user.firstname + ' ' + user.lastname,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              user.email,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: Text(
                              user.roles,
                              style: const TextStyle(color: Colors.amber),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
