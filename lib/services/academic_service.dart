import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'amplify_auth_service.dart';

class ExamOption {
  final String id;
  final String name;
  const ExamOption({required this.id, required this.name});
}

class AcademicService {
  final AmplifyAuthService _authService = AmplifyAuthService();

  Future<Map<String, dynamic>> fetchStudentAyClass({
    required String branchId,
    required String studentDbId, // Mongo _id
  }) async {
    final token = await _authService.getIdToken();
    if (token == null) throw Exception("Token not available");

    final uri = Uri.parse(
      "https://apis-dev.skuteq.net/v1/students/list-ay-class"
      "?branch_id=$branchId"
      "&student_id=$studentDbId",
    );

    debugPrint("📡 LIST AY/CLASS URL:\n$uri");

    final response = await http.get(
      uri,
      headers: {"Authorization": token, "Content-Type": "application/json"},
    );

    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception("Failed to fetch AY/Class");
  }

  Map<String, dynamic>? pickLatestAyClass(Map<String, dynamic> res) {
    final list = (res['data'] as List?) ?? [];
    if (list.isEmpty) return null;

    final latest = list.cast<Map>().where((e) => e['latest'] == true).toList();
    if (latest.isNotEmpty) return Map<String, dynamic>.from(latest.first);

    return Map<String, dynamic>.from(list.first);
  }

  // ✅ NEW: LIST EXAMS (dropdown)
  Future<Map<String, dynamic>> fetchStudentExams({
    required String branchId,
    required String studentUuid, // student_uuid
    required String academicYearId,
    required String classId,
    required String sectionId,
    bool latest = true,
  }) async {
    final token = await _authService.getIdToken();
    if (token == null) throw Exception("Token not available");

    final uri = Uri.parse(
      "https://apis-dev.skuteq.net/v1/students/list-exams"
      "?branch_id=$branchId"
      "&student_uuid=$studentUuid"
      "&academic_year_id=$academicYearId"
      "&class_id=$classId"
      "&section_id=$sectionId"
      "&latest=${latest ? "true" : "false"}"
      "&filter=true",
    );

    debugPrint("📡 LIST EXAMS URL:\n$uri");

    final response = await http.get(
      uri,
      headers: {"Authorization": token, "Content-Type": "application/json"},
    );

    debugPrint("════════════ LIST EXAMS ════════════");
    debugPrint("STATUS => ${response.statusCode}");
    debugPrint("BODY => ${response.body}");
    debugPrint("══════════════════════════════════=");

    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception("Failed to fetch exams");
  }

  // ✅ Extract exams from /students/list-exams response
    // ✅ Extract exams from /students/list-exams response (ROBUST)
  List<ExamOption> extractExamOptionsFromListExams(Map<String, dynamic> res) {
    final List data = (res['data'] as List?) ?? [];

    final exams = <ExamOption>[];

    for (final row in data) {
      if (row is! Map) continue;

      final List examList = (row['exams'] as List?) ?? [];

      for (final ex in examList) {
        if (ex is! Map) continue;

        final id = ex['exam_id']?.toString();
        final name = ex['exam_name']?.toString();

        if (id != null && id.isNotEmpty && name != null && name.isNotEmpty) {
          exams.add(ExamOption(id: id, name: name));
        }
      }
    }

    // de-dupe
    final seen = <String>{};
    final unique = <ExamOption>[];
    for (final e in exams) {
      if (seen.add(e.id)) unique.add(e);
    }

    return [const ExamOption(id: "", name: "Select Exam"), ...unique];
  }

  // Academic report
  Future<Map<String, dynamic>> fetchAcademicReports({
    required String branchId,
    required String studentId, // STDB...
    required String academicYearId,
    required String classId,
    required String sectionId,
    required String examId,
    String role = "directory",
  }) async {
    final token = await _authService.getIdToken();
    if (token == null) throw Exception("Token not available");

    // ✅ Use Uri.https to avoid any malformed URL issues
    final uri = Uri.https("apis-dev.skuteq.net", "/v1/academic-reports", {
      "branch_id": branchId,
      "student_id": studentId,
      "academic_year_id": academicYearId,
      "class_id": classId,
      "section_id": sectionId,
      "exam_id": examId,
      "filter": "true",
      "role": role,
    });

    debugPrint("📡 ACADEMIC REPORTS URL:\n$uri");

    // ✅ Ensure Bearer format
    final authHeader = token.startsWith("Bearer ") ? token : "Bearer $token";

    try {
      final response = await http.get(
        uri,
        headers: {
          "Authorization": authHeader,
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      debugPrint("════════════ ACADEMIC REPORTS ════════════");
      debugPrint("STATUS => ${response.statusCode}");
      debugPrint("BODY => ${response.body}");
      debugPrint("════════════════════════════════════════=");

      if (response.statusCode == 200) return jsonDecode(response.body);

      throw Exception("Academic reports failed (${response.statusCode})");
    } catch (e) {
      debugPrint("❌ HTTP ERROR (academic-reports): $e");
      rethrow;
    }
  }

}
