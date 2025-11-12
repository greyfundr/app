// lib/screens/profile/billscreen.dart
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../services/api_service.dart';
// import '../../auth/login_screen.dart';
import 'homeprofile.dart';
import 'profile_screen.dart';

class MyBillScreen extends StatefulWidget {
  const MyBillScreen({super.key});

  @override
  State<MyBillScreen> createState() => _MyBillScreenState();
}

class _MyBillScreenState extends State<MyBillScreen> {
  // Map<String, dynamic>? user;
  int _selectedIndex = 1; // Bills tab active
  String selectedTab = 'Bill'; // Bill, Request, History

  @override
  void initState() {
    super.initState();
    // loadProfile();
  }

  // void loadProfile() async {
  //   final res = await ApiService.getProfile();
  //   setState(() => user = res['user']);
  // }

  // Future<void> logout() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('token');
  //   await prefs.remove('userId');

  //   if (!mounted) return;
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (_) => const LoginScreen()),
  //     (route) => false,
  //   );
  // }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF007A74), Color(0xFF00B3AE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage('assets/images/avatar.png'),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Good morning!",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "Daniel Imoh",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.search, color: Colors.white),
                              padding: EdgeInsets.zero,
                            ),
                            Stack(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.notifications_none, color: Colors.white),
                                  padding: EdgeInsets.zero,
                                ),
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Stats Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Total Point
                              const Text(
                                "Total Point",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: const [
                                  Text(
                                    "320Pts",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "200 points to your next star",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Total Balance with Add Money button
                              const Text(
                                "Total Balance",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "₦72,311.00",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Icon(Icons.remove_red_eye_outlined, color: Colors.white70, size: 16),
                                    ],
                                  ),
                                  // Add Money button at the right end
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.teal,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(Icons.add_circle_outline, size: 16),
                                        SizedBox(width: 4),
                                        Text("Add Money", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              
                              Row(
                                children: const [
                                  Text(
                                    "You owe: ₦23,200",
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                 
                                  SizedBox(width: 50),
                                  Text(
                                    "Creditors: ₦45,200",
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Total Bill
                              const Text(
                                "Total Bill",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "₦72,311.00",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Icon(Icons.remove_red_eye_outlined, color: Colors.white70, size: 16),
                                    ],
                                  ),
                                  // Add Money button at the right end
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFFF6B35),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(Icons.receipt_long, size: 16),
                                        SizedBox(width: 4),
                                        Text("Create Bill", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 4),
                              Row(
                                children: const [
                                  Text(
                                    "Champion",
                                    style: TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                  SizedBox(width: 50),
                                  Text(
                                    "Split",
                                    style: TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                  SizedBox(width: 70),
                                  Text(
                                    "Backed",
                                    style: TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Text(
                                    "₦85,700",
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                 
                                  const SizedBox(width: 40),
                                  const Text(
                                    "₦239,000",
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                  
                                  const SizedBox(width: 50),
                                  const Text(
                                    "₦32,600",
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(width: 12),
                                  // Create Bill button moved here
                                  // ElevatedButton(
                                  //   onPressed: () {},
                                  //   style: ElevatedButton.styleFrom(
                                  //     backgroundColor: Color(0xFFFF6B35),
                                  //     foregroundColor: Colors.white,
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(25),
                                  //     ),
                                  //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  //   ),
                                  //   child: Row(
                                  //     mainAxisSize: MainAxisSize.min,
                                  //     children: const [
                                  //       Icon(Icons.receipt_long, size: 16),
                                  //       SizedBox(width: 4),
                                  //       Text("Create Bill", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            // Trophy icon
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/images/trophy.png', // Add trophy icon
                                width: 40,
                                height: 40,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.emoji_events, color: Colors.amber, size: 40);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Feature icons row
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _featureIcon("Pay Bill", Icons.receipt, Colors.amber),
                  _featureIcon("Transfer Bill", Icons.swap_horiz, Colors.pink),
                  _featureIcon("Split Bill", Icons.call_split, Colors.green),
                  _featureIcon("Request Bill", Icons.request_page, Colors.orange),
                  _featureIcon("Scan Bill", Icons.qr_code_scanner, Colors.blue),
                ],
              ),
            ),

            // Horizontal scrolling bill cards
            Container(
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
                ],
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
                      onTap: () => setState(() => selectedTab = 'Bill'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedTab == 'Bill' ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: selectedTab == 'Bill'
                              ? [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 4, offset: Offset(0, 2))]
                              : [],
                        ),
                        child: Text(
                          "Bill",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: selectedTab == 'Bill' ? FontWeight.bold : FontWeight.normal,
                            color: selectedTab == 'Bill' ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTab = 'Request'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedTab == 'Request' ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          "Request",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: selectedTab == 'Request' ? FontWeight.bold : FontWeight.normal,
                            color: selectedTab == 'Request' ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTab = 'History'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedTab == 'History' ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          "History",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: selectedTab == 'History' ? FontWeight.bold : FontWeight.normal,
                            color: selectedTab == 'History' ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bills section header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Bills",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Split Bills",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Bills list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildBillCard(
                    title: "Help fight Cancer treatment for my sister",
                    timeLeft: "12 Days lft",
                    amountPaid: "₦24,000",
                    totalAmount: "₦50,000",
                    progress: 0.48,
                    remainingAmount: "₦26,000.00",
                    splits: "25 Split",
                    champions: "5 Champions",
                    backers: "3 Backers",
                    progressPercent: "70%",
                  ),
                  _buildBillCard(
                    title: "Help fight Cancer treatment for my sister",
                    timeLeft: "12 Days lft",
                    amountPaid: "₦24,000",
                    totalAmount: "₦50,000",
                    progress: 0.48,
                    remainingAmount: "₦26,000.00",
                    splits: "25 Split",
                    champions: "5 Champions",
                    backers: "3 Backers",
                    progressPercent: "70%",
                  ),
                  _buildBillCard(
                    title: "Help fight Cancer treatment for my sister",
                    timeLeft: "12 Days lft",
                    amountPaid: "₦24,000",
                    totalAmount: "₦50,000",
                    progress: 0.48,
                    remainingAmount: "₦26,000.00",
                    splits: "25 Split",
                    champions: "5 Champions",
                    backers: "3 Backers",
                    progressPercent: "70%",
                  ),
                ],
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
      width: 250,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 143, 147, 146),
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
                    color: Colors.white,
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
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  amount,
                  style: const TextStyle(
                    color: Colors.white70,
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

  Widget _buildBillCard({
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