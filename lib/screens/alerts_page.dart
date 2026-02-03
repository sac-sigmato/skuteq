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

  // TODO: replace these with real values from dashboard/session
  final String studentId = "682d99cb3d289d109e9b564b";
  final String branchId = "6662dc0b43a130a8011cf306";

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

      setState(() {
        _alerts = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }


  // 🎨 Colors (unchanged)
  static const Color _pageBg = Color(0xFFEAF4FF);
  static const Color _cardBorder = Color(0xFFE7EFF7);
  static const Color _muted = Color(0xFF9FA8B2);
  static const Color _iconBg = Color(0xFFEFF6FF);

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
                ? const Center(child: CircularProgressIndicator())
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

  /// 🔹 Single Alert Card (same UI)
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
