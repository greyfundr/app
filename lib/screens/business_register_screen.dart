import 'package:flutter/material.dart';

class BusinessRegisterScreen extends StatelessWidget {
  const BusinessRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Business / Organization Registration"),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text(
          "Business / Organization Register Screen",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
