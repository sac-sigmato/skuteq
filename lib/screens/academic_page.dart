import 'package:flutter/material.dart';
import 'dart:convert';

class AcademicPage extends StatefulWidget {
  const AcademicPage({super.key});

  @override
  State<AcademicPage> createState() => _AcademicPageState();
}

class _AcademicPageState extends State<AcademicPage> {
  // Corrected JSON data: All keys and string values use double quotes.
  final String sampleJsonData = '''
  {
    "exams": [
      {
        "name": "Mid-Term Exam",
        "date": "March 2024",
        "isSelected": true
      },
      {
        "name": "Final Exam", 
        "date": "June 2024",
        "isSelected": false
      },
      {
        "name": "Unit Test 1",
        "date": "January 2024",
        "isSelected": false
      }
    ],
    "subjects": [
      {
        "subject": "English",
        "totalMarks": 100,
        "obtainedMarks": 88, 
        "percentage": 88 
      },
      {
        "subject": "Kannada", 
        "totalMarks": 100,
        "obtainedMarks": 88, 
        "percentage": 88
      },
      {
        "subject": "Science",
        "totalMarks": 100,
        "obtainedMarks": 89, 
        "percentage": 89
      },
      {
        "subject": "Social",
        "totalMarks": 100,
        "obtainedMarks": 89, 
        "percentage": 89
      },
      {
        "subject": "Hindi",
        "totalMarks": 100,
        "obtainedMarks": 88,
        "percentage": 88
      }
    ]
  }
  ''';

  late Map<String, dynamic> academicData;
  List<dynamic> exams = [];
  List<dynamic> subjects = [];
  String selectedExam = "Mid-Term Exam";

  @override
  void initState() {
    super.initState();
    // This is where the FormatException occurs if the JSON string is invalid.
    academicData = json.decode(sampleJsonData);
    exams = academicData['exams'];
    subjects = academicData['subjects'];

    String initialSelectedExam = "";
    for (var exam in exams) {
      if (exam['isSelected']) {
        initialSelectedExam = exam['name'];
        break;
      }
    }
    selectedExam = initialSelectedExam.isNotEmpty
        ? initialSelectedExam
        : exams.first['name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[100], // Slight grey background for card contrast
      body: CustomScrollView(
        slivers: [
          // Custom AppBar/Header to match the screenshot's fixed blue bar
          _buildSliverAppBar(context),

          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20.0),
                    // Select Exam Dropdown
                    _buildExamDropdown(),
                    const SizedBox(height: 20),

                    // Report Cards (Card-based UI)
                    _buildReportCardsList(),
                    const SizedBox(height: 20), // Padding at the bottom
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  // Custom SliverAppBar for the persistent blue header/back button area
  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned:
          false, // Set to false to allow scrolling up (matches typical app behavior)
      expandedHeight: 140.0,
      backgroundColor: Colors.blue[700], // Slightly darker blue for header
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button and Title/Icon Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button implementation
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),

                  // Title
                  const Expanded(
                    child: Text(
                      'Academic Reports',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Icon (Graduation Cap)
                  const Icon(Icons.school, size: 30, color: Colors.white70),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Exam Dropdown widget
  Widget _buildExamDropdown() {
    List<String> examNames = exams
        .map((exam) => exam['name'] as String)
        .toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedExam,
          hint: const Text('Select Exam'),
          icon: const Icon(Icons.keyboard_arrow_down),
          style: const TextStyle(color: Colors.black87, fontSize: 16),
          onChanged: (String? newValue) {
            setState(() {
              selectedExam = newValue!;
            });
          },
          items: examNames.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ),
      ),
    );
  }

  // Report Cards List (Card-based UI)
  Widget _buildReportCardsList() {
    return Column(
      children: subjects.map<Widget>((subject) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildSubjectCard(subject),
        );
      }).toList(),
    );
  }

  // Single Subject Card Widget (matches SS image_b40d00.png)
  Widget _buildSubjectCard(Map<String, dynamic> subject) {
    int totalMarks = (subject['totalMarks'] as num).toInt();
    int obtainedMarks = (subject['obtainedMarks'] as num).toInt();
    double percentage = (subject['percentage'] as num).toDouble();
    Color percentageColor = _getPercentageColor(percentage);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Subject Name and Percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subject Name (Inside the rounded light blue box)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  subject['subject'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                    fontSize: 16,
                  ),
                ),
              ),

              // Percentage
              Text(
                '${percentage.toInt()}%',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: percentageColor,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Row 2: Max Marks
          _buildDetailRow(
            title: 'Max Marks',
            value: totalMarks.toString(),
            valueColor: Colors.blue.shade600!,
          ),
          const SizedBox(height: 8),

          // Row 3: Secured Marks
          _buildDetailRow(
            title: 'Secured Marks',
            value: obtainedMarks.toString(),
            valueColor: Colors.blue.shade600!,
          ),
        ],
      ),
    );
  }

  // Helper for detail rows (Max Marks, Secured Marks)
  Widget _buildDetailRow({
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.blue.shade700,
            fontSize: 14,
          ), // Text color matches SS
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: valueColor,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Color _getPercentageColor(double percentage) {
    // Coloring logic for the percentage text
    if (percentage >= 85) return Colors.green.shade700!;
    if (percentage >= 70) return Colors.blue.shade700!;
    if (percentage >= 50) return Colors.orange.shade700!;
    return Colors.red.shade700!;
  }
}
