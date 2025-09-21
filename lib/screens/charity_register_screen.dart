import 'package:flutter/material.dart';

class CharityRegisterScreen extends StatelessWidget {
  const CharityRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Charity / Non Profit Organization Registration"),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text(
          "Charity / Non Profit Organization Register Screen",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
