// ignore: file_names
import 'package:flutter/material.dart';
import 'package:iframemobile/widgets/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _nextPage() {
    if (_currentPage < 3) {
      // Last page index
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Homepage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              _buildPage(
                title: 'Welcome!',
                description: 'Welcome to the i-frame Mobile App!',
                image: 'assets/images/iframesplash.png',
                screenSize: screenSize,
              ),
              _buildPage(
                title: 'Features',
                description:
                    'With i-frame, you can manage and monitor all your business processes through the mobile application. Low-code technology makes it easy to create fast and efficient solutions.',
                image: 'assets/images/iframeMobil.jpeg',
                screenSize: screenSize,
              ),
              _buildPage(
                title: 'Security',
                description:
                    'Privacy and security are our top priorities. Your passwords are securely encrypted on your phone and automatically logged into i-frame. Your data is always safe.',
                image: 'assets/images/iframeMobilSecurity.jpeg',
                screenSize: screenSize,
              ),
            ],
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _currentPage == index ? 12.0 : 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                );
              }),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: _skipOnboarding,
                  child: const Text('Skip', style: TextStyle(fontSize: 16)),
                ),
                Row(
                  children: <Widget>[
                    if (_currentPage < 2) ...[
                      TextButton(
                        onPressed: _nextPage,
                        child:
                            const Text('Next', style: TextStyle(fontSize: 16)),
                      ),
                    ] else ...[
                      ElevatedButton(
                        onPressed: _completeOnboarding,
                        child: const Text('Get Started'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(
      {required String title,
      required String description,
      required String image,
      required Size screenSize}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: screenSize.height * 0.4, // Adjust height as needed
          child: Center(
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
