import 'package:flutter/material.dart';
import 'package:skuteq_app/components/app_bottom_nav.dart';
import 'package:skuteq_app/components/exam_type_dropdown.dart';
import 'package:skuteq_app/components/shared_app_head.dart';

import 'package:skuteq_app/services/academic_service.dart';

class AcademicPage extends StatefulWidget {
  final Map<String, dynamic> initialReport;
  final List<ExamOption> exams;
  final String selectedExamId;

  final Future<Map<String, dynamic>> Function(String examId) onFetchByExamId;

  AcademicPage({
    super.key,
    required this.initialReport,
    required this.exams,
    required this.selectedExamId,
    required this.onFetchByExamId,
  });

  @override
  State<AcademicPage> createState() => _AcademicPageState();
}

class _AcademicPageState extends State<AcademicPage>
    with TickerProviderStateMixin {
  // 🎨 COLORS
  static const Color pageBg = Color(0xFFF6FAFF);
  static const Color cardBg = Colors.white;
  static const Color cardBorder = Color(0xFFE7EFF7);
  static const Color subjectBg = Color(0xFFEAF4FF);
  static const Color subjectBorder = Color(0xFFF6FAFF);

  static const Color titleColor = Color(0xFF0B2E4E);
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color mutedText = Color(0xFF9AA6B2);

  late AnimationController _skeletonCtrl;
  late Animation<double> _skeletonFade;

  bool _loading = false;

  late List<ExamOption> _exams;
  late String _selectedExamId;
  late String _selectedExamName;

  List<Map<String, dynamic>> _subjects = [];

  @override
  void initState() {
    super.initState();

    _skeletonCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _skeletonFade = Tween<double>(begin: 0.35, end: 0.7).animate(_skeletonCtrl);

    _exams = widget.exams;
    _selectedExamId = widget.selectedExamId;

    final selected = _exams.firstWhere(
      (e) => e.id == _selectedExamId,
      orElse: () => const ExamOption(id: "", name: ""),
    );
    _selectedExamName = selected.name;

    _subjects = _extractSubjects(widget.initialReport);
  }

  @override
  void dispose() {
    _skeletonCtrl.dispose();
    super.dispose();
  }

  // ✅ robust subject extractor
  List<Map<String, dynamic>> _extractSubjects(dynamic json) {
    final out = <Map<String, dynamic>>[];

    void walk(dynamic node) {
      if (node == null) return;

      if (node is List) {
        for (final it in node) walk(it);
        return;
      }

      if (node is Map) {
        // If this map looks like subject row
        final subject =
            (node['subject'] ?? node['subject_name'] ?? node['name'])
                ?.toString();

        final total =
            node['max_marks'] ??
            node['total_marks'] ??
            node['max_marks'] ??
            node['out_of'];

        final obtained =
            node['secured_marks'] ??
            node['obtained_marks'] ??
            node['marks_obtained'] ??
            node['score'] ??
            node['marks'];

        if (subject != null &&
            subject.isNotEmpty &&
            (total != null || obtained != null)) {
          out.add(Map<String, dynamic>.from(node));
        }

        for (final v in node.values) walk(v);
      }
    }

    walk(json);

    // normalize for UI
    final normalized = <Map<String, dynamic>>[];
    for (final raw in out) {
      final subject =
          (raw['subject'] ?? raw['subject_name'] ?? raw['name'])?.toString() ??
          '-';

      num total =
          num.tryParse(
            (raw['max_marks'] ??
                    raw['total_marks'] ??
                    raw['max_marks'] ??
                    raw['out_of'] ??
                    0)
                .toString(),
          ) ??
          0;

      num obtained =
          num.tryParse(
            (raw['secured_marks'] ??
                    raw['obtained_marks'] ??
                    raw['marks_obtained'] ??
                    raw['score'] ??
                    raw['marks'] ??
                    0)
                .toString(),
          ) ??
          0;

      num? pct = num.tryParse(
        (raw['percentage'] ?? raw['percent'] ?? '').toString(),
      );
      pct ??= (total == 0) ? 0 : ((obtained / total) * 100);

      normalized.add({
        "subject": subject,
        "max_marks": total,
        "secured_marks": obtained,
        "percentage": pct.round(),
      });
    }

    // unique
    final seen = <String>{};
    final unique = <Map<String, dynamic>>[];
    for (final s in normalized) {
      final key = "${s['subject']}_${s['max_marks']}_${s['secured_marks']}";
      if (seen.add(key)) unique.add(s);
    }

    return unique;
  }

  Future<void> _pickExam() async {
    final selected = await showModalBottomSheet<ExamOption>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6EEF6),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                "Select Exam",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _exams.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final e = _exams[i];
                    final isSel = e.id == _selectedExamId;

                    return ListTile(
                      title: Text(
                        e.name,
                        style: TextStyle(
                          fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                      trailing: isSel
                          ? const Icon(Icons.check_circle, color: primaryBlue)
                          : null,
                      onTap: () => Navigator.pop(ctx, e),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selected == null) return;
    if (selected.id.isEmpty) return; // ignore "Select Exam"
    if (selected.id == _selectedExamId) return;

    setState(() {
      _loading = true;
      _selectedExamId = selected.id;
      _selectedExamName = selected.name;
    });

    try {
      final res = await widget.onFetchByExamId(selected.id);
      if (!mounted) return;

      setState(() {
        _subjects = _extractSubjects(res);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load exam report: $e")));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      appBar: SharedAppHead(
        title: "Academic Details",
        showDrawer: false,
        showBack: true,
      ),
      body: Column(
        children: [
          Container(height: 14, color: pageBg),

          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _examTypeCard(),
                      const SizedBox(height: 14),
                      _subjectsCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  Widget _examTypeCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 180,
            child: Text(
              "Exam Type",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: ExamTypeDropdown(
              exams: _exams,
              selectedExamId: _selectedExamId,
              selectedExamName: _selectedExamName,
              disabled: _loading,
              onSelected: (selected) async {
                if (selected.id.isEmpty) return;
                if (selected.id == _selectedExamId) return;

                setState(() {
                  _loading = true;
                  _selectedExamId = selected.id;
                  _selectedExamName = selected.name;
                });

                try {
                  final res = await widget.onFetchByExamId(selected.id);
                  if (!mounted) return;

                  setState(() {
                    _subjects = _extractSubjects(res);
                  });
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to load exam report: $e")),
                  );
                } finally {
                  if (mounted) setState(() => _loading = false);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _subjectsCard() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Text(
                "Subjects",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),

            Expanded(
              child: _loading
                  ? SingleChildScrollView(child: _subjectsSkeleton())
                  : _subjects.isEmpty
                  ? Center(
                      child: Text(
                        "$_selectedExamName data not available",
                        style: const TextStyle(
                          color: mutedText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: _subjects.map(_subjectTile).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _skeletonBox({
    double height = 16,
    double width = double.infinity,
    double radius = 12,
  }) {
    return FadeTransition(
      opacity: _skeletonFade,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: const Color(0xFFE9EFF6),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  Widget _subjectsSkeleton() {
    return Column(
      children: List.generate(
        4,
        (_) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: subjectBg,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: subjectBorder),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _skeletonBox(height: 14, width: 160),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _skeletonBox(height: 26, width: 80, radius: 5),
                        const SizedBox(width: 8),
                        _skeletonBox(height: 26, width: 90, radius: 5),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _skeletonBox(height: 40, width: 64, radius: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _subjectTile(Map<String, dynamic> s) {
    final subject = s['subject'].toString();
    final total = s['max_marks'];
    final obtained = s['secured_marks'];
    final pct = s['percentage'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: subjectBg,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: subjectBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _miniChip("Max $total"),
                    const SizedBox(width: 8),
                    _miniChip("Secured $obtained"),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 64,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: subjectBorder),
            ),
            child: Text(
              "$pct%",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniChip(String text) {
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: subjectBorder),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }
}
