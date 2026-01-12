import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

typedef FetchReceiptDownload =
    Future<Map<String, dynamic>> Function({
      required String receiptId,
      required String branchId,
    });

class ReceiptPdfHelper {
  static String? _extractPdfUrl(dynamic json) {
    if (json == null) return null;

    if (json is String && json.startsWith('http')) return json;

    if (json is Map) {
      for (final k in [
        'url',
        'pdfUrl',
        'pdf_url',
        'downloadUrl',
        'download_url',
        'fileUrl',
        'file_url',
        'link',
        'receiptUrl',
        'receipt_url',
      ]) {
        final v = json[k];
        if (v is String && v.startsWith('http')) return v;
      }

      for (final v in json.values) {
        final got = _extractPdfUrl(v);
        if (got != null) return got;
      }
    }

    if (json is List) {
      for (final item in json) {
        final got = _extractPdfUrl(item);
        if (got != null) return got;
      }
    }

    return null;
  }

  static Future<void> openReceiptPdf({
    required BuildContext context,
    required String receiptId,
    required String branchId,
    required FetchReceiptDownload fetchReceiptDownload,
  }) async {
    // ✅ loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final res = await fetchReceiptDownload(
        receiptId: receiptId,
        branchId: branchId,
      );

      if (Navigator.canPop(context)) Navigator.pop(context);

      final url = _extractPdfUrl(res);

      if (url == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("PDF link not found in response")),
        );
        return;
      }

      final uri = Uri.parse(url);
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!ok) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Unable to open PDF")));
      }
    } catch (e) {
      if (Navigator.canPop(context)) Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load PDF: $e")));
    }
  }
}
