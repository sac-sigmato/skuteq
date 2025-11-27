// lib/screens/student_details_page.dart
import 'package:flutter/material.dart';

class StudentDetailsPage extends StatefulWidget {
  const StudentDetailsPage({super.key});

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  int _selectedSegment = 0; // 0=Student,1=Mother,2=Father

  // Colors tuned to match screenshots
  static const Color _pageBg = Color(0xFFF5F8FB);
  static const Color _cardBorder = Color(0xFFE7EFF7);
  static const Color _titleBlue = Color(0xFF244A6A);
  static const Color _accentBlue = Color(0xFF2E9EE6);
  static const Color _muted = Color(0xFF9FA8B2);

  // Sample grouped data for each segment
  final Map<String, Map<String, String>> _people = {
    'student': {
      'firstName': 'Array ',
      'middleName': '',
      'lastName': 'Sharma',
      'dateOfBirth': 'Oct 18, 2005',
      'bloodGroup': 'A+',
      'gender': 'Male',
      'admissionDate': 'Jun 01, 2025',
      'email': 'neha@example.com',
      'mobile': '849 373 7373',
      'pan': 'DSGHB3456H',
      'aadhaar': '—',
    },
    'mother': {
      'firstName': 'Neha ',
      'middleName': '',
      'lastName': 'Shamani',
      'email': 'neha@example.com',
      'mobile': '849 474 7474',
      'pan': 'DSGHB6789H',
      'aadhaar': '—',
    },
    'father': {
      'firstName': 'Abhi ',
      'middleName': '',
      'lastName': 'Sharma',
      'email': 'abhi@example.com',
      'mobile': '849 373 7373',
      'pan': 'DSGHB3456H',
      'aadhaar': '—',
    },
  };

  @override
  Widget build(BuildContext context) {
    final currentKey = _selectedSegment == 0
        ? 'student'
        : (_selectedSegment == 1 ? 'mother' : 'father');
    final data = _people[currentKey]!;

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
          'Student Details',
          style: TextStyle(
            color: _titleBlue,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: Column(
            children: [
              // Avatar / name / id card
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _cardBorder),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _cardBorder),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          'https://i.pravatar.cc/150?img=47',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.person, color: _titleBlue),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Aaraya Sharma',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: _titleBlue,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'ID 1254',
                            style: TextStyle(fontSize: 12, color: _muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Segmented control
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _cardBorder),
                ),
                child: Row(
                  children: [
                    _segmentButton('Student', 0),
                    _segmentButton('Mother', 1),
                    _segmentButton('Father', 2),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Content area (scrollable)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Details card (title depends on selected segment)
                      _detailsCard(
                        title: _selectedSegment == 0
                            ? 'Basic Information'
                            : (_selectedSegment == 1
                                  ? 'Mother Details'
                                  : 'Father Details'),
                        children: _selectedSegment == 0
                            ? [
                                _fieldRow(
                                  'First Name',
                                  data['firstName'] ?? '',
                                ),
                                _fieldRow(
                                  'Middle Name',
                                  data['middleName'] ?? '',
                                ),
                                _fieldRow('Last Name', data['lastName'] ?? ''),
                                _fieldRow(
                                  'Date of Birth',
                                  data['dateOfBirth'] ?? '',
                                ),
                                _fieldRow(
                                  'Blood Group',
                                  data['bloodGroup'] ?? '',
                                ),
                                _fieldRow('Gender', data['gender'] ?? ''),
                              ]
                            : [
                                _fieldRow(
                                  'First Name',
                                  data['firstName'] ?? '',
                                ),
                                _fieldRow(
                                  'Middle Name',
                                  data['middleName'] ?? '',
                                ),
                                _fieldRow('Last Name', data['lastName'] ?? ''),
                                _fieldRow('Email Address', data['email'] ?? ''),
                                _fieldRow(
                                  'Mobile Number',
                                  data['mobile'] ?? '',
                                ),
                                _fieldRow('PAN', data['pan'] ?? ''),
                                _fieldRow('Aadhaar No.', data['aadhaar'] ?? ''),
                              ],
                      ),

                      // If Student, show Enrollment card below
                      if (_selectedSegment == 0) ...[
                        const SizedBox(height: 12),
                        _detailsCard(
                          title: 'Enrollment',
                          children: [
                            _fieldRow(
                              'Date of Admission',
                              data['admissionDate'] ?? '',
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 20),
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

  // Segment button builder
  Widget _segmentButton(String label, int index) {
    final bool selected = _selectedSegment == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedSegment = index),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF0F7FF) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _cardBorder),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: selected ? _titleBlue : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  // Generic details card used for Basic / Mother / Father / Enrollment
  Widget _detailsCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6, bottom: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: _titleBlue,
              ),
            ),
          ),
          const SizedBox(height: 4),
          ...children,
        ],
      ),
    );
  }

  // Pill-like label/value row
  Widget _fieldRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value.isNotEmpty ? value : '-',
            style: const TextStyle(
              fontSize: 13,
              color: _titleBlue,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
