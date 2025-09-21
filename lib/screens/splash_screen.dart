import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            "assets/images/splash_bg.jpg", // 👈 replace with your file name
            fit: BoxFit.cover,
          ),

          // Dark overlay for readability (optional)
          Container(
            color: Colors.black.withOpacity(0.4),
          ),

          // Centered Logo/Text
          // const Center(
          //   child: Text(
          //     "GreyFundr",
          //     style: TextStyle(
          //       fontSize: 34,
          //       fontWeight: FontWeight.bold,
          //       color: Colors.white,
          //       letterSpacing: 1.5,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
