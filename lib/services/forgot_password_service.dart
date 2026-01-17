import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordService {
  static const String _baseUrl = "https://apis-dev.skuteq.net/v1";

  /// 🔹 STEP 1: Send OTP to email
  Future<Map<String, dynamic>> sendForgotPasswordOtp({
    required String email,
  }) async {
    final uri = Uri.parse("$_baseUrl/students/forgot-password");

    debugPrint("📡 FORGOT PASSWORD URL: $uri");
    debugPrint("📤 BODY: { email: $email }");

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email}),
    );

    debugPrint("📥 STATUS: ${response.statusCode}");
    debugPrint("📥 BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }else{
      print("something went wrong");
      print(response.body);
    }

    final body = jsonDecode(response.body);
    throw Exception(body['message'] ?? "OTP verification failed");
  }

  /// 🔹 STEP 2: Verify OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String session,
    required String email,
    required String otp,
  }) async {
    final uri = Uri.parse("$_baseUrl/students/verify-otp");

    debugPrint("📡 VERIFY OTP URL: $uri");

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"session": session, "email": email, "otp": otp}),
    );

    debugPrint("📥 STATUS: ${response.statusCode}");
    debugPrint("📥 BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }

    final body = jsonDecode(response.body);
    throw Exception(body['message'] ?? "OTP verification failed");
  }

  /// 🔹 STEP 3: Reset Password
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final uri = Uri.parse("$_baseUrl/students/reset-password");

    debugPrint("📡 RESET PASSWORD URL: $uri");

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "new_password": newPassword}),
    );

    debugPrint("📥 STATUS: ${response.statusCode}");
    debugPrint("📥 BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }

    final body = jsonDecode(response.body);
    throw Exception(body['message'] ?? "OTP verification failed");
  }
}
