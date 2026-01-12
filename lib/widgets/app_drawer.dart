import 'package:flutter/material.dart';
import '../screens/profile_page.dart';
import '../screens/faq_page.dart';
import '../screens/about_skuteq_page.dart';

String capitalizeName(String value) {
  if (value.isEmpty) return value;

  return value
      .toLowerCase()
      .split(' ')
      .where((word) => word.isNotEmpty)
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}
class AppDrawer extends StatelessWidget {
  final Map<String, dynamic> parentData;

  const AppDrawer({super.key, required this.parentData});

  @override
  Widget build(BuildContext context) {
    final String name = parentData['name'] ?? 'Parent';
    final String email = parentData['email'] ?? '';
    final String parentId = parentData['parentId'] ?? '';
    final String avatarUrl = parentData['avatarUrl'] ?? '';

    const Color drawerBg = Color(0xFFF6F7FB);
    const Color logoutRed = Color(0xFFE24B4B);

    return Drawer(
      width: MediaQuery.of(context).size.width,
      backgroundColor: drawerBg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// 🔹 Top Header
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 17),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            /// 🔹 Profile Card
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: avatarUrl.isNotEmpty
                        ? NetworkImage(avatarUrl)
                        : null,
                    child: avatarUrl.isEmpty
                        ? const Icon(Icons.person, color: Colors.black54)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        capitalizeName(name),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        email,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// 🔹 Menu
            _drawerTile(
              context,
              icon: Icons.person_outline,
              title: "My Profile",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
            ),

            _drawerTile(
              context,
              icon: Icons.help_outline,
              title: "FAQs",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FaqPage()),
                );
              },
            ),

            _drawerTile(
              context,
              icon: Icons.info_outline,
              title: "About Skuteq",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutSkuteqPage()),
                );
              },
            ),

            const Spacer(),

            /// 🔹 Logout
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: logoutRed,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  // TODO: logout logic
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6EEF6)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
