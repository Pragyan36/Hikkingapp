import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hikkingapp/constant/listview_widget.dart';
import 'package:hikkingapp/model/member_group.dart';
import 'package:hikkingapp/model/users.dart';
import 'package:hikkingapp/provider/controller/dashboard_state.dart';
import 'package:hikkingapp/provider/controller/group_state.dart';
import 'package:provider/provider.dart';

class AddMemberPage extends StatefulWidget {
  const AddMemberPage({super.key});

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  String title = "Crew";

  List<String> selectedMemberIds = [];
  @override
  void initState() {
    super.initState();
    loadCrewMembers();
    loadGroups();
  }

  List<UserModel> members = [];
  bool isLoading = true;
  Future<void> loadCrewMembers() async {
    final dashboardState = DashboardState();
    final fetchedMembers = await dashboardState.getCrewMembers();

    setState(() {
      members = fetchedMembers;
      isLoading = false;
    });
  }

  //fetch
  List<UsergroupModel> groups = [];

  Future<void> loadGroups() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('groups').get();

      final groupList = snapshot.docs.map((doc) {
        return UsergroupModel.fromJson(doc.data(), doc.id);
      }).toList();

      setState(() {
        groups = groupList;
        isLoading = false;
      });

      print("Loaded ${groups.length} groups");
      for (var g in groups) {
        print("Group: ${g.groupName}, Created by: ${g.createdBy}");
      }
    } catch (e) {
      print("Error loading groups: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupState>(builder: (context, groupstate, child) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const Spacer(),
                    if (title == "New Group" && selectedMemberIds.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          // Show dialog to input group name
                          showDialog(
                            context: context,
                            builder: (context) {
                              final TextEditingController groupNameController =
                                  TextEditingController();

                              return AlertDialog(
                                title: const Text('Enter Group Name'),
                                content: TextField(
                                  controller: groupNameController,
                                  decoration: const InputDecoration(
                                    hintText: 'Group Name',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close dialog
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final groupName =
                                          groupNameController.text.trim();
                                      if (groupName.isNotEmpty) {
                                        final selectedMembers = members
                                            .where((user) => selectedMemberIds
                                                .contains(user.id))
                                            .toList();
                                        // Call your createGroup function here:
                                        await groupstate.createGroup(
                                          groupName: groupName,
                                          createdBy: FirebaseAuth
                                              .instance.currentUser!.uid,
                                          members: selectedMembers,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "Group '$groupName' created!"),
                                            backgroundColor: Colors.green,
                                          ),
                                        );

                                        Navigator.of(context).pop();

                                        setState(() {
                                          title = "Crew";
                                          selectedMemberIds.clear();
                                          loadGroups();
                                        });
                                      } else {}
                                    },
                                    child: const Text('Create'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                          "Create",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.black),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Divider
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Divider(
                  color: Colors.grey,
                  thickness: 0.2,
                  height: 0,
                ),
              ),

              // New Group option
              GestureDetector(
                onTap: () {
                  setState(() {
                    title = "New Group";
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.group, color: Colors.white),
                        SizedBox(width: 12),
                        Text(
                          "New Group",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : (title == "New Group"
                        ? ListView.builder(
                            itemCount: members.length,
                            itemBuilder: (context, index) {
                              final member = members[index];
                              final isSelected =
                                  selectedMemberIds.contains(member.id!);

                              return ListItemWidget(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(member.profilePic ?? ""),
                                ),
                                title: "${member.firstname} ${member.lastname}",
                                selected: isSelected,
                                onCheckboxChanged: (value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedMemberIds.add(member.id!);
                                    } else {
                                      selectedMemberIds.remove(member.id!);
                                    }
                                  });
                                },
                              );
                            },
                          )
                        : ListView.builder(
                            itemCount: groups.length,
                            itemBuilder: (context, index) {
                              final group = groups[index];
                              return Card(
                                color: Colors.grey[900],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                  leading: const Icon(Icons.group,
                                      color: Colors.white),
                                  title: Text(
                                    group.groupName,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onTap: () {
                                    // Optional: do something on tap
                                    print('Tapped group ${group.groupName}');
                                  },
                                  // No checkbox needed here
                                ),
                              );
                            },
                          )),
              ),
            ],
          ),
        ),
      );
    });
  }
}
