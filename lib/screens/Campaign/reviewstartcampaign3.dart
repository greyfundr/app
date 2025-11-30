import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'error_boundary.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../class/auth_service.dart';
import '../../class/api_service.dart';
import '../../class/jwt_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'edit_campaign_screen.dart';
import 'campaigncheckapproved.dart';
import '../../class/campaign.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class Reviewstartcampaign3 extends StatefulWidget {
  final Campaign campaign;

  const Reviewstartcampaign3({
    super.key,
    required this.campaign
  });

  @override
  State<Reviewstartcampaign3> createState() => _ReviewStartCampaign3ScreenState();
}

class _ReviewStartCampaign3ScreenState extends State<Reviewstartcampaign3> {
  Map<String, dynamic>? user;
  int _selectedTabIndex = 0;

  // Editable content
  late String _editableDescription;
  List<Map<String, String>> _budgetItems = [];
  List<Map<String, String>> _offers = [];
  bool isLoading = false;

  late File _image;

  // Track expanded sections
  Map<String, bool> _expandedSections = {
    'ABOUT': true,
    'BUDGETING': false,
    'OFFERS': false,
  };


Widget _buildTeamMemberCard({
  String? profilePicUrl,
  String? fallbackImage,
  String? imageUrl,
  required String name,
  required String role,
  required bool isOrganizer,
}) {
  final double cardWidth = MediaQuery.of(context).size.width * 0.70;

  return Container(
    width: cardWidth,
    margin: EdgeInsets.only(right: 16),
    padding: EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 200, 200, 200),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: Offset(0, 4)),
      ],
    ),
    child: Row(
      children: [
        // Avatar
        Stack(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.grey[200],
              backgroundImage: _getImageProvider(profilePicUrl ?? imageUrl ?? fallbackImage),
            ),
            if (isOrganizer)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                  ),
                  child: Icon(Icons.star, size: 14, color: Colors.white),
                ),
              ),
          ],
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                role,
                style: GoogleFonts.inter(fontSize: 11.5, color: const Color.fromARGB(255, 69, 69, 69)),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Helper to safely load image
ImageProvider _getImageProvider(String? url) {
  if (url == null || url.isEmpty) {
    return AssetImage('assets/images/personal.png');
  }
  if (url.startsWith('http') || url.startsWith('https')) {
    return NetworkImage(url);
  }
  return AssetImage(url);
}

void _showTeamBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "List Of Campaign Particpants",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Team List
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                // 1. Organizer (Always first)
                _buildTeamMemberRow(
                  imageUrl: user?['profile_pic'] ?? 'assets/images/personal.png',
                  name: "${user?['first_name'] ?? 'You'} ${user?['last_name'] ?? ''}",
                  role: "Campaign Organizer",
                  isOrganizer: true,
                ),

                // 2. Selected Participants
                if (widget.campaign.participants.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        "No team members added yet",
                        style: GoogleFonts.inter(color: Colors.grey[600]),
                      ),
                    ),
                  )
                else
                  ...widget.campaign.participants.map((p) => _buildTeamMemberRow(
                        imageUrl: p.imageUrl,
                        name: p.name,
                        role: "Campaign Participant",
                        isOrganizer: false,
                      )),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildTeamMemberRow({
  required String imageUrl,
  required String name,
  required String role,
  required bool isOrganizer,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 181, 180, 180),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[300]!, width: 1),
    ),
    child: Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: imageUrl.startsWith('http')
                  ? NetworkImage(imageUrl)
                  : AssetImage(imageUrl) as ImageProvider,
              backgroundColor: Colors.grey[200],
            ),
            if (isOrganizer)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(Icons.star, size: 14, color: Colors.white),
                ),
              ),
          ],
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                role,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ],
          ),
        ),
        if (isOrganizer)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 60, 60, 60),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Host",
              style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.w600),
            ),
          ),
      ],
    ),
  );
}









  @override
  void initState() {
    super.initState();
    _editableDescription = widget.campaign.description;
    List<Map<String, String>> savedAutoOffers = widget.campaign.savedAutoOffers;
    List<Map<String, String>> savedManualOffers = widget.campaign.savedManualOffers;
    List<Map<String, String>> combinedList = [...savedAutoOffers, ...savedManualOffers];
    //print(savedAutoOffers);
    //print(savedManualOffers);
    _offers = combinedList;
    loadProfile();
  }

  void loadProfile() async {
    String? token = await AuthService().getToken();
    if (token != null && !JWTHelper.isTokenExpired(token)) {
      Map<String, dynamic> userData = JWTHelper.decodeToken(token);
      setState(() => user = userData['user']);

    } else {
      print("Token is expired or invalid");
    }
  }

  void createCampaign() async {
    setState(() => isLoading = true);
    final response = await ApiService().createCampaign(widget.campaign, user?['id']);
    print(response.data);
    if (response.statusCode == 200) {
      // Handle successful login
      setState(() => isLoading = false);
      String message = response.data['msg'];
      int id = response.data['id'];


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Campaign Saved successful!'),
          duration: Duration(seconds: 2), // Optional: how long it shows
          backgroundColor: Colors.green, // Optional: customize color
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CampaignApprovalPage(id:id)),
        );
      });

    } else {
      //dynamic responseData = jsonDecode(response.body);
      //String message = responseData['msg'];
      //final test = await ApiService().uploadImage(widget.campaign.imageUrl);

      //print(response.body);




    }

  }



  void _showEditBottomSheet() {
    // Temporary variables for editing
    String tempDescription = _editableDescription;
    List<Map<String, String>> tempBudgetItems = List.from(_budgetItems);
    List<Map<String, String>> tempOffers = List.from(_offers);

    // Controllers for new items
    TextEditingController aboutController = TextEditingController(text: tempDescription);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromRGBO(238, 240, 239, 1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Edit Campaign",
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(41, 47, 56, 1),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(16),
                      children: [
                        // ABOUT Section
                        _buildExpandableSection(
                          title: "ABOUT",
                          icon: Icons.info_outline,
                          setModalState: setModalState,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Campaign Description",
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(41, 47, 56, 0.7),
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: aboutController,
                                maxLines: 5,
                                onChanged: (value) {
                                  tempDescription = value;
                                },
                                decoration: InputDecoration(
                                  hintText: "Enter campaign description...",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(238, 240, 239, 1),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 164, 175, 1),
                                    ),
                                  ),
                                ),
                                style: GoogleFonts.inter(fontSize: 13),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16),

                        // BUDGETING Section
                        _buildExpandableSection(
                          title: "BUDGETING",
                          icon: Icons.account_balance_wallet_outlined,
                          setModalState: setModalState,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Budget Items",
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(41, 47, 56, 0.7),
                                ),
                              ),
                              SizedBox(height: 12),

                              // Budget items list
                              ...tempBudgetItems.asMap().entries.map((entry) {
                                int index = entry.key;
                                Map<String, String> item = entry.value;
                                return Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(247, 247, 249, 1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          item['expense'] ?? '',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          item['cost'] ?? '',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromRGBO(0, 164, 175, 1),
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                        onPressed: () {
                                          setModalState(() {
                                            tempBudgetItems.removeAt(index);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),

                              SizedBox(height: 8),

                              // Add new budget item button
                              OutlinedButton.icon(
                                onPressed: () {
                                  _showAddBudgetItemDialog(context, setModalState, tempBudgetItems);
                                },
                                icon: Icon(Icons.add, size: 18),
                                label: Text("Add Budget Item"),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Color.fromRGBO(0, 164, 175, 1),
                                  side: BorderSide(color: Color.fromRGBO(0, 164, 175, 1)),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16),

                        // OFFERS Section
                        _buildExpandableSection(
                          title: "OFFERS",
                          icon: Icons.card_giftcard_outlined,
                          setModalState: setModalState,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Campaign Offers",
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(41, 47, 56, 0.7),
                                ),
                              ),
                              SizedBox(height: 12),

                              // Offers list
                              ...tempOffers.asMap().entries.map((entry) {
                                int index = entry.key;
                                Map<String, String> offer = entry.value;
                                return Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(247, 247, 249, 1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Color.fromRGBO(238, 240, 239, 1),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Condition:",
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(41, 47, 56, 0.7),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                            padding: EdgeInsets.zero,
                                            constraints: BoxConstraints(),
                                            onPressed: () {
                                              setModalState(() {
                                                tempOffers.removeAt(index);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      Text(
                                        offer['condition'] ?? '',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Reward:",
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromRGBO(41, 47, 56, 0.7),
                                        ),
                                      ),
                                      Text(
                                        offer['reward'] ?? '',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromRGBO(0, 164, 175, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),

                              SizedBox(height: 8),

                              // Add new offer button
                              OutlinedButton.icon(
                                onPressed: () {
                                  _showAddOfferDialog(context, setModalState, tempOffers);
                                },
                                icon: Icon(Icons.add, size: 18),
                                label: Text("Add Offer"),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Color.fromRGBO(0, 164, 175, 1),
                                  side: BorderSide(color: Color.fromRGBO(0, 164, 175, 1)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Update Button
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Color.fromRGBO(238, 240, 239, 1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _editableDescription = tempDescription;
                            _budgetItems = tempBudgetItems;
                            _offers = tempOffers;
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Campaign updated successfully!'),
                              backgroundColor: Color.fromRGBO(0, 164, 175, 1),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(0, 164, 175, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          "UPDATE",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 100,)
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required IconData icon,
    required StateSetter setModalState,
    required Widget child,
  }) {
    bool isExpanded = _expandedSections[title] ?? false;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(238, 240, 239, 1)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setModalState(() {
                _expandedSections[title] = !isExpanded;
              });
            },
            child: Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: Color.fromRGBO(0, 164, 175, 1)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(41, 47, 56, 1),
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Color.fromRGBO(142, 150, 163, 1),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color.fromRGBO(238, 240, 239, 1)),
                ),
              ),
              child: child,
            ),
        ],
      ),
    );
  }

  void _showAddBudgetItemDialog(BuildContext context, StateSetter setModalState, List<Map<String, String>> budgetItems) {
    TextEditingController expenseController = TextEditingController();
    TextEditingController costController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Add Budget Item",
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: expenseController,
                decoration: InputDecoration(
                  labelText: "Expected Expense",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                style: GoogleFonts.inter(fontSize: 13),
              ),
              SizedBox(height: 16),
              TextField(
                controller: costController,
                decoration: InputDecoration(
                  labelText: "Estimated Cost",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixText: "₦ ",
                ),
                keyboardType: TextInputType.number,
                style: GoogleFonts.inter(fontSize: 13),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (expenseController.text.isNotEmpty && costController.text.isNotEmpty) {
                  setModalState(() {
                    budgetItems.add({
                      'expense': expenseController.text,
                      'cost': "₦${costController.text}",
                    });
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(0, 164, 175, 1),
              ),
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showAddOfferDialog(BuildContext context, StateSetter setModalState, List<Map<String, String>> offers) {
    TextEditingController conditionController = TextEditingController();
    TextEditingController rewardController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Add Offer",
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: conditionController,
                decoration: InputDecoration(
                  labelText: "Condition",
                  hintText: "e.g., Donate ₦10,000 or more",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                style: GoogleFonts.inter(fontSize: 13),
              ),
              SizedBox(height: 16),
              TextField(
                controller: rewardController,
                decoration: InputDecoration(
                  labelText: "Reward",
                  hintText: "e.g., Free t-shirt and certificate",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                style: GoogleFonts.inter(fontSize: 13),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (conditionController.text.isNotEmpty && rewardController.text.isNotEmpty) {
                  setModalState(() {
                    offers.add({
                      'condition': conditionController.text,
                      'reward': rewardController.text,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(0, 164, 175, 1),
              ),
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0: // ABOUT
        return Container(
          padding: EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Text(
              _editableDescription,
              style: GoogleFonts.inter(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(0, 0, 0, 0.7),
                decoration: TextDecoration.none,
              ),
            ),
          ),
        );

      case 1: // BUDGETING
        return Container(
          padding: EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Campaign Budget Breakdown",
                  style: GoogleFonts.inter(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(0, 0, 0, 0.8),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 10),
               
               
                ..._budgetItems.map((item) =>
                  _buildBudgetItem(item['expense']!, item['cost']!)
                ),
                if (_budgetItems.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "No custom budget items added",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );

      case 2: // OFFERS
        return Container(
          padding: EdgeInsets.all(15.0),
          child: _offers.isEmpty
              ? Center(
                  child: Text(
                    "No offers available yet",
                    style: GoogleFonts.inter(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                      decoration: TextDecoration.none,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _offers.map((offer) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(247, 247, 249, 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              offer['condition']!,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(0, 0, 0, 0.8),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Reward: ${offer['reward']}",
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(0, 164, 175, 1),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
        );

      case 3: // DONATIONS
        return Container(
          padding: EdgeInsets.all(15.0),
          child: Center(
            child: Text(
              "No donations yet. Be the first to donate!",
              style: GoogleFonts.inter(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(0, 0, 0, 0.5),
                decoration: TextDecoration.none,
              ),
            ),
          ),
        );

      case 4: // COMMENTS
        return Container(
          padding: EdgeInsets.all(15.0),
          child: Center(
            child: Text(
              "No comments yet",
              style: GoogleFonts.inter(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(0, 0, 0, 0.5),
                decoration: TextDecoration.none,
              ),
            ),
          ),
        );

      default:
        return Container();
    }
  }

  Widget _buildBudgetItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.0,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(0, 0, 0, 0.6),
              decoration: TextDecoration.none,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 11.0,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 0, 0, 0.8),
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: GoogleFonts.inter(
                color: isSelected
                    ? Color.fromRGBO(41, 47, 56, 0.8)
                    : Color.fromRGBO(142, 150, 163, 0.7),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 9.0,
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 3),
            Container(
              height: 3,
              width: text.length * 5.0,
              decoration: BoxDecoration(
                color: isSelected
                    ? Color.fromRGBO(41, 47, 56, 0.8)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (isLoading) {
      return Scaffold(
          body: const Center(
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Uploading Images...'),
              ],

            ),
          )
      );
    }

    DateTime startsDate = DateFormat('dd/MM/yyyy').parse(widget.campaign.startDate);
    DateTime endsDate = DateFormat('dd/MM/yyyy').parse(widget.campaign.endDate);
    Duration difference = endsDate.difference(startsDate);
    int days = difference.inDays;
    int i = user!['id'];
    String id = i.toString();

    return Scaffold(
      extendBodyBehindAppBar: true, // This is the key line
      appBar: PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0, top: 8.0),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 22,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black54,
                offset: Offset(0, 1),
              ),
            ],
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: const [SizedBox(width: 56)], // Balanced spacing
    ),
  ),
      body: ErrorBoundary(
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1.0)),
          child: SingleChildScrollView(
            child: ErrorBoundary(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 956.0,
                child: LayoutBuilder(
                  builder: (BuildContext context, constraints) => Stack(
                    children: [
                      //Offers
                      Positioned(
                        left: 333.0,
                        top: 320.0,
                        child: ErrorBoundary(
                          child: Container(
                            width: 42.0 + 10,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "Offers",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.0,
                                  decoration: TextDecoration.none,
                                  color: Color.fromRGBO(251, 251, 255, 1.0),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      //Status
                      


                      //Campaign Title
                      Positioned(
                        top: 252.0,
                        left: 16.0,
                        child: ErrorBoundary(
                          child: Container(
                            
                            child: Text(
                              widget.campaign.title,
                              style: GoogleFonts.inter(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(41, 47, 56, 1.0),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      //Progress Box Background
                      Positioned(
                        top: 287.0,
                        left: (constraints.maxWidth / 2) - (440.0 / 2 - 16.0),
                        child: ErrorBoundary(
                          child: Container(
                            clipBehavior: Clip.none,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: Color.fromRGBO(238, 240, 239, 0.81),
                            ),
                            width: 408.0,
                            height: 78.0,
                          ),
                        ),
                      ),
                      //Organizer Label
                      Positioned(
                        top: 377.0,
                        left: 20.0,
                        child: ErrorBoundary(
                          child: Container(
                            width: 65.0,
                            child: Text(
                              "Organizer",
                              style: GoogleFonts.inter(
                                color: Color.fromRGBO(0, 0, 0, 1.0),
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0,
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),



                      //See All
                     Positioned(
  left: 340.0,
  top: 375.0,
  child: GestureDetector(
    onTap: () {
      _showTeamBottomSheet(context);
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color.fromARGB(37, 240, 240, 240).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromARGB(25, 0, 150, 135), width: 1),
      ),
      child: Text(
        "See All",
        style: GoogleFonts.inter(
          color: Colors.teal,
          fontWeight: FontWeight.w600,
          fontSize: 11.0,
        ),
      ),
    ),
  ),
),




                      //Progress % Text
                      Positioned(
                        top: 321.0,
                        left: 380.0,
                        child: ErrorBoundary(
                          child: Text(
                            "0%",
                            style: GoogleFonts.inter(
                              color: Color.fromRGBO(0, 0, 0, 1.0),
                              fontWeight: FontWeight.w500,
                              fontSize: 9.0,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                      //Raised Amount
                      Positioned(
                        left: 24.0,
                        top: 300.0,
                        child: ErrorBoundary(
                          child: RichText(
                            text: TextSpan(
                              text: "₦ 0 Raised of ",
                              style: GoogleFonts.inter(
                                fontSize: 11.0,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(41, 47, 56, 1.0),
                                decoration: TextDecoration.none,
                              ),
                              children: [
                                TextSpan(
  text: NumberFormat.currency(
    locale: 'en_NG',           // Nigerian English locale
    symbol: '₦',               // Naira symbol
    decimalDigits: 0,          // set to 2 if you want .00
  ).format(widget.campaign.amount),
  style: GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 11.0,
    color: const Color.fromRGBO(41, 47, 56, 1.0),
    decoration: TextDecoration.none,
  ),
),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //Days Left
                      Positioned(
                        left: 350.0,
                        top: 300.0,
                        child: ErrorBoundary(
                          child: Text(
                            '$days Days left',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 9.0,
                              color: Color.fromRGBO(41, 47, 56, 1.0),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),




                      //PROGRESS BAR
                      Positioned(
                        left: 22.0,
                        top: 321.0,
                        child: ErrorBoundary(
                          child: SizedBox(
                            width: 350.0,
                            height: 16.0,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double targetAmount = double.tryParse(
                                  widget.campaign.amount.toString().replaceAll('₦', '').replaceAll(',', '').trim()
                                ) ?? 1.0;
                                double raisedAmount = 0.0;
                                double progress = targetAmount > 0 ? raisedAmount / targetAmount : 0.0;
                                progress = progress.clamp(0.0, 1.0);
                                double indicatorPosition = constraints.maxWidth * progress;

                                return Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 4.0,
                                      child: Container(
                                        width: 392.0,
                                        height: 8.0,
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(192, 206, 199, 1),
                                          borderRadius: BorderRadius.circular(4.0),
                                        ),
                                      ),
                                    ),
                                    if (progress > 0)
                                      Positioned(
                                        left: 0,
                                        top: 4.0,
                                        child: Container(
                                          width: indicatorPosition,
                                          height: 8.0,
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(0, 164, 175, 1.0),
                                            borderRadius: BorderRadius.circular(4.0),
                                          ),
                                        ),
                                      ),
                                    Positioned(
                                      left: indicatorPosition > 0 ? indicatorPosition - 8.0 : 0,
                                      top: 0,
                                      child: Container(
                                        width: 16.0,
                                        height: 16.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: progress > 0
                                              ? Color.fromRGBO(0, 164, 175, 1.0)
                                              : Color.fromRGBO(142, 150, 163, 1.0),
                                          border: Border.all(
                                            color: Color.fromRGBO(255, 255, 255, 1.0),
                                            width: 2.0,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(0, 0, 0, 0.15),
                                              blurRadius: 4.0,
                                              offset: Offset(0, 2.0),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            progress > 0 ? '${(progress * 100).toInt()}%' : '',
                                            style: GoogleFonts.inter(
                                              fontSize: 6.0,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(255, 255, 255, 1.0),
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      
                      //Champions Count
                      Positioned(
                        left: 162.0,
                        top: 341.0,
                        child: ErrorBoundary(
                          child: Text(
                            "0 Champions",
                            style: GoogleFonts.inter(
                              color: Color.fromRGBO(41, 47, 56, 0.8),
                              fontSize: 11.0,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                      //Donors Count
                      Positioned(
                        top: 341.0,
                        left: 44.0,
                        child: ErrorBoundary(
                          child: Text(
                            "0 Donors",
                            style: GoogleFonts.inter(
                              color: Color.fromRGBO(41, 47, 56, 0.8),
                              fontSize: 11.0,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                      //Award Icon
                      Positioned(
                        left: 45.0,
                        top: 341.0,
                        child: ErrorBoundary(
                          child: SvgPicture.asset(
                            "assets/images/group_2.svg",
                            height: 18.0,
                            width: 18.0,
                          ),
                        ),
                      ),



                      //TAB SECTION - HEADER
                      Positioned(
                        top: 490.0,
                        left: 18.0,
                        child: ErrorBoundary(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(241, 241, 247, 1.0),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6.0),
                                topRight: Radius.circular(6.0),
                              ),
                            ),
                            height: 35.0,
                            width: 395.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildTabButton("ABOUT", 0),
                                _buildTabButton("BUDGETING", 1),
                                _buildTabButton("OFFERS", 2),
                                _buildTabButton("DONATIONS", 3),
                                _buildTabButton("COMMENTS", 4),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //TAB CONTENT AREA
                      Positioned(
                        top: 531.0,
                        left: 18.0,
                        child: ErrorBoundary(
                          child: Container(
                            height: 128.0,
                            width: 395.0,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(241, 241, 247, 1.0),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(6.0),
                                bottomRight: Radius.circular(6.0),
                              ),
                            ),
                            child: _buildTabContent(),
                          ),
                        ),
                      ),






                      //Customise Button
                      Positioned(
                        left: 44.0,
                        top: 700.0,
                        child: ErrorBoundary(
                          child: Container(
                            height: 43.0,
                            width: 162.0,
                            clipBehavior: Clip.none,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromRGBO(255, 83, 79, 1.0),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Center(
                              child: Text(
                                "CUSTOMISE",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.0,
                                  color: Color.fromRGBO(252, 100, 58, 1.0),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),




                      //Edit Campaign Button
                      Positioned(
  left: 234.0,
                        top: 700.0,
  // bottom: 20.0, // Nice safe area from bottom
  child: ErrorBoundary(
    child: SizedBox(
      height: 43.0,
                              width: 162.0,
                              
      child: ElevatedButton(
        onPressed: () async {
          // Navigate to the new full-screen Edit Campaign Page
          final updatedCampaign = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditCampaignScreen(campaign: widget.campaign),
            ),
          );

          // If user saved changes and returned a new campaign object
          if (updatedCampaign is Campaign && mounted) {
            setState(() {
              // Update all editable fields locally so the review page reflects changes immediately
              widget.campaign.title = updatedCampaign.title;
              widget.campaign.description = updatedCampaign.description;
              widget.campaign.images = updatedCampaign.images;
              widget.campaign.participants = updatedCampaign.participants;
              widget.campaign.savedManualOffers = updatedCampaign.savedManualOffers;
              widget.campaign.savedAutoOffers = updatedCampaign.savedAutoOffers;

              // Rebuild editable states
              _editableDescription = updatedCampaign.description;
              _offers = [...updatedCampaign.savedAutoOffers, ...updatedCampaign.savedManualOffers];
              // Add budget items if you track them separately
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Campaign updated successfully!"),
                backgroundColor: Colors.teal,
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
  backgroundColor: Colors.transparent,   // Remove background color
  foregroundColor: Colors.teal,          // Text/Icon color
  shadowColor: Colors.transparent,       // Remove shadow
  elevation: 0,                           // No elevation
  

  // Add border + radius
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(6),
    side: BorderSide(
      color: Color.fromRGBO(0, 164, 175, 1), // Border color
      width: 2,                               // Border thickness
    ),
  ),
),
        child: Text(
          "EDIT CAMPAIGN",
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    ),
  ),
),





                      //Organizer Card
                     // === FINAL VERSION: HORIZONTAL 70% WIDTH CARDS WITH PEEK EFFECT ===
Positioned(
  top: 410.0,
  left: 17.0,
  child: ErrorBoundary(
    child: SizedBox(
      height: 70,
      width: MediaQuery.of(context).size.width - 34,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 4),
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: 1 + widget.campaign.participants.length, // Organizer + participants
        itemBuilder: (context, index) {
          if (index == 0) {
            // Organizer (always first)
            return _buildTeamMemberCard(
              profilePicUrl: user?['profile_pic'],
              fallbackImage: 'assets/images/personal.png',
              name: "${user?['first_name'] ?? 'You'} ${user?['last_name'] ?? ''}".trim(),
              role: "Campaign Organizer",
              isOrganizer: true,
            );
          }

          // Selected participants
          final participant = widget.campaign.participants[index - 1];
          return _buildTeamMemberCard(
            imageUrl: participant.imageUrl,
            name: participant.name,
            role: "Campaign Participant",
            isOrganizer: false,
          );
        },
      ),
    ),
  ),
),
// === END OF NEW TEAM ROW ===







                      //Header Union Background






                      // === REDUCED HEIGHT CAMPAIGN IMAGE CAROUSEL (240px) ===
Positioned(
  left: 0,
  top: 0,
  right: 0,
  child: widget.campaign.images.isEmpty
      ? Container(
          height: 240,
          color: Colors.grey[300],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, size: 60, color: Colors.grey[600]),
                SizedBox(height: 8),
                Text(
                  "No images added",
                  style: GoogleFonts.inter(color: Colors.grey[700], fontSize: 14),
                ),
              ],
            ),
          ),
        )
      : SizedBox(
          height: 240,
          child: PageView.builder(
            itemCount: widget.campaign.images.length,
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(widget.campaign.images[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
),

// Optional: Add page dots (beautiful active indicator)
if (widget.campaign.images.isNotEmpty)
  Positioned(
    bottom: 750,
    left: 0,
    right: 0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.campaign.images.length,
        (index) => AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1))
            ],
          ),
        ),
      ),
    ),
  ),





                      //Submit Button
                      Positioned(
                        left: (constraints.maxWidth / 2) - (440.0 / 2 - 90.0),
                        top: 760.0,
                        child: ErrorBoundary(
                          child: InkWell(
                            onTap: createCampaign,
                            child: Container(
                              clipBehavior: Clip.none,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                color: Color.fromRGBO(0, 164, 175, 1.0),
                              ),
                              height: 45.0,
                              width: 260.0,
                              child: Center(
                                child: Text(
                                  "SUBMIT FOR APPROVAL",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.0,
                                    color: Color.fromRGBO(255, 255, 255, 1.0),
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      //Divider Line
                      Positioned(
                        left: 1.5,
                        top: 713.5,
                        child: ErrorBoundary(
                          child: SvgPicture.asset(
                            "assets/images/vector_33.svg",
                            width: 435.5,
                          ),
                        ),
                      ),


                      //End of Campaign Text
                      Align(
  alignment: Alignment.center,
  child: Transform.translate(
    offset: const Offset(0, 200), // Adjust Y position relative to center
    child: ErrorBoundary(
      child: Text(
        "END OF CAMPAIGN",
        style: GoogleFonts.inter(
          color: Color.fromRGBO(87, 87, 87, 0.898),
          fontWeight: FontWeight.w600,
          fontSize: 12.0,
        ),
      ),
    ),
  ),
)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
