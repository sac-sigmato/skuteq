import 'package:flutter/material.dart';
import 'reset_password_page.dart';
import 'select_child_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  int _currentStep = 0;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 5),

              // 🔥 Back + Sign in header
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 22,
                      ),
                      onPressed: _currentStep == 1
                          ? () => setState(() => _currentStep = 0)
                          : () => Navigator.maybePop(context),
                    ),
                  ),

                  const Text(
                    "Sign in",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              // 🔥 EVERYTHING BELOW IS NOW CENTERED
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    physics:
                        const NeverScrollableScrollPhysics(), // avoid scroll jumping
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_currentStep == 0) _buildEmailStep(),
                        if (_currentStep == 1) _buildPasswordStep(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  
Widget _buildEmailStep() {
    // Footer placeholder height (match the height of password footer area)
    const double footerHeight = 40.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Logo
        Center(
          child: Image.asset(
            "assets/images/logo.png",
            height: 35,
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(height: 20),

        // Email field
        TextField(
          style: const TextStyle(
             fontWeight: FontWeight.w800,
          ),
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.email_outlined,
              size: 20,
              color: Colors.black87,
            ),
            hintText: "Email",
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF0E70B8),
                width: 1.4,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFD1D1D1),
                width: 1.3,
              ),
            ),
          ),
        ),

        const SizedBox(height: 25),

        // Next button
        ElevatedButton(
          onPressed: () => setState(() => _currentStep = 1),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0E70B8),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: const Text(
            "Next",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),

        // Keep same spacing/footer area as password step to avoid layout jump
        const SizedBox(height: 16),

        // Placeholder for forgot-password row — invisible but occupies same space
        SizedBox(height: footerHeight, child: const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildPasswordStep() {
    const double footerHeight = 40.0; // same as email placeholder

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Logo
        Center(
          child: Image.asset(
            "assets/images/logo.png",
            height: 35,
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(height: 20),

        // Password field
        TextField(
          style: const TextStyle(fontWeight: FontWeight.w800),
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.lock_outline,
              size: 20,
              color: Colors.black87,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                size: 20,
                color: Colors.grey,
              ),
              onPressed: () =>
                  setState(() => _isPasswordVisible = !_isPasswordVisible),
            ),
            hintText: "Password",
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF0E70B8),
                width: 1.4,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFD1D1D1),
                width: 1.3,
              ),
            ),
          ),
        ),

        const SizedBox(height: 25),

        // Login button
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SelectChildPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0E70B8),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: const Text(
            "Login",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Footer row (visible here)
        SizedBox(
          height: footerHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Forgot your password? ",
                style: TextStyle(fontSize: 13, color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ResetPasswordPage(),
                    ),
                  );
                },
                child: const Text(
                  "Reset your password",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF0E70B8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
