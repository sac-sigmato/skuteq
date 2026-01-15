import 'package:flutter/material.dart';
import 'package:skuteq_app/components/shared_app_head.dart';
import 'package:skuteq_app/helpers/invoice_storage.dart';
import 'package:skuteq_app/services/academic_service.dart';
import 'package:skuteq_app/services/receipt_service.dart';
import 'student_dashboard.dart';
import '../services/student_service.dart';

class SelectChildPage extends StatefulWidget {
  final List<dynamic> students;

  const SelectChildPage({super.key, required this.students});

  @override
  State<SelectChildPage> createState() => _SelectChildPageState();
}

class _SelectChildPageState extends State<SelectChildPage> {
  final StudentService _studentService = StudentService();

  /// ✅ CENTRAL IMAGE RESOLVER
  String resolveStudentImageUrl(dynamic raw) {
    if (raw == null) return "";

    String url = raw.toString().trim();
    if (url.isEmpty) return "";

    if (url.startsWith("http://") || url.startsWith("https://")) {
      return url;
    }

    url = url.replaceFirst(RegExp(r'^/+'), '');

    if (url.startsWith("public/")) {
      return "https://dev-cdn.skuteq.net/$url";
    }

    return "https://dev-cdn.skuteq.net/public/$url";
  }

  Future<void> _saveChildrenToStorage() async {
    try {
      final List<Map<String, dynamic>> children = widget.students.map((s) {
        final Map student = s as Map;

        return {
          "studentDbId": student["_id"]?.toString() ?? "",
          "studentId": student["student_id"]?.toString() ?? "",
          "name": student["full_name"]?.toString() ?? "",
          "className": student["class_name"]?.toString() ?? "",
          "sectionName": student["section_name"]?.toString() ?? "",
          "avatarUrl": resolveStudentImageUrl(student["image_url"]),
        };
      }).toList();

      await InvoiceStorage.saveLinkedChildren(children);

      debugPrint("✅ Linked children saved (${children.length})");
    } catch (e) {
      debugPrint("❌ Failed to save linked children: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _saveChildrenToStorage();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0B2A4A);
    const Color pageBg = Color(0xFFEAF4FF);

    return Scaffold(
      backgroundColor: pageBg,
      appBar: SharedAppHead(
        title: "Welcome",
        showDrawer: true,
        showBack: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: widget.students.isEmpty
                  ? const Center(child: Text("No students found"))
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 16,
                      ),
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: widget.students.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final student = widget.students[index];

                          final String resolvedImage = resolveStudentImageUrl(
                            student['image_url'],
                          );

                          return _buildChildCard(
                            studentId: student['_id'] ?? '',
                            name: student['full_name'] ?? 'Unknown',
                            school: student['branch_name'] ?? '',
                            imagePath: resolvedImage.isNotEmpty
                                ? resolvedImage
                                : 'assets/icon/profile.png',
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
    final bool isNetworkImage = imagePath.startsWith('http');

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

            final studentData = await _studentService.fetchStudentDetailsById(
              studentId,
            );

            final student = studentData['data'] ?? {};
            final String? branchId = student['branch_id']?.toString();
            final String? studentDbId = student['_id']?.toString();

            if (branchId == null || studentDbId == null) {
              throw Exception("Missing identifiers");
            }

            final academicService = AcademicService();

            final ayClassResponse = await academicService.fetchStudentAyClass(
              branchId: branchId,
              studentDbId: studentDbId,
            );

            // ✅ Extract list safely
            final ayClassList = ayClassResponse['data'] as List? ?? [];

            if (ayClassList.isEmpty) {
              throw Exception('No AY/Class mapping found');
            }

            // ✅ Get latest academic year/class
            final latestAyClass = ayClassList.firstWhere(
              (item) => item['latest'] == true,
              orElse: () => ayClassList.first,
            );

            // ✅ Academic year object
            final academicYear = latestAyClass['academic_year'] ?? {};

            // ✅ Call dashboard API
            final dashboardData = await _studentService.fetchStudentDashboard(
              branchId: branchId,
              studentId: studentDbId,
              academicYearId:
                  academicYear['academic_year_id']?.toString() ?? '',
              startDate: academicYear['start_date']?.toString() ?? '',
              endDate: academicYear['end_date']?.toString() ?? '',
              classId: latestAyClass['class_id']?.toString() ?? '',
              sectionId: latestAyClass['section_id']?.toString() ?? '',
            );

            // final int receiptsAllTotalCount = dashboardData['receipt_count'];
            // final int invoicesAllTotalCount = dashboardData['invoice_count'];

            if (Navigator.canPop(context)) Navigator.pop(context);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => StudentDashboard(
                  studentData: studentData,
                  ayClassResponse: ayClassResponse,
                  dashboardData: dashboardData,
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
                  child: isNetworkImage
                      ? Image.network(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _fallbackAvatar(),
                        )
                      : Image.asset(imagePath, fit: BoxFit.cover),
                ),
              ),

              const SizedBox(width: 16),

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

  Widget _fallbackAvatar() {
    return Container(
      color: Colors.grey[100],
      alignment: Alignment.center,
      child: const Icon(Icons.person, size: 32, color: Colors.grey),
    );
  }
}

extension on Map<String, dynamic> {
  get data => null;
}
