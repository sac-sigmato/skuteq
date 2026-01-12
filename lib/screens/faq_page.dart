import 'package:flutter/material.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  // 🔹 JSON-based FAQ data (replace later with API)
  final List<Map<String, dynamic>> _faqData = [
    {
      "question": "How do I pay my child’s fees?",
      "answer":
          "Go to Fees tab in the bottom navigation, select Pending Invoice and use Pay Now to complete payment securely.",
    },
    {
      "question": "Where can I see homework status?",
      "answer":
          "Open Homework tab. Use filters for Upcoming, Ongoing, Completed to track submissions and due dates.",
    },
    {
      "question": "How to update parent profile?",
      "answer":
          "Open the side menu, tap Profile to edit name, photo, email and contact details, then Save.",
    },
  ];

  int _expandedIndex = -1;

  // Colors
  static const Color _pageBg = Color(0xFFF6FAFF);
  static const Color _headerBg = Color(0xFFEAF4FF);
  static const Color _cardBorder = Color(0xFFE7EFF7);
  static const Color _titleBlue = Color(0xFF244A6A);
  static const Color _muted = Color(0xFF9FA8B2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      body: Column(
        children: [
          Container(height: 20),
          /// 🔹 HEADER INSIDE BODY
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
                      icon: const Icon(Icons.chevron_left, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    const Text(
                      'FAQs',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
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

          /// 🔹 GAP BELOW HEADER
          Container(height: 14),

          /// 🔹 PAGE CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  /// Search Bar
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.search, color: _muted),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Search FAQs",
                            style: TextStyle(color: _muted, fontSize: 14, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// FAQ LIST CARD
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      
                      children: List.generate(
                        _faqData.length,
                        (index) => _faqTile(index),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 FAQ Tile
  Widget _faqTile(int index) {
    final item = _faqData[index];
    final bool expanded = _expandedIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _expandedIndex = expanded ? -1 : index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _cardBorder),
                    ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Question Row
            Row(
              children: [
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.black54,
                ),
                Expanded(
                  child: Text(
                    item['question'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                
              ],
            ),

            /// Answer
            if (expanded) ...[
              const SizedBox(height: 8),
              Text(
                item['answer'],
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7C93),
                  height: 1.4,
                  fontWeight: FontWeight.w900
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
