import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'verify_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PersonalRegisterScreen extends StatelessWidget {
  const PersonalRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passController = TextEditingController();
    final confirmController = TextEditingController();

    void _showErrorDialog(context,String message) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registeration Error'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void register() async {
      final response = await http.post(
        Uri.parse('https://greyfoundr-backend.onrender.com/auth/register'),
        body: {
          'email': emailController.text,
          'username': emailController.text,
          'phone': phoneController.text,
          'password': passController.text,
          'cpassword': confirmController.text,
        },
      );
      if (response.statusCode == 200) {
        // Handle successful login
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String message = responseData['message'];
        print('Response from Node.js: $responseData');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User Register successful!'),
            duration: Duration(seconds: 2), // Optional: how long it shows
            backgroundColor: Colors.green, // Optional: customize color
          ),

        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );



      } else {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String message = responseData['error'];
        print('Response from Node.js: $message');

        _showErrorDialog(context,message);


      }

    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login_bg.png"), // 👈 background image
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Row: Back + Need Help
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),

                    // Need Help
                    GestureDetector(
                      onTap: () {
                        // TODO: add help navigation
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Need Help tapped")),
                        );
                      },
                      child: const Text(
                        "Need Help?",
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Top GreyFundr Section
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  child: const Center(
                    child: Text(
                      "GreyFundr",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00796B),
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Section with form
              Expanded(
                flex: 16,
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
                          const Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Create a GreyFundr account to continue",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Email
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: const TextStyle(color: Colors.grey),
                              suffixIcon:
                                  const Icon(Icons.email, color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Phone
                          TextField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              labelText: "Phone",
                              labelStyle: const TextStyle(color: Colors.grey),
                              suffixIcon:
                                  const Icon(Icons.phone, color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Password
                          TextField(
                            controller: passController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: const TextStyle(color: Colors.grey),
                              suffixIcon: const Icon(Icons.visibility_off,
                                  color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Retype Password
                          TextField(
                            controller: confirmController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Re-type Password",
                              labelStyle: const TextStyle(color: Colors.grey),
                              suffixIcon: const Icon(Icons.visibility_off,
                                  color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Continue Button
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
                              onPressed: register,
                              child: const Text(
                                "Continue",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Already have account? Login
                          // Already have account? Login
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Have an account? ",
                                style: TextStyle(color: Colors.grey),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                                  );
                                },
                                child: const Text(
                                  "Login Here",
                                  style: TextStyle(
                                    color: Colors.red,
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

// // Curved background clipper
// class CurvedTopClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     path.lineTo(0, 8);
//     path.quadraticBezierTo(
//       size.width / 2, -40, 
//       size.width, 20
//       );
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }


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
