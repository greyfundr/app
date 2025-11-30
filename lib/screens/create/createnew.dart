import 'package:flutter/material.dart';
import 'bill/quicksplit.dart';
import 'fundpool/fundpool.dart';
import 'invoice/invoice.dart';
import 'events/eventwelcome.dart';
import '../Campaign/campaign_option.dart';

class CreateNewPage extends StatelessWidget {
  const CreateNewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create New',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Start something new—just fill in a few details to get going.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            _buildOptionCard(
              icon: 'assets/images/split.png',
              iconBg: const Color(0xFFE3F2FD),
              title: 'Split A Bill',
              description:
                  'Enter the Bill amount and choose how you want to split it with others.',
              onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const QuickSplitPage(),
                          ),
                        );
                      },
            ),
            const SizedBox(height: 12),
            _buildOptionCard(
              icon: 'assets/images/porsh.png',
              iconBg: const Color(0xFFE1F5FE),
              title: 'Fund Pool',
              description:
                  'Pool money together with friends, your community or the public for something meaningful.',
             onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StartFundPoolPage(),
                          ),
                        );
                      },
            ),
            const SizedBox(height: 12),
            _buildOptionCard(
              icon: 'assets/images/porsh.png',
              iconBg: const Color(0xFFE1F5FE),
              title: 'Generate Invoice',
              description:
                  'Create a detailed invoice with all the necessary billing info for your records or clients.',
              onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateInvoicePage(),
                          ),
                        );
                      },
            ),
            const SizedBox(height: 12),
            _buildOptionCard(
              icon: 'assets/images/giveaway.png',
  iconBg: const Color(0xFFFFEBEE),
              title: 'Launch Fundraising Campaign',
              description:
                  'Ready to raise funds? Set up your campaign, tell your story, and watch the support roll in.',
              onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CampaignOptionScreen(),
                          ),
                        );
                      },
            ),
            const SizedBox(height: 12),
            _buildOptionCard(
              icon: 'assets/images/giveaway.png',
              iconBg: const Color(0xFFFFEBEE),
              title: 'Events',
              description:
                  'Create your event and have guests donate towards your goal',
              onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>  EventWelcomePage(),
                          ),
                        );
                      },
            ),
            const SizedBox(height: 12),
            _buildOptionCard(
              icon: 'assets/images/giveaway.png',
              iconBg: const Color(0xFFFFEBEE),
              title: 'Giveaway',
              description:
                  'Set up a giveaway to thank your supporters, engage your community, or inspire kindness.',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
  required String icon, // asset path
  required Color iconBg,
  required String title,
  required String description,
  required VoidCallback onTap,
}) {
  return Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Image.asset(
                  icon, // <- replaced Text with Image.asset
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  
  }
}
