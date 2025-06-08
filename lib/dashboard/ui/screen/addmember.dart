import 'package:flutter/material.dart';

class AddMemberPage extends StatefulWidget {
  const AddMemberPage({super.key});

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  String title = "Crew";

  List<Map<String, dynamic>> members = [
    {"id": 1, "name": "Alice", "image": "https://i.pravatar.cc/150?img=1"},
    {"id": 2, "name": "Bob", "image": "https://i.pravatar.cc/150?img=2"},
    {"id": 3, "name": "Charlie", "image": "https://i.pravatar.cc/150?img=3"},
  ];

  List<int> selectedMemberIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top Row with Cancel and dynamic title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  // ✅ Conditionally show "Create" when members are selected and in New Group mode
                  if (title == "New Group" && selectedMemberIds.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        final selectedMembers = members
                            .where((member) =>
                                selectedMemberIds.contains(member["id"]))
                            .toList();

                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: Colors.grey[900],
                            title: const Text("Group Created",
                                style: TextStyle(color: Colors.white)),
                            content: Text(
                              "Selected Members:\n${selectedMembers.map((m) => m['name']).join(', ')}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("OK",
                                    style: TextStyle(color: Colors.blue)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text(
                        "Create",
                        style: TextStyle(fontSize: 16, color: Colors.green),
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

            // Member List for New Group
            if (title == "New Group")
              Expanded(
                child: ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    final isSelected = selectedMemberIds.contains(member["id"]);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isSelected,
                              activeColor: Colors.red,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    selectedMemberIds.add(member["id"]);
                                  } else {
                                    selectedMemberIds.remove(member["id"]);
                                  }
                                });
                              },
                            ),
                            CircleAvatar(
                              backgroundImage: NetworkImage(member["image"]),
                              radius: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              member["name"],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
