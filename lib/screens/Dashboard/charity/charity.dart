import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../class/auth_service.dart';
import '../../../class/api_service.dart';  // Assuming this is where getCampaign() lives
import 'package:intl/intl.dart';
import '../../Auth/login_screen.dart';
import '../../Campaign/detailedcampaign.dart'; // ← CampaignDetailPage
import 'package:flutter_svg/flutter_svg.dart';
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
 bool _isHeaderCollapsed = true;  // ← This makes it collapsed by default
  
  Map<String, dynamic>? user;
  Map<String, dynamic>? wallet;
  int _selectedIndex = 1; // Bills tab active
  String selectedTab = 'Explore'; // Explore, For You, Following


  // NEW: Campaign data + lazy loading
  List<Map<String, dynamic>> _allCampaigns = [];
  List<Map<String, dynamic>> _displayedCampaigns = [];
  bool _isLoadingMore = false;
  final int _batchSize = 6;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState(); // ← Must be first
    _scrollController = ScrollController()..addListener(_onScroll);
    loadProfile();
    _loadCampaigns();
  }



  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _displayedCampaigns.length < _allCampaigns.length) {
      _loadMoreCampaigns();
    }
  }


  Future<void> _loadMoreCampaigns() async {
    if (_isLoadingMore) return;
    setState(() => _isLoadingMore = true);

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final start = _displayedCampaigns.length;
    final end = (start + _batchSize).clamp(0, _allCampaigns.length);
    final more = _allCampaigns.sublist(start, end);

    setState(() {
      _displayedCampaigns.addAll(more);
      _isLoadingMore = false;
    });
  }


  Future<void> _loadCampaigns() async {
    try {
      final response = await ApiService().getCampaign();
      if (!mounted) return;

      if (response == null || response is! List) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No campaigns found")),
        );
        return;
      }

      final List<Map<String, dynamic>> campaigns =
          response.cast<Map<String, dynamic>>();

      setState(() {
        _allCampaigns = campaigns;
        _displayedCampaigns = campaigns.take(_batchSize).toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }


// Number formatting helper (K, M)
  String _formatNumber(double number) {
    if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}K';
    return number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},');
  }
  


// Tab Content
  Widget _getTabContent() {
    switch (selectedTab) {
      case 'Explore':
        return _buildExploreTab();
      case 'For You':
        return _buildForYouTab();
      case 'Following':
        return _buildFollowingTab();
      default:
        return _buildExploreTab();
    }
  }

   Widget _buildExploreTab() {
    if (_allCampaigns.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _displayedCampaigns.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _displayedCampaigns.length) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF007A74),
              ),
            ),
          );
        }
        return _buildCampaignCard(_displayedCampaigns[index]);
      },
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

 









 Widget _buildCampaignCard(Map<String, dynamic> campaign) {
    final double currentAmount = double.tryParse(campaign['current_amount'].toString()) ?? 0.0;
    final double goalAmount = double.tryParse(campaign['goal_amount'].toString()) ?? 1.0;
    final double progressValue = goalAmount > 0 ? (currentAmount / goalAmount).clamp(0.0, 1.0) : 0.0;
    final int progressPercent = (progressValue * 100).round();

    final DateTime? endDate = DateTime.tryParse(campaign['end_date'] ?? '');
    final int daysLeft = endDate != null ? endDate.difference(DateTime.now()).inDays : 0;
    final String daysText = daysLeft <= 0
        ? "Ended"
        : daysLeft == 1
            ? "1 Day left"
            : "$daysLeft Days left";

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CampaignDetailPage(id: campaign['id'].toString()),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + Days Left Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    "https://pub-bcb5a51a1259483e892a2c2993882380.r2.dev/${campaign['image']}",
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null ? child : Container(height: 200, color: Colors.grey[200], child: const Center(child: CircularProgressIndicator())),
                    errorBuilder: (_, __, ___) => Container(height: 200, color: Colors.grey[300], child: const Icon(Icons.broken_image, size: 50)),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: daysLeft <= 3 ? Colors.red.withOpacity(0.9) : Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(daysLeft <= 0 ? Icons.timer_off : Icons.access_time, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(daysText, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(campaign['title'] ?? 'Untitled', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                            children: [
                              TextSpan(text: '₦${_formatNumber(currentAmount)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: ' raised of ₦${_formatNumber(goalAmount)}', style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CampaignDetailPage(id: campaign['id'].toString()))),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF007A74), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                        child: const Text('View', style: TextStyle(fontSize: 13, color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(value: progressValue, backgroundColor: Colors.grey[200], valueColor: const AlwaysStoppedAnimation(Color(0xFF007A74)), minHeight: 7),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.people, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('${campaign['donors'] ?? 0} Donors', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                      const SizedBox(width: 16),
                      const Icon(Icons.emoji_events, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${campaign['champions'] ?? 0} Champions', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                      const Spacer(),
                      Text('$progressPercent%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF007A74))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
      backgroundColor: Colors.transparent,     // no fill
      foregroundColor: Colors.white,            // text + icon color
      shadowColor: Colors.transparent,
      elevation: 0,
      // COMPLETELY REMOVE THE BORDER
      side: BorderSide.none,                    // This removes the white border
      // Optional: remove default splash overlay if you want it super clean
      splashFactory: NoSplash.splashFactory,   // removes ripple (remove if you want ripple)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/icons/plus2.svg',
          width: 22,
          height: 22,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Add Money",
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
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
                          const SizedBox(width: 30),
                          const Text("Champion 0.0M", style: TextStyle(color: Colors.white70, fontSize: 12)),
                          
                          
                        ],
                      ),
                    ],
                  ),
              SizedBox(
  height: 28, // exact height you want
  child: ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFF6B35),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      minimumSize: Size.zero, // removes default 48px min height
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.favorite_border, size: 13),
        SizedBox(width: 5),
        Text(
          "Start Campaign",
          style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
        ),
      ],
    ),
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
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 231, 231, 231),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTab = 'Explore'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          color: selectedTab == 'Explore' ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: selectedTab == 'Explore'
                              ? [BoxShadow(color: const Color.fromARGB(255, 248, 248, 248), blurRadius: 4, offset: Offset(0, 2))]
                              : [],
                        ),
                        child: Text(
                          "Explore",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: selectedTab == 'Explore' ? FontWeight.bold : FontWeight.normal,
                            color: selectedTab == 'Explore' ? Colors.black : const Color.fromARGB(255, 84, 84, 84),
                          ),
                        ),
                      ),
                    ),
                  ),




                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTab = 'For You'),
                      child: Container(
                        // padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          color: selectedTab == 'For You' ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "For You",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: selectedTab == 'For You' ? FontWeight.bold : FontWeight.normal,
                            color: selectedTab == 'For You' ? Colors.black : const Color.fromARGB(255, 84, 84, 84),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTab = 'Following'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          color: selectedTab == 'Following' ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Following",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: selectedTab == 'Following' ? FontWeight.bold : FontWeight.normal,
                            color: selectedTab == 'Following' ? Colors.black :const Color.fromARGB(255, 84, 84, 84),
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
              "Donate",
              style: TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  
}

