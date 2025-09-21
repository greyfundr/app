import 'package:flutter/material.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  final List<Map<String, String>> pages = [
    {
      "image": "assets/images/onboarding1.jpg",
      "title": "Pay, Transfer & Split Bills",
      "subtitle": "Pay, transfer, or split bills with others. Everyone can pitch in - easy, fair, and hassle-free."
    },
    {
      "image": "assets/images/onboarding2.jpg",
      "title": "Donate, Back & Champion",
      "subtitle": "Bills, Campaigns, Causes you believe in so they can attain success in their endeavors"
    },
    {
      "image": "assets/images/onboarding3.jpg",
      "title": "Support Communities",
      "subtitle": "Together we can make an impact."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: pages.length,
        onPageChanged: (index) {
        },
        itemBuilder: (_, index) {
          return Stack(
            children: [
              // Background image
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(pages[index]["image"]!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Bottom curved container
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipPath(
                  clipper: TopCurveClipper(),
                  child: Container(
                    width: double.infinity,
                    color: Colors.teal.shade700,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title with padding top 20
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Text(
                            pages[index]["title"]!,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Subtitle
                        Text(
                          pages[index]["subtitle"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 60),

                        // Skip button (above Next)
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                            );
                          },
                          child: const Text(
                            "Skip",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Next or Get Started button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: () {
                            if (index == pages.length - 1) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              );
                            } else {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            }
                          },
                          child: Text(
                            index == pages.length - 1
                                ? "Get Started"
                                : "Next",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 30);

    var firstControlPoint = Offset(size.width / 4, 0);
    var firstEndPoint = Offset(size.width / 2, 30);

    var secondControlPoint = Offset(3 * size.width / 4, 60);
    var secondEndPoint = Offset(size.width, 40);

    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
