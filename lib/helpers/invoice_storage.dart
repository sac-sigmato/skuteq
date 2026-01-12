import 'package:shared_preferences/shared_preferences.dart';

class InvoiceStorage {
  static const String _kInvoiceHeaderId = "invoice_header_id";

  // ✅ Receipt storage keys
  static const String _kReceiptId = "receipt_id";
  static const String _kReceiptBranchId = "receipt_branch_id";

  // ✅ NEW: Academic Year Date keys
  static const String _kAyStartDate = "ay_start_date";
  static const String _kAyEndDate = "ay_end_date";
  static const String _kAyAcademicYearId = "ay_academic_year_id";
  static const String _kStudentId = "student_id";
  // ✅ NEW: endMonth/endYear keys
  static const String _kAyEndMonth = "ay_end_month";
  static const String _kAyEndYear = "ay_end_year";

  static const String _kStudent_Id = "_id";
  static const String _kBranchId = "branch_id";
  static const String _kAyStatus = "ongoing";

  static Future<void> saveAyStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAyStatus, status);
  }
  static Future<String?> getAyStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kAyStatus);
  }

static Future<void> clearAyStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kAyStatus);
  } 
  static Future<void> saveBranchId(String branchId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kBranchId, branchId);
  }
  static Future<String?> getBranchId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kBranchId);
  }

  static Future<void> saveAyEndMonthYear({
    required String endMonth, // e.g. "April"
    required int endYear, // e.g. 2026
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAyEndMonth, endMonth);
    await prefs.setInt(_kAyEndYear, endYear);
  }

  static Future<String?> getAyEndMonth() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kAyEndMonth);
  }

  static Future<int?> getAyEndYear() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kAyEndYear);
  }

  static Future<void> clearAyEndMonthYear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kAyEndMonth);
    await prefs.remove(_kAyEndYear);
  }

  // ---------------- INVOICE ----------------

  static Future<void> saveInvoiceHeaderId(String invoiceHeaderId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kInvoiceHeaderId, invoiceHeaderId);
  }

  static Future<void> saveStudent_Id(String student_Id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kStudent_Id, student_Id);
  }

  static Future<String?> getStudent_Id() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kStudent_Id);
  }

  static Future<void> saveStudentId(String studentId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kStudentId, studentId);
  }

  static Future<String?> getStudentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kStudentId);
  }

  static Future<String?> getInvoiceHeaderId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kInvoiceHeaderId);
  }

  static Future<void> clearInvoiceHeaderId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kInvoiceHeaderId);
  }

  // ---------------- RECEIPT ----------------

  /// Save both receiptId + branchId together
  static Future<void> saveReceiptInfo({
    required String receiptId,
    required String branchId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kReceiptId, receiptId);
    await prefs.setString(_kReceiptBranchId, branchId);
  }

  static Future<String?> getReceiptId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kReceiptId);
  }

  static Future<String?> getReceiptBranchId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kReceiptBranchId);
  }

  /// Get both values in one call
  static Future<Map<String, String?>> getReceiptInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "receiptId": prefs.getString(_kReceiptId),
      "branchId": prefs.getString(_kReceiptBranchId),
    };
  }

  static Future<void> clearReceiptInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kReceiptId);
    await prefs.remove(_kReceiptBranchId);
  }

  // ---------------- ACADEMIC YEAR DATES (NEW) ----------------

  /// Save AY start & end date (ISO) + academicYearId
  static Future<void> saveAyDates({
    required String academicYearId,
    required String startDateIso,
    required String endDateIso,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAyAcademicYearId, academicYearId);
    await prefs.setString(_kAyStartDate, startDateIso);
    await prefs.setString(_kAyEndDate, endDateIso);
  }

  static Future<String?> getAyStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kAyStartDate);
  }

  static Future<String?> getAyEndDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kAyEndDate);
  }

  static Future<String?> getAyAcademicYearId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kAyAcademicYearId);
  }

  /// Get all AY values in one call
  static Future<Map<String, String?>> getAyDates() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "academicYearId": prefs.getString(_kAyAcademicYearId),
      "startDate": prefs.getString(_kAyStartDate),
      "endDate": prefs.getString(_kAyEndDate),
    };
  }

  static Future<void> clearStudentId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kStudentId);
  }

  static Future<void> clearAyDates() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kAyAcademicYearId);
    await prefs.remove(_kAyStartDate);
    await prefs.remove(_kAyEndDate);
  }

  /// Optional: clear everything stored in this class
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kInvoiceHeaderId);
    await prefs.remove(_kReceiptId);
    await prefs.remove(_kReceiptBranchId);
    await prefs.remove(_kAyAcademicYearId);
    await prefs.remove(_kAyStartDate);
    await prefs.remove(_kAyEndDate);
  }

 static Future<Map<String, String>> getInvoiceParamsOrThrow() async {
    final prefs = await SharedPreferences.getInstance();

    final studentId = prefs.getString(_kStudentId); // STDB...
    final startDate = prefs.getString(_kAyStartDate);
    final endDate = prefs.getString(_kAyEndDate);

    if (studentId == null || studentId.isEmpty) {
      throw Exception("student_id (STDB...) missing in storage");
    }
    if (startDate == null || startDate.isEmpty) {
      throw Exception("startDate missing in storage");
    }
    if (endDate == null || endDate.isEmpty) {
      throw Exception("endDate missing in storage");
    }

    return {"studentId": studentId, "startDate": startDate, "endDate": endDate};
  }

static Future<Map<String, String>> getInvoiceParamsWithStudentDbIdOrThrow() async {
  final prefs = await SharedPreferences.getInstance();

  final studentDbId = prefs.getString(_kStudent_Id); // Mongo _id
  final startDate = prefs.getString(_kAyStartDate);
  final endDate = prefs.getString(_kAyEndDate);

  if (studentDbId == null || studentDbId.isEmpty) {
    throw Exception("_id (Mongo) missing in storage");
  }
  if (startDate == null || startDate.isEmpty) {
    throw Exception("startDate missing in storage");
  }
  if (endDate == null || endDate.isEmpty) {
    throw Exception("endDate missing in storage");
  }

  return {
    "studentDbId": studentDbId,
    "startDate": startDate,
    "endDate": endDate,
  };
}

}
