import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skuteq_app/components/app_bottom_nav.dart';
import 'package:skuteq_app/components/shared_app_head.dart';
import 'package:skuteq_app/helpers/invoice_pdf_helper.dart';

class InvoiceDetailsPage extends StatelessWidget {
  final Map<String, dynamic> apiResponse;

  InvoiceDetailsPage({super.key, required this.apiResponse});

  // ---------------- COLORS ----------------
   static const Color pageBg = Color(0xFFF6FAFF);
  static const Color cardBorder = Color(0xFFE6EEF6);
  static const Color muted = Color(0xFF9FA8B2);
  static const Color blue = Color(0xFF2E9EE6);
  static const Color paidGreen = Color(0xFF2ECC71);
  
  String? get invoiceHeaderId => null;

  // ---------------- HELPERS ----------------
  double _parse(dynamic v) => double.tryParse(v?.toString() ?? '') ?? 0;

  String _money(dynamic v) => "₹ ${_parse(v).toInt()}";

  String _date(String? iso) {
    if (iso == null) return "-";
    final d = DateTime.tryParse(iso);
    if (d == null) return "-";
    return DateFormat("dd MMM yyyy").format(d);
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    final data = apiResponse;

    final List items = data['line_items'] ?? [];
    final List payments = data['payment_details'] ?? [];

    final double invoiceAmount = _parse(data['invoice_amount']);
    final double balanceDue = _parse(data['balance_due']);

    return Scaffold(
      backgroundColor: pageBg,
      appBar: SharedAppHead(
        title: "Invoice Details",
        showDrawer: false,
        showBack: true,
      ),
      body: Column(
        children: [
          

          Container(height: 14, color: pageBg),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              children: [
                // ================= HEADER CARD =================
                _card(
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Invoice #${data['invoice_number']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () async {
                                await InvoicePdfHelper.openInvoicePdf(
                                  context: context,
                                  invoiceHeaderId:invoiceHeaderId, // optional (if you have it)
                                );
                              },
                              icon: const Icon(Icons.download, size: 16),
                              label: const Text("PDF"),
                            )

                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['invoice_name'] ?? '-',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _date(data['invoice_date']),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: muted,
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
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: balanceDue == 0
                                        ? paidGreen
                                        : Colors.orange,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    balanceDue == 0 ? "Paid" : "Pending",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
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
                  child: Column(
                    children: [
                      _tableHeader(),
                      ...items.map(_itemRow),
                      const Divider(),
                      _summary("Invoice Total", _money(invoiceAmount)),
                      _summary("Balance Due", _money(balanceDue)),
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
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text("-", style: TextStyle(color: muted)),
                        )
                      : Column(children: payments.map(_paymentRow).toList()),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  // ================= SMALL WIDGETS =================

  Widget _card(Widget child) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: cardBorder),
    ),
    child: child,
  );

  Widget _section({
    required String title,
    required Widget child,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) Icon(icon, color: blue, size: 18),
              if (icon != null) const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _tableHeader() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(flex: 4, child: Text("Item")),
        Expanded(flex: 1, child: Text("Qty", textAlign: TextAlign.center)),
        Expanded(flex: 2, child: Text("Charge", textAlign: TextAlign.center)),
        Expanded(flex: 2, child: Text("Total", textAlign: TextAlign.right)),
      ],
    ),
  );

  Widget _itemRow(dynamic it) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(it['line_item'] ?? '-')),
          Expanded(
            flex: 1,
            child: Text(
              it['issue_quantity']?.toString() ?? '1',
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _money(it['total_line_amount']),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _money(it['total_line_amount']),
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w700),
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
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _paymentRow(dynamic p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Receipt #${p['receipt_number']}",
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  _date(p['received_date']),
                  style: const TextStyle(fontSize: 12, color: muted),
                ),
              ],
            ),
          ),
          Text(
            _money(p['line_amount_received']),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
