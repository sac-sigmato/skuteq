// lib/screens/select_child_page.dart

import 'package:flutter/material.dart';
import 'student_dashboard.dart';

class SelectChildPage extends StatefulWidget {
  const SelectChildPage({super.key});

  @override
  State<SelectChildPage> createState() => _SelectChildPageState();
}

class _SelectChildPageState extends State<SelectChildPage> {
  // Example API/JSON response
  final List<Map<String, dynamic>> childrenData = [
    {
      "name": "Aarav Sharma",
      "school": "VVP Spool - Magadha Campus",
      "image": "assets/images/student1.png",
      "highlight": true,
    },
    {
      "name": "Diya Sharma",
      "school": "VVP School - Magadha Campus",
      "image": "assets/images/student2.png",
      "highlight": false,
    },
    {
      "name": "Kabir Sharma",
      "school": "VVP School - Magadha Campus",
      "image": "assets/images/student3.png",
      "highlight": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Colors used in screenshot
    const Color primaryBlue = Color(0xFF106EB4);
    const Color pageBg = Color(0xFFF6F9FB); // overall light page bg

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Column(
          children: [
            // ---------- FULL WIDTH HEADER (outside inner padding) ----------
            Container(
              width: double.infinity,
              color: Colors
                  .transparent, // leave transparent so header card shadow visible on page bg
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Container(
                // inner white card
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Hamburger (left)
                    InkWell(
                      onTap: () {
                        // open drawer or menu
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Open drawer (implement)'),
                          ),
                        );
                      },
                      customBorder: const CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(
                          Icons.menu,
                          size: 22,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Center title
                    const Text(
                      "Welcome Priya",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    const Spacer(),

                    // Right spacer to keep title centered (same width as left button)
                    const SizedBox(width: 34),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ---------- CONTENT (keeps inner padding) ----------
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    // Subtitle
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Please select your Child",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Child list
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 24),
                        itemCount: childrenData.length,
                        itemBuilder: (context, index) {
                          final child = childrenData[index];
                          return _buildChildCard(
                            name: child["name"],
                            school: child["school"],
                            imagePath: child["image"],
                            highlight: child["highlight"] ?? false,
                            primaryBlue: primaryBlue,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildCard({
    required String name,
    required String school,
    required String imagePath,
    required bool highlight,
    required Color primaryBlue,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with outer ring
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(4), // outer ring width
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: highlight
                  ? LinearGradient(
                      colors: [Colors.orange.shade200, Colors.orange.shade400],
                    )
                  : const LinearGradient(colors: [Colors.white, Colors.white]),
              border: Border.all(
                color: highlight
                    ? Colors.orange.shade400
                    : Colors.grey.shade200,
                width: highlight ? 2.5 : 1.0,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100],
              ),
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.person, size: 36, color: Colors.grey[500]),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Name + school
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  school,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Right arrow circle only (progress removed)
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StudentDashboard(),
                ),
              );
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryBlue.withOpacity(0.18),
                  width: 1.2,
                ),
              ),
              child: Icon(
                Icons.chevron_right_rounded,
                color: primaryBlue,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
