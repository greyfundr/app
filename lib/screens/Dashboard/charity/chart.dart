import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../class/auth_service.dart';
import '../../../class/api_service.dart';  // Assuming this is where getCampaign() lives
import 'package:intl/intl.dart';
import '../../Auth/login_screen.dart';
import '../../../class/jwt_helper.dart';
import '../../Dashboard/homeprofile.dart';
import '../../Dashboard/notification_screen.dart';
import '../../Dashboard/profile_screen.dart';

class CharityScreen extends StatefulWidget {
  const CharityScreen({super.key});

  @override
  State<CharityScreen> createState() => _CharityScreenState();
}

class ConcaveBottomClipper extends CustomClipper<Path> {
  final double depth; // how deep the curve goes (30–60 looks perfect)

  

  const ConcaveBottomClipper({this.depth = 10});

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0) // top-left
      ..lineTo(size.width, 0) // top-right
      ..lineTo(size.width, size.height - depth) // go down to right side before curve
      ..quadraticBezierTo(
        size.width * 0.75, size.height, // control point (pulls up)
        size.width * 0.5, size.height - 0, // middle point (highest point of curve)
      )
      ..quadraticBezierTo(
        size.width * 0.25, size.height, // control point
        0, size.height - depth, // back to left side
      )
      ..close();

    ;

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _CharityScreenState extends State<CharityScreen> {
  bool _isHeaderCollapsed = false;
  
  Map<String, dynamic>? user;
  Map<String, dynamic>? wallet;
  int _selectedIndex = 1; // Bills tab active
  String selectedTab = 'Explore'; // Explore, For You, Following

  


  Widget _getTabContent() {
  switch (selectedTab) {
    case 'Explore':
      return _buildExploreTab();
    case 'For You':
      return _buildForYouTab();
    case 'Following':
      return _buildFollowingTab();
    default:
      return _buildExploreTab();  // Fallback to Explore
  }
}



Widget _buildExploreTab() {
  return ListView(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    // scrollDirection: Axis.horizontal,
    children: [
      _buildCampaignCard(
        title: "Help fight Cancer treatment for my sister",
        timeLeft: "12 Days left",
        amountPaid: "₦24,000",
        totalAmount: "₦50,000",
        progress: 0.48,
        remainingAmount: "₦26,000.00",
        splits: "25 Splits",
        champions: "5 Champions",
        backers: "3 Backers",
        progressPercent: "48%",
      ),
      _buildCampaignCard(
        title: "Support Education for Orphans in Lagos",
        timeLeft: "8 Days left",
        amountPaid: "₦180,000",
        totalAmount: "₦500,000",
        progress: 0.36,
        remainingAmount: "₦320,000.00",
        splits: "42 Splits",
        champions: "12 Champions",
        backers: "8 Backers",
        progressPercent: "36%",
      ),
      _buildCampaignCard(
        title: "Medical Emergency: Baby Needs Heart Surgery",
        timeLeft: "3 Days left",
        amountPaid: "₦2,100,000",
        totalAmount: "₦5,000,000",
        progress: 0.42,
        remainingAmount: "₦2,900,000.00",
        splits: "89 Splits",
        champions: "21 Champions",
        backers: "15 Backers",
        progressPercent: "42%",
      ),
      // Add more _buildCampaignCard() calls as needed for real data
    ],
  );
}

Widget _buildForYouTab() {
  return ListView(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    children: [
      Center(
        child: Column(
          children: [
            Icon(Icons.recommend_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "Personalized bills coming soon!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text(
              "We’ll show bills recommended just for you based on your interests.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
      // Later, replace with real personalized bills using _buildCampaignCard()
    ],
  );
}

Widget _buildFollowingTab() {
  return ListView(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    children: [
      Center(
        child: Column(
          children: [
            Icon(Icons.people_alt_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "No bills from people you follow yet",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text(
              "When someone you follow creates or backs a bill, it’ll appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
      // Later, add _buildCampaignCard() for followed users' bills
    ],
  );
}



  

  Widget _billSummaryColumn(String label, String amount) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      Text(amount, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
    ],
  );
}

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

     String formatAmount(dynamic amount) {
  final numValue = int.tryParse(amount.toString()) ?? 0;
  return NumberFormat("#,###").format(numValue);
}
final formatter = NumberFormat('#,##0.00'); // comma + 2 decimal places

  

 void loadProfile() async {
    String? token = await AuthService().getToken();
    if (token != null && !JWTHelper.isTokenExpired(token)) {
      Map<String, dynamic> userData = JWTHelper.decodeToken(token);
      setState(() => user = userData['user']);
      setState(() => wallet = userData['wallet']);
      print("User ID: ${userData['user']}");
      print("User ID: ${userData['wallet']}");
    } else {
      print("Token is expired or invalid");
    }
  }

   Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await AuthService().logout();

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
        break;
      case 1:
        // already on Bills
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeProfile()),
        );
        break;
    }
  }


  // void _showAddMoneyModal() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) => const AddMoneyBottomSheet(),
  //   );
  // }


  void _openSettingsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsActivityPage(
          user: user,
          onLogout: logout,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Column(
          children: [
            // Header Section
GestureDetector(
  onTap: () => setState(() => _isHeaderCollapsed = !_isHeaderCollapsed),
  child: AnimatedContainer(
    duration: const Duration(milliseconds: 400),
    curve: Curves.easeInOut,
    width: double.infinity,
    height: _isHeaderCollapsed ? 220: 370, // 195 when collapsed (tight!)
    child: ClipPath(
      clipper: const ConcaveBottomClipper(depth: 30),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF007A74), Color.fromARGB(255, 29, 45, 44)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // === 1. Top Bar: Name + Icons (Always visible) ===
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 23,
                            backgroundImage: const AssetImage('assets/images/personal.png'),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Hello!", style: TextStyle(color: Colors.white70, fontSize: 13)),
                              Text(
                                user != null ? "${user!['first_name']} ${user!['last_name']}" : "Loading...",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen())),
                            icon: const Icon(Icons.notifications_none, color: Colors.white),
                          ),
                          IconButton(
                            onPressed: _openSettingsPage,
                            icon: const Icon(Icons.menu, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // === 2. Collapsible Middle Section: Points + Balance (Only visible when expanded) ===
            AnimatedOpacity(
              opacity: _isHeaderCollapsed ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Offstage(
                offstage: _isHeaderCollapsed,
                child: Padding(
                  padding: const EdgeInsets.only(top: 78, left: 20, right: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 6),

                      // Points + Trophy
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Total Point", style: TextStyle(color: Colors.white70, fontSize: 12)),
                              SizedBox(height: 4),
                              Text("0Pts", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                              SizedBox(height: 4),
                              Text("10 points to your next star", style: TextStyle(color: Colors.white70, fontSize: 10)),
                            ],
                          ),
                          Image.asset('assets/images/trophy.png', width: 48, height: 48,
                            errorBuilder: (_, __, ___) => const Icon(Icons.emoji_events, color: Colors.amber, size: 42),
                          ),
                        ],
                      ),

                      const Divider(color: Colors.white24, height: 24),

                      // Balance + Add Money
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Total Balance", style: TextStyle(color: Colors.white70, fontSize: 12)),
                              Row(
                                children: [
                                  Text(
                                    wallet?['balance'] != null
                                        ? NumberFormat('#,##0.00').format(double.parse(wallet!['balance']))
                                        : '0.00',
                                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.remove_red_eye_outlined, color: Colors.white70, size: 18),
                                ],
                              ),
                              Text(
                                'You owe: ₦${wallet?['incoming_balance'] != null ? formatter.format(double.parse(wallet!['incoming_balance'])) : '0.00'}',
                                style: const TextStyle(color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 100,
                            child: ElevatedButton(
                            onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                side: const BorderSide(color: Colors.white, width: 1.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add_circle_outline, size: 18),
                                  SizedBox(height: 3),
                                  Text("Add Money", style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Divider(color: Colors.white24, height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // === 3. Always Visible: Total Bills + Create Bill (Moves up when collapsed!) ===
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              top: _isHeaderCollapsed ? 100 : 250,  // This is the magic!
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Total Donations", style: TextStyle(color: Colors.white70, fontSize: 12)),
                      const Text("₦0.00", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 8),
                      Row(
                        children: [

                          const Text("Funded 0.0M", style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(width: 20),
                          const Text("Champion 0.0M", style: TextStyle(color: Colors.white70, fontSize: 12)),
                          
                          
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFFF6B35),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: const [
      Icon(Icons.favorite_border, color: Colors.white, size: 16), // heart outline
      SizedBox(width: 6),
      Text(
        "Start Campaign",
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  ),
),
          

            // Feature icons row
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _featureIcon("Medical", Icons.receipt, Colors.amber),
                  _featureIcon("Education", Icons.swap_horiz, Colors.pink),
                  _featureIcon("Travel", Icons.call_split, Colors.green),
                  _featureIcon("Nature", Icons.request_page, Colors.orange),
                  _featureIcon("Animals", Icons.qr_code_scanner, Colors.blue),
                ],
              ),
            ),

            // Horizontal scrolling bill cards
            // Replace your current horizontal ListView container with this:
AnimatedOpacity(
  opacity: _isHeaderCollapsed ? 0.0 : 1.0,
  duration: const Duration(milliseconds: 400),
  child: AnimatedSlide(
    offset: _isHeaderCollapsed ? const Offset(0, -0.5) : Offset.zero,
    duration: const Duration(milliseconds: 450),
    curve: Curves.easeOut,
    child: Offstage(
      offstage: _isHeaderCollapsed,
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(left: 16, bottom: 16),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _horizontalBillCard(
              name: "Hip Replacement",
              subtitle: "Angel needs hip replacement",
              amount: "24 million naira",
            ),
            _horizontalBillCard(
              name: "Sandra's Wedding",
              subtitle: "My Wedding is coming soon",
              amount: "85 million",
            ),
            // Add more if you want
          ],
        ),
      ),
    ),
  ),
),

            // Tab selector
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTab = 'Explore'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedTab == 'Explore' ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: selectedTab == 'Explore'
                              ? [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 4, offset: Offset(0, 2))]
                              : [],
                        ),
                        child: Text(
                          "Explore",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: selectedTab == 'Explore' ? FontWeight.bold : FontWeight.normal,
                            color: selectedTab == 'Explore' ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTab = 'For You'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedTab == 'For You' ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          "For You",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: selectedTab == 'For You' ? FontWeight.bold : FontWeight.normal,
                            color: selectedTab == 'For You' ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTab = 'Following'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedTab == 'Following' ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          "Following",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: selectedTab == 'Following' ? FontWeight.bold : FontWeight.normal,
                            color: selectedTab == 'Following' ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // // Bills section header
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: const [
            //       Text(
            //         "Bills",
            //         style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           fontSize: 16,
            //         ),
            //       ),
            //       Text(
            //         "Split Bills",
            //         style: TextStyle(
            //           color: Colors.grey,
            //           fontSize: 14,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // Bills list
            Expanded(
  child: AnimatedSwitcher(
    duration: const Duration(milliseconds: 300),
    transitionBuilder: (child, animation) {
      return FadeTransition(opacity: animation, child: child);
    },
    child: _getTabContent(),
  ),
),
          ],
        ),
      ),

      // Bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF007A74),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Bills'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _featureIcon(String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _horizontalBillCard({
    required String name,
    required String subtitle,
    required String amount,
  }) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 232, 232, 232),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/avatar.png'),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 26, 25, 25),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color.fromARGB(179, 121, 121, 121),
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  amount,
                  style: const TextStyle(
                    color: Color.fromARGB(179, 37, 60, 48),
                    fontSize: 9,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size(60, 30),
            ),
            child: const Text(
              "Sort Bill",
              style: TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignCard({
    required String title,
    required String timeLeft,
    required String amountPaid,
    required String totalAmount,
    required double progress,
    required String remainingAmount,
    required String splits,
    required String champions,
    required String backers,
    required String progressPercent,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/avatar.png'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          timeLeft,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF007A74),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  "Sort Bill",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "$amountPaid paid of $totalAmount",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey[200],
                  color: Color(0xFF007A74),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      progressPercent,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.people_outline, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    splits,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.emoji_events_outlined, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    champions,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.favorite_outline, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    backers,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Text(
                remainingAmount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.send_outlined, color: Colors.grey[600]),
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

