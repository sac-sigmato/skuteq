

import 'package:flutter/material.dart';
import 'package:skuteq_app/components/app_bottom_nav.dart';
import 'package:skuteq_app/components/ay_picker.dart';
import 'package:skuteq_app/components/student_header_card.dart';
import 'package:skuteq_app/helpers/invoice_storage.dart';
import 'package:skuteq_app/services/academic_service.dart';
import 'package:skuteq_app/services/receipt_service.dart';
import 'package:skuteq_app/widgets/app_drawer.dart';
import '../services/student_service.dart';
import 'profile_page.dart';
import 'attendance_widget.dart';
import 'academic_page.dart';
import 'invoices_page.dart';
import 'receipts_page.dart';
import 'student_details_page.dart';
import 'alerts_page.dart';
import '../services/invoice_service.dart';
import '../services/attendance_service.dart';
import 'package:skuteq_app/components/shared_app_head.dart';

class StudentDashboard extends StatefulWidget {
  final Map<String, dynamic> studentData;
  final Map<String, dynamic> ayClassResponse;
  final Map<String, dynamic> dashboardData;

  const StudentDashboard({
    super.key,
    required this.studentData,
    required this.ayClassResponse,
    required this.dashboardData,
  });

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  late Map<String, dynamic> _dashboardData;
  bool _loadingDashboard = false;

  int currentIndex = 0;
  String selectedYear = "";

  // ✅ AY/Class picker state (AyClassOption comes from ay_picker.dart)
  List<AyClassOption> _ayOptions = [];
  AyClassOption? _selectedAy;

  Map<String, dynamic> get parentData {
    final data = widget.studentData['data'] ?? {};

    if (data['is_father_details'] == true && data['father_details'] != null) {
      final father = data['father_details'];
      return {
        "name": father['first_name'] ?? 'Parent',
        "email": father['email_address'] ?? '',
        "mobile": father['mobile_number'] ?? '',
        "avatarUrl": father['father_image_url'] ?? '',
        "parentId": "Father",
      };
    }

    if (data['is_mother_details'] == true && data['mother_details'] != null) {
      final mother = data['mother_details'];
      return {
        "name": mother['first_name'] ?? 'Parent',
        "email": mother['email_address'] ?? '',
        "mobile": mother['mobile_number'] ?? '',
        "avatarUrl": mother['mother_image_url'] ?? '',
        "parentId": "Mother",
      };
    }

    return {
      "name": "Parent",
      "email": "",
      "mobile": "",
      "avatarUrl": "",
      "parentId": "",
    };
  }

  Map<String, dynamic> get student => widget.studentData['data'] ?? {};

  String studentName() => (student['full_name'] ?? '').toString();
  String student_Id() => (student['_id'] ?? '').toString();
  String studentId() => (student['student_id'] ?? '').toString();
  String branchName() => (student['branch_name'] ?? '').toString();
  String imageUrl() => (student['image_url'] ?? '').toString();

  String resolveStudentImageUrl() {
    var raw = imageUrl().trim();
    if (raw.isEmpty) return "";

    // already full url
    if (raw.startsWith("http://") || raw.startsWith("https://")) return raw;

    // remove leading slashes
    raw = raw.replaceFirst(RegExp(r'^/+'), '');

    // if api already includes "public/..."
    if (raw.startsWith("public/")) {
      return "https://dev-cdn.skuteq.net/$raw";
    }

    // normal case: relative under public
    return "https://dev-cdn.skuteq.net/public/$raw";
  }

  Future<void> _reloadDashboardForSelectedAy() async {
    final opt = _selectedAy;
    if (opt == null) return;

    try {
      setState(() => _loadingDashboard = true);

      final branchId = student['branch_id']?.toString() ?? '';
      final studentDbId = student['_id']?.toString() ?? '';

      if (branchId.isEmpty || studentDbId.isEmpty) {
        throw Exception("Missing branchId / studentId");
      }
      final StudentService _studentService = StudentService();
      final dashboardData = await _studentService.fetchStudentDashboard(
        branchId: branchId,
        studentId: studentDbId,
        academicYearId: opt.academicYearId,
        startDate: isoToYmd(opt.ayStartDate!),
        endDate: isoToYmd(opt.ayEndDate!),
        classId: opt.classId,
        sectionId: opt.sectionId,
      );

      print('✅ Decoded Student Dashboard: $dashboardData');

      // ✅ Extract attendance safely
      final attendance =
          dashboardData['attendance'] as Map<String, dynamic>? ?? {};

      // ✅ percentage (can be int or double)
      final double percentage = attendance['percentage'] is num
          ? (attendance['percentage'] as num).toDouble()
          : double.tryParse(attendance['percentage']?.toString() ?? '0') ?? 0.0;

      // ✅ total days
      final int totalDays = attendance['total_days'] is int
          ? attendance['total_days']
          : int.tryParse(attendance['total_days']?.toString() ?? '0') ?? 0;

      // ✅ present days
      final int presentDays = attendance['total_present'] is int
          ? attendance['total_present']
          : int.tryParse(attendance['total_present']?.toString() ?? '0') ?? 0;

      // ✅ Save all 3 values
      await InvoiceStorage.saveAttendanceStats(
        percentage: percentage,
        totalDays: totalDays,
        presentDays: presentDays,
      );

      setState(() {
        _dashboardData = dashboardData;
      });
    } catch (e) {
      debugPrint("❌ Dashboard reload failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update dashboard")),
      );
    } finally {
      setState(() => _loadingDashboard = false);
    }
  }

  Future<void> _saveParentDataToStorage() async {
    try {
      final data = parentData; // getter you already have
      await InvoiceStorage.saveParentData(data);
      debugPrint("✅ Parent data saved to storage: $data");
    } catch (e) {
      debugPrint("❌ Failed to save parent data: $e");
    }
  }

  String get img => resolveStudentImageUrl();
  @override
  void initState() {
    super.initState();
    _saveParentDataToStorage();
    _dashboardData = widget.dashboardData;
    final data = widget.studentData['data'] ?? {};

    final studId = (data['student_id'] ?? "").toString();
    if (studId.isNotEmpty) {
      InvoiceStorage.saveStudentId(studId);
    }

    final studDbId = (data['_id'] ?? "").toString();
    if (studDbId.isNotEmpty) {
      InvoiceStorage.saveStudent_Id(studDbId);
    }

    final branchId = (data['branch_id'] ?? "").toString();
    if (branchId.isNotEmpty) {
      InvoiceStorage.saveBranchId(branchId);
    }

    _ayOptions = _buildAyOptions(widget.ayClassResponse);

    _selectedAy = _ayOptions.firstWhere(
      (e) => e.latest == true,
      orElse: () => _ayOptions.isNotEmpty
          ? _ayOptions.first
          : const AyClassOption(
              academicYearId: "",
              academicYearName: "",
              name:"  ",
              classId: "",
              className: "",
              sectionId: "",
              sectionName: "",
              latest: false,
            ),
    );

    selectedYear = _selectedAy?.academicYearName ?? "";

    // ✅ save dates initially
    _saveSelectedAyToStorage();
  }

  String isoToYmd(String iso) {
    // "2026-04-30T23:59:59.999Z" -> "2026-04-30"
    return DateTime.parse(iso).toIso8601String().split('T').first;
  }

  static const List<String> _months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  Map<String, dynamic> monthYearFromIso(String iso) {
    final clean = iso.contains('T') ? iso.split('T').first : iso;
    final dt = DateTime.parse(clean);
    return {"month": _months[dt.month - 1], "year": dt.year};
  }

  Future<void> _saveSelectedAyToStorage() async {
    final opt = _selectedAy;
    if (opt == null) return;

    final startIso = opt.ayStartDate;
    final endIso = opt.ayEndDate;

    if (opt.academicYearId.isEmpty || startIso == null || endIso == null)
      return;

    final startYmd = isoToYmd(startIso);
    final endYmd = isoToYmd(endIso);

    await InvoiceStorage.saveAyDates(
      academicYearId: opt.academicYearId,
      startDateIso: startYmd,
      endDateIso: endYmd,
    );

    final my = monthYearFromIso(endYmd);
    await InvoiceStorage.saveAyEndMonthYear(
      endMonth: my["month"] as String,
      endYear: my["year"] as int,
    );
  }

  // =========================
  // ✅ Parse AY/Class response
  // =========================
  List<AyClassOption> _buildAyOptions(Map<String, dynamic> res) {
    final List list = (res['data'] as List?) ?? [];
    final out = <AyClassOption>[];

    for (final row in list) {
      if (row is! Map) continue;

      final ayObj = row['academic_year'] is Map
          ? row['academic_year'] as Map
          : null;

      final academicYearId =
          (row['academic_year_id'] ??
                  ayObj?['academic_year_id'] ??
                  ayObj?['id'] ??
                  "")
              .toString();
      final academicYearName =
          (row['academic_year_name'] ?? ayObj?['name'] ?? "").toString();

      final classId = (row['class_id'] ?? "").toString();
      final className = (row['class_name'] ?? "").toString();
      final name = (row['name'] ?? ayObj?['name'] ?? "").toString();

      final sectionId = (row['section_id'] ?? "").toString();
      final sectionName = (row['section_name'] ?? "").toString();

      final latest = row['latest'] == true;

      final studentUuid = (row['student_uuid'] ?? row['uuid'])?.toString();
      final ayStartDate = ayObj?['start_date']?.toString();
      final ayEndDate = ayObj?['end_date']?.toString();

      if (academicYearId.isEmpty || classId.isEmpty || sectionId.isEmpty)
        continue;

      out.add(
        AyClassOption(
          academicYearId: academicYearId,
          academicYearName: academicYearName,
          name:name,
          classId: classId,
          className: className,
          sectionId: sectionId,
          sectionName: sectionName,
          latest: latest,
          studentUuid: studentUuid,
          ayStartDate: ayStartDate,
          ayEndDate: ayEndDate,
        ),
      );
    }

    // ✅ de-dupe (same AY+class+section)
    final seen = <String>{};
    final unique = <AyClassOption>[];
    for (final e in out) {
      final key = "${e.academicYearId}|${e.classId}|${e.sectionId}";
      if (seen.add(key)) unique.add(e);
    }

    return unique;
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0E70B8);
    const Color pageBg = Color(0xFFEAF4FF);

    return Scaffold(
      backgroundColor: pageBg,

      drawer: AppDrawer(parentData: parentData),

      appBar: SharedAppHead(
        title: "Dashboard",
        showDrawer: true,
        showBack: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Column(
              children: [
                StudentHeaderCard(
                  name: studentName(),
                  studentIdText: studentId(),
                  branchName: branchName(),
                  imageUrl: img, // ✅ use resolved url
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            StudentDetailsPage(studentData: widget.studentData),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 14),

                // ✅ AY pill full width like screenshot
                SizedBox(
                  width: double.infinity,
                  child: AyPickerPill(
                    options: _ayOptions,
                    selected: _selectedAy,
                    onSelected: (picked) async {
                      // ✅ If same AY + class + section → DO NOTHING
                      if (_selectedAy != null &&
                          _selectedAy!.academicYearId ==
                              picked.academicYearId &&
                          _selectedAy!.classId == picked.classId &&
                          _selectedAy!.sectionId == picked.sectionId) {
                        return; // 🔥 no fetch, no loading
                      }

                      setState(() {
                        _selectedAy = picked;
                        selectedYear = picked.academicYearName;
                      });

                      await _saveSelectedAyToStorage();
                      await _reloadDashboardForSelectedAy();
                    },

                  ),
                ),

                const SizedBox(height: 14),

                // ✅ Fixed tile height like screenshot (no squashed cards)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 92, // ✅ matches SS height
                  ),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _statTile(
                        title: "Attendance",
                        value:
                            (_dashboardData['attendance']?['percentage'] ?? '0')
                                .toString() +
                            "%",
                        topColor: const Color(0xFF2B6DE5),
                        onTap: () async {
                          // your existing Attendance onTap 그대로
                          try {
                            final opt = _selectedAy;
                            if (opt == null || opt.academicYearId.isEmpty) {
                              throw Exception("Please select Academic Year");
                            }

                            final branchId = student['branch_id']?.toString();
                            final studId = student['student_id']?.toString();
                            if (branchId == null || studId == null) {
                              throw Exception("Missing branchId/studentId");
                            }

                            final now = DateTime.now();
                            const months = [
                              "January",
                              "February",
                              "March",
                              "April",
                              "May",
                              "June",
                              "July",
                              "August",
                              "September",
                              "October",
                              "November",
                              "December",
                            ];
                            final defaultMonth = months[now.month - 1];
                            final defaultYear = now.year;

                            final attendanceService = AttendanceService();

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );

                            final attendanceApiResponse =
                                await attendanceService.fetchYearWiseAttendance(
                                  branchId: branchId,
                                  studentId: studId,
                                  academicYearId: opt.academicYearId,
                                  classId: opt.classId,
                                  sectionId: opt.sectionId,
                                  month: defaultMonth,
                                  year: defaultYear,
                                );

                            Navigator.pop(context);
                            final attendanceSummary =
                                _dashboardData['attendance'] ?? {};
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AttendancePage(
                                  apiResponse: attendanceApiResponse,
                                  fetchAttendance: (month, year) {
                                    return attendanceService
                                        .fetchYearWiseAttendance(
                                          branchId: branchId,
                                          studentId: studId,
                                          academicYearId: opt.academicYearId,
                                          classId: opt.classId,
                                          sectionId: opt.sectionId,
                                          month: month,
                                          year: year,
                                        );
                                  },
                                  attendanceSummary: attendanceSummary,
                                ),
                              ),
                            );
                          } catch (e) {
                            if (Navigator.canPop(context))
                              Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Failed to load attendance"),
                              ),
                            );
                          }
                        },
                      );
                    }

                    if (index == 1) {
                      return _statTile(
                        title: "Academics",
                        value:
                            "${_dashboardData['academic_percentage'] ?? '0'}%",
                        topColor: const Color(0xFFF7C71C),
                        onTap: () async {
                          // your existing Academics onTap 그대로
                          try {
                            final opt = _selectedAy;
                            if (opt == null || opt.academicYearId.isEmpty) {
                              throw Exception("Please select Academic Year");
                            }

                            final branchId = student['branch_id']?.toString();
                            final studId = student['student_id']?.toString();
                            final studentUuid =
                                (opt.studentUuid ?? student['uuid'])
                                    ?.toString();

                            if (branchId == null ||
                                studId == null ||
                                studentUuid == null ||
                                studentUuid.isEmpty) {
                              throw Exception("Academic params missing");
                            }

                            final academicService = AcademicService();

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );

                            final examsRes = await academicService
                                .fetchStudentExams(
                                  branchId: branchId,
                                  studentUuid: studentUuid,
                                  academicYearId: opt.academicYearId,
                                  classId: opt.classId,
                                  sectionId: opt.sectionId,
                                  latest: true,
                                );

                            final exams = academicService
                                .extractExamOptionsFromListExams(examsRes);

                            final firstRealExam = exams.firstWhere(
                              (e) => e.id.isNotEmpty,
                              orElse: () =>
                                  const ExamOption(id: "", name: "Select Exam"),
                            );

                            Map<String, dynamic> reportRes = {"data": []};
                            if (firstRealExam.id.isNotEmpty) {
                              reportRes = await academicService
                                  .fetchAcademicReports(
                                    branchId: branchId,
                                    studentId: studId,
                                    academicYearId: opt.academicYearId,
                                    classId: opt.classId,
                                    sectionId: opt.sectionId,
                                    examId: firstRealExam.id,
                                    role: "directory",
                                  );
                            }

                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AcademicPage(
                                  initialReport: reportRes,
                                  exams: exams,
                                  selectedExamId: firstRealExam.id,
                                  onFetchByExamId: (examId) {
                                    return academicService.fetchAcademicReports(
                                      branchId: branchId,
                                      studentId: studId,
                                      academicYearId: opt.academicYearId,
                                      classId: opt.classId,
                                      sectionId: opt.sectionId,
                                      examId: examId,
                                      role: "directory",
                                    );
                                  },
                                ),
                              ),
                            );
                          } catch (e) {
                            if (Navigator.canPop(context))
                              Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Failed to load academics"),
                              ),
                            );
                          }
                        },
                      );
                    }

                    if (index == 2) {
                      return _statTile(
                        title: "Receipts",
                        value: "${_dashboardData['receipt_count'] ?? '0'}",
                        topColor: const Color(0xFF2DBE7C),
                        onTap: () async {
                          // your existing Receipts onTap 그대로
                          try {
                            final receiptService = ReceiptService();
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );

                            final receiptApiResponse = await receiptService
                                .fetchReceipts();
                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReceiptsPage(
                                  apiResponse: receiptApiResponse,
                                  branchId: "${student['branch_id']}",
                                ),
                              ),
                            );
                          } catch (e) {
                            if (Navigator.canPop(context))
                              Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Failed to load receipts"),
                              ),
                            );
                          }
                        },
                      );
                    }

                    return _statTile(
                      title: "Invoices",
                      value: "${_dashboardData['invoice_count'] ?? '0'}",
                      topColor: const Color(0xFFFFA726),
                      onTap: () async {
                        // your existing Invoices onTap 그대로
                        try {
                          final invoiceService = InvoiceService();
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                          final invoices = await invoiceService
                              .fetchStudentInvoices();
                          Navigator.pop(context);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => InvoicesPage(invoices: invoices),
                            ),
                          );
                        } catch (e) {
                          if (Navigator.canPop(context)) Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Failed to load invoices"),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          if (_loadingDashboard)
            Positioned.fill(
              child: Container(
                // color: Colors.black.withOpacity(0.25),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),

      bottomNavigationBar: AppBottomNav(currentIndex: currentIndex),

    );
  }

  Widget _statTile({
    required String title,
    required String value,
    required Color topColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6EEF6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 4, // ✅ thin top strip like SS
              decoration: BoxDecoration(
                color: topColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        //  height: 1.0,
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
}
