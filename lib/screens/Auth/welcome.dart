import 'package:flutter/material.dart';
import 'dart:async';
import '../Dashboard/profile_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  final String userName;

  const WelcomeScreen({
    super.key,
    required this.userName,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to profile screen after 4 seconds
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfileScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Section
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hi!",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00796B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.userName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Section with curved top
              Expanded(
                flex: 17,
                child: ClipPath(
                  clipper: CurvedTopClipper(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    color: const Color(0xFFE0F2F1),
                    child: Column(
                      children: [
                        const Spacer(flex: 2),

                        // Checkmark Circle
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.5),
                            border: Border.all(
                              color: const Color(0xFF00796B).withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.check,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const Spacer(flex: 2),

                        // Welcome Text
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                            children: [
                              TextSpan(
                                text: "Welcome to\n",
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: "GreyFundr",
                                style: TextStyle(
                                  color: Color(0xFF00796B),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(flex: 1),

                        // Bottom Message
                        const Text(
                          "You are all set.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),

                        const Spacer(flex: 3),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurvedTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 20);

    var firstControlPoint = Offset(size.width / 4, 0);
    var firstEndPoint = Offset(size.width / 2, 1);

    var secondControlPoint = Offset(3 * size.width / 4, 0);
    var secondEndPoint = Offset(size.width, 30);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
