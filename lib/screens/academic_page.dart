import 'dart:convert';
import 'package:flutter/material.dart';

class AcademicPage extends StatefulWidget {
  const AcademicPage({super.key});

  @override
  State<AcademicPage> createState() => _AcademicPageState();
}

class _AcademicPageState extends State<AcademicPage> {
  final String sampleJsonData = '''
  {
    "exams": [
      {"name":"Select Exam","isSelected":true}
    ],
    "subjects": [
      {"subject":"Mathematics","totalMarks":100,"obtainedMarks":92,"percentage":92},
      {"subject":"Science","totalMarks":100,"obtainedMarks":80,"percentage":80},
      {"subject":"English","totalMarks":100,"obtainedMarks":88,"percentage":88},
      {"subject":"Social Studies","totalMarks":100,"obtainedMarks":82,"percentage":82},
      {"subject":"Social Studies","totalMarks":100,"obtainedMarks":82,"percentage":82},
      {"subject":"Social Studies","totalMarks":100,"obtainedMarks":82,"percentage":82}
    ]
  }
  ''';

  late Map<String, dynamic> academicData;
  List subjects = [];
  String selectedExam = "Select Exam";

  // 🎨 COLORS — MATCH SS
  static const Color pageBg = Color(0xFFF6F9FC);
  static const Color cardBg = Colors.white;
  static const Color cardBorder = Color(0xFFE7EFF7);
  static const Color subjectBg = Color(0xFFEFF6FF);
  static const Color subjectBorder = Color(0xFFEAF4FF);

  static const Color titleColor = Color(0xFF0B2E4E);
  static const Color accentBlue = Color(0xFF2E9EE6);
  static const Color mutedText = Color(0xFF9AA6B2);

  @override
  void initState() {
    super.initState();
    academicData = json.decode(sampleJsonData);
    subjects = academicData['subjects'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,

      body: Column(
        children: [
          /// 🔹 CUSTOM HEADER
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            margin: const EdgeInsets.only(top: 20),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Academic Details",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),

          /// ✅ THIS IS THE GAP YOU SEE IN THE SCREENSHOT
          Container(height: 14, color: pageBg),

          /// 🔹 PAGE CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _examTypeCard(),
                  const SizedBox(height: 14),
                  _subjectsCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  // ---------------- EXAM TYPE CARD ----------------

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
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: cardBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedExam,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.black45),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- SUBJECTS CARD ----------------

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
            /// Header
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Text(
                "Subjects",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            /// Subject list
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: subjects.map((s) => _subjectTile(s)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- SUBJECT TILE ----------------

  Widget _subjectTile(dynamic s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: subjectBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: subjectBorder),
      ),
      child: Row(
        children: [
          /// LEFT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s['subject'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _miniChip("Max ${s['totalMarks']}"),
                    const SizedBox(width: 8),
                    _miniChip("Secured ${s['obtainedMarks']}"),
                  ],
                ),
              ],
            ),
          ),

          /// PERCENTAGE PILL
          Container(
            width: 56,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: subjectBorder),
            ),
            child: Text(
              "${s['percentage']}%",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: titleColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- MINI CHIP ----------------

  Widget _miniChip(String text) {
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: subjectBorder),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }
}
