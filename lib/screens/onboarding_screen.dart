import 'package:flutter/material.dart';
import 'Auth/login_screen.dart';
import 'Auth/register_screen.dart'; // 👈 make sure this file exists

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
      "title": "Pay, \nTransfer & Split Bills",
      "subtitle":
          "Pay, transfer, or split bills with others. Everyone can pitch in - easy, fair, and hassle-free."
    },
    {
      "image": "assets/images/onboarding2.jpg",
      "title": "Donate,\nBack & Champion", // 👈 forced line break
      "subtitle":
          "Bills, Campaigns, Causes you believe in so they can attain success in their endeavors"
    },
    {
      "image": "assets/images/onboarding3.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: pages.length,
        itemBuilder: (_, index) {
          final isLast = index == pages.length - 1;

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

              // 👇 GreyFundr + Fundr text overlay
              Align(
  alignment: Alignment.center,
  child: Transform.translate(
    offset: const Offset(0, -180), // shift upwards by 30px
    child: Image.asset(
      "assets/images/greyfdr.png", // 👈 replace with your actual PNG path
      width: 250,  // adjust size
      fit: BoxFit.contain,
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
                    color: const Color.fromARGB(255, 26, 173, 166),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 👉 If it's NOT the last page, show title + subtitle
                        if (!isLast) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pages[index]["title"]!,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  pages[index]["subtitle"]!,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 60),
                        ],

                        // 👉 If it's the last page, show the two buttons instead
                        if (isLast) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 252, 100, 58),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              onPressed: () {
                                // TODO: navigate to Quick Split Bill screen
                              },
                              child: const Text(
                                "Quick Split Bill",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            onPressed: () {
                              // TODO: navigate to Browse Campaign screen
                            },
                            child: const Text(
                              "Browse Campaign",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],

                        // Skip button (hidden only on last screen)
                        if (!isLast) ...[
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
                        ],

                        // Next / Get Started / Login button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isLast
                                ? Colors.transparent
                                : const Color.fromARGB(255, 252, 100, 58),
                            side: isLast
                                ? const BorderSide(color: Color.fromARGB(255, 252, 100, 58), width: 2)
                                : BorderSide.none,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: () {
                            if (isLast) {
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
                            isLast ? "Login" : "Next",
                            style: TextStyle(
                              fontSize: 16,
                              color: isLast ? const Color.fromARGB(255, 252, 100, 58) : Colors.white,
                            ),
                          ),
                        ),

                        // 👇 Register link (only on last page)
                        if (isLast) ...[
                          const SizedBox(height: 15),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const RegisterScreen()),
                              );
                            },
                            child: const Text(
                              "Don’t have an account? Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
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
    path.lineTo(0, 20);

    var firstControlPoint = Offset(size.width / 4, 0);
    var firstEndPoint = Offset(size.width / 2, 1);

    var secondControlPoint = Offset(3 * size.width / 4, 0);
    var secondEndPoint = Offset(size.width, 30);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
