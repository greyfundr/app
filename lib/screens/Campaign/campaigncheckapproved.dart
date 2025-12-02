import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../class/api_service.dart';
import 'dart:async';
import '../../class/auth_service.dart';
import '../../class/campaign.dart';
import '../../class/jwt_helper.dart';
import 'detailedcampaign.dart';

class CampaignApprovalPage extends StatefulWidget {
  final bool isApproved;
  final int stakeholdersApproved;
  final Campaign campaign;

  const CampaignApprovalPage({
    super.key,
    this.isApproved = false,
    this.stakeholdersApproved = 0,
    required this.campaign,
  });

  @override
  State<CampaignApprovalPage> createState() => _CampaignApprovalPageState();
}

class _CampaignApprovalPageState extends State<CampaignApprovalPage> {
  Map<String, dynamic>? user;
  late bool _isApproved;
  late int _stakeholdersApproved = 0;
  late int totalStakeholders = 1;
  Timer? _timer;
  late int campaigId = 0;

  @override
  void initState() {
    super.initState();
    loadProfile();
    //createCampaign();
    _timer = Timer.periodic(Duration(seconds: 20), (Timer t) =>
       // loadCampaignApproval()); // Your function
    loadCampaignApproval()
    );
    _isApproved = widget.isApproved;
    _stakeholdersApproved = widget.stakeholdersApproved;

  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void loadProfile() async {
    String? token = await AuthService().getToken();
    if (token != null && !JWTHelper.isTokenExpired(token)) {
      Map<String, dynamic> userData = JWTHelper.decodeToken(token);
      setState(() => user = userData['user']);

      createCampaign();
    } else {
      print("Token is expired or invalid");
    }
  }

  void createCampaign() async {
    print(widget.campaign);
    final response = await ApiService().createCampaign(widget.campaign, user?['id']);
    print(response.data);
    if (response.statusCode == 200) {
      // Handle successful login
      String message = response.data['msg'];
      setState(() => campaigId = response.data['id']);


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Campaign Saved successful!'),
          duration: Duration(seconds: 2), // Optional: how long it shows
          backgroundColor: Colors.green, // Optional: customize color
        ),
      );

      //loadCampaignApproval();



    } else {
      //dynamic responseData = jsonDecode(response.body);
      //String message = responseData['msg'];
      //final test = await ApiService().uploadImage(widget.campaign.imageUrl);

      //print(response.body);




    }

  }


  Future<void> loadCampaignApproval() async {
    String ids = campaigId.toString();
    print(ids);
    dynamic token = await ApiService().getCampaignApproval(ids) ;
    print(token);
    int champions = (token[0]['champions']);
    int hosts = (token[0]['host']);
    int approved = (token[0]['approved']);
    int tApproved = (token[0]['total_approved']);
    int waiting = (champions + hosts);
    setState(() => totalStakeholders = waiting);
    setState(() => _stakeholdersApproved = tApproved);
    if(approved == 1)
      {

        setState(() => _isApproved = true);
        _timer!.cancel();
      }


    List<Map<String, dynamic>> tasks = token.cast<Map<String, dynamic>>();
    //setState(() => categories = tasks);
  }

  @override
  Widget build(BuildContext context) {
    final bool allStakeholdersApproved =
        _stakeholdersApproved >= totalStakeholders;
    final bool campaignLive = _isApproved && allStakeholdersApproved;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Top Icon and Status
            _buildStatusHeader(campaignLive),

            const SizedBox(height: 20),

            // Progress Steps
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepItem(
                    'Posted to your GreyFundr',
                    true,
                  ),
                  const SizedBox(height: 16),
                  _buildStepItem(
                    'Shared with team for review',
                    true,
                  ),
                  const SizedBox(height: 16),
                  _buildStepItem(
                    'Pending approval from Stakeholder(s)',
                    allStakeholdersApproved,
                    trailing: Text(
                      '$_stakeholdersApproved/$totalStakeholders',
                      style: TextStyle(
                        color: allStakeholdersApproved
                            ? const Color(0xFF00ACC1)
                            : Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStepItem(
                    campaignLive
                        ? 'Hurray! Your Campaign is LIVE'
                        : 'Awaiting approval from Greyfundr',
                    campaignLive,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Wave Divider
            CustomPaint(
              size: const Size(double.infinity, 60),
              painter: WavePainter(campaignLive),
            ),

            // Bottom Section
            Container(
              color: const Color.fromARGB(255, 255, 254, 254),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Champion Your Campaign with Others',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildActionButton(
                    icon: Icons.content_copy_rounded,
                    label: 'Copy Link',
                    isActive: campaignLive,
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: 'https://api.greyfundr.com/campaign/getcampaign/${widget.campaign.sharetitle}'));
                      // Optionally, show a SnackBar to confirm the copy action
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Text copied to clipboard!'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildActionButton(
                    icon: Icons.share_rounded,
                    label: 'Send/Share and More',
                    isActive: campaignLive,
                    onTap: () {
                      // Handle share
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildActionButton(
                    icon: Icons.group_add_rounded,
                    label: 'Create Team',
                    isActive: campaignLive,
                    onTap: () {
                      // Handle create team
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildActionButton(
                    icon: Icons.grid_view_rounded,
                    label: 'More Options',
                    isActive: campaignLive,
                    onTap: () {
                      // Handle more options
                    },
                  ),

                  const SizedBox(height: 24),

                  // Back to Donation Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CampaignDetailPage(id:campaigId.toString())),
                        );// Handle back to donation
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00ACC1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Back to Donation',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader(bool campaignLive) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: campaignLive
                ? const Color(0xFFE0F7FA)
                : const Color(0xFFF5F5F5),
            shape: BoxShape.circle,
          ),
          child: campaignLive
              ? const Icon(
            Icons.check,
            size: 30,
            color: Color(0xFFB0BEC5),
          )
              : const Icon(
            Icons.schedule,
            size: 30,
            color: Color(0xFFB0BEC5),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          campaignLive ? 'Campaign Approved' : 'Pending Approval',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: campaignLive
                ? const Color(0xFF00ACC1)
                : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildStepItem(String text, bool isCompleted, {Widget? trailing}) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isCompleted
                ? const Color(0xFF00ACC1)
                : const Color(0xFFE0E0E0),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            size: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isCompleted ? Colors.black87 : Colors.grey,
            ),
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isActive ? onTap : null,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF00ACC1)
                  : const Color(0xFFBDBDBD),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.black87 : const Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final bool isActive;

  WavePainter(this.isActive);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isActive
          ? const Color(0xFF00ACC1)
          : const Color(0xFFBDBDBD)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final path = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.5,
        0,
        size.width,
        size.height * 0.5,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => isActive != oldDelegate.isActive;
}