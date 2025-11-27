// lib/screens/receipt_details_page.dart
import 'package:flutter/material.dart';

class ReceiptDetailsPage extends StatelessWidget {
  final String receiptNo;
  const ReceiptDetailsPage({super.key, required this.receiptNo});

  // Sample detailed data keyed by receipt number.
  static final Map<String, Map<String, dynamic>> sampleDetails = {
    'RCP-1042': {
      'title': 'Receipt #RCP-1042',
      'amount': '₹ 4,800',
      'date': '08 Oct 2024',
      'reference': 'TXN-56A9-1042',
      'paidOn': '08 Oct 2024, 10:42 AM',
      'items': [
        {'title': 'Tuition Fee - Oct', 'amount': '₹ 3,600', 'inv': 'INV-7841'},
        {'title': 'Lab & Library', 'amount': '₹ 900', 'inv': 'INV-7798'},
        {'title': 'Transport (Oct)', 'amount': '₹ 300', 'inv': 'INV-7756'},
      ],
      'amountInWords': 'Four rupees and forty-four paise only',
      'terms':
          'All fee payments are final and cannot be refunded or transferred.',
    },
  };

  static const Color _kBlue = Color(0xFF2E9EE6);
  static const Color _kMuted = Color(0xFF9FA8B2);
  static const Color _kBg = Color(0xFFF5F8FB);

  @override
  Widget build(BuildContext context) {
    final data =
        sampleDetails[receiptNo] ??
        {
          'title': 'Receipt #$receiptNo',
          'amount': '₹ 0',
          'date': '',
          'reference': '-',
          'paidOn': '-',
          'items': [],
          'amountInWords': '',
          'terms': '',
        };

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Receipt Details',
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
            // Header card: title (left), amount (right) and PDF button under amount
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE7EFF7)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: title + date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data['date'] ?? '',
                          style: const TextStyle(fontSize: 12, color: _kMuted),
                        ),
                      ],
                    ),
                  ),

                  // Right: amount and PDF button (stacked)
                  SizedBox(
                    width: 110, // fixed width keeps right column consistent
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // amount (top-right)
                        Text(
                          data['amount'] ?? '',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // PDF button aligned right
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: implement PDF open/download
                          },
                          icon: const Icon(Icons.download_rounded, size: 16),
                          label: const Text('PDF'),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                            side: const BorderSide(color: Color(0xFFE7EFF7)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Payment summary card with two columns aligned properly
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE7EFF7)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Summary',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _kBlue,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Use Table so both rows share the same column widths and alignments
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(
                        1,
                      ), // left column takes remaining space
                      1: IntrinsicColumnWidth(), // right column fits its content
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          // left label
                          const Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Text(
                              'Reference #',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // right value (aligned right)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                data['reference'] ?? '-',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // second row (Paid On)
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Text(
                              'Paid On',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                data['paidOn'] ?? '-',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Details section (list of items) — items aligned with amount right
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE7EFF7)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _kBlue,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Item rows
                  ...((data['items'] as List).map((it) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FBFF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFEBF4FB)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // left: title + inv (stacked)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  it['title'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  it['inv'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: _kMuted,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // right: amount aligned top-right
                          SizedBox(
                            width: 80,
                            child: Text(
                              it['amount'] ?? '',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  })).toList(),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Amount in words + Terms & Conditions card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE7EFF7)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Amount in Words',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data['amountInWords'] ?? '',
                    style: const TextStyle(color: _kMuted),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Terms & Conditions',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data['terms'] ?? '',
                    style: const TextStyle(color: _kMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
