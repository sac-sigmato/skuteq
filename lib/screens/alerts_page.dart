import 'package:flutter/material.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  /// 🔹 JSON-based alerts (replace later with API response)
  static final List<Map<String, String>> _alerts = [
    {
      "title": "Invoice Generated",
      "message": "April Tuition invoice INV-2045 is now available.",
      "time": "Today • 9:20 AM",
      "icon": "invoice",
    },
    {
      "title": "Payment Received",
      "message": "₹8,500 received for INV-2038. Thank you!",
      "time": "Yesterday • 4:05 PM",
      "icon": "payment",
    },
    {
      "title": "Marked Absent",
      "message": "Aarav was marked absent on 12 Apr 2025.",
      "time": "2 days ago • 8:15 AM",
      "icon": "absent",
    },
    {
      "title": "Academic Records Added",
      "message": "Term 1 English scores have been published.",
      "time": "3 days ago • 6:40 PM",
      "icon": "academic",
    },
    {
      "title": "Marked Absent",
      "message": "Late entry recorded. Attendance updated to half-day.",
      "time": "Last week • 10:05 AM",
      "icon": "absent",
    },
    {
      "title": "Invoice Generated",
      "message": "Transport fee invoice TR-554 issued.",
      "time": "Last week • 9:10 AM",
      "icon": "invoice",
    },
  ];

  // 🎨 Colors matching SS
  static const Color _pageBg = Color(0xFFF6FAFF);
  static const Color _headerBg = Color(0xFFEAF4FF);
  static const Color _cardBorder = Color(0xFFE7EFF7);
  static const Color _titleBlue = Color(0xFF244A6A);
  static const Color _muted = Color(0xFF9FA8B2);
  static const Color _iconBg = Color(0xFFEFF6FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      body: Column(
        children: [
          Container(height: 20),
          /// 🔹 HEADER INSIDE BODY (as per SS)
          /// 
          Container(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                      color:  Colors.black,
                    ),
                    const Spacer(),
                    const Text(
                      "Alerts",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),

          /// 🔹 TOP GAP BELOW HEADER
          Container(height: 14),

          /// 🔹 ALERTS LIST
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: _alerts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final alert = _alerts[index];
                return _alertCard(alert);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Single Alert Card
  Widget _alertCard(Map<String, String> alert) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _iconBg,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: _cardBorder),
            ),
            child: Icon(_iconFor(alert['icon']), size: 20, color:  Colors.black),
          ),

          const SizedBox(width: 12),

          /// Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color:  Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert['message'] ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  alert['time'] ?? '',
                  style: const TextStyle(
                    fontSize: 11,
                    color: _muted,
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

  /// 🔹 Icon mapper
  IconData _iconFor(String? type) {
    switch (type) {
      case 'invoice':
        return Icons.receipt_long;
      case 'payment':
        return Icons.check_circle_outline;
      case 'absent':
        return Icons.person_off_outlined;
      case 'academic':
        return Icons.menu_book_outlined;
      default:
        return Icons.notifications_none;
    }
  }
}
