// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'onboarding_page.dart'; // Import the onboarding page

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  _navigateToOnboarding() async {
    // Wait for 3 seconds
    await Future.delayed(const Duration(seconds: 3), () {});

    // Check if the widget is still in the tree before navigating
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingPage()),
      );
    }
  }
@override
 Widget build(BuildContext context) {
   return Scaffold( // The 'const' is removed here because Image.asset is not a const constructor
     body: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           // Replace the Icon with your logo
           Image.asset(
             'assets/images/logo.png', // Path to your logo
             width: 150, // You can adjust the size as needed
           ),
         ],
       ),
     ),
   );
 }
}