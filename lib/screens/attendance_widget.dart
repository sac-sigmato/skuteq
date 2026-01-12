import 'package:flutter/material.dart';
import 'package:skuteq_app/helpers/invoice_storage.dart';


class AttendancePage extends StatefulWidget {
  /// initial month data (current month ideally)
  final Map<String, dynamic> apiResponse;

  /// ✅ Pass your fetch function from service
  /// Example:
  /// (month, year) => attendanceService.fetchYearWiseAttendance(..., month: month, year: year)
  final Future<Map<String, dynamic>> Function(String month, int year)
  fetchAttendance;

  const AttendancePage({
    super.key,
    required this.apiResponse,
    required this.fetchAttendance,
  });

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  // ---------------- COLORS ----------------
  static const Color pageBg = Color(0xFFF6FAFF);
  static const Color cardBg = Colors.white;

  static const Color presentColor = Color(0xFF46B670);
  static const Color absentColor = Color(0xFFF07D7B);
  static const Color halfDayColor = Color(0xFFFFD856);
  static const Color holidayColor = Color(0xFFEEF2F6);
  static const Color defaultDayColor = Color(0xFFF1F4F8);

  static const Color primaryBlue = Color(0xFF1E6FD8);
  static const Color borderColor = Color(0xFFE6EEF6);
  // --------------------------------------------------

   Map<String, dynamic> _attendance = {};

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

  int _monthIndex(String monthName) {
    final idx = _months.indexWhere(
      (m) => m.toLowerCase() == monthName.trim().toLowerCase(),
    );
    return idx == -1 ? 1 : (idx + 1); // 1..12
  }

  DateTime _focusedDay = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _currentLimit = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _attendance = _mapApiToUi(widget.apiResponse);
    _initAyLimit();
  }

  Future<void> _initAyLimit() async {
    final ayStatus =
        (await InvoiceStorage.getAyStatus())?.toString() ?? "ongoing";

    final now = DateTime.now();
    DateTime limit = DateTime(now.year, now.month, 1);

    if (ayStatus != "ongoing") {
      final endMonthName = await InvoiceStorage.getAyEndMonth();
      final endYear = await InvoiceStorage.getAyEndYear();

      if (endMonthName != null && endYear != null) {
        final endMonth = _monthIndex(endMonthName);
        limit = DateTime(endYear, endMonth, 1);
      }
    }

    if (!mounted) return;

    setState(() {
      _currentLimit = limit;
      _focusedDay = limit;
    });

    // ✅ Fetch correct month
    await _fetchAndApply(_focusedDay);
  }

  // ---------------- CORE TRANSFORM ----------------
  Map<String, dynamic> _mapApiToUi(Map<String, dynamic> api) {
    final List<dynamic> list = api['data'] ?? [];

    final Map<String, String> daysMap = {};
    double presentCount = 0;

    for (final d in list) {
      final String date = d['date'];

      final String firstHalf = (d['first_half'] ?? '').toLowerCase();
      final String secondHalf = (d['second_half'] ?? '').toLowerCase();

      String finalStatus = 'absent';

      if (firstHalf == 'present' && secondHalf == 'present') {
        finalStatus = 'present';
        presentCount += 1;
      } else if ((firstHalf == 'present' && secondHalf == 'absent') ||
          (firstHalf == 'absent' && secondHalf == 'present')) {
        finalStatus = 'halfday';
        presentCount += 0.5;
      } else if (firstHalf == 'absent' && secondHalf == 'absent') {
        finalStatus = 'absent';
      }

      daysMap[date] = finalStatus;
    }

    final int totalDays = list.length;
    final String percent = totalDays == 0
        ? "0%"
        : "${((presentCount / totalDays) * 100).round()}%";

    return {
      "attendancePercent": percent,
      "presentDays": presentCount,
      "totalDays": totalDays,
      "holidays": api['holidays'] ?? [],
      "days": daysMap,
    };
  }

  // ---------------- HELPERS ----------------
  String _dateKey(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  String _monthName(int month) => _months[month - 1];

  String? _statusFor(DateTime d) {
    final String key = _dateKey(d);
    final String? status = _attendance['days'][key];

    final holidays = _attendance['holidays'];
    if (status == null && holidays is List) {
      if (holidays.contains(key)) return 'holiday';
    }
    return status;
  }

  // ✅ "Future" = beyond limit (current month if ongoing, else AY end month)
  bool _isFutureMonth(DateTime monthStart) {
    return monthStart.isAfter(_currentLimit);
  }

  Future<void> _fetchAndApply(DateTime monthStart) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final monthStr = _monthName(monthStart.month);
      final year = monthStart.year;

      final res = await widget.fetchAttendance(monthStr, year);

      if (!mounted) return;

      setState(() {
        _focusedDay = monthStart;
        _attendance = _mapApiToUi(res);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load attendance: $e")));
    }
  }

  void _goPrev() {
    final prev = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
    _fetchAndApply(prev);
  }

  void _goNext() {
    final next = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);

    // ✅ block beyond limit
    if (_isFutureMonth(next)) return;

    _fetchAndApply(next);
  }


  // ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      body: Column(
        children: [
          _header(),
          const SizedBox(height: 14),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _overallAttendanceCard(),
                  const SizedBox(height: 16),
                  _calendarCard(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- HEADER ----------------

  Widget _header() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
      margin: const EdgeInsets.only(top: 20),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => Navigator.pop(context),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  "Attendance",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  // ---------------- OVERALL CARD ----------------

  Widget _overallAttendanceCard() {
    final double present = _attendance['presentDays'];
    final int total = _attendance['totalDays'];
    final double progress = total == 0 ? 0 : present / total;

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
                child: Text(
                  _attendance['attendancePercent'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                "${present % 1 == 0 ? present.toInt() : present} / $total days",
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
    );
  }

  // ---------------- CALENDAR ----------------

  Widget _calendarCard() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              _calendarHeader(),
              const SizedBox(height: 14),
              _weekDays(),
              const SizedBox(height: 8),
              _calendarGrid(),
              const SizedBox(height: 16),
              _legendRow(),
            ],
          ),
        ),

        // ✅ Loading overlay
        if (_isLoading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.65),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }

  Widget _calendarHeader() {
    final nextMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
final bool nextDisabled = _isFutureMonth(nextMonth) || _isLoading;


    final bool prevDisabled = _isLoading;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${_monthName(_focusedDay.month)} ${_focusedDay.year}",
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        Row(
          children: [
            _navBtn(
              Icons.chevron_left,
              prevDisabled ? null : _goPrev,
              disabled: prevDisabled,
            ),
            const SizedBox(width: 8),
            _navBtn(
              Icons.chevron_right,
              nextDisabled ? null : _goNext,
              disabled: nextDisabled,
            ),
          ],
        ),
      ],
    );
  }

  Widget _navBtn(IconData icon, VoidCallback? onTap, {bool disabled = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(30),
          color: disabled ? const Color(0xFFF3F6FA) : Colors.white,
        ),
        child: Icon(
          icon,
          size: 18,
          color: disabled ? Colors.black26 : Colors.black87,
        ),
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
}
