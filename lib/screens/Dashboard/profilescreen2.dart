// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import '../../auth/login_screen.dart';
// import 'homeprofile.dart';
// import 'billscreen.dart';




// import 'package:shared_preferences/shared_preferences.dart';
// import '../Auth/login_screen.dart';
// import '../../class/auth_service.dart';
// import '../../class/jwt_helper.dart';
// import '../Campaign/main_campaign.dart';
// import 'kyc.dart';



// // import 'kyc.dart';
// // import 'create/createnew.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {

//  Map<String, dynamic>? user;
  
//   int _selectedIndex = 0;

//    @override
//   void initState() {
//     super.initState();
//     loadProfile();
//   }


//   void loadProfile() async {
//     String? token = await AuthService().getToken();
//     if (token != null && !JWTHelper.isTokenExpired(token)) {
//       Map<String, dynamic> userData = JWTHelper.decodeToken(token);
//       setState(() => user = userData['user']);
//       print("User ID: ${userData['user']}");
//     } else {
//       print("Token is expired or invalid");

//     }
//    // setState(() => user = res['user']);
//   }

//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');
//     await prefs.remove('userId');
//     await AuthService().logout();

//     if (!mounted) return;
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (_) => const LoginScreen()),
//           (route) => false,
//     );
//   }


  

//   void _onItemTapped(int index) {
//     if (index == _selectedIndex) return;

//     setState(() => _selectedIndex = index);

//     switch (index) {
//       case 0:
//         break;
//       case 1:
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const MyBillScreen()),
//         );
//         break;
//       case 2:
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const HomeProfile()),
//         );
//         break;
//     }
//   }

//   void _showAddMoneyModal() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => const AddMoneyBottomSheet(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: user == null
//           ? const Center(child: CircularProgressIndicator())
//           : SafeArea(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             CircleAvatar(
//                               radius: 25,
//                               backgroundImage: user!['profile_pic'] != null
//                                   ? NetworkImage(user!['profile_pic'])
//                                   : const AssetImage('assets/images/avatar.png')
//                                       as ImageProvider,
//                             ),
//                             const SizedBox(width: 10),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "${user!['first_name']} ${user!['last_name']}",
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Text(
//                                   "@${user!['username']}",
//                                   style: const TextStyle(color: Colors.grey),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             IconButton(
//                               onPressed: () {},
//                               icon: const Icon(Icons.notifications_none),
//                             ),
//                             IconButton(
//                               onPressed: logout,
//                               icon: const Icon(Icons.logout, color: Colors.red),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 20),

//                     InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (_) => const KYCPage()),
//                         );
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.red[400],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Text(
//                               'Kindly verify your Identity to upgrade your account',
//                               style: TextStyle(color: Colors.white),
//                               textAlign: TextAlign.center,
//                             ),
//                             SizedBox(width: 8),
//                             Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
//                           ],
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 25),

//                     GridView.count(
//                       crossAxisCount: 2,
//                       shrinkWrap: true,
//                       crossAxisSpacing: 13,
//                       mainAxisSpacing: 13,
//                       physics: const NeverScrollableScrollPhysics(),
//                       children: [
//                         _buildFeatureCard('Lifestyle', 'assets/images/lifestyle.png', null),
//                         _buildFeatureCard('Invoices', 'assets/images/invoices.png', null),
//                         _buildFeatureCard('Create New', 'assets/images/create.png', () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (_) => const CampaignScreen()),
//                           );
//                         }),
//                         _buildFeatureCard('Charity', 'assets/images/charity.png', null),
//                       ],
//                     ),

//                     const SizedBox(height: 25),

//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [Color(0xFF007A74), Color(0xFF00B3AE)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Total Balance',
//                             style: TextStyle(color: Colors.white70, fontSize: 14),
//                           ),
//                           const SizedBox(height: 5),
//                           const Text(
//                             '₦72,311.00',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: const [
//                               Text('You owe: ₦23,200',
//                                   style: TextStyle(color: Colors.white70)),
//                               Text('You are owed: ₦45,200',
//                                   style: TextStyle(color: Colors.white70)),
//                             ],
//                           ),
//                           const SizedBox(height: 15),
//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: ElevatedButton.icon(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.white,
//                                 foregroundColor: Colors.teal,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                               ),
//                               onPressed: _showAddMoneyModal,
//                               icon: const Icon(Icons.add),
//                               label: const Text('Add Money'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.teal,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Bills'),
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Profile'),
//         ],
//       ),
//     );
//   }

//   Widget _buildFeatureCard(String title, String imagePath, VoidCallback? onTap) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Center(
//           child: Image.asset(
//             imagePath, 
//             height: 200, 
//             fit: BoxFit.contain,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // === Add Money Bottom Sheet ===
// class AddMoneyBottomSheet extends StatefulWidget {
//   const AddMoneyBottomSheet({super.key});

//   @override
//   State<AddMoneyBottomSheet> createState() => _AddMoneyBottomSheetState();
// }

// class _AddMoneyBottomSheetState extends State<AddMoneyBottomSheet> {
//   final TextEditingController _amountController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     // Auto-focus the text field when modal opens
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _focusNode.requestFocus();
//     });
//   }

//   @override
//   void dispose() {
//     _amountController.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   String _formatNumber(String value) {
//     if (value.isEmpty) return '';
    
//     // Remove all non-digits
//     String digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    
//     if (digitsOnly.isEmpty) return '';
    
//     // Format with commas
//     final formatter = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
//     return digitsOnly.replaceAllMapped(formatter, (Match m) => '${m[1]},');
//   }

//   void _onContinue() {
//     if (_amountController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter an amount')),
//       );
//       return;
//     }
    
//     // Remove commas to get actual number
//     String actualAmount = _amountController.text.replaceAll(',', '');
    
//     // Here you can process the amount
//     Navigator.pop(context);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Adding ₦$actualAmount to wallet')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF007A74), Color(0xFF00B3AE)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Enter Amount',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'how much do you want to add to you GreyFundr wallet',
//               style: TextStyle(
//                 color: Colors.white70,
//                 fontSize: 14,
//               ),
//             ),
//             const SizedBox(height: 24),
            
//             // Amount Input Field
//             Container(
//               decoration: BoxDecoration(
//                 color: const Color(0xFF00C9C3),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: TextField(
//                 controller: _amountController,
//                 focusNode: _focusNode,
//                 keyboardType: TextInputType.number,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   hintText: '0',
//                   hintStyle: TextStyle(
//                     color: Colors.white54,
//                     fontSize: 18,
//                   ),
//                   prefixText: '₦ ',
//                   prefixStyle: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 inputFormatters: [
//                   FilteringTextInputFormatter.digitsOnly,
//                   TextInputFormatter.withFunction((oldValue, newValue) {
//                     if (newValue.text.isEmpty) {
//                       return newValue;
//                     }
                    
//                     String formatted = _formatNumber(newValue.text);
//                     return TextEditingValue(
//                       text: formatted,
//                       selection: TextSelection.collapsed(offset: formatted.length),
//                     );
//                   }),
//                 ],
//               ),
//             ),
            
//             const SizedBox(height: 24),
            
//             // Continue Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _onContinue,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFFF6B57),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   elevation: 0,
//                 ),
//                 child: const Text(
//                   'CONTINUE',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1,
//                   ),
//                 ),
//               ),
//             ),
            
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }