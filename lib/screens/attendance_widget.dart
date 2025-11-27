// lib/screens/attendance_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  // ------------------- Exact colors from screenshot -------------------
  static const Color colorPresent = Color(0xFF2ECC71); // green
  static const Color colorAbsent = Color(0xFFF2545B); // red
  static const Color colorHalf = Color(0xFFF39C12); // orange
  static const Color colorHoliday = Color(0xFFF0F4F8); // blue
  static const Color pageBg = Color(0xFFF8F9FA); // lighter background
  static const Color cardBg = Colors.white;
  static const Color progressBg = Color(0xFFE8F4FE);
  static const Color progressValue = Color(0xFF3498DB); // matching blue
  static const Color percentBadge = Color(0xFFE8F4FE);
  static const Color percentTextColor = Color(0xFF3498DB);
  static const Color holidayCard = Color(0xFFE8F4FE);
  static const Color holidayIcon = Color(0xFF3498DB);
  static const Color borderColor = Color(0xFFE0E0E0);
  // ---------------------------------------------------------------------------

  // Sample JSON (replace with backend response later)
  final String sampleJsonData = '''
  {
    "attendancePercent": "92%",
    "presentDays": 178,
    "totalDays": 194,
    "month": "November",
    "year": 2024,
    "holidays": [
      {"date": "2024-11-01", "title": "Karnataka Rajyotsava"},
      {"date": "2024-11-01", "title": "Gandhi Jayanthi"},
      {"date": "2024-11-16", "title": "School Holiday"}
    ],
    "days": {
      "2024-11-01": "holiday",
      "2024-11-02": "present",
      "2024-11-03": "present",
      "2024-11-04": "present",
      "2024-11-05": "present",
      "2024-11-06": "present",
      "2024-11-07": "present",
      "2024-11-08": "present",
      "2024-11-09": "present",
      "2024-11-10": "present",
      "2024-11-11": "present",
      "2024-11-12": "present",
      "2024-11-13": "present",
      "2024-11-14": "present",
      "2024-11-15": "present",
      "2024-11-16": "holiday",
      "2024-11-17": "present",
      "2024-11-18": "present",
      "2024-11-19": "present",
      "2024-11-20": "present",
      "2024-11-21": "present",
      "2024-11-22": "present",
      "2024-11-23": "present",
      "2024-11-24": "present",
      "2024-11-25": "halfday",
      "2024-11-26": "present",
      "2024-11-27": "absent",
      "2024-11-28": "present",
      "2024-11-29": "present",
      "2024-11-30": "holiday"
    }
  }
  ''';

  late final Map<String, dynamic> _data;
  DateTime _focusedDay = DateTime(2024, 11, 1);
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _data = json.decode(sampleJsonData);
    _selectedDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
  }

  String _dateKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String? _statusFor(DateTime day) {
    final key = _dateKey(day);
    final days = (_data['days'] as Map<String, dynamic>? ?? {});
    return days.containsKey(key) ? days[key] as String : null;
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'present':
        return colorPresent;
      case 'absent':
        return colorAbsent;
      case 'halfday':
        return colorHalf;
      case 'holiday':
        return colorHoliday;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 24),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        title: const Text(
          'Attendance',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            _overallAttendanceCard(),
            const SizedBox(height: 20),
            _calendarContainer(),
            const SizedBox(height: 20),
            _buildLegendRow(),
            const SizedBox(height: 20),
            _holidayPanel(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _overallAttendanceCard() {
    final percentText = _data['attendancePercent'] as String? ?? '0%';
    final present = _data['presentDays'] ?? 0;
    final total = _data['totalDays'] ?? 1;
    final progress = (present / (total == 0 ? 1 : total)).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5EBF3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overall Attendance',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15.5,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 14),

          // ---- PROGRESS BAR ----
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFFE7EEF7), // progress background
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E88E5), // progress fill color
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Percentage bubble
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F3FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  percentText,
                  style: const TextStyle(
                    color: Color(0xFF1E88E5),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              // Days count with small dot preceding it
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E88E5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                    '$present / $total days',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
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

  Widget _calendarContainer() {
    final monthTitle = '${_data['month'] ?? ''} ${_data['year'] ?? ''}';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with month and navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                monthTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  _navButton(Icons.chevron_left, () {
                    setState(() {
                      _focusedDay = DateTime(
                        _focusedDay.year,
                        _focusedDay.month - 1,
                        1,
                      );
                    });
                  }),
                  const SizedBox(width: 8),
                  _navButton(Icons.chevron_right, () {
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
          ),

          const SizedBox(height: 20),

          // Week days header
          _buildWeekDays(),

          const SizedBox(height: 10),

          // Calendar grid
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _navButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor),
        ),
        child: Icon(icon, size: 18, color: Colors.black54),
      ),
    );
  }

  Widget _buildWeekDays() {
    const weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekDays.map((day) {
        return SizedBox(
          width: 32,
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);

    // correct weekday start (we want Monday->0 .. Sunday->6)
    final int firstWeekdayIndex = (firstDay.weekday + 6) % 7; // Monday=0
    List<Widget> cells = [];

    // add empty slots before first day
    for (int i = 0; i < firstWeekdayIndex; i++) {
      cells.add(const SizedBox(width: 32, height: 32));
    }

    // add actual day cells
    for (int d = 1; d <= lastDay.day; d++) {
      final current = DateTime(_focusedDay.year, _focusedDay.month, d);
      final status = _statusFor(current);
      final isSelected =
          _selectedDay != null &&
          _selectedDay!.year == current.year &&
          _selectedDay!.month == current.month &&
          _selectedDay!.day == current.day;
      cells.add(_calendarDay(d, status, isSelected, current));
    }

    // pad trailing empty cells to complete final week
    while (cells.length % 7 != 0) {
      cells.add(const SizedBox(width: 32, height: 32));
    }

    // build rows of 7
    List<Widget> rows = [];
    for (int i = 0; i < cells.length; i += 7) {
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: cells.sublist(i, i + 7),
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _calendarDay(int day, String? status, bool isSelected, DateTime date) {
    // Default: white background + dark text
    Color bgColor = Colors.white;
    Color textColor = Colors.black87;
    Color border = Colors.transparent;

    // For filled style (present/absent/halfday) we fill the cell color and make text white
    if (status == 'present' || status == 'absent' || status == 'halfday') {
      bgColor = _statusColor(status);
      textColor = Colors.black;
    } else if (status == 'holiday') {
      // Holiday: light-blue fill with darker blue text (or white if you prefer)
      bgColor = colorHoliday.withOpacity(0.95);
      textColor = Colors.black;
    } else if (status == 'absent') {
      bgColor = colorAbsent;
      textColor = Colors.white;
    }else if(status == 'halfday'){
      bgColor = colorHalf;
      textColor = Colors.white;
    }

    if (isSelected) {
      border = progressValue;
    }

    return GestureDetector(
      onTap: () => setState(() => _selectedDay = date),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? border : const Color(0xFFF0F3F6),
            width: isSelected ? 2 : 1.0,
          ),
          boxShadow: [
            if (status != null)
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Center(
          child: Text(
            '$day',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _legendItem(colorPresent, 'Present'),
        _legendItem(colorAbsent, 'Absent'),
        _legendItem(colorHalf, 'Half day'),
        _legendItem(colorHoliday, 'Holiday'),
      ],
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _holidayPanel() {
    final holidays = (_data['holidays'] as List<dynamic>? ?? []);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: holidays.map((h) {
        final date = h['date'] as String? ?? '';
        final title = h['title'] as String? ?? '';
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: holidayCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: holidayIcon.withOpacity(0.18)),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: holidayIcon, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
              Text(
                _formatShortDate(date),
                style: TextStyle(
                  color: holidayIcon,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatShortDate(String isoDate) {
    try {
      final d = DateTime.parse(isoDate);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[d.month - 1]} ${d.day}';
    } catch (e) {
      return isoDate;
    }
  }
}
