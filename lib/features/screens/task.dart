import 'package:flutter/material.dart';
import 'package:hikkingapp/constant/appbar.dart';

class CrewScreen extends StatefulWidget {
  const CrewScreen({super.key});

  @override
  State<CrewScreen> createState() => _CrewScreenState();
}

class _CrewScreenState extends State<CrewScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Appbar(),
            Container(
              child: Text("data"),
            )
          ],
        ),
      ),
    );
  }
}
