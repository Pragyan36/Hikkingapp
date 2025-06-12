import 'package:flutter/material.dart';

class EditableCard extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool? enabled;
  const EditableCard(
      {super.key,
      required,
      required this.label,
      required this.controller,
      required this.icon,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: TextField(
          controller: controller,
          enabled: enabled,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
