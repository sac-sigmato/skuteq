// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:skuteq_app/screens/login_page.dart';
import 'package:skuteq_app/screens/select_child_page.dart';
import 'package:skuteq_app/screens/onboarding_page.dart';
import 'package:skuteq_app/services/amplify_auth_service.dart';
import 'package:skuteq_app/helpers/app_prefs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startFlow();
  }

  Future<void> _startFlow() async {
    // ⏳ Show splash
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // 1️⃣ Onboarding check
    final onboardingDone = await AppPrefs.isOnboardingDone();

    if (!onboardingDone) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingPage()),
      );
      return;
    }

    // 2️⃣ Auth check
    try {
      final token = await AmplifyAuthService().getIdToken();

      if (!mounted) return;

      if (token != null && token.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const SelectChildPage(students: []),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    } catch (_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset('assets/images/logo.png', width: 150)),
    );
  }
}
