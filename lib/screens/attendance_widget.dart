// attendance_page.dart
import 'package:flutter/material.dart';
import 'dart:convert';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  // Sample JSON data - replace this with your actual API response
  final String sampleJsonData = '''
  {
    "month": "February",
    "year": 2025,
    "days": [
      {"day": 1, "status": "general"},
      {"day": 2, "status": "general"},
      {"day": 3, "status": "general"},
      {"day": 4, "status": "general"},
      {"day": 5, "status": "general"},
      {"day": 6, "status": "general"},
      {"day": 7, "status": "general"},
      {"day": 8, "status": "present"},
      {"day": 9, "status": "present"},
      {"day": 10, "status": "present"},
      {"day": 11, "status": "absent"},
      {"day": 12, "status": "present"},
      {"day": 13, "status": "general"},
      {"day": 14, "status": "general"},
      {"day": 15, "status": "present"},
      {"day": 16, "status": "present"},
      {"day": 17, "status": "present"},
      {"day": 18, "status": "present"},
      {"day": 19, "status": "absent"},
      {"day": 20, "status": "general"},
      {"day": 21, "status": "general"},
      {"day": 22, "status": "present"},
      {"day": 23, "status": "present"},
      {"day": 24, "status": "present"},
      {"day": 25, "status": "present"},
      {"day": 26, "status": "present"},
      {"day": 27, "status": "general"},
      {"day": 28, "status": "general"},
      {"day": 29, "status": "present"},
      {"day": 30, "status": "present"},
      {"day": 31, "status": "general"},
      {"day": 1, "status": "general"},
      {"day": 2, "status": "general"},
      {"day": 3, "status": "general"}
    ]
  }
  ''';

  late Map<String, dynamic> attendanceData;

  @override
  void initState() {
    super.initState();
    // Parse the JSON data when the widget initializes
    attendanceData = json.decode(sampleJsonData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildAttendanceWidget(),
      ),
    );
  }

  Widget _buildAttendanceWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Attendance',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Details',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Month and Year
          Text(
            '${attendanceData['month']}, ${attendanceData['year']}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Week days header
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _WeekDayText('M'),
              _WeekDayText('T'),
              _WeekDayText('W'),
              _WeekDayText('T'),
              _WeekDayText('F'),
              _WeekDayText('S'),
              _WeekDayText('S'),
            ],
          ),
          const SizedBox(height: 12),

          // Calendar grid
          _buildCalendarGrid(),
          const SizedBox(height: 20),

          // Legend
          _buildAttendanceLegend(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    List<dynamic> days = attendanceData['days'];

    // Group days into weeks (each week has 7 days)
    List<List<dynamic>> weeks = [];
    List<dynamic> currentWeek = [];

    for (var day in days) {
      currentWeek.add(day);

      if (currentWeek.length == 7) {
        weeks.add(currentWeek);
        currentWeek = [];
      }
    }

    // Add remaining days if any
    if (currentWeek.isNotEmpty) {
      weeks.add(currentWeek);
    }

    return Column(
      children: weeks.map((week) => _buildCalendarRow(week)).toList(),
    );
  }

  Widget _buildCalendarRow(List<dynamic> weekDays) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekDays.map((day) => _buildDayCell(day)).toList(),
    );
  }

  Widget _buildDayCell(Map<String, dynamic> day) {
    Color getStatusColor() {
      switch (day['status']) {
        case 'present':
          return Colors.green;
        case 'absent':
          return Colors.red;
        case 'general':
        default:
          return Colors.grey.withOpacity(0.3);
      }
    }

    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: getStatusColor(),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          day['day'].toString().padLeft(2, '0'),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: day['status'] == 'general' ? Colors.black87 : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem(Colors.green, 'Present'),
        _buildLegendItem(Colors.red, 'Absent'),
        _buildLegendItem(Colors.grey.withOpacity(0.3), 'General'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _WeekDayText extends StatelessWidget {
  final String text;

  const _WeekDayText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.grey,
      ),
    );
  }
}

// If you want to use this page directly, add this main function:
/*
void main() {
  runApp(MaterialApp(
    home: AttendancePage(),
  ));
}
*/
