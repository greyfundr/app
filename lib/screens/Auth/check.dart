import 'package:flutter/material.dart';

import '../../class/auth_service.dart';
import '../Dashboard/profile_screen.dart';
import 'login_screen.dart';
// ... imports for secure storage

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<String?> _checkToken() async {
    // Check for token in secure storage
    String? token = await AuthService().getToken();
    print(token);
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _checkToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while checking the token
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          // If token exists, go to Home; otherwise, go to Login
          if (snapshot.hasData && snapshot.data != null) {
            return const ProfileScreen(); // or navigate with replacement
          } else {
            return const LoginScreen(); // or navigate with replacement
          }
        }
      },
    );
  }
}
