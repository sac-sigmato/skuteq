import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skuteq_app/components/app_bottom_nav.dart';
import 'package:skuteq_app/components/shared_app_head.dart';
import 'package:skuteq_app/helpers/invoice_pdf_helper.dart';
import 'package:dotted_border/dotted_border.dart';

class InvoiceDetailsPage extends StatelessWidget {
  final Map<String, dynamic> apiResponse;

  const InvoiceDetailsPage({super.key, required this.apiResponse});

  // 🎨 COLORS
  static const Color pageBg = Color(0xFFF6FAFF);
  static const Color cardBorder = Color(0xFFE6EEF6);
  static const Color muted = Color(0xFF9FA8B2);
  static const Color blue = Color(0xFF1E6FD8);
  static const Color paidGreen = Color(0xFF27AE60);

  double _parse(dynamic v) => double.tryParse(v?.toString() ?? '') ?? 0;
  String _money(dynamic v) => "₹ ${_parse(v).toInt()}";

  String _date(String? iso) {
    if (iso == null) return "-";
    final d = DateTime.tryParse(iso);
    if (d == null) return "-";
    return DateFormat("dd MMM yyyy").format(d);
  }

  @override
  Widget build(BuildContext context) {
    final data = apiResponse;
    final List items = data['line_items'] ?? [];
    final List payments = data['payment_details'] ?? [];

    final double invoiceAmount = _parse(data['invoice_amount']);
    final double balanceDue = _parse(data['balance_due']);

    return Scaffold(
      backgroundColor: pageBg,
      appBar: const SharedAppHead(
        title: "Invoice Details",
        showDrawer: false,
        showBack: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        children: [
          // ================= HEADER =================
          _card(
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Invoice #${data['invoice_number']}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await InvoicePdfHelper.openInvoicePdf(
                            context: context,
                            invoiceHeaderId: null,
                          );
                        },
                        child: Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFEAF4FF,
                            ), // ✅ light blue fill (SS)
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.download,
                                size: 18,
                                color: Colors.black, // ✅ dark navy
                              ),
                              SizedBox(width: 6),
                              Text(
                                "PDF",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
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
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFE6EEF6),
                ),

                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['invoice_name'] ?? '-',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _date(data['invoice_date']),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _money(invoiceAmount),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: balanceDue == 0
                                  ? paidGreen
                                  : Colors.orange,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  balanceDue == 0
                                      ? Icons.check_circle
                                      : Icons.schedule, // ⏳ pending
                                  size: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  balanceDue == 0 ? "Paid" : "Pending",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ================= ITEMS =================
          _section(
            title: "Items",
            noInnerPadding: true, // 🔥 critical
            child: Column(
              children: [
                // title with padding
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Items",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: blue,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // FULL-WIDTH solid divider
                _solidDivider(),

                // header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: _tableHeader(),
                ),

                // FULL-WIDTH dotted divider
                _dottedDivider(),

                // rows
                ...List.generate(items.length, (index) {
                  final it = items[index];
                  final isLast = index == items.length - 1;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: _itemRow(it),
                      ),
                      if (!isLast) _dottedDivider(),
                    ],
                  );
                }),

                // FULL-WIDTH solid divider before totals
                _solidDivider(),

                // totals
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      _summary("Invoice Total", _money(invoiceAmount)),
                      _summary("Balance Due", _money(balanceDue)),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ================= PAYMENTS =================
          _section(
            title: "Payments",
            icon: Icons.receipt_long,
            child: payments.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: Text("-", style: TextStyle(color: muted)),
                  )
                : Column(children: payments.map(_paymentRow).toList()),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  // ================= WIDGETS =================

  Widget _card(Widget child) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: cardBorder),
    ),
    child: child,
  );

  Widget _edgeToEdgeDivider({bool dotted = false}) {
    return Transform.translate(
      offset: const Offset(-12, 0), // cancels section padding visually
      child: SizedBox(
        width: MediaQueryData.fromWindow(
          WidgetsBinding.instance.window,
        ).size.width,
        child: dotted
            ? DottedBorder(
                color: const Color(0xFFD6E6FA),
                strokeWidth: 1,
                dashPattern: const [3, 4],
                padding: EdgeInsets.zero,
                child: const SizedBox(height: 0),
              )
            : const Divider(height: 1, thickness: 1, color: Color(0xFFE6EEF6)),
      ),
    );
  }

  Widget _solidDivider() {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFE6EEF6));
  }

  Widget _dottedDivider() {
    return DottedBorder(
      color: const Color(0xFFD6E6FA),
      strokeWidth: 1,
      dashPattern: const [3, 4],
      padding: EdgeInsets.zero,
      child: const SizedBox(width: double.infinity, height: 0),
    );
  }

  Widget _section({
    required String title,
    required Widget child,
    IconData? icon,
    bool noInnerPadding = false,
  }) {
    return Container(
      padding: noInnerPadding ? EdgeInsets.zero : const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!noInnerPadding)
            Row(
              children: [
                if (icon != null) Icon(icon, color: blue, size: 18),
                if (icon != null) const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: blue,
                  ),
                ),
              ],
            ),

          if (!noInnerPadding) const SizedBox(height: 12),

          child,
        ],
      ),
    );
  }

  Widget _tableHeader() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            "Item",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "Qty",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "Charge",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "Total",
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _itemRow(dynamic it) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              it['line_item'] ?? '-',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Text(
              it['issue_quantity']?.toString() ?? '1',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _money(it['total_line_amount']),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _money(it['total_line_amount']),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summary(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentRow(dynamic p) {
    return DottedBorder(
      color: const Color(0xFFD6E6FA),
      strokeWidth: 1,
      dashPattern: const [4, 4],
      borderType: BorderType.RRect,
      radius: const Radius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Receipt #${p['receipt_number']}",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _date(p['received_date']),
                    style: const TextStyle(
                      fontSize: 13,
                      color: muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              _money(p['line_amount_received']),
              style: const TextStyle(
                
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
            
            ),
          ],
        ),
      ),
    );
  }
}
