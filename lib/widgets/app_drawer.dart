import 'package:flutter/material.dart';
import 'package:skuteq_app/components/shared_app_head.dart';
import 'package:skuteq_app/helpers/invoice_storage.dart';
import 'package:skuteq_app/screens/select_child_page.dart';
import 'package:skuteq_app/screens/login_page.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:skuteq_app/screens/settings_page.dart';
import 'package:skuteq_app/services/amplify_auth_service.dart';
import '../screens/profile_page.dart';
import '../screens/faq_page.dart';
import '../screens/about_skuteq_page.dart';

String capitalizeName(String value) {
  if (value.isEmpty) return value;
  return value
      .toLowerCase()
      .split(' ')
      .where((e) => e.isNotEmpty)
      .map((e) => e[0].toUpperCase() + e.substring(1))
      .join(' ');
}

class AppDrawer extends StatefulWidget {
  final Map<String, dynamic> parentData;

  const AppDrawer({super.key, required this.parentData});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isSigningOut = false;

  @override
  Widget build(BuildContext context) {
    final name = capitalizeName(widget.parentData['name'] ?? 'Parent');
    final parentId = widget.parentData['parentId'] ?? '—';
    final avatarUrl = widget.parentData['avatarUrl'] ?? '';

    const Color logoutRed = Color(0xFFE24B4B);
    const Color pageBg = Color(0xFFEAF4FF);

    return Scaffold(
      backgroundColor: pageBg,
      appBar: SharedAppHead(title: "", showDrawer: false, showBack: true),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Profile
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              margin: const EdgeInsets.only(top: 12),
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
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Parent ID P-$parentId",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _actionCard(
                    icon: Icons.sync,
                    label: "Switch Child",
                    onTap: () async {
                      final students = await InvoiceStorage.getStudentsData();

                      if (!mounted) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SelectChildPage(students: students),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _actionCard(
                    icon: Icons.person_outline,
                    label: "My Profile",
                    onTap: () async {
                      final students = await InvoiceStorage.getStudentsData();

                      if (!mounted) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfilePage(
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            _listTile(
              icon: Icons.settings_outlined,
              title: "Settings",
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (_) => const SettingsPage()),
                // );
              },
            ),
            _listTile(
              icon: Icons.help_outline,
              title: "FAQs",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FaqPage()),
                );
              },
            ),
            _listTile(
              icon: Icons.info_outline,
              title: "About Skuteq",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutSkuteqPage()),
                );
              },
            ),

            // const Spacer(),

            /// Logout Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon: _isSigningOut
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.logout),
                  label: Text(
                    _isSigningOut ? "Logging out..." : "Logout",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: logoutRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isSigningOut ? null : _handleLogout,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Logout handler
  Future<void> _handleLogout() async {
    setState(() => _isSigningOut = true);

    try {
      print("➡️ Logout button pressed");

      await AmplifyAuthService().signOut(); // ✅ CALL YOUR LOGGING FUNCTION
      await InvoiceStorage.clearAll();

      print("➡️ Navigating to Login page");

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      print("❌ Logout flow failed: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Logout failed. Try again")));
    } finally {
      if (mounted) {
        setState(() => _isSigningOut = false);
      }
    }
  }

  /// 🔹 Action Card
  Widget _actionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE6EEF6)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 List Tile
  Widget _listTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE6EEF6)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
