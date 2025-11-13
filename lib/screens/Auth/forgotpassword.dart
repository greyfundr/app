// import 'package:flutter/material.dart';
// import '../../services/api_service.dart';
// import 'verify_otp_screen.dart';
// import 'login_screen.dart';

// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final identifierController = TextEditingController();
//   bool loading = false;

//   void sendOtp() async {
//     if (identifierController.text.isEmpty) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('Enter your phone or email')));
//       return;
//     }

//     setState(() => loading = true);
    
//     // Commented out authentication
//     // final res = await ApiService.sendOtp(identifierController.text);
//     // setState(() => loading = false);

//     // if (res['message'] == 'OTP sent successfully') {
//     //   Navigator.push(
//     //     context,
//     //     MaterialPageRoute(
//     //       builder: (_) => VerifyOtpScreen(identifier: identifierController.text),
//     //     ),
//     //   );
//     // } else {
//     //   ScaffoldMessenger.of(context)
//     //       .showSnackBar(SnackBar(content: Text(res['error'] ?? 'Error sending OTP')));
//     // }

//     // Bypass authentication for testing
//     await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
//     setState(() => loading = false);
    
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => VerifyOtpScreen(identifier: identifierController.text),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/images/login_bg.png"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: SafeArea(
//           child: Stack(
//             children: [
//               LayoutBuilder(
//                 builder: (context, constraints) {
//                   return SingleChildScrollView(
//                     padding: EdgeInsets.only(
//                       bottom: MediaQuery.of(context).viewInsets.bottom,
//                     ),
//                     child: ConstrainedBox(
//                       constraints: BoxConstraints(
//                         minHeight: constraints.maxHeight,
//                       ),
//                       child: IntrinsicHeight(
//                         child: Column(
//                           children: [
//                             // 🔹 Top Section
//                             Expanded(
//                               flex: 8,
//                               child: Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 40, horizontal: 20),
//                                 color: Colors.transparent,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: const [
//                                     Text(
//                                       "GreyFundr",
//                                       style: TextStyle(
//                                         fontSize: 28,
//                                         fontWeight: FontWeight.bold,
//                                         color: Color(0xFF00796B),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),

//                             // 🔹 Bottom Section
//                             Expanded(
//                               flex: 12,
//                               child: ClipPath(
//                                 clipper: CurvedTopClipper(),
//                                 child: Container(
//                                   width: double.infinity,
//                                   padding: const EdgeInsets.all(20),
//                                   color: const Color(0xFFE0F2F1),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       const Text(
//                                         "Forgot Password",
//                                         style: TextStyle(
//                                           fontSize: 24,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       const Text(
//                                         "Enter your phone number or email, and we will send you a code",
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 25),

//                                       // 🔹 Email or Phone Field
//                                       TextField(
//                                         controller: identifierController,
//                                         decoration: InputDecoration(
//                                           labelText: "Enter Email or Phone",
//                                           labelStyle:
//                                               const TextStyle(color: Colors.grey),
//                                           suffixIcon: const Icon(
//                                               Icons.email_outlined,
//                                               color: Colors.grey),
//                                           filled: true,
//                                           fillColor: Colors.white,
//                                           border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.circular(8),
//                                             borderSide: BorderSide.none,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(height: 25),

//                                       // 🔹 Continue Button
//                                       SizedBox(
//                                         width: double.infinity,
//                                         height: 50,
//                                         child: ElevatedButton(
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor:
//                                                 const Color(0xFF00796B),
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                             ),
//                                           ),
//                                           onPressed: loading ? null : sendOtp,
//                                           child: loading
//                                               ? const SizedBox(
//                                                   height: 20,
//                                                   width: 20,
//                                                   child: CircularProgressIndicator(
//                                                     color: Colors.white,
//                                                     strokeWidth: 2,
//                                                   ),
//                                                 )
//                                               : const Text(
//                                                   "CONTINUE",
//                                                   style: TextStyle(
//                                                     fontSize: 16,
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                         ),
//                                       ),
//                                       const SizedBox(height: 20),

//                                       // 🔹 Login Redirect
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           const Text(
//                                             "Click here to ",
//                                             style: TextStyle(color: Colors.grey),
//                                           ),
//                                           GestureDetector(
//                                             onTap: () {
//                                               Navigator.pushReplacement(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (_) =>
//                                                       const LoginScreen(),
//                                                 ),
//                                               );
//                                             },
//                                             child: const Text(
//                                               "Login",
//                                               style: TextStyle(
//                                                 color: Color(0xFF00796B),
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               // 🔹 Back Button in Top Left
//               Positioned(
//                 top: 16,
//                 left: 16,
//                 child: IconButton(
//                   icon: const Icon(
//                     Icons.arrow_back,
//                     color: Color(0xFF00796B),
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // 🔹 Curved Background Clipper
// class CurvedTopClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     path.lineTo(0, 20);

//     var firstControlPoint = Offset(size.width / 4, 0);
//     var firstEndPoint = Offset(size.width / 2, 1);

//     var secondControlPoint = Offset(3 * size.width / 4, 0);
//     var secondEndPoint = Offset(size.width, 30);

//     path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
//         firstEndPoint.dx, firstEndPoint.dy);
//     path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
//         secondEndPoint.dx, secondEndPoint.dy);

//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height