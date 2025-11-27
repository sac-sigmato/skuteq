// lib/screens/profile_page.dart
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // sample data
  final Map<String, String> _profile = const {
    'name': 'Rohit Sharma',
    'subtitle': 'Parent ID P-3021',
    'firstName': 'Abhi Sharma',
    'middleName': 'Odds',
    'lastName': 'Sdfsdf',
    'email': 'kjcdks@jdkf.com',
    'mobile': '849 373 7373',
    'pan': 'DSGHB3456H',
    'aadhaar': '-',
  };

  final List<Map<String, String>> _children = const [
    {
      'name': 'Aarav Sharma',
      'meta': 'Grade 5 • Sec B • Roll 17',
      'avatar': 'https://i.pravatar.cc/150?img=32',
    },
    {
      'name': 'Anaya Sharma',
      'meta': 'Grade 2 • Sec A • Roll 08',
      'avatar': 'https://i.pravatar.cc/150?img=47',
    },
  ];

  // UI colors (match previous screens)
  static const Color _pageBg = Color(0xFFF5F8FB);
  static const Color _cardBorder = Color(0xFFE7EFF7);
  static const Color _titleBlue = Color(0xFF244A6A);
  static const Color _muted = Color(0xFF9FA8B2);

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

  Widget _childTile(BuildContext context, Map<String, String> child) {
    return InkWell(
      onTap: () {
        // navigate to child profile / details
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Tapped ${child['name']}')));
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _cardBorder),
        ),
        child: Row(
          children: [
            // avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _cardBorder),
              ),
              child: ClipOval(
                child: Image.network(
                  child['avatar'] ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.person, color: _titleBlue),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // name + meta
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: _titleBlue,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    child['meta'] ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      color: _muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.black38),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // unwrap sample map to use values (keeps code simple)
    final name = _profile['name']!;
    final subtitle = _profile['subtitle']!;

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
          'My Profile',
          style: TextStyle(
            color: _titleBlue,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Top card: avatar / name / parent id
                Container(
                  width: double.infinity,
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
                            'https://i.pravatar.cc/150?img=12',
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
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: _titleBlue,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                fontSize: 12,
                                color: _muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Profile fields card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // title omitted (screen shows not in this card)
                      _fieldRow('First Name', _profile['firstName'] ?? ''),
                      _fieldRow('Middle Name', _profile['middleName'] ?? ''),
                      _fieldRow('Last Name', _profile['lastName'] ?? ''),
                      _fieldRow('Email Address', _profile['email'] ?? ''),
                      _fieldRow('Mobile Number', _profile['mobile'] ?? ''),
                      _fieldRow('PAN', _profile['pan'] ?? ''),
                      _fieldRow('Aadhaar No.', _profile['aadhaar'] ?? ''),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Linked children card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 8),
                        child: Text(
                          'Linked children',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: _titleBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // children list
                      ..._children.map((c) => _childTile(context, c)).toList(),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
