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
      "school": "VVP School - Magadha Campus",
      "image": "assets/images/student1.png",
      "highlight": false,
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
    const Color primaryBlue = Color(0xFF0B2A4A);
    const Color pageBg = Color(0xFFF6F9FB);
    const Color textPrimary = Color(0xFF1A1A1A);
    const Color textSecondary = Color(0xFF666666);

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Column(
          children: [
            // ---------- HEADER SECTION ----------
            // Replace your existing header Container with this
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Left hamburger (tappable)
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        // open drawer or do action
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        Scaffold.of(context).openDrawer(); // or your handler
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        // optional light bg for the icon area
                        // decoration: BoxDecoration(
                        //   color: Colors.grey.shade50,
                        //   borderRadius: BorderRadius.circular(8),
                        // ),
                        child: Icon(
                          Icons.menu_rounded,
                          size: 30,
                          color: textPrimary, // keep using your color variable
                        ),
                      ),
                    ),

                    // Small gap between icon and centered title
                    const SizedBox(width: 8),

                    // Middle: use Expanded with Center so text remains centered between
                    // left icon and an equally sized trailing spacer
                    Expanded(
                      child: Center(
                        child: Text(
                          "Welcome Priya",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ),

                    // Trailing invisible box to balance the left icon so title stays exactly centered
                    SizedBox(width: 40),
                  ],
                ),
              ),
            ),


            // ---------- MAIN CONTENT ----------
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Child list
                    Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: childrenData.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
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

                    const SizedBox(height: 24),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StudentDashboard()),
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: highlight
                  ? primaryBlue.withOpacity(0.2)
                  : Colors.grey[200]!,
              width: highlight ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 16,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Avatar with conditional border
              Container(
                width: 56,
                height: 56,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: highlight ? primaryBlue : Colors.grey[300]!,
                    width: highlight ? 2.5 : 1.5,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[100],
                      child: Icon(
                        Icons.person,
                        size: 24,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.3,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      school,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                        letterSpacing: -0.2,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Arrow indicator
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color:  Color(0xFFEAF4FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: primaryBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
