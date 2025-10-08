import 'package:flutter/material.dart';
import 'dart:convert';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  // Dummy JSON data structure for the invoice
  final String sampleJsonData = '''
  {
    "student_name": "Janhvi K",
    "record_id": "STDB1VVPV0579",
    "invoice_amount": 14500.00,
    "invoice_date": "Sep 01, 2025",
    "added_date": "Sep 01, 2025 8:22 AM",
    "invoice_number": "INV2599",
    "invoice_name": "3times - Term 3",
    "academic_year": "Jan 25 - Dec 25",
    "financial_year": "FY 2025-2026",
    "invoice_total": 14500.00,
    "balance_due": 10500.00,
    "items": [
      {
        "item_name": "Tution Fee",
        "quantity": 1,
        "charge": 5000.00,
        "total": 5000.00
      },
      {
        "item_name": "Fee Sep 18",
        "quantity": 1,
        "charge": 8333.34,
        "total": 8333.34
      },
      {
        "item_name": "Dance Fee",
        "quantity": 1,
        "charge": 1166.66,
        "total": 1166.66
      }
    ]
  }
  ''';

  late Map<String, dynamic> invoiceData;

  @override
  void initState() {
    super.initState();
    // Decode the JSON data
    invoiceData = json.decode(sampleJsonData);
  }

  // Helper to format currency
  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Custom AppBar/Header with back and download buttons
          _buildSliverAppBar(context),

          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Invoice Title
                    const Text(
                      'Invoice',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Static Invoice Details
                    _buildDetailSection(),
                    const SizedBox(height: 20),

                    // Items Table
                    _buildItemsTable(),
                    const SizedBox(height: 10),

                    // Invoice Total and Balance Due
                    _buildSummarySection(),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ]),
          ),
        ],
      ),
    );
  }

  // Header with back button and download icon
  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      toolbarHeight: 56.0,
      backgroundColor: Colors.blue[700],
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.download, color: Colors.white),
          onPressed: () {
            // Handle download action
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // Section for static key-value details
  Widget _buildDetailSection() {
    return Column(
      children: [
        _buildDetailRow('Student Name', invoiceData['student_name']),
        _buildDetailRow('Record ID', invoiceData['record_id']),
        _buildDetailRow(
          'Invoice Amount',
          _formatCurrency(invoiceData['invoice_amount']),
          isBoldValue: true,
        ),
        _buildDetailRow('Invoice Date', invoiceData['invoice_date']),
        _buildDetailRow('Added Date', invoiceData['added_date']),
        _buildDetailRow('Invoice #', invoiceData['invoice_number']),
        _buildDetailRow('Invoice Name', invoiceData['invoice_name']),
        _buildDetailRow('Academic Year', invoiceData['academic_year']),
        _buildDetailRow('Financial Year', invoiceData['financial_year']),
      ],
    );
  }

  // Helper widget for detail rows
  Widget _buildDetailRow(
    String label,
    String value, {
    bool isBoldValue = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label (left column)
          SizedBox(
            width:
                MediaQuery.of(context).size.width / 2 -
                16, // Approximately half the screen
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
          // Value (right column)
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isBoldValue ? FontWeight.bold : FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section for the tabular items list
  Widget _buildItemsTable() {
    List<dynamic> items = invoiceData['items'];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          // Table Header
          _buildTableHeader(),

          // Table Rows
          ...items.asMap().entries.map((entry) {
            bool isLast = entry.key == items.length - 1;
            return _buildTableRow(entry.value, isLast: isLast);
          }).toList(),
        ],
      ),
    );
  }

  // Table Header widget
  Widget _buildTableHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[600],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _TableHeaderCell(title: 'Items', flex: 4),
            _TableHeaderCell(title: 'Quantity', flex: 2),
            _TableHeaderCell(title: 'Charge', flex: 3),
            _TableHeaderCell(title: 'Total', flex: 3, isLast: true),
          ],
        ),
      ),
    );
  }

  // Helper widget for Table Header Cells
  Widget _TableHeaderCell({
    required String title,
    required int flex,
    bool isLast = false,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  right: BorderSide(color: Colors.blue.shade400!, width: 1),
                ),
        ),
        child: Text(
          title,
          textAlign: flex == 4 ? TextAlign.left : TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // Single Table Row
  Widget _buildTableRow(Map<String, dynamic> item, {required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        children: [
          _TableRowCell(
            text: item['item_name'],
            flex: 4,
            alignment: TextAlign.left,
            isLastRow: isLast,
          ),
          _TableRowCell(
            text: item['quantity'].toString(),
            flex: 2,
            isLastRow: isLast,
          ),
          _TableRowCell(
            text: _formatCurrency(item['charge']),
            flex: 3,
            isLastRow: isLast,
          ),
          _TableRowCell(
            text: _formatCurrency(item['total']),
            flex: 3,
            isLastRow: isLast,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  // Helper widget for Table Row Cells
  Widget _TableRowCell({
    required String text,
    required int flex,
    required bool isLastRow,
    TextAlign alignment = TextAlign.center,
    bool isTotal = false,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.grey.shade300, width: 1),
            bottom: isLastRow
                ? BorderSide.none
                : BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: Text(
          text,
          textAlign: alignment,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isTotal ? FontWeight.w500 : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  // Invoice Total and Balance Due Summary
  Widget _buildSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Invoice Total
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Invoice Total:',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(width: 8),
              Text(
                _formatCurrency(invoiceData['invoice_total']),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        // Balance Due
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Balance Due:',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(width: 8),
              Text(
                _formatCurrency(invoiceData['balance_due']),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
