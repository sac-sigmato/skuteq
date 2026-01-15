import 'package:flutter/material.dart';
import 'package:skuteq_app/components/app_bottom_nav.dart';
import 'package:skuteq_app/components/shared_app_head.dart';
import 'package:skuteq_app/services/invoice_service.dart';
import 'dart:math' as math;
import '../helpers/invoice_storage.dart';
import 'invoice_details_page.dart';

class InvoicesPage extends StatefulWidget {
  final List<dynamic> invoices;

  const InvoicesPage({super.key, required this.invoices});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  late AnimationController _controller;
  Animation<double> _pillAnimation = const AlwaysStoppedAnimation(3.0);

  double _pillLeft = 3.0; // 🔥 remembers last position

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    _pillAnimation = AlwaysStoppedAnimation(_pillLeft);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ---------------- COLORS ----------------
  static const Color bg = Color(0xFFF6FAFF);
  static const Color pageBg = Color(0xFFEAF4FF);
  static const Color cardBorder = Color(0xFFE6EEF6);
  static const Color titleBlue = Color(0xFF244A6A);
  static const Color pillBg = Color(0xFFEFF7FF);
  static const Color muted = Color(0xFF9FA8B2);

  // ================= DATA =================

  List<Map<String, dynamic>> get _outstanding => widget.invoices
      .where((e) => (e['status'] ?? '').toString().toLowerCase() != 'paid')
      .map((e) => Map<String, dynamic>.from(e))
      .toList();

  List<Map<String, dynamic>> get _paid => widget.invoices
      .where((e) => (e['status'] ?? '').toString().toLowerCase() == 'paid')
      .map((e) => Map<String, dynamic>.from(e))
      .toList();

  double _parseAmount(dynamic raw) {
    if (raw is num) return raw.toDouble();
    if (raw is String) {
      return double.tryParse(raw.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
    }
    return 0;
  }

  String _formatAmount(dynamic raw) {
    final v = _parseAmount(raw);
    return '₹ ${v.toStringAsFixed(0)}';
  }

  double get _outstandingTotal {
    double total = 0;
    for (var it in _outstanding) {
      total += _parseAmount(it['due_amount']);
    }
    return total;
  }

  String _getInvoiceId(Map<String, dynamic> item) =>
      item['invoice_number'] ?? '-';

  String _getTitle(Map<String, dynamic> item) =>
      item['invoice_name'] ?? 'Invoice';

  void _onInvoiceTap(Map<String, dynamic> item) async {
    try {
      final invoiceHeaderId = item['invoice_header_id'];

      if (invoiceHeaderId == null) {
        throw Exception("Invoice header id missing");
      }
      InvoiceStorage.saveInvoiceHeaderId(invoiceHeaderId);
      final invoiceService = InvoiceService();

      // 🔄 SHOW LOADER
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final invoiceDetailsResponse = await invoiceService.fetchInvoiceDetails(
        invoiceHeaderId: invoiceHeaderId.toString(),
      );

      // ❌ CLOSE LOADER
      Navigator.pop(context);

      // ➡️ NAVIGATE WITH FULL API RESPONSE
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              InvoiceDetailsPage(apiResponse: invoiceDetailsResponse),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      debugPrint("❌ Invoice details error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load invoice details")),
      );
    }
  }

  Widget _animatedToggle() {
    final totalWidth = MediaQuery.of(context).size.width - 32;
    final pillWidth = (totalWidth - 6) / 2;

    return Container(
      height: 44,
      width: totalWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorder),
      ),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _pillAnimation,
            builder: (_, __) {
              return Positioned(
                left: _pillAnimation.value,
                top: 3,
                child: Container(
                  width: pillWidth,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF7FF),
                    borderRadius: BorderRadius.circular(19),
                  ),
                ),
              );
            },
          ),

          Row(
            children: [
              _toggleItem("Outstanding", 0, pillWidth),
              _toggleItem("Paid", 1, pillWidth),
            ],
          ),
        ],
      ),
    );
  }

  Widget _toggleItem(String title, int index, double pillWidth) {
    final active = _selectedTab == index;

    return SizedBox(
      width: pillWidth,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (_selectedTab == index) return;

          // 🔥 CALCULATE FROM & TO EXPLICITLY
          final double fromLeft = _selectedTab == 0 ? 3.0 : pillWidth + 3;
          final double toLeft = index == 0 ? 3.0 : pillWidth + 3;

          _pillAnimation = Tween<double>(begin: fromLeft, end: toLeft).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
          );

          // 🚀 START ANIMATION FIRST
          _controller.forward(from: 0);

          // 🔁 UPDATE STATE AFTER
          setState(() {
            _selectedTab = index;
            _pillLeft = toLeft; // persist
          });
        },
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: active ? const Color(0xFF244A6A) : Colors.black45,
            ),
            child: Text(title),
          ),
        ),
      ),
    );
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    final items = _selectedTab == 0 ? _outstanding : _paid;

    return Scaffold(
      backgroundColor: pageBg,
      appBar: SharedAppHead(
        title: "Invoices",
        showDrawer: false,
        showBack: true,
      ),
      body: Column(
        children: [
          Container(height: 14, color: pageBg),

          // 🔹 TABS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _animatedToggle(),
          ),

          const SizedBox(height: 12),

          // 🔹 LIST
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: items.isEmpty
                  ? const Center(child: Text("No invoices found"))
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: items.length + (_selectedTab == 0 ? 1 : 0),
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        if (_selectedTab == 0 && index == items.length) {
                          return _totalFooter();
                        }
                        final item = items[index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _onInvoiceTap(item),
                          child: _invoiceCard(item),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  // ================= WIDGETS =================

  Widget _pillTab(String title, int index) {
    final active = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: active ? pillBg : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: active ? Colors.black87 : Colors.black45,
            ),
          ),
        ),
      ),
    );
  }

  Widget _totalFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "Total outstanding amount",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            _formatAmount(_outstandingTotal),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _invoiceCard(Map<String, dynamic> item) {
    final status = (item['status'] ?? '').toString().toLowerCase();

    Color badgeBg;
    Color badgeText = Colors.white;

    if (status == 'paid') {
      badgeBg = const Color(0xFF2ECC71);
    } else if (status.contains('part')) {
      badgeBg = const Color(0xFFFFD54F);
      badgeText = Colors.black;
    } else {
      badgeBg = const Color(0xFFF39C12);
      badgeText = Colors.black;
    }

    final iconAsset = status == 'paid'
        ? 'assets/images/paid.png'
        : 'assets/images/unpaid.png';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: Transform.rotate(
              angle: -math.pi / 180,
              child: Image.asset(
                iconAsset,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.receipt_long),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTitle(item),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: titleBlue,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Invoice #${_getInvoiceId(item)}",
                  style: const TextStyle(fontSize: 12, color: muted),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatAmount(item['invoice_total']),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item['status'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: badgeText,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
