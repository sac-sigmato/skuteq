import 'package:flutter/material.dart';

class ReceiptDetailsPage extends StatelessWidget {
  final String receiptNo;
  const ReceiptDetailsPage({super.key, required this.receiptNo});

  // ---------------- SAMPLE DATA ----------------
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

  // ---------------- COLORS ----------------
  static const Color pageBg = Color(0xFFF6F7FB);
  static const Color cardBorder = Color(0xFFE6EEF6);
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color mutedText = Color(0xFF7A869A);

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
      backgroundColor: pageBg,

      body: Column(
        children: [
          /// 🔹 HEADER INSIDE BODY
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            margin: const EdgeInsets.only(top: 20),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Receipt Details",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),

          /// 🔹 TOP GAP (LIKE SS)
          Container(height: 14, color: pageBg),

          /// 🔹 SCROLLABLE CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _headerCard(data),
                  const SizedBox(height: 12),
                  _paymentSummary(data),
                  const SizedBox(height: 12),
                  _detailsCard(data),
                  const SizedBox(height: 12),
                  _footerCard(data),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- HEADER CARD ----------------

  Widget _headerCard(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: [
          /// LEFT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data['date'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: mutedText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          /// RIGHT
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data['amount'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_rounded, size: 16),
                label: const Text("PDF"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  side: BorderSide(color: cardBorder),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- PAYMENT SUMMARY ----------------

  Widget _paymentSummary(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Payment Summary",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 12),
          _summaryRow("Reference #", data['reference']),
          const SizedBox(height: 10),
          _summaryRow("Paid On", data['paidOn']),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  // ---------------- DETAILS CARD ----------------

  Widget _detailsCard(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Details",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(data['items'].length, (i) {
            final it = data['items'][i];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FBFF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEBF4FB)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          it['title'],
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          it['inv'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: mutedText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    it['amount'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ---------------- FOOTER ----------------

  Widget _footerCard(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Amount in Words",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(data['amountInWords'], style: const TextStyle(color: mutedText)),
          const SizedBox(height: 14),
          const Text(
            "Terms & Conditions",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(data['terms'], style: const TextStyle(color: mutedText)),
        ],
      ),
    );
  }
}
