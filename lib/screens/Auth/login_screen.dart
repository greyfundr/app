import 'package:flutter/material.dart';
import 'package:greyfdr/screens/Auth/pin_screen.dart';
import '../../class/api_service.dart';
import '../../class/jwt_helper.dart';
import 'register_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../class/auth_service.dart';
import '../Dashboard/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final emailController = TextEditingController();
  static final passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false; // Added loading state


  void loadProfile() async {
    String? token = await AuthService().getToken();
    if (token != null && !JWTHelper.isTokenExpired(token)) {
      Map<String, dynamic> userData = JWTHelper.decodeToken(token);
      var email = userData['user']['email'];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => PinScreen(email:email)),
      );
    } else {
      print("Token is expired or invalid");
    }
  }

  @override
  Widget build(BuildContext context) {
    void _showErrorDialog(BuildContext context, String message) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Error'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void login() async {
      // Start loading
      setState(() {
        _isLoading = true;
      });

      try {
        SharedPreferences.setMockInitialValues({});
        final email = emailController.text;
        final password = passwordController.text;

        dynamic token = await ApiService().login(email,password);

        // Stop loading
        setState(() {
          _isLoading = false;
        });

        if (token) {

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const ProfileScreen()),
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login Error!'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Stop loading on error
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog(context, 'An error occurred. Please try again.');
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
              // Top section
              Expanded(
                flex: 8,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  color: Colors.transparent,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "GreyFundr",
                        style: TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00796B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom section with curved background
              Expanded(
                flex: 12,
                child: ClipPath(
                  clipper: CurvedTopClipper(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    color: const Color(0xFFE0F2F1),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            "Welcome",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Log in to GreyFundr to continue",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Email / Phone
                          TextField(
                            controller: emailController,
                            enabled: !_isLoading, // Disable when loading
                            decoration: InputDecoration(
                              labelText: "Enter Email or Phone",
                              labelStyle: const TextStyle(color: Colors.grey),
                              suffixIcon: const Icon(Icons.email, color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Password
                          TextField(
                            controller: passwordController,
                            enabled: !_isLoading, // Disable when loading
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: const TextStyle(color: Colors.grey),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _isLoading ? null : () {}, // Disable when loading
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Login Button with Loading Spinner
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00796B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: _isLoading ? null : login, // Disable when loading
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text(
                                      "Log In",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Sign Up
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(color: Colors.grey),
                              ),
                              GestureDetector(
                                onTap: _isLoading ? null : () { // Disable when loading
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const RegisterScreen()),
                                  );
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: _isLoading ? Colors.grey : const Color(0xFF00796B),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
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

// Curved background clipper
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