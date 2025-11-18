// lib/screens/onboarding_page.dart

import 'package:flutter/material.dart';
import 'login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Track Records',
      'description': 'Track your children real time',
      'image': 'assets/images/1.png',
    },
    {
      'title': 'Stay Updated',
      'description': 'Get real-time updates on attendance and grades',
      'image': 'assets/images/2.png',
    },
     {
      'title': 'Connect with Teachers',
      'description': 'Communicate easily with teachers and staff',
      'image': 'assets/images/3.png',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Track swipes
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });

    // Start auto-slide
    Future.delayed(Duration.zero, () {
      _startAutoSlide();
    });
  }

  // AUTO SLIDE FUNCTION
  void _startAutoSlide() async {
    bool forward = true; // direction control

    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 1500)); // 1.5 seconds
      if (!mounted) return;

      if (forward) {
        if (_currentPage < onboardingData.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        } else {
          forward = false; // reached last → reverse
        }
      } else {
        if (_currentPage > 0) {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        } else {
          forward = true; // reached first → forward again
        }
      }
    }
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Navigate to Login
  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return _buildPage(
                    title: onboardingData[index]['title']!,
                    description: onboardingData[index]['description']!,
                    image: onboardingData[index]['image']!,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // PAGE INDICATOR DOTS
            _buildDots(),

            const SizedBox(height: 40),

            // BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _navigateToLogin, // NO sliding here!
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF106EB4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Let's go!", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // IMAGE PAGE
  Widget _buildPage({
    required String title,
    required String description,
    required String image,
  }) {
    return Center(
      child: Image.asset(
        image,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  // DOT INDICATOR
  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(onboardingData.length, (index) {
        final bool isActive = _currentPage == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: isActive ? 20.0 : 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isActive ? Colors.blue : Colors.grey.withOpacity(0.5),
          ),
        );
      }),
    );
  }
}
