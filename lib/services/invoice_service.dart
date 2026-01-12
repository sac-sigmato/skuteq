import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skuteq_app/helpers/invoice_storage.dart';
import 'amplify_auth_service.dart';

class InvoiceService {
  final AmplifyAuthService _authService = AmplifyAuthService();

  Future<List<dynamic>> fetchStudentInvoices({
    String invoiceStatus = "all",
  }) async {
    final token = await _authService.getIdToken();
    if (token == null) {
      throw Exception("Token not available");
    }
    final params =
        await InvoiceStorage.getInvoiceParamsWithStudentDbIdOrThrow();

    final studentDbId = params["studentDbId"]!;
    final startDate = params["startDate"]!;
    final endDate = params["endDate"]!;

    final uri = Uri.parse(
      "https://apis-dev.skuteq.net/v1/students/view-student-invoice/$studentDbId"
      "?start_date=$startDate"
      "&end_date=$endDate"
      "&invoice_status=$invoiceStatus"
      "&status=true",
    );

    print("📡 Invoice API URL: $uri");

    final response = await http.get(
      uri,
      headers: {"Authorization": token, "Content-Type": "application/json"},
    );

    print("📥 Status Code: ${response.statusCode}");
    print("📥 Raw Response: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      // ✅ API returns { statements: [] }
      return decoded['statements'] ?? [];
    }

    throw Exception("Failed to fetch invoices");
  }

  Future<Map<String, dynamic>> fetchInvoiceDetails({
    required String invoiceHeaderId,
  }) async {
    final token = await _authService.getIdToken();
    if (token == null) {
      throw Exception("Token not available");
    }

    final uri = Uri.parse(
      "https://apis-dev.skuteq.net/v1/invoice/details?_id=$invoiceHeaderId",
    );

    print("📡 INVOICE DETAILS URL:\n$uri");

    final response = await http.get(
      uri,
      headers: {"Authorization": token, "Content-Type": "application/json"},
    );

    print("════════════ INVOICE DETAILS ════════════");
    print("STATUS => ${response.statusCode}");
    print("BODY => ${response.body}");
    print("════════════════════════════════════════");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to load invoice details");
  }

  Future<Map<String, dynamic>> fetchInvoiceDownload({
    required String invoiceHeaderId,
  }) async {
    final token = await _authService.getIdToken();
    if (token == null) {
      throw Exception("Token not available");
    }

    final uri = Uri.parse(
      "https://apis-dev.skuteq.net/v1/invoice/details?_id=$invoiceHeaderId&export=true",
    );

    print("📡 INVOICE DETAILS URL:\n$uri");

    final response = await http.get(
      uri,
      headers: {"Authorization": token, "Content-Type": "application/json"},
    );

    print("════════════ INVOICE DETAILS ════════════");
    print("STATUS => ${response.statusCode}");
    print("BODY => ${response.body}");
    print("════════════════════════════════════════");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to load invoice details");
  }
}
