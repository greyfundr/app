import 'package:flutter/material.dart';
// import 'package:greyfdr/screens/Auth/pin_screen.dart';
import '../../class/api_service.dart';
import '../../class/jwt_helper.dart';
import '../../utils/custom_message_modal.dart';        // ← Your modal
import '../../class/user.dart';
import '../../class/wallet.dart';
import 'check.dart';
import 'register_screen.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../class/auth_service.dart';
// import '../Dashboard/profile_screen.dart';               // ← AuthWrapper is here
// import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final emailController = TextEditingController();
  static final passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  late User user;
  late Wallet userWallet;

  // ← CORRECT PLACE: Outside build()
  Future<void> loadUser() async {
    String? token = await AuthService().getToken();
    if (token != null && !JWTHelper.isTokenExpired(token)) {
      Map<String, dynamic> userData = JWTHelper.decodeToken(token);

      user = User(
        id: userData['user']["id"],
        first_name: userData['user']["first_name"],
        last_name: userData['user']["last_name"],
        profile_pic: userData['user']["profile_pic"],
        username: userData['user']["username"],
        occupation: userData['user']["occupation"],
      );

      userWallet = Wallet(
        id: userData['wallet']["id"],
        balance: double.parse(userData['wallet']["balance"].toString()),
        incoming_balance: double.parse(userData['wallet']["incoming_balance"].toString()),
        balance_owed: double.parse(userData['wallet']["balance_owed"].toString()),
      );

      String userString = jsonEncode(user.toJson());
      String walletString = jsonEncode(userWallet.toJson());

      await AuthService().saveUserToken(userString);
      await AuthService().saveWalletToken(walletString);

      // ← No AlertDialog anymore! Success message shown in login()
    } else {
      print("Token is expired or invalid");
    }
  }

  // ← CORRECT PLACE: Outside build()
  Future<void> login() async {
    setState(() => _isLoading = true);

    try {
      final email = emailController.text.trim();
      final password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        CustomMessageModal.show(
          context: context,
          message: "Please fill in all fields",
          isSuccess: false,
        );
        setState(() => _isLoading = false);
        return;
      }

      dynamic token = await ApiService().login(email, password);

      setState(() => _isLoading = false);

      if (token != false && token != null) {
        await loadUser();

        CustomMessageModal.show(
          context: context,
          message: "Welcome back! Login successful",
          isSuccess: true,
          duration: const Duration(seconds: 2),
        );

        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AuthWrapper()),
            );
          }
        });
      } else {
        CustomMessageModal.show(
          context: context,
          message: "Invalid email or password",
          isSuccess: false,
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      CustomMessageModal.show(
        context: context,
        message: "Network error. Please try again.",
        isSuccess: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                flex: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
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
                          const Text("Welcome", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text("Log in to GreyFundr to continue", style: TextStyle(fontSize: 14, color: Colors.grey)),
                          const SizedBox(height: 20),

                          // Email Field
                          TextField(
                            controller: emailController,
                            enabled: !_isLoading,
                            decoration: InputDecoration(
                              labelText: "Enter Email or Phone",
                              labelStyle: const TextStyle(color: Colors.grey),
                              suffixIcon: const Icon(Icons.email, color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Password Field
                          TextField(
                            controller: passwordController,
                            enabled: !_isLoading,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: const TextStyle(color: Colors.grey),
                              suffixIcon: IconButton(
                                icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 10),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _isLoading ? null : () {},
                              child: const Text("Forgot Password?", style: TextStyle(color: Colors.red)),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00796B),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: _isLoading ? null : login,
                              child: _isLoading
                                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                  : const Text("Log In", style: TextStyle(fontSize: 16, color: Colors.white)),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Sign Up
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
                              GestureDetector(
                                onTap: _isLoading ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(color: _isLoading ? Colors.grey : const Color(0xFF00796B), fontWeight: FontWeight.bold),
                                ),
                              ),
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

class CurvedTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 20);
    var firstControlPoint = Offset(size.width / 4, 0);
    var firstEndPoint = Offset(size.width / 2, 1);
    var secondControlPoint = Offset(3 * size.width / 4, 0);
    var secondEndPoint = Offset(size.width, 30);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
