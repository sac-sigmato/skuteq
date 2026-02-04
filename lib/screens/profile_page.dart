import 'package:flutter/material.dart';
import 'package:skuteq_app/components/shared_app_head.dart';
import 'package:skuteq_app/helpers/invoice_storage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // UI colors
  static const Color _pageBg = Color(0xFFEAF4FF);
  static const Color _cardBorder = Color(0xFFE7EFF7);
  static const Color _titleBlue = Color(0xFF244A6A);
  static const Color _muted = Color(0xFF7A8AAA);

  String safeText(dynamic value) {
    if (value == null) return '-';
    final v = value.toString().trim();
    return v.isEmpty ? '-' : v;
  }

  String buildChildMeta(Map<String, dynamic> child) {
    final studentId = (child['studentDbId'] ?? '').toString().trim();

    if (studentId.isEmpty) return '-';

    return studentId.toUpperCase(); // ✅ CAPITAL
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        InvoiceStorage.getParentData(),
        InvoiceStorage.getLinkedChildren(),
        InvoiceStorage.getStudent_Id(),
      ]),
      builder: (context, snapshot) {
        // 🔄 Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ❌ No data
        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            backgroundColor: _pageBg,
            body: const Center(child: Text("No profile data found")),
          );
        }

        // ✅ Extract data
        final parentData = snapshot.data![0] as Map<String, dynamic>?;
        final List<Map<String, dynamic>> allChildren =
            snapshot.data![1] as List<Map<String, dynamic>>;
        final String? selectedStudentId = snapshot.data![2] as String?;

        final List<Map<String, dynamic>> children = allChildren.where((child) {
          final childId =
              child['studentDbId']?.toString() ??
              child['_id']?.toString() ??
              child['student_id']?.toString();

          return childId != selectedStudentId;
        }).toList();

        if (parentData == null) {
          return Scaffold(
            backgroundColor: _pageBg,
            body: const Center(child: Text("Parent data missing")),
          );
        }

        final String name = parentData['name']?.toString() ?? '';
        final String email = parentData['email']?.toString() ?? '';
        final String mobile = parentData['mobile']?.toString() ?? '';
        final String avatarUrl = parentData['avatarUrl']?.toString() ?? '';
        final String subtitle = parentData['parentId'] != null
            ? "Parent ID ${parentData['parentId']}"
            : "";

        return Scaffold(
          backgroundColor: _pageBg,

          // ✅ Common Header
          appBar: SharedAppHead(
            title: "My Profile",
            showDrawer: false,
            showBack: true,
          ),
          body: Column(
            children: [
              // const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(0),
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
                          avatarUrl,
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
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: const TextStyle(fontSize: 12, color: _muted,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// 🔹 CONTENT
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: [
                      /// Profile summary card
                      const SizedBox(height: 14),

                      /// Profile fields
                      _card(
                        children: [
                          _field('First Name', safeText(parentData['name'])),
                          _field(
                            'Middle Name',
                            safeText(parentData['middle_name']),
                          ),
                          _field(
                            'Last Name',
                            safeText(parentData['last_name']),
                          ),
                          _field(
                            'Email Address',
                            safeText(parentData['email']),
                          ),
                          _field(
                            'Mobile Number',
                            safeText(parentData['mobile']),
                          ),
                          _field('PAN', safeText(parentData['pan'])),
                          _field(
                            'Aadhaar No.',
                            safeText(parentData['aadhaar']),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      /// Linked children (FROM STORAGE)
                      if (children.isNotEmpty)
                        _card(
                          title: 'Linked children',
                          children: children.map((child) {
                            return _childTile(
                              context,
                              name: safeText(child['name']),
                              meta: buildChildMeta(child),
                              avatar: child['avatarUrl'],
                            );
                          }).toList(),
                        ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black
                ),
              ),
            ),
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value.isNotEmpty ? value : '-',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ],
      ),
    );
  }

  /// 🔹 Child tile
  Widget _childTile(
    BuildContext context, {
    required String name,
    required String meta,
    dynamic avatar,
  }) {
    final String avatarUrl = avatar == null || avatar.toString().trim().isEmpty
        ? ''
        : avatar.toString();

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
              backgroundColor: const Color(0xFFEAF0F6),
              backgroundImage: avatarUrl.isNotEmpty
                  ? NetworkImage(avatarUrl)
                  : null,
              child: avatarUrl.isEmpty
                  ? const Icon(Icons.person, color: Colors.black54, size: 22)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    meta,
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
