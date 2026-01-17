import 'dart:async';
import 'package:flutter/material.dart';
import 'package:skuteq_app/components/shared_app_head.dart';
import 'package:skuteq_app/screens/reset_password_page.dart';
import 'package:skuteq_app/services/forgot_password_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  final String email;

  const ForgotPasswordPage({super.key, required this.email});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final ForgotPasswordService _forgotService = ForgotPasswordService();
  String? _session;
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  late TextEditingController _emailController;
  bool _isEditingEmail = false;
  String? _emailError;

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return emailRegex.hasMatch(email);
  }

  bool _hasError = false;
  int _secondsLeft = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    _startTimer();
    _sendOtp(); // ✅ ADD THIS
  }

  Future<void> _sendOtp() async {
    try {
      final res = await _forgotService.sendForgotPasswordOtp(
        email: _emailController.text.trim(),
      );
      _session = res['session'];
    } catch (e) {
      setState(() => _hasError = true);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = 30;

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  Future<void> _verifyOtp() async {
    final otp = _otpControllers.map((e) => e.text).join();

    if (otp.length != 6 || _session == null) {
      setState(() => _hasError = true);
      return;
    }

    try {
      await _forgotService.verifyOtp(
        session: _session!,
        email: _emailController.text.trim(),
        otp: otp,
      );

      setState(() => _hasError = false);

      // ✅ Navigate to ResetPasswordPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ResetPasswordPage(email: _emailController.text.trim()),
        ),
      );
    } catch (e) {
      setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFF),
      appBar: SharedAppHead(
        title: "Forgot Password",
        showDrawer: false,
        showBack: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// LOGO
              Image.asset("assets/images/logo.png", height: 36),

              const SizedBox(height: 24),

              /// CARD
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE6EFF8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// STEP LABEL
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF2FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Step 1 of 2 · Verify email",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      "Enter the 6-digit OTP sent to your email address",
                      style: TextStyle(fontSize: 13, color: Color(0xFF6B7C93)),
                    ),

                    const SizedBox(height: 12),

                    /// EMAIL ROW
                    Row(
                      children: [
                        const Icon(Icons.email_outlined, size: 18),
                        const SizedBox(width: 8),

                        Expanded(
                          child: _isEditingEmail
                              ? TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  autofocus: true,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              : Text(
                                  _emailController.text,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),

                        TextButton(
                          onPressed: () {
                            if (_isEditingEmail) {
                              final newEmail = _emailController.text.trim();

                              if (newEmail.isEmpty ||
                                  !_isValidEmail(newEmail)) {
                                setState(() {
                                  _emailError = "Invalid email address";
                                });
                                return; // ❌ block save
                              }

                              // ✅ VALID EMAIL
                              setState(() {
                                _emailError = null;
                                _isEditingEmail = false;
                                _startTimer(); // restart OTP timer if required
                              });
                            } else {
                              // ✏️ CHANGE
                              setState(() {
                                _emailError = null;
                                _isEditingEmail = true;
                              });
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF106EB4),
                          ),
                          child: Text(_isEditingEmail ? "Save" : "Change"),
                        ),
                      ],
                    ),
                    if (_emailError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 26),
                        child: Text(
                          _emailError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    /// OTP INPUTS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (i) => _otpBox(i)),
                    ),

                    const SizedBox(height: 10),

                    /// ERROR
                    if (_hasError)
                      Column(
                        children: [
                          const Text(
                            "Incorrect code. Please try again or request new OTP.",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: _startTimer,
                            child: const Text("Resend OTP"),
                          ),
                        ],
                      )
                    else
                      Text(
                        _secondsLeft > 0
                            ? "Resend OTP in 00:${_secondsLeft.toString().padLeft(2, '0')}"
                            : "Resend OTP",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7C93),
                        ),
                      ),

                    const SizedBox(height: 16),

                    /// VERIFY BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed:
                            _otpControllers.every((c) => c.text.isNotEmpty)
                            ? _verifyOtp
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1F6FDB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Verify OTP",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// BACK TO SIGN IN
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text("Back to Sign In"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _otpBox(int index) {
    return SizedBox(
      width: 44,
      height: 44,
      child: TextField(
        controller: _otpControllers[index],
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        onChanged: (v) {
          if (v.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          }
          setState(() => _hasError = false);
        },
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: _hasError ? Colors.red : const Color(0xFFE6EFF8),
              width: 1.4,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: _hasError ? Colors.red : const Color(0xFF1F6FDB),
              width: 1.6,
            ),
          ),
        ),
      ),
    );
  }
}
