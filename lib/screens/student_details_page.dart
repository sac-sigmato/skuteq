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
  bool _isLoading = true;

  static const Color pageBg = Color(0xFFF6FAFF);
  static const Color cardBorder = Color(0xFFE6EEF6);
  static const Color muted = Color(0xFF9AA6B2);
  static const Color skeleton = Color(0xFFE9EEF5);

  Map<String, dynamic> get student => widget.studentData['data'] ?? {};
  Map<String, dynamic> get mother => student['is_mother_details'] == true
      ? student['mother_details'] ?? {}
      : {};
  Map<String, dynamic> get father => student['is_father_details'] == true
      ? student['father_details'] ?? {}
      : {};

  @override
  void initState() {
    super.initState();

    /// simulate API / processing delay
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

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
    if (raw == null || raw.trim().isEmpty) return '';
    if (raw.startsWith('http')) return raw;
    return 'https://dev-cdn.skuteq.net/public/$raw';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      appBar: SharedAppHead(
        title: "Student Details",
        showDrawer: false,
        showBack: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                0,
                12,
                0,
                MediaQuery.of(context).padding.bottom + 16,
              ),
              child: Column(
                children: [
                  _isLoading ? _profileSkeleton() : _profileCard(),
                  const SizedBox(height: 18),
                  _isLoading ? _segmentSkeleton() : _segmentedToggle(),
                  const SizedBox(height: 16),
                  _isLoading
                      ? _detailsSkeleton()
                      : _detailsCard(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- REAL UI ----------------

  Widget _profileCard() {
    return Container(
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
            backgroundImage: _resolveImageUrl(student['image_url']).isNotEmpty
                ? NetworkImage(_resolveImageUrl(student['image_url']))
                : null,
            child: _resolveImageUrl(student['image_url']).isEmpty
                ? const Icon(Icons.person, size: 28)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['full_name'] ?? '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "ID ${student['student_id'] ?? '-'}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- SKELETONS ----------------

  Widget _profileSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: [
          _skelCircle(56),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _skelLine(140),
                const SizedBox(height: 8),
                _skelLine(90),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _segmentSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: List.generate(
          3,
          (_) => Expanded(child: Center(child: _skelLine(60))),
        ),
      ),
    );
  }

  Widget _detailsSkeleton() {
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
        children: List.generate(
          6,
          (_) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _skelField(),
          ),
        ),
      ),
    );
  }

  Widget _skelField() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: skeleton,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _skelLine(double width) {
    return Container(
      height: 12,
      width: width,
      decoration: BoxDecoration(
        color: skeleton,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _skelCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: skeleton, shape: BoxShape.circle),
    );
  }

  // ---------------- DATA UI ----------------

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

  Widget _segmentItem(
    String label,
    int index, {
    bool enabled = true,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final selected = _selectedSegment == index;
    return Expanded(
      child: InkWell(
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
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: enabled
                  ? (selected
                        ? const Color(0xFF0B2A4A)
                        : const Color(0xFF7A8AAA))
                  : const Color(0xFFB0B8C4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _divider() =>
      Container(width: 1, height: double.infinity, color: cardBorder);

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
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
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
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
          Text(
            value?.isNotEmpty == true ? value! : '-',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
