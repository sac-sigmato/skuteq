import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'amplify_auth_service.dart';

class AlertItem {
  final String title;
  final String message;
  final String time;
  final String type;

  AlertItem({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
  });

  factory AlertItem.fromJson(Map<String, dynamic> json) {
    return AlertItem(
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
    );
  }
}

class AlertsService {
  final AmplifyAuthService _authService = AmplifyAuthService();

  Future<List<AlertItem>> fetchStudentAlerts({
    required String studentId,
    required String branchId,
  }) async {
    final token = await _authService.getIdToken();
    if (token == null) throw Exception("Token not available");

    final uri = Uri.parse(
      "https://apis-dev.skuteq.net/v1/students/list-alerts"
      "?student_id=$studentId"
      "&branch_id=$branchId",
    );

    debugPrint("📡 LIST ALERTS URL:\n$uri");

    final response = await http.get(
      uri,
      headers: {
        "Authorization": token,
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    debugPrint("📥 ALERTS STATUS => ${response.statusCode}");
    debugPrint("📥 ALERTS BODY => ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch alerts");
    }

    final decoded = jsonDecode(response.body);
    final List list = (decoded['data'] as List?) ?? [];

    return list
        .whereType<Map>()
        .map((e) => AlertItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
