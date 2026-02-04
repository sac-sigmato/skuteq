import 'package:flutter/material.dart';
import 'package:skuteq_app/components/app_bottom_nav.dart';
import 'package:skuteq_app/components/shared_app_head.dart';
import 'package:skuteq_app/helpers/invoice_storage.dart';
import 'package:skuteq_app/services/receipt_service.dart';
import 'receipt_details_page.dart';
import 'package:intl/intl.dart';


class ReceiptsPage extends StatefulWidget {
  final Map<String, dynamic> apiResponse;
  final String branchId;

  const ReceiptsPage({
    super.key,
    required this.apiResponse,
    required this.branchId,
  });

  @override
  State<ReceiptsPage> createState() => _ReceiptsPageState();
}

class _ReceiptsPageState extends State<ReceiptsPage> {
  List<Map<String, dynamic>> receiptsData = [];
  Map<String, dynamic> summaryData = {};

  /// COLORS
   static const Color pageBg = Color(0xFFF6FAFF);
  static const Color cardBorder = Color(0xFFE6EEF6);
  static const Color primaryBlue = Color(0xFF1E6FD8);
  static const Color mutedText = Color(0xFF7A8AAA);

  @override
  void initState() {
    super.initState();

    final response = widget.apiResponse;

    final List list = response['data'] ?? [];

    summaryData = {
      'totalReceipts': response['total_count'] ?? 0,
      'amountPaid': "₹ ${ _formatAmount(response['report_total'] ?? 0)}",
    };

    receiptsData = List<Map<String, dynamic>>.from(
      list.map(
        (e) => {
          'receiptNo': e['receipt_number'] ,
          'receiptId': e['_id'], // 🔥 IMPORTANT
          'date': _formatDate(e['received_date']),
          'amount': "₹ ${_formatAmount(e['received_amount'])}",
        },
      ),
    );
  }

  String _formatAmount(dynamic value) {
    if (value == null) return '0';

    final num amount = value is num
        ? value
        : num.tryParse(value.toString()) ?? 0;

    // Indian number format
    final formatter = NumberFormat('#,##,###', 'en_IN');

    if (amount % 1 == 0) {
      return formatter.format(amount.toInt());
    } else {
      return formatter.format(amount);
    }
  }


  String _formatDate(String? iso) {
    if (iso == null) return '';
    final d = DateTime.tryParse(iso);
    if (d == null) return '';

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return "${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      appBar: SharedAppHead(
        title: "Receipts",
        showDrawer: false,
        showBack: true,
      ),
      body: Column(
        children: [
         
          Container(height: 14, color: pageBg),

          /// CONTENT
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
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
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
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Receipts",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryBlue,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${summaryData['totalReceipts']}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  "Amount Paid",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryBlue,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  summaryData['amountPaid'] ?? '₹ 0',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
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
    if (receiptsData.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Text(
          "No receipts found",
          style: TextStyle(color: mutedText, fontWeight: FontWeight.w600),
        ),
      );
    }

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
    return Material(
      color: Colors.transparent, // IMPORTANT
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          debugPrint("🟢 RECEIPT TAPPED => ${r['receiptId']}");

          try {
            final receiptId = r['receiptId'];
            final branchId = widget.branchId;

            if (receiptId == null || branchId == null) {
              throw Exception("Receipt params missing");
            }
            await InvoiceStorage.saveReceiptInfo(
              receiptId: receiptId.toString(),
              branchId: branchId.toString(),
            );

            final receiptService = ReceiptService();

            // 🔄 SHOW LOADER
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );

            final receiptDetailsResponse = await receiptService
                .fetchReceiptDetails(
                  receiptId: receiptId.toString(),
                  branchId: branchId.toString(),
                );

            // ❌ CLOSE LOADER
            Navigator.pop(context);

            // ➡️ NAVIGATE
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ReceiptDetailsPage(apiResponse: receiptDetailsResponse),
              ),
            );
          } catch (e) {
            Navigator.pop(context);
            debugPrint("❌ Receipt details error: $e");

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to load receipt details")),
            );
          }
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "#${r['receiptNo']}",
                     style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      r['date'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: mutedText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                r['amount'],
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
