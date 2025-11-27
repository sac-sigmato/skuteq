// lib/screens/invoices_page.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'invoice_details_page.dart'; // ensure correct relative path

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  int _selectedTab = 0; // 0 = Outstanding, 1 = Paid

  static const Color _bg = Color(0xFFF5F8FB);
  static const Color _cardBorder = Color(0xFFE7EFF7);
  static const Color _titleBlue = Color(0xFF244A6A);
  static const Color _pillBg = Color(0xFFEFF7FF);
  static const Color _muted = Color(0xFF9FA8B2);

  // sample lists (replace with your backend data)
  final List<Map<String, dynamic>> _outstanding = [
    {
      'title': 'Activity Fee - Q3',
      'invoice': 'INV-2098',
      'amount': '₹ 900',
      'status': 'Unpaid',
      // you can include items/payments here to send to details page immediately
      'items': [
        {'item': 'Activity Fee', 'qty': 1, 'charge': 900, 'total': 900},
      ],
    },
    {
      'title': 'Library Fine',
      'invoice': 'INV-2103',
      'amount': '₹ 150',
      'status': 'Partially paid',
      'items': [
        {'item': 'Fine', 'qty': 1, 'charge': 150, 'total': 150},
      ],
    },
  ];

  final List<Map<String, dynamic>> _paid = [
    {
      'title': 'Tuition Fee - Q2',
      'invoice': 'INV-2060',
      'amount': '₹ 12,000',
      'status': 'Paid',
      'items': [
        {'item': 'Tuition', 'qty': 1, 'charge': 12000, 'total': 12000},
      ],
      'payments': [
        {'receipt': 'RCT-1001', 'date': '05 Sep 2025', 'amount': 12000},
      ],
    },
    {
      'title': 'Transport Fee - May',
      'invoice': 'INV-2074',
      'amount': '₹ 1,200',
      'status': 'Paid',
      'items': [
        {'item': 'Transport', 'qty': 1, 'charge': 1200, 'total': 1200},
      ],
      'payments': [
        {'receipt': 'RCT-1002', 'date': '10 May 2025', 'amount': 1200},
      ],
    },
  ];

  double _parseAmount(dynamic raw) {
    if (raw == null) return 0.0;
    if (raw is num) return raw.toDouble();
    if (raw is String) {
      final cleaned = raw.replaceAll(RegExp(r'[^\d.]'), '');
      return double.tryParse(cleaned) ?? 0.0;
    }
    return 0.0;
  }

  String _formatAmount(dynamic raw) {
    final val = _parseAmount(raw);
    if (val % 1 == 0) return '₹ ${val.toInt()}';
    return '₹ ${val.toStringAsFixed(2)}';
  }

  double get _outstandingTotal {
    double total = 0;
    for (var it in _outstanding) {
      total += _parseAmount(it['amount']);
    }
    return total;
  }

  /// robust id extractor (keeps compatibility with different backends)
  String _getInvoiceId(Map<String, dynamic> item) {
    final candidates = [
      item['invoice'],
      item['invoiceNo'],
      item['invoice_number'],
      item['id'],
      item['invoice_id'],
    ];
    for (var c in candidates) {
      if (c == null) continue;
      final s = c.toString().trim();
      if (s.isNotEmpty) return s;
    }
    return '';
  }

  void _onInvoiceTap(Map<String, dynamic> item) {
    // Always navigate and pass full item map to details page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => InvoiceDetailsPage(invoiceData: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _selectedTab == 0 ? _outstanding : _paid;

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
          'Invoices',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // pill tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: _cardBorder),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = 0),
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: _selectedTab == 0
                                ? _pillBg
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Outstanding',
                            style: TextStyle(
                              color: _selectedTab == 0
                                  ? Colors.black87
                                  : Colors.black45,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = 1),
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: _selectedTab == 1
                                ? _pillBg
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Paid',
                            style: TextStyle(
                              color: _selectedTab == 1
                                  ? Colors.black87
                                  : Colors.black45,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // list (footer included inside list when Outstanding selected)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 6, bottom: 16),
                  itemCount: items.length + (_selectedTab == 0 ? 1 : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    if (_selectedTab == 0 && index == items.length)
                      return _totalFooter();
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

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _totalFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Total outstanding amount',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
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
    final status = (item['status'] ?? item['payment_status'] ?? '').toString();
    Color badgeBg;
    Color badgeTextColor = Colors.white;

    if (status.toLowerCase() == 'paid') {
      badgeBg = const Color(0xFF2ECC71);
    } else if (status.toLowerCase().contains('part')) {
      badgeBg = const Color(0xFFF1C40F);
      badgeTextColor = Colors.black87;
    } else {
      badgeBg = const Color(0xFFF39C12);
    }

    final leftIconAsset = (status.toLowerCase() == 'paid')
        ? 'assets/images/paid.png'
        : 'assets/images/unpaid.png';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF7FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _cardBorder),
            ),
            child: Center(
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationZ(-math.pi / 30),
                child: Image.asset(
                  leftIconAsset,
                  width: 44,
                  height: 44,
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, err, st) => const Icon(
                    Icons.receipt_long,
                    color: Color(0xFF2B6F9E),
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] ?? item['name'] ?? '',
                  style: const TextStyle(
                    color: _titleBlue,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Invoice #${_getInvoiceId(item)}',
                  style: const TextStyle(
                    color: Color(0xFF9FA8B2),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatAmount(
                  item['amount'] ??
                      item['invoice_total'] ??
                      item['invoice_amount'] ??
                      0,
                ),
                style: const TextStyle(
                  color: Colors.black87,
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
                  item['status'] ?? status ?? '',
                  style: TextStyle(
                    color: badgeTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
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
