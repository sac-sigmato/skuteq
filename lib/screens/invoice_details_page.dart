// lib/screens/invoice_details_page.dart
import 'package:flutter/material.dart';

class InvoiceDetailsPage extends StatelessWidget {
  final String? invoiceNo; // optional fallback id
  final Map<String, dynamic>? invoiceData; // preferred full data

  const InvoiceDetailsPage({super.key, this.invoiceNo, this.invoiceData});

  // Fallback sample data (kept for local testing)
  static final Map<String, Map<String, dynamic>> sampleData = {
    'INV-2086': {
      'invoiceNo': 'INV-2086',
      'title': 'Tuition Fee - Oct',
      'date': '01 Oct 2024',
      'amount': 5800,
      'status': 'Paid',
      'items': [
        {'item': 'Tuition (Oct)', 'qty': 1, 'charge': 4800, 'total': 4800},
        {'item': 'Bus Fee (Oct)', 'qty': 1, 'charge': 1000, 'total': 1000},
      ],
      'payments': [
        {'receipt': 'RCT-1042', 'date': '08 Oct 2024', 'amount': 3900},
        {'receipt': 'RCT-1043', 'date': '08 Oct 2024', 'amount': 1900},
      ],
      'amountInWords': 'Five thousand eight hundred only',
      'terms':
          'All fee payments are final and cannot be refunded or transferred.',
    },
  };

  // UI colors
  static const Color _bg = Color(0xFFF5F8FB);
  static const Color _cardBorder = Color(0xFFE7EFF7);
  static const Color _muted = Color(0xFF9FA8B2);
  static const Color _accentBlue = Color(0xFF2E9EE6);
  static const Color _titleBlue = Color(0xFF244A6A);

  double _parseAmount(dynamic raw) {
    if (raw == null) return 0.0;
    if (raw is num) return raw.toDouble();
    if (raw is String) {
      final cleaned = raw.replaceAll(RegExp(r'[^\d.]'), '');
      return double.tryParse(cleaned) ?? 0.0;
    }
    return 0.0;
  }

  String _formatFromNum(double v) {
    if (v % 1 == 0) return '₹ ${v.toInt()}';
    return '₹ ${v.toStringAsFixed(2)}';
  }

  String _format(dynamic raw) {
    if (raw == null) return '₹ 0';
    if (raw is num) return _formatFromNum(raw.toDouble());
    if (raw is String) {
      final parsed = _parseAmount(raw);
      return _formatFromNum(parsed);
    }
    return '₹ 0';
  }

  Map<String, dynamic> _resolveData() {
    if (invoiceData != null) return invoiceData!;
    if (invoiceNo != null && sampleData.containsKey(invoiceNo)) {
      return sampleData[invoiceNo]!;
    }
    return <String, dynamic>{
      'invoiceNo': invoiceNo ?? '',
      'title': '',
      'date': '',
      'amount': 0,
      'status': '',
      'items': [],
      'payments': [],
      'amountInWords': '',
      'terms': '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final data = _resolveData();

    final invoiceNoDisplay =
        (data['invoiceNo'] ??
                data['invoice'] ??
                data['invoice_number'] ??
                data['id'] ??
                invoiceNo ??
                '')
            .toString();
    final title =
        (data['title'] ??
                data['invoice_name'] ??
                data['description'] ??
                data['name'] ??
                '')
            .toString();
    final date =
        (data['date'] ?? data['invoice_date'] ?? data['added_date'] ?? '')
            .toString();

    final amountVal = _parseAmount(
      data['amount'] ??
          data['invoice_total'] ??
          data['invoice_amount'] ??
          data['amount_paid'] ??
          0,
    );
    final status = (data['status'] ?? data['payment_status'] ?? '').toString();

    final items = (data['items'] is List)
        ? List<Map<String, dynamic>>.from(data['items'])
        : <Map<String, dynamic>>[];
    final payments = (data['payments'] is List)
        ? List<Map<String, dynamic>>.from(data['payments'])
        : <Map<String, dynamic>>[];

    final total = items.fold<double>(
      0.0,
      (s, it) =>
          s +
          _parseAmount(
            it['total'] ??
                it['total_amount'] ??
                it['charge'] ??
                it['amount'] ??
                0,
          ),
    );
    final paidSum = payments.fold<double>(
      0.0,
      (s, p) =>
          s + _parseAmount(p['amount'] ?? p['paid_amount'] ?? p['paid'] ?? 0),
    );
    final balance = (total - paidSum) <= 0 ? 0.0 : (total - paidSum);

    final amountInWords =
        (data['amountInWords'] ?? data['amount_in_words'] ?? '').toString();
    final terms =
        (data['terms'] ??
                data['terms_and_conditions'] ??
                data['terms_and_condition'] ??
                '')
            .toString();

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Invoice Details',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          children: [
            // Combined card: invoice header (top row) + divider + main info row
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  // Top row: Invoice # and compact PDF button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            invoiceNoDisplay.isNotEmpty
                                ? 'Invoice #$invoiceNoDisplay'
                                : 'Invoice',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _cardBorder),
                          ),
                          child: TextButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('PDF action not implemented'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.download_rounded, size: 16),
                            label: const Text(
                              'PDF',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // thin divider (subtle)
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFECEFF2),
                  ),

                  // main info row: title/date left, amount + badge right
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // left block: title + date
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title.isNotEmpty
                                    ? title
                                    : (data['description'] ?? '').toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                date,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: _muted,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // right block: amount + badge
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _format(amountVal),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: status.toLowerCase() == 'paid'
                                      ? const Color(0xFF2ECC71)
                                      : const Color(0xFFF39C12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (status.toLowerCase() == 'paid')
                                      const Icon(
                                        Icons.check_circle,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    if (status.toLowerCase() == 'paid')
                                      const SizedBox(width: 6),
                                    Text(
                                      status.isNotEmpty
                                          ? status
                                          : (data['payment_status'] ?? '')
                                                .toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Items card (table-like) — unchanged from prior version but spacing tuned
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Text(
                      'Items',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _accentBlue,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 2,
                    thickness: 2,
                    color: Color(0xFFECEFF2),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    
                    child: Row(
                      children: const [
                        Expanded(
                          flex: 4,
                          child: Text(
                            'Item',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Qty',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Charge',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Total',
                            textAlign: TextAlign.right,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFECEFF2),
                  ),
                  ...items.map((it) {
                    final isLast = it == items.last;
                    final itemName =
                        (it['item'] ?? it['name'] ?? it['description'] ?? '')
                            .toString();
                    final qty = it['qty'] ?? it['quantity'] ?? 1;
                    final charge = _parseAmount(
                      it['charge'] ?? it['amount'] ?? it['price'] ?? 0,
                    );
                    final rowTotal = _parseAmount(
                      it['total'] ?? it['total_amount'] ?? charge,
                    );
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Text(
                                  itemName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  qty.toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  _format(charge),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    _format(rowTotal),
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isLast)
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: Color(0xFFECEFF2),
                          ),
                      ],
                    );
                  }).toList(),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFECEFF2),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Invoice Total',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Text(
                          _format(total),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Balance Due',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Text(
                          _format(balance),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Payments card with label + small icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F8FF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE7F2FD)),
                        ),
                        child: const Icon(
                          Icons.receipt_long,
                          color: _accentBlue,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Payments',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _titleBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...payments.map((p) {
                    final receipt =
                        (p['receipt'] ??
                                p['receiptNo'] ??
                                p['receipt_number'] ??
                                p['id'] ??
                                '')
                            .toString();
                    final dateStr =
                        (p['date'] ?? p['paid_on'] ?? p['paid_at'] ?? '')
                            .toString();
                    final amt = _parseAmount(
                      p['amount'] ?? p['paid_amount'] ?? 0,
                    );
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FBFF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFEBF4FB)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Receipt #$receipt',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  dateStr,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: _muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _format(amt),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  if (amountInWords.isNotEmpty || terms.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (amountInWords.isNotEmpty) ...[
                            const Text(
                              'Amount in Words',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              amountInWords,
                              style: const TextStyle(color: _muted),
                            ),
                            const SizedBox(height: 10),
                          ],
                          if (terms.isNotEmpty) ...[
                            const Text(
                              'Terms & Conditions',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            Text(terms, style: const TextStyle(color: _muted)),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
