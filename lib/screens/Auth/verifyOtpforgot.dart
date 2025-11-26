import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greyfdr/screens/Auth/login_screen.dart';
import 'chooseusername.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyPerScreen extends StatefulWidget {
  final String phoneNumber;
  final String email;


  const VerifyPerScreen({super.key, required this.phoneNumber, required this.email});

  @override
  State<VerifyPerScreen> createState() => _VerifyPerScreenState();
}

class _VerifyPerScreenState extends State<VerifyPerScreen> {
  final List<TextEditingController> _otpControllers =
  List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(4, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _onOtpBackspace(int index, String value) {
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void verifyCode() async {
    String values = '';
    for (var controller in _otpControllers) {
      values = values + controller.text;
    }



    final response = await http.post(
      Uri.parse('https://api.greyfundr.com/auth/verifyphone'),
      body: {
        'code': values,
        'email': widget.email,
      },
    );
    if (response.statusCode == 200) {
      // Handle successful login
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String message = responseData['message'];
      int id = responseData['id'];
      print('Response from Node.js: $responseData');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 2), // Optional: how long it shows
          backgroundColor: Colors.green, // Optional: customize color
        ),

      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );





    } else {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String message = responseData['error'];
      print('Response from Node.js: $message');

      _showErrorDialog(context,message);


    }

  }

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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => const NeedHelpScreen(),
                        //   ),
                        // );
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
                            "Verify",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Verify your phone number ending with ${widget.phoneNumber}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // iPhone Image
                          Center(
                            child: Image.asset(
                              "assets/images/iphone.png", // Replace with your actual iPhone image path
                              width: 120,
                              height: 180,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // OTP Input Boxes
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(4, (index) {
                              return SizedBox(
                                width: 50,
                                height: 60,
                                child: TextField(
                                  controller: _otpControllers[index],
                                  focusNode: _focusNodes[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    counterText: "",
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
                                      borderSide: const BorderSide(
                                        color: Color(0xFF00796B),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    _onOtpChanged(index, value);
                                  },
                                  onTap: () {
                                    // Clear the field when tapped
                                    _otpControllers[index].clear();
                                  },
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 20),

                          // Instructions text
                          const Center(
                            child: Text(
                              "we text you a One Time Password (OTP)\nenter the code to proceed.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Verify Button
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
                              // onPressed: () {
                              //   // Collect OTP
                              //   String otp = _otpControllers
                              //       .map((controller) => controller.text)
                              //       .join();
                              //   print("OTP Entered: $otp");

                              //   // Navigator.push(
                              //   //   context,
                              //   //   MaterialPageRoute(
                              //   //       builder: (_) => const NextScreen()),
                              //   // );
                              // },

                              onPressed: verifyCode,
                              child: const Text(
                                "Verify",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
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
