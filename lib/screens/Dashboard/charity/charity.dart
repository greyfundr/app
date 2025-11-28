import 'dart:io';

import 'package:flutter/material.dart';
import 'package:greyfdr/screens/Dashboard/profile_screen.dart';
// import '../../class/campaign.dart';
// import '../Campaign/detailedcampaign.dart';
// import 'notification_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Auth/login_screen.dart';
// import '../../class/auth_service.dart';
// import '../../class/jwt_helper.dart';
// import 'editprofile.dart'; 
// import 'homeprofile.dart';
import '../../../class/api_service.dart';
import '../../../class/participants.dart';
import '../../Campaign/detailedcampaign.dart';
import '../../Dashboard/profile_screen.dart';

class CharityPage extends StatefulWidget {
  const CharityPage({Key? key}) : super(key: key);

  @override
  State<CharityPage> createState() => _CharityPageState();
}

class _CharityPageState extends State<CharityPage>


    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;
  List<Map<String, dynamic>> _filteredCampaigns = [];



  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCampaigns();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCampaigns() async {
    List<Map<String, String>> offer = [];
    List<Map<String, String>> moffer = [];
    List<File> images = [];
    List<Participant> participant = [];

    try {
      setState(() => isLoading = true);

      dynamic token = await ApiService().getCampaign();


      // Add null check
      if (token == null) {
        print('API returned null');
        setState(() => isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No campaigns available'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Check if token is a List before casting
      if (token is! List) {
        print('Unexpected data type: ${token.runtimeType}');
        print('Data: $token');
        setState(() => isLoading = false);
        return;
      }

      setState(() {
        _filteredCampaigns = token.cast<Map<String, dynamic>>();;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading campaign: $e');
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: const Center(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Loading Campaign...'),
            ],

        ),
        )
      );
    }
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(),
            // Categories Section
            _buildCategories(),
            // Urgent Campaign Carousel
            _buildUrgentCampaigns(),
            // Tabs
            _buildTabs(),
            // Campaign List
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCampaignList(_filteredCampaigns),
                  _buildCampaignList(_getForYouCampaigns()),
                  _buildCampaignList(_getFollowingCampaigns()),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D7377),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Top Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/100',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Text(
                        'Bills',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 24),
                      const Text(
                        'Charity',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Text(
                        'Lifestyle',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.search, color: Colors.white, size: 20),
                  const SizedBox(width: 16),
                  Stack(
                    children: [
                      const Icon(Icons.notifications_outlined,
                          color: Colors.white, size: 20),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
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
          const SizedBox(height: 24),
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Ranking',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '234 th',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Philanthropy',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Donation',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '₦3.5',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  icon: const Icon(Icons.favorite, size: 16, color: Colors.white,),
                  label: const Text(
                    'Start Campaign',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      {'name': 'Medical', 'icon': '💊', 'color': Colors.pink[100]},
      {'name': 'Education', 'icon': '📚', 'color': Colors.blue[100]},
      {'name': 'Travel', 'icon': '🌍', 'color': Colors.cyan[100]},
      {'name': 'Nature', 'icon': '🌿', 'color': Colors.green[100]},
      {'name': 'Animal', 'icon': '🦁', 'color': Colors.orange[100]},
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: categories.map((cat) {
              return Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: cat['color'] as Color?,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        cat['icon'] as String,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cat['name'] as String,
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgentCampaigns() {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildUrgentCard(
            'Kidney Transplant',
            'Jasper needs a kidney transplant',
            '135 million naira.',
            'https://i.pravatar.cc/101',
          ),
          const SizedBox(width: 12),
          _buildUrgentCard(
            'Heart Surgery',
            'Jasper needs urgent surgery',
            '50 million naira.',
            'https://i.pravatar.cc/102',
          ),
        ],
      ),
    );
  }

  Widget _buildUrgentCard(
      String title, String subtitle, String amount, String image) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(image),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  amount,
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D7377),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              minimumSize: Size.zero,
            ),
            child: const Text(
              'Donate',
              style: TextStyle(fontSize: 11, color: Colors.white),

            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF0D7377),
        unselectedLabelColor: Colors.grey[400],
        indicatorColor: const Color(0xFF0D7377),
        indicatorWeight: 2,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(text: 'Explore'),
          Tab(text: 'For you'),
          Tab(text: 'Following'),
        ],
      ),
    );
  }

  Widget _buildCampaignList(List<Map<String, dynamic>> campaigns) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: campaigns.length,

      itemBuilder: (context, index) {

        return _buildCampaignCard(campaigns[index]);
      },
    );
  }

  Widget _buildCampaignCard(Map<String, dynamic> campaign) {
    print(campaign['title']);
    final currentAmount = campaign['current_amount'];
    final amount = campaign['goal_amount'];
    double progress = (currentAmount / amount) * 100;

    final startdate = campaign['start_date'];
    final enddate = campaign['end_date'];
    DateTime specificDate = DateTime.parse(startdate); // Example: Nov 26, 2025, 10:30 AM
    DateTime specificendDate = DateTime.parse(enddate); // Example: Nov 26, 2025, 10:30 AM


    // Calculate the duration between the two dates
    Duration difference = specificendDate.difference(specificDate);

    // Get the difference in hours
    int hoursDifference = difference.inDays;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  "https://pub-bcb5a51a1259483e892a2c2993882380.r2.dev/${campaign['image']}",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time,
                          color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '$hoursDifference Days left',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campaign['title'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 12),
                          children: [
                            TextSpan(
                              text: '₦ ${currentAmount}',
                              style:
                                  const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                            ),
                            TextSpan(
                              text: ' raised of ₦ ${amount}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CampaignDetailPage(
                                id: campaign['id'].toString()
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D7377),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                      ),
                      child: const Text(
                        'Donate',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF0D7377),
                    ),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('👥', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Text(
                      '${campaign['donors']} Donors',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 16),
                    const Text('⏱️', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Text(
                      '${campaign['champions']} Champions',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    const Spacer(),
                    Text(
                      '$progress %',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', true),
          _buildNavItem(Icons.description_outlined, 'Bills', false),
          _buildNavItem(Icons.person_outline, 'Profile', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFF0D7377) : Colors.grey[400],
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? const Color(0xFF0D7377) : Colors.grey[400],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getExploreCampaigns() {
    return [
      {
        'title': 'Borno State Flood Victims this year 2024 October',
        'image': 'https://picsum.photos/400/300?random=1',
        'raised': '347,000',
        'goal': '4,000,000',
        'donors': 100,
        'champions': 15,
        'daysLeft': 12,
        'progress': 70,
      },
      {
        'title': 'Help fight Cancer treatment for my sister',
        'image': 'https://picsum.photos/400/300?random=2',
        'raised': '125,000',
        'goal': '500,000',
        'donors': 45,
        'champions': 8,
        'daysLeft': 20,
        'progress': 25,
      },
      {
        'title': 'Build a School in Rural Community',
        'image': 'https://picsum.photos/400/300?random=3',
        'raised': '890,000',
        'goal': '2,000,000',
        'donors': 156,
        'champions': 22,
        'daysLeft': 8,
        'progress': 45,
      },
    ];
  }

  List<Map<String, dynamic>> _getForYouCampaigns() {
    return [
      {
        'title': 'Clean Water Project for Communities',
        'image': 'https://picsum.photos/400/300?random=4',
        'raised': '456,000',
        'goal': '1,000,000',
        'donors': 89,
        'champions': 12,
        'daysLeft': 15,
        'progress': 46,
      },
      {
        'title': 'Emergency Medical Equipment Fund',
        'image': 'https://picsum.photos/400/300?random=5',
        'raised': '678,000',
        'goal': '1,500,000',
        'donors': 120,
        'champions': 18,
        'daysLeft': 10,
        'progress': 45,
      },
    ];
  }

  List<Map<String, dynamic>> _getFollowingCampaigns() {
    return [
      {
        'title': 'Youth Education Scholarship Program',
        'image': 'https://picsum.photos/400/300?random=6',
        'raised': '234,000',
        'goal': '800,000',
        'donors': 67,
        'champions': 10,
        'daysLeft': 25,
        'progress': 29,
      },
    ];
  }
}