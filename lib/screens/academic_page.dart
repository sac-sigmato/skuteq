// lib/screens/academic_page.dart
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
      {"name":"Select Exam","date":"","isSelected":true}
    ],
    "subjects": [
      {"subject":"Mathematics","totalMarks":100,"obtainedMarks":92,"percentage":92},
      {"subject":"Science","totalMarks":100,"obtainedMarks":80,"percentage":80},
      {"subject":"English","totalMarks":100,"obtainedMarks":88,"percentage":88},
      {"subject":"Social Studies","totalMarks":100,"obtainedMarks":82,"percentage":82}
    ]
  }
  ''';

  late Map<String, dynamic> academicData;
  List<dynamic> exams = [];
  List<dynamic> subjects = [];
  String? selectedExam;

  // Colors
  static const Color _pageBg = Color(0xFFF5F8FB);
  static const Color _cardBorder = Color(0xFFE7EFF7);
  static const Color _mutedText = Color(0xFF9FA8B2);
  static const Color _accentBlue = Color(0xFF2E9EE6);
  static const Color _titleBlue = Color(0xFF244A6A);
  static const Color _subjectBg = Color(0xFFF0F7FF);
  static const Color _subjectBorder = Color(0xFFE6F3FB);

  @override
  void initState() {
    super.initState();
    academicData = json.decode(sampleJsonData);
    exams = academicData['exams'] ?? [];
    subjects = academicData['subjects'] ?? [];
    selectedExam = exams.isNotEmpty ? exams.first['name'] : "Select Exam";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Academic Details',
          style: TextStyle(
            color: _titleBlue,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Card 1: Exam Type
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _cardBorder),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 110,
                      child: Text(
                        'Exam Type',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // TODO: open exam selector
                        },
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: _cardBorder),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedExam ?? 'Select Exam',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black45,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Card 2: Subjects (separate container)
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subjects header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                        child: Text(
                          'Subjects',
                          style: TextStyle(
                            color: _accentBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      // Subject list
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Column(
                              children: subjects
                                  .map((s) => _subjectTile(s))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _subjectTile(dynamic s) {
    final String name = (s['subject'] ?? '').toString();
    final int max = (s['totalMarks'] ?? 0) is num
        ? (s['totalMarks'] as num).toInt()
        : 0;
    final int obtained = (s['obtainedMarks'] ?? 0) is num
        ? (s['obtainedMarks'] as num).toInt()
        : 0;
    final int percent =
        (s['percentage'] ?? (max == 0 ? 0 : (obtained * 100 ~/ max))) is num
        ? (s['percentage'] as num).toInt()
        : (max == 0 ? 0 : (obtained * 100 ~/ max));

    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 4, right: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _subjectBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _subjectBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _titleBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _miniChip("Max $max"),
                    const SizedBox(width: 8),
                    _miniChip("Secured $obtained"),
                  ],
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _subjectBorder),
            ),
            child: Text(
              "$percent%",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: _titleBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _subjectBorder),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: _mutedText,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
