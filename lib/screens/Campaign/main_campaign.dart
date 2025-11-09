import 'package:flutter/material.dart';
import 'campaign_exist.dart';
import 'campaign_option.dart';



class CampaignScreen extends StatelessWidget {
  const CampaignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No default AppBar like before
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 10),

              // Title & Subtitle
              const Text(
                "Start Campaign",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Want to start a New or Join an Existing Campaign",
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 15),

              // Options
              Expanded(
                child: ListView(
                  children: [
                    _buildOptionCard(
                      context,
                      icon: "assets/icons/personal.png",
                      title: "New Campaign",
                      description:
                      "By setting up a Personal Account, you gain and control all aspects of this Account",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CampaignOptionScreen(),
                          ),
                        );
                      },
                    ),
                    _buildOptionCard(
                      context,
                      icon: "assets/icons/groupb.png",
                      title: "Existing Campaign",
                      description:
                      "By setting up a Group or Community Account, you might need to add one more Stakeholder to the Account",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const Profilepublicviewrequest15(),
                          ),
                        );
                      },
                    ),


                  ],
                ),
              ),


              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
      BuildContext context, {
        required String icon,
        required String title,
        required String description,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.teal.shade50,
              child: Image.asset(
                icon,
                width: 60,
                height: 60,
              ),
            ),
            const SizedBox(width: 16),
            // Title + Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 71, 71, 71),
                      height: 1.3,
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
}
