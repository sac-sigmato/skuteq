// lib/screens/select_child_page.dart

import 'package:flutter/material.dart';
import 'package:skuteq_app/services/academic_service.dart';
import 'package:skuteq_app/services/receipt_service.dart';
import 'student_dashboard.dart';
import '../services/student_service.dart'; // your existing one

class SelectChildPage extends StatefulWidget {
  final List<dynamic> students; // 👈 DATA FROM LOGIN

  const SelectChildPage({super.key, required this.students});

  @override
  State<SelectChildPage> createState() => _SelectChildPageState();
}

class _SelectChildPageState extends State<SelectChildPage> {
  final StudentService _studentService = StudentService();

  @override
  Widget build(BuildContext context) {
    // Colors
    const Color primaryBlue = Color(0xFF0B2A4A);
    const Color pageBg = Color(0xFFF6FAFF);
    const Color textPrimary = Color(0xFF1A1A1A);

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Column(
          children: [
            // ---------- HEADER ----------
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              color: Colors.white,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(Icons.menu_rounded, size: 30),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Select Student",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // ---------- STUDENT LIST ----------
            Expanded(
              child: widget.students.isEmpty
                  ? const Center(
                      child: Text(
                        "No students found",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: widget.students.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final student = widget.students[index];

                          return _buildChildCard(
                            studentId: student['_id'] ?? '',
                            name: student['full_name'] ?? 'Unknown',
                            school: student['branch_name'] ?? '',
                            imagePath:
                                (student['image_url'] != null &&
                                    student['image_url'].toString().isNotEmpty)
                                ? student['image_url']
                                : 'assets/images/student1.png',
                            highlight: false,
                            primaryBlue: primaryBlue,
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String capitalizeName(String value) {
    if (value.isEmpty) return value;

    return value
        .toLowerCase()
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  // ---------- CHILD CARD ----------
  Widget _buildChildCard({
    required String studentId,
    required String name,
    required String school,
    required String imagePath,
    required bool highlight,
    required Color primaryBlue,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () async {
          try {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );

            // ✅ 1) Student details
            final studentData = await _studentService.fetchStudentDetailsById(
              studentId,
            );

            final student = studentData['data'] ?? {};
            final String? branchId = student['branch_id']?.toString();
            final String? studentDbId = student['_id']?.toString(); // Mongo _id
            final String? studentUuid = (student['uuid'] ?? student['_id'])
                ?.toString();

            // ✅ for receipts date range (prefer academic_year else hardcode fallback)
            final String startDate = "2025-04-01";
            final String endDate = "2026-03-31";

            if (branchId == null ||
                studentDbId == null ||
                studentUuid == null) {
              throw Exception("Missing branchId or studentDbId or studentUuid");
            }

            // ✅ 2) AY/Class list
            final academicService = AcademicService();
            final ayClassResponse = await academicService.fetchStudentAyClass(
              branchId: branchId,
              studentDbId: studentDbId,
            );

            // ✅ 3) Receipts (only need all_total_count)
            // final receiptService = ReceiptService();
            // final receiptsRes = await receiptService.fetchReceipts();

            final int receiptsAllTotalCount = 18;
            //     (receiptsRes['all_total_count'] as num?)?.toInt() ?? 0;

            if (Navigator.canPop(context))
              Navigator.pop(context); // close loader

            // ✅ 4) Navigate with all three
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => StudentDashboard(
                  studentData: studentData,
                  ayClassResponse: ayClassResponse,
                  receiptsAllTotalCount: receiptsAllTotalCount, // ✅ NEW
                ),
              ),
            );
          } catch (e) {
            if (Navigator.canPop(context)) Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to load student details")),
            );
            debugPrint("❌ onTap error: $e");
          }
        },

        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: highlight
                  ? primaryBlue.withOpacity(0.2)
                  : Colors.grey[200]!,
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
              // Avatar
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
                  child:
                      (imagePath != null &&
                          imagePath.toString().isNotEmpty &&
                          imagePath.toString().startsWith('http'))
                      ? Image.network(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.person,
                            size: 32,
                            color: Colors.grey,
                          ),
                        )
                      : Container(
                          color: Colors.grey[100],
                          child: const Icon(
                            Icons.person,
                            size: 32,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),

              const SizedBox(width: 16),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      capitalizeName(name),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),
                    Text(
                      school,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              // Arrow
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF4FF),
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
