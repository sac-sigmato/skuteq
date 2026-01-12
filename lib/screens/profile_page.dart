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

  // UI colors
  static const Color _pageBg = Color(0xFFF6FAFF);
  static const Color _headerBg = Color(0xFFEAF4FF);
  static const Color _cardBorder = Color(0xFFE7EFF7);
  static const Color _titleBlue = Color(0xFF244A6A);
  static const Color _muted = Color(0xFF7A8AAA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      body: Column(
        children: [
          Container(height: 20),
          /// 🔹 HEADER INSIDE BODY (MATCH SS)
          Container(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.black87),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    const Text(
                      'My Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48), // balance back button
                  ],
                ),
              ),
            ),
          ),

          /// 🔹 GAP BELOW HEADER (VISIBLE IN SS)
          Container(height: 14),

          /// 🔹 PAGE CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  /// Profile summary card
                  Container(
                    padding: const EdgeInsets.all(12),
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
                                _profile['name']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: _titleBlue,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _profile['subtitle']!,
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

                  /// Profile fields
                  _card(
                    children: [
                      _field('First Name', _profile['firstName']!),
                      _field('Middle Name', _profile['middleName']!),
                      _field('Last Name', _profile['lastName']!),
                      _field('Email Address', _profile['email']!),
                      _field('Mobile Number', _profile['mobile']!),
                      _field('PAN', _profile['pan']!),
                      _field('Aadhaar No.', _profile['aadhaar']!),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// Linked children
                  _card(
                    title: 'Linked children',
                    children: _children
                        .map((c) => _childTile(context, c))
                        .toList(),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Reusable Card
  Widget _card({String? title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ),
          ],
          ...children,
        ],
      ),
    );
  }

  /// 🔹 Field row
  Widget _field(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
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
                  color: Color(0xFF7A8AAA),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value.isNotEmpty ? value : '-',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Child tile
  Widget _childTile(BuildContext context, Map<String, String> child) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _cardBorder),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(child['avatar']!),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child['name']!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    child['meta']!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: _muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}
