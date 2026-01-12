import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skuteq_app/helpers/invoice_storage.dart';
import 'amplify_auth_service.dart';
import 'package:flutter/foundation.dart';

class AttendanceService {
  final AmplifyAuthService _authService = AmplifyAuthService();

  static const List<String> _months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  int _monthIndex(String monthName) {
    final idx = _months.indexWhere(
      (m) => m.toLowerCase() == monthName.trim().toLowerCase(),
    );
    return idx == -1 ? 1 : (idx + 1); // 1..12
  }

  bool _isAfter(int y1, int m1, int y2, int m2) {
    // (y1,m1) > (y2,m2)
    return (y1 > y2) || (y1 == y2 && m1 > m2);
  }

  Future<Map<String, dynamic>> fetchYearWiseAttendance({
    required String branchId,
    required String studentId,
    required String academicYearId,
    required String classId,
    required String sectionId,
    required String month,
    required int year,
  }) async {
    final token = await _authService.getIdToken();
    if (token == null) throw Exception("Token not available");

    // ✅ get AY status from storage: "ongoing" | "completed" | "upcoming"
    final ayStatus =
        (await InvoiceStorage.getAyStatus())?.toString() ?? "ongoing";

    // ✅ define max allowed month/year based on status
    final now = DateTime.now();
    int maxYear = now.year;
    int maxMonth = now.month;

    if (ayStatus != "ongoing") {
      final endMonthName = await InvoiceStorage.getAyEndMonth();
      final endYear = await InvoiceStorage.getAyEndYear();

      if (endMonthName == null || endYear == null) {
        throw Exception("endMonth/endYear missing in storage");
      }

      maxYear = endYear;
      maxMonth = _monthIndex(endMonthName);
    }

    // ✅ clamp requested month/year if user tries beyond allowed max
    int reqYear = year;
    int reqMonth = _monthIndex(month);

    if (_isAfter(reqYear, reqMonth, maxYear, maxMonth)) {
      reqYear = maxYear;
      reqMonth = maxMonth;
    }

    final usedMonthName = _months[reqMonth - 1];

    final uri = Uri.parse(
      "https://apis-dev.skuteq.net/v1/student-attendance"
      "?branch_id=$branchId"
      "&student_id=$studentId"
      "&academic_year_id=$academicYearId"
      "&class_id=$classId"
      "&section_id=$sectionId"
      "&filter=true"
      "&type=month"
      "&page_number=1"
      "&month=$usedMonthName"
      "&year=$reqYear",
    );

    debugPrint("📡 Attendance API URL:\n$uri");

    final response = await http.get(
      uri,
      headers: {"Authorization": token, "Content-Type": "application/json"},
    );

    try {
      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200) return decoded;
    } catch (_) {}

    throw Exception("Failed to fetch attendance");
  }
}
