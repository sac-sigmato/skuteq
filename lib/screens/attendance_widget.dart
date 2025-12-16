import 'dart:convert';
import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  // ---------------- COLORS (MATCH SS) ----------------
  static const Color pageBg = Color(0xFFF6F7FB);
  static const Color cardBg = Colors.white;

  static const Color presentColor = Color(0xFF46B670);
  static const Color absentColor = Color(0xFFF07D7B);
  static const Color halfDayColor = Color(0xFFFFD856);
  static const Color holidayColor = Color(0xFFEEF2F6);
  static const Color defaultDayColor = Color(0xFFF1F4F8);

  static const Color primaryBlue = Color(0xFF1E6FD8);
  static const Color borderColor = Color(0xFFE6EEF6);
  // --------------------------------------------------

  // ---------------- SAMPLE JSON (API READY) ----------------
  final String sampleJsonData = '''
  {
    "attendancePercent": "92%",
    "presentDays": 178,
    "totalDays": 194,
    "holidays": [
      {"date": "2024-11-01", "title": "Karnataka Rajyotsava"},
      {"date": "2024-11-01", "title": "Gandhi Jayanthi"},
      {"date": "2024-11-16", "title": "School Holiday"}
    ],
    "days": {
      "2024-11-02": "present",
      "2024-11-03": "present",
      "2024-11-04": "present",
      "2024-11-05": "present",
      "2024-11-06": "absent",
      "2024-11-07": "present",
      "2024-11-08": "present",
      "2024-11-09": "halfday",
      "2024-11-16": "holiday",
      "2024-11-27": "absent"
    }
  }
  ''';

  late final Map<String, dynamic> _data;
  DateTime _focusedDay = DateTime(2024, 11, 1);

  @override
  void initState() {
    super.initState();
    _data = json.decode(sampleJsonData);
  }

  String _dateKey(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  String? _statusFor(DateTime d) {
    final days = _data['days'] as Map<String, dynamic>? ?? {};
    return days[_dateKey(d)];
  }

  String _monthName(int month) {
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
    return months[month - 1];
  }

  // ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      body: Column(
        children: [
          // ---------- HEADER ----------
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(8,8,8,8),
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
                        "Attendance",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),

          // ---------- GAP BELOW HEADER ----------
          Container(height: 14, color: pageBg),

          // ---------- CONTENT ----------
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _overallAttendanceCard(),
                  const SizedBox(height: 16),
                  _calendarCombinedCard(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- OVERALL ATTENDANCE CARD ----------------

  Widget _overallAttendanceCard() {
    final int present = _data['presentDays'];
    final int total = _data['totalDays'];
    final double progress = present / total;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Overall Attendance",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: progress,
              backgroundColor: const Color(0xFFE7EEF7),
              valueColor: const AlwaysStoppedAnimation(primaryBlue),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F0FA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "92%",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  const CircleAvatar(radius: 3, backgroundColor: primaryBlue),
                  const SizedBox(width: 8),
                  Text(
                    "$present / $total days",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- CALENDAR CARD ----------------

  Widget _calendarCombinedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _calendarHeader(),
          const SizedBox(height: 14),
          _weekDays(),
          const SizedBox(height: 8),
          _calendarGrid(),
          const SizedBox(height: 16),
          _legendRow(),
          const SizedBox(height: 16),
          _holidayList(),
        ],
      ),
    );
  }

  Widget _calendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${_monthName(_focusedDay.month)} ${_focusedDay.year}",
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        Row(
          children: [
            _navBtn(Icons.chevron_left, () {
              setState(() {
                _focusedDay = DateTime(
                  _focusedDay.year,
                  _focusedDay.month - 1,
                  1,
                );
              });
            }),
            const SizedBox(width: 8),
            _navBtn(Icons.chevron_right, () {
              setState(() {
                _focusedDay = DateTime(
                  _focusedDay.year,
                  _focusedDay.month + 1,
                  1,
                );
              });
            }),
          ],
        ),
      ],
    );
  }

  Widget _navBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }

  Widget _weekDays() {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days
          .map(
            (d) => SizedBox(
              width: 40,
              child: Text(
                d,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8A94A6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _calendarGrid() {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    final startOffset = (firstDay.weekday + 6) % 7;

    List<Widget> cells = [];

    for (int i = 0; i < startOffset; i++) {
      cells.add(const SizedBox(width: 40, height: 40));
    }

    for (int i = 1; i <= lastDay.day; i++) {
      final date = DateTime(_focusedDay.year, _focusedDay.month, i);
      cells.add(_dayCell(i, _statusFor(date)));
    }

    while (cells.length % 7 != 0) {
      cells.add(const SizedBox(width: 40, height: 40));
    }

    return Column(
      children: List.generate(cells.length ~/ 7, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: cells.sublist(i * 7, i * 7 + 7),
          ),
        );
      }),
    );
  }

  Widget _dayCell(int day, String? status) {
    Color bg = defaultDayColor;
    Color text = Colors.black87;

    switch (status) {
      case 'present':
        bg = presentColor;
        text = Colors.white;
        break;
      case 'absent':
        bg = absentColor;
        text = Colors.white;
        break;
      case 'halfday':
        bg = halfDayColor;
        break;
      case 'holiday':
        bg = holidayColor;
        text = Colors.black54;
        break;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: status == null ? borderColor : Colors.transparent,
        ),
      ),
      child: Center(
        child: Text(
          "$day",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: text,
          ),
        ),
      ),
    );
  }

  // ---------------- LEGEND ----------------

  Widget _legendRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _legendItem(presentColor, "Present"),
        _legendItem(absentColor, "Absent"),
        _legendItem(halfDayColor, "Half day"),
        _legendItem(holidayColor, "Holiday"),
      ],
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF7A869A),
          ),
        ),
      ],
    );
  }

  // ---------------- HOLIDAYS ----------------

  Widget _holidayList() {
    final holidays = _data['holidays'] as List<dynamic>? ?? [];

    return Column(
      children: holidays.map((h) {
        final DateTime date = DateTime.parse(h['date']);
        final String title = h['title'];

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F3FF),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              /// 🔹 PNG ICON CONTAINER
              Container(
                width: 32,
                height: 32,
                padding: const EdgeInsets.all(6),
                
                child: Image.asset(
                  'assets/icon/calendar.png',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(width: 10),

              /// Date text
              Text(
                "Nov ${date.day}",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(width: 14),

              /// Title
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

}
