import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/invoice_service.dart';
import 'invoice_storage.dart';

class InvoicePdfHelper {
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

  /// Call this on PDF button click.
  /// If invoiceHeaderId not passed, it will use stored one.
  static Future<void> openInvoicePdf({
    required BuildContext context,
    String? invoiceHeaderId,
  }) async {
    final invoiceService = InvoiceService();

    // ✅ prefer passed ID, fallback to storage
    final id = (invoiceHeaderId != null && invoiceHeaderId.isNotEmpty)
        ? invoiceHeaderId
        : await InvoiceStorage.getInvoiceHeaderId();

    if (id == null || id.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invoice ID not found")));
      return;
    }

    // ✅ show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final res = await invoiceService.fetchInvoiceDownload(
        invoiceHeaderId: id,
      );
      final url = _extractPdfUrl(res);

      if (Navigator.canPop(context)) Navigator.pop(context);

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
