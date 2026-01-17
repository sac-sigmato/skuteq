import 'package:flutter/material.dart';
import 'package:skuteq_app/components/shared_app_head.dart';
import 'package:skuteq_app/services/forgot_password_service.dart';
import 'login_page.dart';

enum ResetPasswordState { form, success }

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final ForgotPasswordService _forgotService = ForgotPasswordService();

  ResetPasswordState _currentState = ResetPasswordState.form;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _forgotService.resetPassword(
        email: widget.email,
        newPassword: _newPasswordController.text.trim(),
      );

      setState(() {
        _currentState = ResetPasswordState.success;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to reset password. Please try again.";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFF),
      appBar: _currentState == ResetPasswordState.form
          ? SharedAppHead(
              title: "Create New Password",
              showBack: true,
              showDrawer: false,
            )
          : null,
      body: SafeArea(
        child: _currentState == ResetPasswordState.form
            ? _buildForm()
            : _buildSuccess(),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Image.asset("assets/images/logo.png", height: 36),
            const SizedBox(height: 24),

            _stepBadge(),
            const SizedBox(height: 16),

            _passwordField(
              label: "New Password",
              controller: _newPasswordController,
            ),
            const SizedBox(height: 6),
            _passwordHint(),

            const SizedBox(height: 16),

            _passwordField(
              label: "Confirm New Password",
              controller: _confirmPasswordController,
              confirm: true,
            ),

            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F6FDB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Reset Password",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Back to Sign in"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2DBE60),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Your password has been reset successfully",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text(
              "Redirecting to Sign In...",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false,
                );
              },
              child: const Text("Go to Sign In Now"),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Helpers ----------------

  Widget _stepBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "Step 2 of 2 · Create new password",
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _passwordHint() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          "At least 8 characters",
          style: TextStyle(fontSize: 12, color: Color(0xFF6B7C93)),
        ),
        Text(
          "Medium",
          style: TextStyle(fontSize: 12, color: Color(0xFF6B7C93)),
        ),
      ],
    );
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    bool confirm = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: true,
          validator: (v) {
            if (v == null || v.length < 8) {
              return "Password must be at least 8 characters";
            }
            if (confirm && v != _newPasswordController.text) {
              return "Passwords do not match";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: confirm ? "Re-enter password" : "Enter new password",
            prefixIcon: const Icon(Icons.lock_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
