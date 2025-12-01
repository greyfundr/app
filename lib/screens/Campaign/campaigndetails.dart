import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../class/api_service.dart';
import '../../class/jwt_helper.dart';
import '../../class/auth_service.dart';
import '../../main.dart';
import '../Dashboard/billscreen.dart';
import '../Dashboard/campaign_search_page.dart';
import '../Dashboard/homeprofile.dart';
import '../Dashboard/profile_screen.dart';
import 'package:flutter/services.dart';
import '../../class/global.dart';


class CampaignDetails extends StatefulWidget {
  final String id;
  const CampaignDetails({super.key, required this.id});

  @override
  State<CampaignDetails> createState() => _CampaignDetailPageState();
}

class _CampaignDetailPageState extends State<CampaignDetails> {
  @override
  void initState() {
    super.initState();
    loadProfile();
    loadCampaign();
  }

  int selectedTabIndex = 2;
  int financingSubTabIndex = 1; // Default: Expenditure
  int donationSubTabIndex = 1; // Default: Top Donors
  int userId = 0;

  Map<String, dynamic>? campaign;
  bool isLoading = true;
  String title = '';
  int campaignId = 0;
  String goal = '';
  String current = '';
  String description = '';
  String startDate = '';
  String endDate = '';
  int champion = 0;
  int donor = 0;
  String image = '';
  String first = '';
  String last = '';
  String profile = '';
  int _selectedIndex = 1; // Bills tab active
  double percentage = 0.00;
  int cId = 0;
  String occupation = '';
  late List< dynamic> moffer;
  late List< dynamic> aoffer;

  late bool campaignLive = true;

  final List<String> mainTabs = [
    "ABOUT",
    "FINANCING",
    "OFFERS",
    "DONATIONS",
    "COMMENTS",
  ];

  late List< dynamic> donations;

  void loadProfile() async {
    String? token = await AuthService().getToken();
    if (token != null && !JWTHelper.isTokenExpired(token)) {
      Map<String, dynamic> userData = JWTHelper.decodeToken(token);
      setState(() => userId = userData['user']['id']);
      setState(() => occupation = userData['user']['occupation']);

    } else {
      print("Token is expired or invalid");

    }
    // setState(() => user = res['user']);
  }

  void loadCampaign() async {
    try {
      final id = widget.id;
      final String baseUrl = 'https://api.greyfundr.com/campaign/getcampaign';
      final url = Uri.parse('$baseUrl/$id');

      final response = await http.get(url);



      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        //print(responseData);
        dynamic campaign = responseData['payload']['campaigns'];
        //print(campaign);
        List<dynamic> donors = responseData['payload']['donors'];
        print(donors);


        // Update all campaign data in setState
        setState(() {
          campaign = campaign;
          title = campaign['title'] ?? '';
          goal = campaign['goal_amount'].toString();
          current = campaign['current_amount'].toString() ?? '0';
          description = campaign['description'] ?? '';
          startDate = campaign['start_date'] ?? '';
          endDate = campaign['end_date'] ?? '';
          champion = campaign['champions'] ?? 0;
          donor = campaign['donors'] ?? 0;
          image = campaign['image'] ?? 0;
          image = image.replaceAll('\\', '/');
          cId = campaign['creator_id'];
          campaignId = campaign['id'];


          moffer = campaign['moffer'];
          aoffer = campaign['aoffer'];
          //final dataArray = JSON.parse(storedString);
          //List<dynamic> combinedList = [...muoffer, ...amoffer];
          print(moffer);
          print(aoffer);


          donations=donors.cast<Map<String, dynamic>>();
        });

        double a =campaign['current_amount'].toDouble();
        double b =campaign['goal_amount'].toDouble();

        double percent =  a/b;
        percentage = percent;

        print(percentage);

        final creatorId = campaign['creator_id'];

        if(userId == creatorId)
        {

          campaignLive = false;


        }

        // FIXED: Changed from localhost to actual API URL
        final String userBaseUrl = 'https://api.greyfundr.com/users/getUser';
        final userUrl = Uri.parse('$userBaseUrl/$creatorId');

        final userResponse = await http.get(userUrl);

        if (userResponse.statusCode == 200) {
          Map<String, dynamic> userData = jsonDecode(userResponse.body);
          print(userData);

          // FIXED: Update user data in setState
          setState(() {

            first = userData['first_name'];
            last = userData['last_name'];
            profile = userData['profile_pic'];

            isLoading = false;

          });

          print(first);
          print(last);
          print(profile);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Campaign Loaded successfully!'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          setState(() => isLoading = false);
        }
      } else {
        setState(() => isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No Campaign Found'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
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

  void _showAddMoneyModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          AddMoneyBottomSheet(
            userId:userId,
            creatorId: cId,
            campaignId:campaignId,
          ),
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MyBillScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeProfile()),
        );
        break;
    }
  }

  Widget _buildFinancingSubTabs() {
    final List<String> subTabs = ["Budgeting", "Expenditure"];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(subTabs.length, (index) {
          final bool isSelected = financingSubTabIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                financingSubTabIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? Colors.teal : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                subTabs[index],
                style: TextStyle(
                  color: isSelected ? Colors.teal : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 15,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDonationSubTabs() {
    final List<String> subTabs = ["All Donors", "Top Donors"];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(subTabs.length, (index) {
          final bool isSelected = donationSubTabIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                donationSubTabIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? Colors.teal : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                subTabs[index],
                style: TextStyle(
                  color: isSelected ? Colors.teal : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 15,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildExpenditureContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(
                flex: 2,
                child: Text("Expected Expense",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text("Estimate Cost",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text("Document",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: const [
              Expanded(flex: 2, child: Text("1. Vedic Hospital Bill")),
              Expanded(child: Text("₦3,458,000")),
              Expanded(
                  child: Text("View 2 docs",
                      style: TextStyle(color: Colors.teal))),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: const [
              Expanded(flex: 2, child: Text("2. Transportation")),
              Expanded(child: Text("₦458,000")),
              Expanded(
                  child: Text("No docs", style: TextStyle(color: Colors.grey))),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: const [
              Expanded(flex: 2, child: Text("3. Feeding and hygiene")),
              Expanded(child: Text("₦1,458,000")),
              Expanded(
                  child: Text("View 4 docs",
                      style: TextStyle(color: Colors.teal))),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(flex: 2, child: Text("4. Lab Tests")),
              const Expanded(child: Text("₦800,000")),
              Expanded(
                child: Row(
                  children: [
                    Image.asset('assets/images/doc1.png',
                        height: 40, width: 30, fit: BoxFit.cover),
                    const SizedBox(width: 4),
                    Image.asset('assets/images/doc2.png',
                        height: 40, width: 30, fit: BoxFit.cover),
                    const SizedBox(width: 4),
                    Image.asset('assets/images/doc3.png',
                        height: 40, width: 30, fit: BoxFit.cover),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Through the surgery we will be doing 20 lab tests at ₦40,000 each.",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(8)),
                child: const Text("Tags",
                    style: TextStyle(color: Colors.teal, fontSize: 13)),
              ),
              const SizedBox(width: 8),
              Image.asset('assets/images/doc1.png',
                  height: 40, width: 30, fit: BoxFit.cover),
              const SizedBox(width: 4),
              Image.asset('assets/images/doc2.png',
                  height: 40, width: 30, fit: BoxFit.cover),
              const SizedBox(width: 4),
              Image.asset('assets/images/doc3.png',
                  height: 40, width: 30, fit: BoxFit.cover),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Total Estimate =",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("₦6,458,000", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("7 docs", style: TextStyle(color: Colors.teal)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetingContent() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        "The Budgeting section provides a breakdown of planned expenses and funding allocation. "
            "Here, we outline projected spending categories and future fund distributions.",
        style: TextStyle(height: 1.4, color: Colors.black87),
      ),
    );
  }

  Widget _buildFinancingContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFinancingSubTabs(),
        financingSubTabIndex == 0
            ? _buildBudgetingContent()
            : _buildExpenditureContent(),
      ],
    );
  }


  Widget _buildTopdonorContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          ListView.builder(
            itemCount: donations.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final donor = donations[index];
              final amount = donor['amount'];
              final name = donor['name'];
              final date = donor['created_at'];
              DateTime specificDate = DateTime.parse(date); // Example: Nov 26, 2025, 10:30 AM

              // Get the current date and time
              DateTime now = DateTime.now();

              // Calculate the duration between the two dates
              Duration difference = now.difference(specificDate);

              // Get the difference in hours
              int hoursDifference = difference.inHours;
              return ListTile(
                leading: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/organizer.jpg'),
                ),
                title: Text(name),
                subtitle:  Text('₦ ${amount.toString()}'),
                trailing:  Text('${hoursDifference.toString()} hours',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAlldonorContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          ListView.builder(
            itemCount: donations.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final donor = donations[index];
              final amount = donor['amount'];
              final name = donor['name'];
              final date = donor['created_at'];
              DateTime specificDate = DateTime.parse(date); // Example: Nov 26, 2025, 10:30 AM

              // Get the current date and time
              DateTime now = DateTime.now();

              // Calculate the duration between the two dates
              Duration difference = now.difference(specificDate);

              // Get the difference in hours
              int hoursDifference = difference.inHours;
              return ListTile(
                leading: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/organizer.jpg'),
                ),
                title: Text(name),
                subtitle:  Text(amount.toString()),
                trailing:  Text("${hoursDifference.toString()} hours",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDonationContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDonationSubTabs(),
        donationSubTabIndex == 0
            ? _buildAlldonorContent()
            : _buildTopdonorContent(),
      ],
    );
  }

  Widget _buildTabContent() {
    switch (selectedTabIndex) {
      case 0:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            description.isEmpty
                ? "Welcome to [Charity Name], where together we can make a difference! "
                "We are dedicated to empowering lives and creating positive change in our community. "
                "Whether you're here to volunteer, donate, or spread the word, your support helps us provide "
                "essential resources to those in need."
                : description,
            style: const TextStyle(height: 1.4, color: Colors.black87),
          ),
        );

      case 1:
        return _buildFinancingContent();

      case 2:

        if(moffer.isEmpty || aoffer.isEmpty) {
          return Padding(

            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(

              'Manual Offers \n\n'

                  'Auto Offers \n\n',



              style: const TextStyle(height: 1.4, color: Colors.black87),
            ),
          );
        }
        else
          {
            return Padding(

              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(

                'Manual Offers \n\n'
                    "• Condition: ${moffer[0]['condition']} \n"
                    "• Reward: ${moffer[0]['reward']} \n\n"
                    'Auto Offers \n\n'
                    "• Condition: ${aoffer[0]['condition']} \n"
                    "• Reward: ${aoffer[0]['reward']} \n\n",


                style: const TextStyle(height: 1.4, color: Colors.black87),
              ),
            );

          }

      case 3:
        return _buildDonationContent();

      case 4:
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "User comments and feedback will be shown here.",
            style: TextStyle(height: 1.4, color: Colors.black87),
          ),
        );

      default:
        return const SizedBox();
    }
  }

  // FIXED: Calculate days safely with null checks
  int _calculateDaysLeft() {
    if (endDate.isEmpty || startDate.isEmpty) return 0;

    try {
      DateTime dateTimeObject = DateTime.parse(endDate);
      DateTime dateTimesObject = DateTime.parse(startDate);
      Duration difference = dateTimeObject.difference(dateTimesObject);
      return difference.inDays;
    } catch (e) {
      print('Error parsing dates: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {


    // FIXED: Safe calculation of days
    int days = _calculateDaysLeft();

    //final bool campaignLive = _isApproved && allStakeholdersApproved;

    // FIXED: Show loading indicator while data loads
    if (isLoading) {
      return Scaffold(
        body: const Center(
          child: CircularProgressIndicator(color: Colors.teal),
        ),
      );
    }


    return Scaffold(

      appBar: AppBar(
        title: const Text('Start Campaign'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined), label: "Bills"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Image.network(
                      "https://pub-bcb5a51a1259483e892a2c2993882380.r2.dev/${image}",
                      height: 240,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 6,
                        offset: const Offset(0, 3))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("₦$current raised of ₦$goal"),
                    const SizedBox(height: 6),
                    LinearPercentIndicator(
                      lineHeight: 8,
                      percent: percentage,
                      progressColor: Colors.teal,
                      backgroundColor: Colors.grey.shade200,
                      barRadius: const Radius.circular(8),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          const Icon(Icons.schedule,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text("$days Days left",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                        ]),
                        Row(children: [
                          const Icon(Icons.people_outline,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text("$donor Donors",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                          const SizedBox(width: 10),
                          const Icon(Icons.volunteer_activism_outlined,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('$champion Champions',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text("Organizer",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    TextButton(
                        onPressed: () {}, child: const Text("See All")),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 6,
                        offset: const Offset(0, 3))
                  ],
                ),
                child: Row(
                  children: [
                    // FIXED: Use NetworkImage for URL, AssetImage for local assets
                    CircleAvatar(
                      backgroundImage: profile.isNotEmpty &&
                          profile.startsWith('http')
                          ? NetworkImage(profile) as ImageProvider
                          : AssetImage(profile),
                      radius: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("$first $last",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(
                              occupation,
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade50,
                        foregroundColor: Colors.teal,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Follow"),
                    ),
                    const SizedBox(width: 10),
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/avatar.png'),
                      radius: 18,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: mainTabs.length,
                  itemBuilder: (context, index) {
                    final bool isSelected = selectedTabIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => selectedTabIndex = index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 20),
                        padding: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: isSelected
                                  ? Colors.teal
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          mainTabs[index],
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.grey,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              _buildTabContent(),
              const SizedBox(height: 24),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    if (campaignLive) ...[

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Champion"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _showAddMoneyModal,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Donate"),
                        ),
                      ),]
                    else ...[


                    ],
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}



// === Add Money Bottom Sheet ===
class AddMoneyBottomSheet extends StatefulWidget {
  final int userId;
  final int creatorId;
  final int campaignId;

  const AddMoneyBottomSheet({super.key, required this.userId, required this.creatorId, required this.campaignId,});

  @override
  State<AddMoneyBottomSheet> createState() => _AddMoneyBottomSheetState();
}

class _AddMoneyBottomSheetState extends State<AddMoneyBottomSheet> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _formatNumber(String value) {
    if (value.isEmpty) return '';
    String digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) return '';
    final formatter = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return digitsOnly.replaceAllMapped(formatter, (Match m) => '${m[1]},');
  }



  @override
  Widget build(BuildContext context) {

    Future<void> _onContinue() async {
      if (_amountController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter an amount')),
        );
        return;
      }
      String actualAmount = _amountController.text.replaceAll(',', '');
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Donating ₦$actualAmount to campaign')),
      );

      dynamic token = await ApiService().createDonation(widget.userId,widget.creatorId,widget.campaignId,int.parse(actualAmount));
      print(token);
      if(token)
      {
        print('found');

        navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (context) => CampaignSearchPage(),
            ));

      }

    }
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF007A74), Color(0xFF00B3AE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Amount',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'how much do you want to Donate? ',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF00C9C3),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _amountController,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '0',
                  hintStyle: TextStyle(
                    color: Colors.white54,
                    fontSize: 18,
                  ),
                  prefixText: '₦ ',
                  prefixStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    if (newValue.text.isEmpty) {
                      return newValue;
                    }
                    String formatted = _formatNumber(newValue.text);
                    return TextEditingValue(
                      text: formatted,
                      selection:
                      TextSelection.collapsed(offset: formatted.length),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B57),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'CONTINUE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
