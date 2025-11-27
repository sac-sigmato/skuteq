// lib/screens/student_dashboard.dart
import 'package:flutter/material.dart';
import 'select_child_page.dart';
import 'profile_page.dart';
import 'attendance_widget.dart';
import 'academic_page.dart';
import 'invoices_page.dart';
import 'receipts_page.dart';
import 'student_details_page.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  String selectedYear = "AY 2024-2025 ( Grade 5 Section B )";
  int currentIndex = 0;

  // <-- user profile (uses your uploaded local path; toolchain will convert it)
  final Map<String, dynamic> userProfile = {
    "name": "Rohit Sharma",
    "parentId": "P-3021",
    "email": "rohit.sharma@example.com",
    // local path you uploaded; your infra will transform to a URL at runtime.
    "avatarUrl": "/mnt/data/e4d92258-e3be-4cd3-87fb-18ece55927a3.png",
  };

  // Dummy data (replace with actual API response)
  final Map<String, dynamic> studentData = {
    "studentInfo": {
      "name": "Aaray Sharma",
      "id": "ID 6986911",
      "school": "VVP School - Maghadha Campus",
      "image": "assets/images/student1.png",
    },
    "stats": {
      "attendance": "92%",
      "academics": "86%",
      "receipts": "12",
      "invoices": "4",
    },
    "years": [
      "AY 2024-2025 ( Grade 5 Section B )",
      "AY 2023-2024 ( Grade 4 Section A )",
    ],
  };

  String _str(String key, [String fallback = ""]) {
    final v = studentData["studentInfo"]?[key];
    return v?.toString() ?? fallback;
  }

  String _stat(String key, [String fallback = "0"]) {
    final v = studentData["stats"]?[key];
    return v?.toString() ?? fallback;
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0E70B8);
    const Color pageBg = Color(0xFFF6F9FB);

    return Scaffold(
      backgroundColor: pageBg,
      drawer: _buildDrawer(context),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
        title: const Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text(
            'Dashboard',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
          children: [
            // Student card (blue rounded card with white avatar ring)
            Container(
              width: double.infinity,
              height: 180,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentDetailsPage(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      // Avatar with white ring
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            _str('image'),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.white,
                              child: const Icon(
                                Icons.person,
                                size: 36,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Text info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _str("name"),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _str("id"),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _str("school"),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Year selector (pill-like)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedYear,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showYearPicker(context),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Stats grid (2x2)
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.9,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AttendancePage()),
                    );
                  },
                  child: _statTile(
                    "Attendance",
                    _stat("attendance"),
                    const Color(0xFF3F51B5),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AcademicPage()),
                    );
                  },
                  child: _statTile(
                    "Academics",
                    _stat("academics"),
                    const Color(0xFFF7C71C),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReceiptsPage()),
                    );
                  },
                  child: _statTile(
                    "Receipts",
                    _stat("receipts"),
                    const Color(0xFF4CAF50),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InvoicesPage()),
                    );
                  },
                  child: _statTile(
                    "Invoices",
                    _stat("invoices"),
                    const Color(0xFFFFA726),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: currentIndex,
          selectedItemColor: primaryBlue,
          unselectedItemColor: const Color(0xFF9E9E9E),
          onTap: (index) {
            setState(() => currentIndex = index);
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profile",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none),
              label: "Alerts",
            ),
          ],
        ),
      ),
    );
  }

  Widget _statTile(String title, String value, Color topColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: topColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- DRAWER --------------------
  Widget _buildDrawer(BuildContext context) {
    final profile = userProfile;
    final avatarUrl = profile['avatarUrl'] as String? ?? '';

    const Color dividerColor = Color(0xFFE6EEF6);
    const Color primaryRed = Color(0xFFE35A58);

    return Drawer(
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TOP WHITE BAR WITH BACK ARROW
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 22,
                      color: Colors.black87,
                    ),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                ],
              ),
            ),

            // Divider under the white bar
            Container(height: 1, color: dividerColor),

            const SizedBox(height: 14),

            // PROFILE CARD
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12.0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: dividerColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipOval(child: _buildAvatarWidget(avatarUrl)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile['name'] ?? 'Parent Name',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfilePage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Parent ID ${profile['parentId']}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // QUICK ACTIONS (ROW OF 2)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(child: _quickAction(Icons.sync_alt, "Switch Child")),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _quickAction(Icons.person_outline, "My Profile"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // LIST ITEMS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  _drawerListTile(icon: Icons.settings, title: "Settings"),
                  const SizedBox(height: 10),
                  _drawerListTile(icon: Icons.help_outline, title: "FAQs"),
                  const SizedBox(height: 10),
                  _drawerListTile(
                    icon: Icons.info_outline,
                    title: "About Skuteq",
                  ),
                ],
              ),
            ),

            // const Spacer(),

            // LOGOUT BUTTON
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 26,
                top: 26,
              ),
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.white, size: 20),
                  label: const Text(
                    "Logout",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SelectChildPage(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Quick action card (Switch Child / My Profile)
  Widget _quickAction(IconData icon, String label) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6EEF6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 26, color: const Color(0xFF1F3D7A)),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  /// List tile used inside drawer (wrapped visual style)
  Widget _drawerListTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6EEF6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF1F3D7A), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF95A3B8),
        ),
        onTap: onTap,
      ),
    );
  }

  // Avatar widget that picks asset vs network depending on the provided path.
  Widget _buildAvatarWidget(String avatarPath) {
    if (avatarPath.isEmpty) {
      return const Icon(Icons.person, size: 28, color: Colors.grey);
    }
    if (avatarPath.startsWith('assets/')) {
      return Image.asset(
        avatarPath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.person, size: 28, color: Colors.grey),
      );
    }
    // use Image.network for local uploaded path (tooling will transform /mnt/data -> http URL)
    return Image.network(
      avatarPath,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.person, size: 28, color: Colors.grey),
    );
  }

  // Year picker bottom sheet
  void _showYearPicker(BuildContext context) {
    final years =
        (studentData["years"] as List<dynamic>?)?.cast<String>() ?? [];
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: years.map((y) {
              return ListTile(
                title: Text(y),
                onTap: () {
                  setState(() => selectedYear = y);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
