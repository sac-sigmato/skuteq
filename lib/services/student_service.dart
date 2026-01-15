import 'dart:convert';
import 'package:http/http.dart' as http;
import 'amplify_auth_service.dart';

class StudentService {
  final AmplifyAuthService _authService = AmplifyAuthService();
  // Fetch Students
  Future<List<dynamic>> fetchStudents() async {
    final token = await _authService.getIdToken();
    if (token == null) {
      throw Exception('token not available');
    }

    final url = 'https://apis-dev.skuteq.net/v1/students/list-students';
    final uri = Uri.parse(url);

    // 🔍 LOG EVERYTHING
    // print('📡 API URL: $url');
    // print('🔐 Authorization: Bearer ${token}');
    // print('📦 Headers OK');

    late http.Response response;

    try {
      response = await http.get(
        uri,
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('❌ FETCH ERROR (WEB): $e');
      rethrow;
    }

    // print('📥 Status Code: ${response.statusCode}');
    // print('📥 Raw Response: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      // print('✅ Decoded Response: $decoded');
      return decoded['students'] ?? [];
    }

    throw Exception('Unauthorized');
  }

  // Fetch Student Details
  Future<Map<String, dynamic>> fetchStudentDetailsById(String studentId) async {
    final token = await _authService.getIdToken();
    if (token == null) {
      throw Exception('Token not available');
    }

    final url = Uri.parse(
      "https://apis-dev.skuteq.net/v1/students/$studentId?status=true",
    );

    // print('📡 Student details URL: $url');
    // print('🔐 Authorization: Bearer $token');

    final response = await http.get(
      url,
      headers: {
        'Authorization': token, // ✅ FIXED
        'Content-Type': 'application/json',
      },
    );

    // print('📥 Status Code: ${response.statusCode}');
    // print('📥 Raw Response: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['student'] ?? decoded;
    } else {
      throw Exception(
        "Failed to fetch student details (${response.statusCode})",
      );
    }
  }

  Future<Map<String, dynamic>> fetchStudentDashboard({
    required String branchId,
    required String studentId,
    required String academicYearId,
    required String startDate,
    required String endDate,
    required String classId,
    required String sectionId,
  }) async {
    final token = await _authService.getIdToken();
    if (token == null) {
      throw Exception('Token not available');
    }

    final uri = Uri.parse('https://apis-dev.skuteq.net/v1/students/dashboard')
        .replace(
          queryParameters: {
            'branch_id': branchId,
            'student_id': studentId,
            'academic_year_id': academicYearId,
            'start_date': startDate,
            'end_date': endDate,
            'class_id': classId,
            'section_id': sectionId,
          },
        );

    // Debug logs (optional)
    // print('📡 Dashboard URL: $uri');
    // print('🔐 Authorization: Bearer $token');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': token, // ✅ same as your working API
        'Content-Type': 'application/json',
      },
    );

    print('📥 Status Code: ${response.statusCode}');
    print('📥 Raw Response: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      // print('✅ Decoded Student Dashboard: $decoded');
      return decoded;
    } else {
      throw Exception(
        'Failed to fetch student dashboard (${response.statusCode})',
      );
    }
  }
}
