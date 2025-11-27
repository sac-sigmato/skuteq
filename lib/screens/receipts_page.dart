// lib/screens/receipts_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'receipt_details_page.dart'; // <-- import the new page

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
      {"receiptNo":"RCP-1042","date":"08 Oct 2024","amount":"₹ 4,800"},
      {"receiptNo":"RCP-1041","date":"07 Oct 2024","amount":"₹ 1,200"},
      {"receiptNo":"RCP-1040","date":"05 Oct 2024","amount":"₹ 800"},
      {"receiptNo":"RCP-1039","date":"03 Oct 2024","amount":"₹ 1,500"},
      {"receiptNo":"RCP-1038","date":"01 Oct 2024","amount":"₹ 900"}
    ]
  }
  ''';

  static const Color kBlue = Color(0xFF2E9EE6);
  static const Color kMuted = Color(0xFF9FA8B2);
  static const Color kBg = Color(0xFFF5F8FB);

  @override
  void initState() {
    super.initState();
    final data = json.decode(sampleJsonData);
    summaryData = data["summary"];
    receiptsData = List<Map<String, dynamic>>.from(data["receipts"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Receipts",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSummaryCard(),
          Expanded(child: _buildList()),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE7EFF7)),
        ),
        child: Row(
          children: [
            // LEFT
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Receipts',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: kBlue,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${summaryData['totalReceipts']}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),

            // RIGHT
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Amount Paid',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: kBlue,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      summaryData['amountPaid'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      itemCount: receiptsData.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, index) => _receiptTile(receiptsData[index]),
    );
  }

  Widget _receiptTile(Map<String, dynamic> r) {
    return InkWell(
      onTap: () {
        // Navigate to details page and pass receiptNo
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReceiptDetailsPage(receiptNo: r['receiptNo']),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE7EFF7)),
        ),
        child: Row(
          children: [
            // REMOVED ICON → ONLY TEXT NOW
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// RECEIPT NUMBER (BLACK)
                  Text(
                    "#${r['receiptNo']}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),

                  /// DATE (MUTED GRAY)
                  Text(
                    r['date'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: kMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            /// AMOUNT (BLACK)
            Text(
              r['amount'],
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.home, color: kBlue),
          Icon(Icons.person, color: Colors.black54),
          Icon(Icons.notifications, color: Colors.black54),
        ],
      ),
    );
  }
}
