import 'package:flutter/material.dart';

import '../services/amplify_auth_service.dart';
import '../services/student_service.dart';

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

  final AmplifyAuthService _authService = AmplifyAuthService();
  final StudentService _studentService = StudentService();

  bool _isLoading = false;
  String? _errorMessage;

  int _currentStep = 0;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// 🔹 TOP SPACING
              const SizedBox(height: 24),

              /// 🔹 HEADER INSIDE BODY (MATCHES SS)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.white,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 22),
                      onPressed: _currentStep == 1
                          ? () => setState(() => _currentStep = 0)
                          : () => Navigator.maybePop(context),
                    ),
                    const Expanded(
                      child: Text(
                        "Sign in",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40), // balance back icon
                  ],
                ),
              ),

              /// 🔹 CONTENT
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
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

  // ---------------- EMAIL STEP ----------------

  Widget _buildEmailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /// LOGO
        Center(child: Image.asset("assets/images/logo.png", height: 36)),

        const SizedBox(height: 10),

        /// CARD CONTAINER (INPUT + BUTTON)
        Container(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE7EFF7), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// EMAIL INPUT
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontWeight: FontWeight.w800),
                decoration: _inputDecoration(
                  hint: "Email",
                  icon: Icons.email_outlined,
                ),
              ),

              const SizedBox(height: 20),

              /// NEXT BUTTON
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () => setState(() => _currentStep = 1),
                  style: _buttonStyle(),
                  child: const Text(
                    "Next",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  // ---------------- PASSWORD STEP ----------------

Widget _buildPasswordStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /// LOGO
        Center(child: Image.asset("assets/images/logo.png", height: 36)),
        const SizedBox(height: 24),

        /// MAIN CARD
        Container(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE7EFF7)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// EMAIL DISPLAY (NO BORDER – FIXED)
              Row(
                children: [
                  const Icon(
                    Icons.email_outlined,
                    size: 18,
                    color: Color(0xFF244A6A),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      _emailController.text.isNotEmpty
                          ? _emailController.text
                          : "name@school.com",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF244A6A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  GestureDetector(
                    onTap: () => setState(() => _currentStep = 0),
                    child: const Text(
                      "Change",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F6FDB),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              /// PASSWORD FIELD (ONLY THIS IS BOXED)
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: const TextStyle(fontWeight: FontWeight.w800),
                decoration: _inputDecoration(
                  hint: "Password",
                  icon: Icons.lock_outline,
                  suffix: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 20,
                    ),
                    onPressed: () => setState(
                      () => _isPasswordVisible = !_isPasswordVisible,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              /// FORGOT PASSWORD
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ResetPasswordPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F6FDB),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              /// SIGN IN BUTTON
              SizedBox(
                height: 50,
                child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: _buttonStyle(),
                child: const Text(
                  "Sign In",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
              ),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Center(child: CircularProgressIndicator()),
                ),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }


  // ---------------- LOGIN HANDLER ----------------

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await _authService.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!success) {
        throw Exception("Invalid email or password");
      }

      final students = await _studentService.fetchStudents();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SelectChildPage(students: students)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception:', '').trim();
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ---------------- UI HELPERS ----------------

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 20),
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE7EFF7), width: 1.4),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF0E70B8), width: 1.4),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1F6FDB),
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 0,
    );
  }
}
