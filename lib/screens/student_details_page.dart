import 'package:flutter/material.dart';

class StudentDetailsPage extends StatefulWidget {
  final Map<String, dynamic> studentData;

  const StudentDetailsPage({super.key, required this.studentData});

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  int _selectedSegment = 0; // 0=Student,1=Mother,2=Father

  // Colors
  static const Color pageBg = Color(0xFFF6FAFF);
  static const Color cardBorder = Color(0xFFE6EEF6);
  static const Color muted = Color(0xFF9FA8B2);

  // ================= API DATA =================

  Map<String, dynamic> get student => widget.studentData['data'] ?? {};

  Map<String, dynamic> get mother => student['is_mother_details'] == true
      ? (student['mother_details'] ?? {})
      : {};

  Map<String, dynamic> get father => student['is_father_details'] == true
      ? (student['father_details'] ?? {})
      : {};

  String _fmtDate(String? iso) {
    if (iso == null || iso.isEmpty) return '-';
    try {
      final d = DateTime.parse(iso);
      return "${d.day.toString().padLeft(2, '0')} "
          "${_month(d.month)} ${d.year}";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      body: Column(
        children: [
          const SizedBox(height: 20),

          /// 🔹 HEADER
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
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
                        "Student Details",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),

          Container(height: 14, color: pageBg),

          /// 🔹 CONTENT
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// ================= PROFILE CARD =================
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: cardBorder),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey[200],
                          backgroundImage:
                              (student['image_url'] ?? '').isNotEmpty
                              ? NetworkImage(student['image_url'])
                              : null,
                          child: (student['image_url'] ?? '').isEmpty
                              ? const Icon(Icons.person, color: Colors.black54)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student['full_name'] ?? '-',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
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
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ================= SEGMENTS =================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _segment("Student", 0, enabled: true),
                        _segment(
                          "Mother",
                          1,
                          enabled: student['is_mother_details'] == true,
                        ),
                        _segment(
                          "Father",
                          2,
                          enabled: student['is_father_details'] == true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// ================= DETAILS =================
                  _detailsCard(
                    title: _selectedSegment == 0
                        ? 'Basic Information'
                        : _selectedSegment == 1
                        ? 'Mother Details'
                        : 'Father Details',
                    children: _selectedSegment == 0
                        ? _studentFields()
                        : _selectedSegment == 1
                        ? _parentFields(mother)
                        : _parentFields(father),
                  ),

                  if (_selectedSegment == 0) ...[
                    const SizedBox(height: 14),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= FIELD BUILDERS =================

  List<Widget> _studentFields() => [
    _field("First Name", student['first_name']),
    _field("Middle Name", student['middle_name']),
    _field("Last Name", student['last_name']),
    _field("Date of Birth", _fmtDate(student['date_of_birth'])),
    _field("Blood Group", student['blood_group']),
    _field("Gender", student['gender']),
  ];

  List<Widget> _parentFields(Map<String, dynamic> p) {
    if (p.isEmpty) {
      return [_field("Info", "No details available")];
    }

    return [
      _field("First Name", p['first_name']),
      _field("Middle Name", p['middle_name']),
      _field("Last Name", p['last_name']),
      _field("Email Address", p['email_address']),
      _field("Mobile Number", p['mobile_number']),
      _field("PAN", p['pan_number']),
      _field("Aadhaar No.", p['aadhar_number']?['number']),
    ];
  }

  // ================= UI HELPERS =================

  Widget _segment(String label, int index, {bool enabled = true}) {
    final selected = _selectedSegment == index;

    return Expanded(
      child: InkWell(
        onTap: enabled ? () => setState(() => _selectedSegment = index) : null,
        borderRadius: BorderRadius.circular(10),
        child: Opacity(
          opacity: enabled ? 1 : 0.4,
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFF0F7FF) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: cardBorder),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: selected ? Colors.black : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailsCard({required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6, bottom: 8),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _field(String label, String? value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: cardBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            (value != null && value.isNotEmpty) ? value : '-',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
