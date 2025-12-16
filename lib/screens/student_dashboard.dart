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

  // Key used to anchor the popup menu to the year pill.
  final GlobalKey _yearKey = GlobalKey();

  final Map<String, dynamic> userProfile = {
    "name": "Rohit Sharma",
    "parentId": "P-3021",
    "email": "rohit.sharma@example.com",
    "avatarUrl": "/mnt/data/e4d92258-e3be-4cd3-87fb-18ece55927a3.png",
  };

  final Map<String, dynamic> studentData = {
    "studentInfo": {
      "name": "Aarav Sharma", // FIXED: Changed from "Aaray" to "Aarav"
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: pageBg,
          padding: const EdgeInsets.symmetric(
            vertical: 20,
          ), // <-- vertical 20 for both
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,

            // Remove extra paddings since parent has padding
            title: const Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),

            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.black87),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
          children: [
            // Student Profile Card with Avatar - FIXED OVERFLOW
            SizedBox(
              height: 140, // Reduced height for better proportion
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Blue card background - positioned lower
                  Positioned(
                    top: 0, // Lower position to allow avatar overlap
                    left: 0,
                    right: 0,
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
                        height: 150, // Reduced height
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF0E70B8), Color(0xFF0A5F93)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 14,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.only(
                          left: 150, // Adjusted for smaller avatar
                          right: 16,
                          top: 16,
                          bottom: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _str("name"),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22, // Slightly smaller
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _str("id"),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
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
                    ),
                  ),

                  // Avatar overlapping the card - PROPERLY POSITIONED
                  Positioned(
                    left: 16, // Adjusted left position
                    top: 16, // Top aligned with Stack
                    child: Container(
                      width: 120, // Smaller avatar size
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4, // Thinner border
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          _str('image'),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.person,
                              size: 36,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Year selector pill (the whole pill is tappable and anchored)
            GestureDetector(
              key: _yearKey,
              onTap: () => _showYearMenu(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFE6EEF6)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
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
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 22),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Stats grid (2x2)
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.2,
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

            const SizedBox(height: 24),
          ],
        ),
      ),

      // Bottom Navigation
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
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
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
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: topColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
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
    final String avatarUrl = profile['avatarUrl'] ?? '';

    const Color borderColor = Color(0xFFE6EEF6);
    const Color drawerBg = Color(0xFFF6F7FB);
    const Color logoutRed = Color(0xFFE35A58);

    return Drawer(
      width: MediaQuery.of(context).size.width,
      backgroundColor: drawerBg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// 🔹 Top Header (MATCHING IMAGE)
            Container(
                margin: const EdgeInsets.symmetric(
                vertical: 14,
              ),
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 17),
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Colors.black87,
                      ),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// 🔹 Profile Card
            Container(
              // margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
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
                        profile['name'] ?? 'Rohit Sharma',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Parent ID ${profile['parentId'] ?? 'P-3021'}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// 🔹 Quick Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: _quickActionCard(
                      icon: Icons.sync_alt,
                      title: "Switch Child",
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _quickActionCard(
                      icon: Icons.person_outline,
                      title: "My Profile",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfilePage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 Menu List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  _drawerTile(
                    icon: Icons.settings,
                    title: "Settings",
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  _drawerTile(
                    icon: Icons.help_outline,
                    title: "FAQs",
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  _drawerTile(
                    icon: Icons.info_outline,
                    title: "About Skuteq",
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const Spacer(),

            /// 🔹 Logout Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 26),
              child: SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout, size: 20),
                  label: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: logoutRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
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

  Widget _quickActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE6EEF6)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: const Color(0xFF0E70B8)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6EEF6)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFE6EEF6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: const Color(0xFF0E70B8)),
            ),
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
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }


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
    return Image.network(
      avatarPath,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.person, size: 28, color: Colors.grey),
    );
  }

  /// Show an anchored popup menu below the year pill.
  /// Uses [_yearKey] to compute position so the popup appears right at the pill.
  void _showYearMenu() async {
    final years =
        (studentData["years"] as List<dynamic>?)?.cast<String>() ?? <String>[];

    if (_yearKey.currentContext == null || years.isEmpty) {
      return;
    }

    final RenderBox renderBox =
        _yearKey.currentContext!.findRenderObject()! as RenderBox;
    final Offset topLeft = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    final RelativeRect position = RelativeRect.fromLTRB(
      topLeft.dx,
      topLeft.dy + size.height,
      topLeft.dx + size.width,
      topLeft.dy,
    );

    final selected = await showMenu<String>(
      context: context,
      position: position,
      items: years.map((y) {
        return PopupMenuItem<String>(
          value: y,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(y, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
        );
      }).toList(),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    if (selected != null) {
      setState(() => selectedYear = selected);
    }
  }

  // kept for compatibility; not used now
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
