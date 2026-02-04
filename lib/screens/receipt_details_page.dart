import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skuteq_app/components/app_bottom_nav.dart';
import 'package:skuteq_app/components/shared_app_head.dart';
import 'package:skuteq_app/helpers/invoice_storage.dart';
import 'package:skuteq_app/helpers/receipt_pdf_helper.dart';
import 'package:skuteq_app/services/receipt_service.dart';
import 'package:dotted_border/dotted_border.dart';


class ReceiptDetailsPage extends StatelessWidget {
  final Map<String, dynamic> apiResponse;

  const ReceiptDetailsPage({super.key, required this.apiResponse});

  static const Color pageBg = Color(0xFFF6FAFF);
  static const Color cardBorder = Color(0xFFE6EEF6);
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color mutedText = Color(0xFF7A8AAA);

  @override
  Widget build(BuildContext context) {
    final data = apiResponse['data'] ?? {};
    final List items = data['payment_details'] ?? [];

    return Scaffold(
      backgroundColor: pageBg,
      appBar: SharedAppHead(
        title: "Receipt Details",
        showDrawer: false,
        showBack: true,
      ),
      body: Column(
        children: [
          Container(height: 14, color: pageBg),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _headerCard(context, data),
                  const SizedBox(height: 12),
                  _paymentSummary(data),
                  const SizedBox(height: 12),
                  _detailsCard(items),
                  const SizedBox(height: 12),
                  _footerCard(data),
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

  // ---------------- HEADER ----------------

  Widget _header(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
      margin: const EdgeInsets.only(top: 20),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => Navigator.pop(context),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  "Receipt Details",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  // ---------------- HEADER CARD ----------------

  Widget _headerCard(BuildContext context, Map<String, dynamic> data) {
    return _card(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Receipt #${data['receipt_number'] ?? '-'}",
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatDate(data['received_date']),
                  style: const TextStyle(fontSize: 12, color: mutedText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹ ${_formatAmount(data['received_amount'])}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () async {
                  final receiptService = ReceiptService();

                  // ✅ Always take from storage
                  final stored = await InvoiceStorage.getReceiptInfo();
                  final String? rid = stored["receiptId"];
                  final String? bid = stored["branchId"];

                  // ✅ Guard
                  if (rid == null ||
                      rid.isEmpty ||
                      bid == null ||
                      bid.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Receipt info not found")),
                    );
                    return;
                  }

                  await ReceiptPdfHelper.openReceiptPdf(
                    context: context,
                    receiptId: rid,
                    branchId: bid,
                    fetchReceiptDownload:
                        ({required receiptId, required branchId}) {
                          return receiptService.fetchReceiptDownload(
                            receiptId: receiptId,
                            branchId: branchId,
                          );
                        },
                  );
                },

                icon: const Icon(Icons.download_rounded, size: 16),
                label: const Text("PDF"),
                style: OutlinedButton.styleFrom(
                  backgroundColor: pageBg,
                  foregroundColor: Colors.black,
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
                    borderRadius: BorderRadius.circular(5),
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
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Payment Summary",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 12),

          _row(
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "Reference #",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                 
                ],
              ),
            ),
            data['reference_number']?.isNotEmpty == true
                ? data['reference_number']
                : '-',
          ),


          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFE6EEF6)),
          const SizedBox(height: 10),

         _row(
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "Paid On",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  
                ],
              ),
            ),
            _formatDateTime(data['received_date']),
          ),

        ],
      ),
    );
  }

  // ---------------- DETAILS ----------------

  Widget _detailsCard(List items) {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Details",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 12),

          if (items.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FBFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "-",
                style: TextStyle(color: mutedText, fontWeight: FontWeight.w600),
              ),
            ),

          ...items.map((it) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: DottedBorder(
                color: const Color(0xFFE6F0FA), // soft blue like SS
                strokeWidth: 1.2,
                dashPattern: const [6, 4], // dash-gap
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  color: const Color(0xFFFFFFFF),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              it['line_item'] ?? '-',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize:15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              it['invoice_number'] ?? '-',
                              style: const TextStyle(
                                fontSize: 12,
                                color: mutedText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "₹ ${_formatAmount(it['line_amount_received'])}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),

        ],
      ),
    );
  }

  // ---------------- FOOTER ----------------

  Widget _footerCard(Map<String, dynamic> data) {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Amount in Words",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(
            _amountInWords(data['received_amount']),
            style: const TextStyle( fontSize: 13,color: mutedText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            "Terms & Conditions",
             style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 6),
          const Text(
            "All fee payments are final and cannot be refunded or transferred.",
            style: const TextStyle(
              fontSize: 13,
              color: mutedText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- HELPERS ----------------

  Widget _card(Widget child) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: child,
    );
  }

 Widget _row(Widget label, String value) {
    return Row(
      children: [
        Expanded(child: label),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }


  String _amountInWords(dynamic value) {
    final num amount = num.tryParse(value?.toString() ?? '') ?? 0;

    if (amount == 0) return '-';

    return "${_numberToWords(amount.toInt())} rupees only".replaceFirstMapped(
      RegExp(r'^\w'),
      (m) => m.group(0)!.toUpperCase(),
    );
  }

  String _numberToWords(int number) {
    if (number == 0) return "zero";

    const units = [
      "",
      "one",
      "two",
      "three",
      "four",
      "five",
      "six",
      "seven",
      "eight",
      "nine",
      "ten",
      "eleven",
      "twelve",
      "thirteen",
      "fourteen",
      "fifteen",
      "sixteen",
      "seventeen",
      "eighteen",
      "nineteen",
    ];

    const tens = [
      "",
      "",
      "twenty",
      "thirty",
      "forty",
      "fifty",
      "sixty",
      "seventy",
      "eighty",
      "ninety",
    ];

    if (number < 20) return units[number];

    if (number < 100) {
      return tens[number ~/ 10] +
          (number % 10 != 0 ? " ${units[number % 10]}" : "");
    }

    if (number < 1000) {
      return "${units[number ~/ 100]} hundred"
          "${number % 100 != 0 ? " ${_numberToWords(number % 100)}" : ""}";
    }

    if (number < 100000) {
      return "${_numberToWords(number ~/ 1000)} thousand"
          "${number % 1000 != 0 ? " ${_numberToWords(number % 1000)}" : ""}";
    }

    if (number < 10000000) {
      return "${_numberToWords(number ~/ 100000)} lakh"
          "${number % 100000 != 0 ? " ${_numberToWords(number % 100000)}" : ""}";
    }

    return "${_numberToWords(number ~/ 10000000)} crore"
        "${number % 10000000 != 0 ? " ${_numberToWords(number % 10000000)}" : ""}";
  }

  String _formatDate(String? iso) {
    if (iso == null) return '-';
    final d = DateTime.tryParse(iso);
    if (d == null) return '-';
    return DateFormat('dd MMM yyyy').format(d);
  }

  String _formatDateTime(String? iso) {
    if (iso == null) return '-';
    final d = DateTime.tryParse(iso);
    if (d == null) return '-';
    return DateFormat('dd MMM yyyy, hh:mm a').format(d);
  }

  String _formatAmount(dynamic value) {
    final num amount = num.tryParse(value?.toString() ?? '0') ?? 0;
    return NumberFormat(
      '#,##,###',
      'en_IN',
    ).format(amount % 1 == 0 ? amount.toInt() : amount);
  }
}
