import 'package:flutter/material.dart';

class FeesPage extends StatelessWidget {
  const FeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Fees & Payments',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            onPressed: () => _viewPaymentHistory(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fee Summary Card
            _buildFeeSummaryCard(),

            const SizedBox(height: 24),

            // Due Date Alert
            _buildDueDateAlert(),

            const SizedBox(height: 24),

            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildQuickActions(),

            const SizedBox(height: 24),

            // Fee Breakdown
            const Text(
              'Fee Breakdown',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildFeeBreakdown(),

            const SizedBox(height: 24),

            // Recent Payments
            const Text(
              'Recent Payments',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildRecentPayments(),

            const SizedBox(height: 32),
          ],
        ),
      ),
      // Pay Now Button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _payNow(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF106EB4),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.payment, size: 20),
                SizedBox(width: 8),
                Text(
                  'Pay Now - ₹15,000',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeeSummaryCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Circular Progress
            Row(
              children: [
                // Circular Progress Bar
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 10,
                        backgroundColor: const Color(0xFFFFE0E0),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFF7C71C),
                        ),
                      ),
                    ),
                    // Progress circle
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: 0.75,
                        strokeWidth: 10,
                        backgroundColor: Colors.transparent,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF106EB4),
                        ),
                      ),
                    ),
                    // Percentage text
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "75%",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Text(
                          "Paid",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(width: 20),

                // Amount Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Paid Amount
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "₹30,000",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF106EB4),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Paid (75%)",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Due Amount
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "₹15,000",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF7C71C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Due (25%)",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Total Amount
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Amount",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "₹45,000",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Academic Year",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "2024-25",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF106EB4),
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
    );
  }

  Widget _buildDueDateAlert() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFEEBA)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber, color: Colors.orange.shade800, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Due Soon',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Next due date: Apr 15, 2025',
                  style: TextStyle(fontSize: 14, color: Colors.orange.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return const Row(
      children: [
        Expanded(
          child: QuickActionCard(
            icon: Icons.receipt,
            title: 'View Invoice',
            color: Colors.blue,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: QuickActionCard(
            icon: Icons.download,
            title: 'Download Receipt',
            color: Colors.green,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: QuickActionCard(
            icon: Icons.history,
            title: 'Payment History',
            color: Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildFeeBreakdown() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFeeItem(
              title: 'Tuition Fee',
              amount: '₹25,000',
              status: 'Paid',
              isPaid: true,
            ),
            const Divider(),
            _buildFeeItem(
              title: 'Laboratory Fee',
              amount: '₹8,000',
              status: 'Partially Paid',
              isPaid: false,
            ),
            const Divider(),
            _buildFeeItem(
              title: 'Library Fee',
              amount: '₹3,000',
              status: 'Paid',
              isPaid: true,
            ),
            const Divider(),
            _buildFeeItem(
              title: 'Sports Fee',
              amount: '₹4,000',
              status: 'Due',
              isPaid: false,
            ),
            const Divider(),
            _buildFeeItem(
              title: 'Development Fee',
              amount: '₹5,000',
              status: 'Due',
              isPaid: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeItem({
    required String title,
    required String amount,
    required String status,
    required bool isPaid,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isPaid
                        ? Colors.green.shade50
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isPaid
                          ? Colors.green.shade200
                          : Colors.orange.shade200,
                    ),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      color: isPaid
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isPaid ? Colors.green.shade700 : Colors.orange.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPayments() {
    return Column(
      children: [
        PaymentHistoryItem(
          date: '15 Mar 2025',
          amount: '₹15,000',
          type: 'Tuition Fee',
          status: 'Completed',
          isSuccess: true,
        ),
        PaymentHistoryItem(
          date: '28 Feb 2025',
          amount: '₹8,000',
          type: 'Lab & Library',
          status: 'Completed',
          isSuccess: true,
        ),
        PaymentHistoryItem(
          date: '15 Jan 2025',
          amount: '₹7,000',
          type: 'Tuition Fee',
          status: 'Completed',
          isSuccess: true,
        ),
      ],
    );
  }

  void _payNow(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pay Fees',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Due Amount: ₹15,000',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildPaymentMethod(
              icon: Icons.credit_card,
              title: 'Credit/Debit Card',
              isSelected: true,
            ),
            _buildPaymentMethod(
              icon: Icons.account_balance,
              title: 'Net Banking',
              isSelected: false,
            ),
            _buildPaymentMethod(
              icon: Icons.wallet,
              title: 'UPI Payment',
              isSelected: false,
            ),
            _buildPaymentMethod(
              icon: Icons.pix,
              title: 'Digital Wallet',
              isSelected: false,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _processPayment(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF106EB4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Proceed to Pay ₹15,000',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod({
    required IconData icon,
    required String title,
    required bool isSelected,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected ? Colors.blue.shade50 : Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Colors.blue)
            : const Icon(Icons.radio_button_unchecked),
        onTap: () {},
      ),
    );
  }

  void _processPayment(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Processing payment...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _viewPaymentHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaymentHistoryPage()),
    );
  }
}

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          switch (title) {
            case 'View Invoice':
              _viewInvoice(context);
              break;
            case 'Download Receipt':
              _downloadReceipt(context);
              break;
            case 'Payment History':
              _viewPaymentHistory(context);
              break;
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _viewInvoice(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Opening invoice...')));
  }

  void _downloadReceipt(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Downloading receipt...')));
  }

  void _viewPaymentHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaymentHistoryPage()),
    );
  }
}

class PaymentHistoryItem extends StatelessWidget {
  final String date;
  final String amount;
  final String type;
  final String status;
  final bool isSuccess;

  const PaymentHistoryItem({
    super.key,
    required this.date,
    required this.amount,
    required this.type,
    required this.status,
    required this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isSuccess ? Colors.green.shade50 : Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isSuccess ? Icons.check_circle : Icons.pending,
            color: isSuccess ? Colors.green : Colors.orange,
          ),
        ),
        title: Text(
          type,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          date,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSuccess ? Colors.green.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 10,
                  color: isSuccess
                      ? Colors.green.shade700
                      : Colors.orange.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        onTap: () => _viewPaymentDetails(context),
      ),
    );
  }

  void _viewPaymentDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Date', date),
            _buildDetailRow('Type', type),
            _buildDetailRow('Amount', amount),
            _buildDetailRow('Status', status),
            _buildDetailRow(
              'Transaction ID',
              'TXN${DateTime.now().millisecondsSinceEpoch}',
            ),
            _buildDetailRow('Payment Method', 'Credit Card'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => _downloadReceipt(context),
            child: const Text('Download Receipt'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }

  void _downloadReceipt(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Downloading receipt...')));
  }
}

class PaymentHistoryPage extends StatelessWidget {
  const PaymentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment History',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          PaymentHistoryItem(
            date: '15 Mar 2025',
            amount: '₹15,000',
            type: 'Tuition Fee - Q4',
            status: 'Completed',
            isSuccess: true,
          ),
          PaymentHistoryItem(
            date: '28 Feb 2025',
            amount: '₹8,000',
            type: 'Lab & Library Fees',
            status: 'Completed',
            isSuccess: true,
          ),
          PaymentHistoryItem(
            date: '15 Jan 2025',
            amount: '₹7,000',
            type: 'Tuition Fee - Q3',
            status: 'Completed',
            isSuccess: true,
          ),
          PaymentHistoryItem(
            date: '15 Dec 2024',
            amount: '₹15,000',
            type: 'Tuition Fee - Q2',
            status: 'Completed',
            isSuccess: true,
          ),
          PaymentHistoryItem(
            date: '30 Nov 2024',
            amount: '₹5,000',
            type: 'Sports & Development',
            status: 'Completed',
            isSuccess: true,
          ),
        ],
      ),
    );
  }
}
