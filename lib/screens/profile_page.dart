import 'package:flutter/material.dart';
import 'package:skuteq_app/components/shared_app_head.dart';
import 'package:skuteq_app/helpers/invoice_storage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const Color _pageBg = Color(0xFFEAF4FF);
  static const Color _cardBorder = Color(0xFFE7EFF7);
  static const Color _titleBlue = Color(0xFF244A6A);
  static const Color _muted = Color(0xFF7A8AAA);
  static const Color _skeleton = Color(0xFFE9EEF5);

  String safeText(dynamic value) {
    if (value == null) return '-';
    final v = value.toString().trim();
    return v.isEmpty ? '-' : v;
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
        /// ✅ SKELETON LOADING
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _skeletonScaffold();
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            backgroundColor: _pageBg,
            body: const Center(child: Text("No profile data found")),
          );
        }

        final parentData = snapshot.data![0] as Map<String, dynamic>?;
        final List<Map<String, dynamic>> allChildren =
            snapshot.data![1] as List<Map<String, dynamic>>;
        final String? selectedStudentId = snapshot.data![2] as String?;

        if (parentData == null) {
          return Scaffold(
            backgroundColor: _pageBg,
            body: const Center(child: Text("Parent data missing")),
          );
        }

        final children = allChildren.where((child) {
          final childId =
              child['studentDbId']?.toString() ??
              child['_id']?.toString() ??
              child['student_id']?.toString();
          return childId != selectedStudentId;
        }).toList();

        return Scaffold(
          backgroundColor: _pageBg,
          appBar: const SharedAppHead(
            title: "My Profile",
            showDrawer: false,
            showBack: true,
          ),
          body: Column(
            children: [
              _profileHeader(
                name: safeText(parentData['name']),
                subtitle: parentData['parentId'] != null
                    ? "Parent ID ${parentData['parentId']}"
                    : "",
                avatarUrl: parentData['avatarUrl'],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 14),
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
                      if (children.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        _card(
                          title: 'Linked children',
                          children: children.map((child) {
                            return _childTile(
                              name: safeText(child['name']),
                              meta: safeText(child['studentDbId']),
                              avatar: child['avatarUrl'],
                            );
                          }).toList(),
                        ),
                      ],
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

  /// ---------------- SKELETON ----------------

  Widget _skeletonScaffold() {
    return Scaffold(
      backgroundColor: _pageBg,
      appBar: const SharedAppHead(
        title: "My Profile",
        showDrawer: false,
        showBack: true,
      ),
      body: Column(
        children: [
          _skeletonBox(height: 72),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: List.generate(7, (_) => _skeletonField()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _skeletonBox({double height = 20}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: height,
      decoration: BoxDecoration(
        color: _skeleton,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _skeletonField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      height: 44,
      decoration: BoxDecoration(
        color: _skeleton,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  /// ---------------- UI ----------------

  Widget _profileHeader({
    required String name,
    required String subtitle,
    dynamic avatarUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: _skeleton,
            backgroundImage:
                avatarUrl != null && avatarUrl.toString().isNotEmpty
                ? NetworkImage(avatarUrl)
                : null,
            child: avatarUrl == null || avatarUrl.toString().isEmpty
                ? const Icon(Icons.person, color: _titleBlue)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: _muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ...children,
        ],
      ),
    );
  }

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
                color: _muted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value.isNotEmpty ? value : '-',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _childTile({
    required String name,
    required String meta,
    dynamic avatar,
  }) {
    return Container(
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
            backgroundColor: _skeleton,
            backgroundImage: avatar != null && avatar.toString().isNotEmpty
                ? NetworkImage(avatar)
                : null,
            child: avatar == null || avatar.toString().isEmpty
                ? const Icon(Icons.person, size: 22)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
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
    );
  }
}
