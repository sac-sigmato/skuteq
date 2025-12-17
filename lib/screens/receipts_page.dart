import 'dart:convert';
import 'package:flutter/material.dart';
import 'receipt_details_page.dart';

class ReceiptsPage extends StatefulWidget {
  const ReceiptsPage({super.key});

  @override
  State<ReceiptsPage> createState() => _ReceiptsPageState();
}

class _ReceiptsPageState extends State<ReceiptsPage> {
  List<Map<String, dynamic>> receiptsData = [];
  Map<String, dynamic> summaryData = {};

  final String sampleJsonData = '''
  {
    "summary": {
      "totalReceipts": 12,
      "amountPaid": "₹ 58,400"
    },
    "receipts": [
      {"receiptNo":"RCP-1042","date":"08 Oct 2024","amount":"₹ 900"},
      {"receiptNo":"RCP-1042","date":"08 Oct 2024","amount":"₹ 900"},
      {"receiptNo":"RCP-1042","date":"08 Oct 2024","amount":"₹ 900"},
      {"receiptNo":"RCP-1042","date":"08 Oct 2024","amount":"₹ 900"},
      {"receiptNo":"RCP-1042","date":"08 Oct 2024","amount":"₹ 900"},
      {"receiptNo":"RCP-1042","date":"08 Oct 2024","amount":"₹ 900"}
    ]
  }
  ''';

  /// COLORS (MATCH SS)
  static const Color pageBg = Color(0xFFF6F7FB);
  static const Color cardBorder = Color(0xFFE6EEF6);
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color mutedText = Color(0xFF7A869A);

  @override
  void initState() {
    super.initState();
    final data = json.decode(sampleJsonData);
    summaryData = Map<String, dynamic>.from(data['summary']);
    receiptsData = List<Map<String, dynamic>>.from(data['receipts']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,

      body: Column(
        children: [
          /// 🔹 HEADER (INSIDE BODY)
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
                        "Receipts",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
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

          /// 🔹 CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _summaryCard(),
                  const SizedBox(height: 14),
                  _receiptList(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- SUMMARY CARD ----------------

  Widget _summaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          /// LEFT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Receipts",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: primaryBlue,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${summaryData['totalReceipts']}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          /// RIGHT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  "Amount Paid",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: primaryBlue,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  summaryData['amountPaid'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- RECEIPTS LIST ----------------

  Widget _receiptList() {
    return Column(
      children: receiptsData
          .map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _receiptTile(r),
            ),
          )
          .toList(),
    );
  }

  Widget _receiptTile(Map<String, dynamic> r) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReceiptDetailsPage(receiptNo: r['receiptNo']),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cardBorder),
        ),
        child: Row(
          children: [
            /// LEFT TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "#${r['receiptNo']}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    r['date'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: mutedText,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),

            /// AMOUNT
            Text(
              r['amount'],
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
