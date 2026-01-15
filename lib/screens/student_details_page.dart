import 'package:flutter/material.dart';
import 'package:skuteq_app/components/shared_app_head.dart';

class StudentDetailsPage extends StatefulWidget {
  final Map<String, dynamic> studentData;

  const StudentDetailsPage({super.key, required this.studentData});

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  int _selectedSegment = 0;

  static const Color pageBg = Color(0xFFEAF4FF);
  static const Color cardBorder = Color(0xFFE6EEF6);
  static const Color muted = Color(0xFF9AA6B2);
  static const Color selectedBg = Color(0xFFD0E7FF);

  Map<String, dynamic> get student => widget.studentData['data'] ?? {};
  Map<String, dynamic> get mother => student['is_mother_details'] == true
      ? student['mother_details'] ?? {}
      : {};
  Map<String, dynamic> get father => student['is_father_details'] == true
      ? student['father_details'] ?? {}
      : {};

  String _fmtDate(String? iso) {
    if (iso == null || iso.isEmpty) return '-';
    try {
      final d = DateTime.parse(iso);
      return "${d.day.toString().padLeft(2, '0')} ${_month(d.month)} ${d.year}";
    } catch (_) {
      return '-';
    }
  }

  String _month(int m) => const [
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
  ][m - 1];

  String _resolveImageUrl(String? raw) {
    if (raw == null) return '';
    final url = raw.trim();
    if (url.isEmpty) return '';

    // already full URL
    if (url.startsWith('http')) return url;

    // your CDN case
    return 'https://dev-cdn.skuteq.net/public/$url';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,

      // ✅ Common Header
      appBar: SharedAppHead(
        title: "Student Details",
        showDrawer: false,
        showBack: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  /// PROFILE CARD
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cardBorder),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage:
                              _resolveImageUrl(student['image_url']).isNotEmpty
                              ? NetworkImage(
                                  _resolveImageUrl(student['image_url']),
                                )
                              : null,
                          child: _resolveImageUrl(student['image_url']).isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 28,
                                  color: Colors.black54,
                                )
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student['full_name']?.toString() ?? '-',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "ID ${student['student_id'] ?? '-'}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: muted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  _segmentedToggle(),

                  const SizedBox(height: 16),

                  /// DETAILS
                  _detailsCard(
                    title: _selectedSegment == 0
                        ? "Basic Information"
                        : _selectedSegment == 1
                        ? "Mother Details"
                        : "Father Details",
                    children: _selectedSegment == 0
                        ? _studentFields()
                        : _selectedSegment == 1
                        ? _parentFields(mother)
                        : _parentFields(father),
                  ),

                  if (_selectedSegment == 0)
                    _detailsCard(
                      title: "Enrollment",
                      children: [
                        _field(
                          "Date of Admission",
                          _fmtDate(student['date_of_admission']),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _segmentItem(
    String label,
    int index, {
    bool enabled = true,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final bool selected = _selectedSegment == index;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.horizontal(
          left: isFirst ? const Radius.circular(24) : Radius.zero,
          right: isLast ? const Radius.circular(24) : Radius.zero,
        ),
        onTap: enabled ? () => setState(() => _selectedSegment = index) : null,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFEAF4FF) : Colors.transparent,
            borderRadius: BorderRadius.horizontal(
              left: isFirst ? const Radius.circular(14) : Radius.zero,
              right: isLast ? const Radius.circular(14) : Radius.zero,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: enabled
                  ? (selected
                        ? const Color(0xFF0B2A4A)
                        : const Color(0xFF7A8CA5))
                  : const Color(0xFFB0B8C4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _segmentedToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: [
          _segmentItem("Student", 0, isFirst: true),
          _divider(),
          _segmentItem(
            "Mother",
            1,
            enabled: student['is_mother_details'] == true,
          ),
          _divider(),
          _segmentItem(
            "Father",
            2,
            enabled: student['is_father_details'] == true,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(width: 1, height: double.infinity, color: cardBorder);
  }

  /// SEGMENT
  Widget _segment(String label, int index, {bool enabled = true}) {
    final selected = _selectedSegment == index;

    return Expanded(
      child: GestureDetector(
        onTap: enabled ? () => setState(() => _selectedSegment = index) : null,
        child: Container(
          height: 42,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? selectedBg : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: cardBorder),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: enabled ? Colors.black : Colors.black38,
            ),
          ),
        ),
      ),
    );
  }

  /// DETAILS CARD
  Widget _detailsCard({required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _field(String label, String? value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          Text(
            (value != null && value.isNotEmpty) ? value : '-',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  List<Widget> _studentFields() => [
    _field("First Name", student['first_name']),
    _field("Middle Name", student['middle_name']),
    _field("Last Name", student['last_name']),
    _field("Date of Birth", _fmtDate(student['date_of_birth'])),
    _field("Blood Group", student['blood_group']),
    _field("Gender", student['gender']),
  ];

  List<Widget> _parentFields(Map<String, dynamic> p) {
    if (p.isEmpty) return [_field("Info", "No details available")];
    return [
      _field("First Name", p['first_name']),
      _field("Middle Name", p['middle_name']),
      _field("Last Name", p['last_name']),
      _field("Email", p['email_address']),
      _field("Mobile", p['mobile_number']),
    ];
  }
}
