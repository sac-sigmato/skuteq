import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:skuteq_app/helpers/invoice_storage.dart';
import 'amplify_auth_service.dart';

class ReceiptService {
  static const String _baseUrl =
      "https://apis-dev.skuteq.net/v1/collect-fees/fee-report";

  final AmplifyAuthService _authService = AmplifyAuthService();

  Future<Map<String, dynamic>> fetchReceipts({int pageNumber = 1}) async {
    final token = await _authService.getIdToken();
    if (token == null) {
      throw Exception("Token not available");
    }

    final params =
        await InvoiceStorage.getInvoiceParamsWithStudentDbIdOrThrow();
    final branchId = await InvoiceStorage.getBranchId();
    final studentDbId = params["studentDbId"]!;
    final startDate = params["startDate"]!;
    final endDate = params["endDate"]!;
    // final branchId = params["branchId"]!;

    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'branch_id': branchId,
        'student_uuid': studentDbId,
        'start_date': startDate,
        'end_date': endDate,
        'page_number': pageNumber.toString(),
        'filter': 'true',
        'sort': 'receipt_number+desc',
      },
    );

    debugPrint("📡 RECEIPT API URL:\n$uri");
    debugPrint("🔐 Token:\n$token");

    final response = await http.get(
      uri,
      headers: {"Authorization": token, "Content-Type": "application/json"},
    );

    print("════════════════ RECEIPT API ════════════════");
    print("STATUS CODE => ${response.statusCode}");
    print("RAW BODY => ${response.body}");
    print("════════════════════════════════════════════=");

    try {
      final decoded = jsonDecode(response.body);
      const encoder = JsonEncoder.withIndent("  ");
      debugPrint("📦 FULL RECEIPT RESPONSE:\n${encoder.convert(decoded)}");

      if (response.statusCode == 200) {
        return decoded;
      }
    } catch (e) {
      debugPrint("❌ JSON PARSE ERROR: $e");
      debugPrint("📦 RAW BODY:\n${response.body}");
    }

    throw Exception("Failed to fetch receipts");
  }

  Future<Map<String, dynamic>> fetchReceiptDetails({
    required String receiptId,
    required String branchId,
  }) async {
    final token = await _authService.getIdToken();
    if (token == null) {
      throw Exception("Token not available");
    }

    final uri = Uri.parse(
      "https://apis-dev.skuteq.net/v1/collect-fees/view-fee-report"
      "?_id=$receiptId&branch_id=$branchId",
    );

    debugPrint("📡 RECEIPT DETAILS URL:\n$uri");

    final response = await http.get(
      uri,
      headers: {"Authorization": token, "Content-Type": "application/json"},
    );

    debugPrint("════════════ RECEIPT DETAILS ════════════");
    debugPrint("STATUS => ${response.statusCode}");
    debugPrint("BODY => ${response.body}");
    debugPrint("════════════════════════════════════════");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to fetch receipt details");
  }

  Future<Map<String, dynamic>> fetchReceiptDownload({
    required String receiptId,
    required String branchId,
  }) async {
    final token = await _authService.getIdToken();
    if (token == null) {
      throw Exception("Token not available");
    }

    final uri = Uri.parse(
      "https://apis-dev.skuteq.net/v1/collect-fees/download/"
      "$receiptId/$branchId",
    );

    debugPrint("📡 RECEIPT DETAILS URL:\n$uri");

    final response = await http.get(
      uri,
      headers: {"Authorization": token, "Content-Type": "application/json"},
    );

    debugPrint("════════════ RECEIPT DETAILS ════════════");
    debugPrint("STATUS => ${response.statusCode}");
    debugPrint("BODY => ${response.body}");
    debugPrint("════════════════════════════════════════");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to fetch receipt details");
  }
}
