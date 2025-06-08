import 'package:flutter/material.dart';
import 'package:hikkingapp/dashboard/ui/screen/addmember.dart';

class Appbar extends StatelessWidget {
  const Appbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.black45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Gantavya",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddMemberPage(), // Replace with your page widget
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
