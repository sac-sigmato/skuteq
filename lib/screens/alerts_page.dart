import 'package:flutter/material.dart';
import 'package:skuteq_app/components/shared_app_head.dart';
import 'package:skuteq_app/services/alerts_service.dart';
import 'package:skuteq_app/helpers/invoice_storage.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final AlertsService _alertsService = AlertsService();

  bool _loading = true;
  List<AlertItem> _alerts = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    try {
      final studentId = await InvoiceStorage.getStudent_Id();
      final branchId = await InvoiceStorage.getBranchId();

      if (studentId == null || branchId == null) {
        throw Exception("Student or Branch ID not found");
      }

      final data = await _alertsService.fetchStudentAlerts(
        studentId: studentId,
        branchId: branchId,
      );

      if (!mounted) return;

      setState(() {
        _alerts = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  // 🎨 Colors (unchanged)
  static const Color _pageBg = Color(0xFFF6FAFF);
  static const Color _cardBorder = Color(0xFFE7EFF7);
  static const Color _muted = Color(0xFF9FA8B2);
  static const Color _iconBg = Color(0xFFEFF6FF);
  static const Color _skeleton = Color(0xFFE9EEF5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      appBar: SharedAppHead(title: "Alerts", showDrawer: false, showBack: true),
      body: Column(
        children: [
          const SizedBox(height: 14),
          Expanded(
            child: _loading
                ? _skeletonList()
                : _error != null
                ? Center(
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : _alerts.isEmpty
                ? const Center(
                    child: Text(
                      "No alerts available",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: _alerts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _alertCard(_alerts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ---------------- SKELETON ----------------

  Widget _skeletonList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => _skeletonCard(),
    );
  }

  Widget _skeletonCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon skeleton
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _skeleton,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          const SizedBox(width: 12),

          // Text skeletons
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _skeletonLine(width: double.infinity, height: 14),
                const SizedBox(height: 6),
                _skeletonLine(width: double.infinity, height: 12),
                const SizedBox(height: 6),
                _skeletonLine(width: 80, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _skeletonLine({double width = 100, double height = 12}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: _skeleton,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  // ---------------- REAL ALERT CARD ----------------

  Widget _alertCard(AlertItem alert) {
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _iconBg,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: _cardBorder),
            ),
            child: Icon(_iconFor(alert.type), size: 20, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert.message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  alert.time,
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

  IconData _iconFor(String type) {
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
