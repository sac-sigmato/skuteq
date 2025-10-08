import 'package:flutter/material.dart';
import 'attendance_widget.dart'; // Assuming this exists
import 'academic_page.dart'; // Assuming this exists
import 'profile_page.dart'; // Assuming this exists
import 'invoice_page.dart'; // Assuming this exists
import 'select_child_page.dart'; // Assuming this exists
import 'login_page.dart'; // Assuming this exists

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  String selectedYear = "2024";
  int currentIndex = 0;

  // JSON-like dummy data with proper structure
  final Map<String, dynamic> studentData = {
    "studentInfo": {
      "name": "Janavi H K",
      "class": "Class 12",
      "section": "Section A",
      "phone": "080987654345",
      "image": "assets/images/student1.png",
    },
    // Dummy data for the Drawer profile
    "userProfile": {"name": "Sanjana K", "email": "sanjanakriaik@gmail.com"},
    "stats": {
      "attendance": "92%",
      "academicDetails": "92%",
      "receipts": "02",
      "invoices": "02",
    },
    "feeDetails": {
      "nextDueDate": "Apr 15, 2025",
      "totalAmount": "45,000",
      "paidAmount": "30,000",
      "dueAmount": "15,000",
      "paidPercentage": 75,
      "duePercentage": 25,
    },
    "years": ["2024", "2023", "2022", "2021"],
  };

  // Safe data access methods
  String _getStringData(
    Map<String, dynamic>? data,
    String key,
    String fallback,
  ) {
    if (data == null) return fallback;
    final value = data[key];
    return value?.toString() ?? fallback;
  }

  int _getIntData(Map<String, dynamic>? data, String key, int fallback) {
    if (data == null) return fallback;
    final value = data[key];
    return value is int ? value : fallback;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 1. ADD THE DRAWER HERE
      drawer: _buildDrawer(context),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return Container(
              margin: const EdgeInsets.only(left: 16, top: 8),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF2196F3),
                child: IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 20),
                  // 2. SET THE ONPRESSED TO OPEN THE DRAWER
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 16.0),
            child: Stack(
              children: [
                const Icon(
                  Icons.notifications_none,
                  size: 28,
                  color: Colors.black,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(radius: 4, backgroundColor: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Year Selector
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Year",
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedYear,
                    underline: const SizedBox(),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF666666),
                      size: 24,
                    ),
                    items:
                        (studentData["years"] as List<dynamic>?)
                            ?.map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(
                                  value.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              );
                            })
                            .toList() ??
                        [
                          const DropdownMenuItem(
                            value: "2024",
                            child: Text("2024"),
                          ),
                        ],
                    onChanged: (String? value) {
                      setState(() {
                        selectedYear = value!;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Student Info Card (made clickable)
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2A38),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getStringData(
                              studentData["studentInfo"],
                              "name",
                              "Student Name",
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.school,
                            _getStringData(
                              studentData["studentInfo"],
                              "class",
                              "Class",
                            ),
                          ),
                          const SizedBox(height: 6),
                          _buildInfoRow(
                            Icons.class_,
                            _getStringData(
                              studentData["studentInfo"],
                              "section",
                              "Section",
                            ),
                          ),
                          const SizedBox(height: 6),
                          _buildInfoRow(
                            Icons.phone,
                            _getStringData(
                              studentData["studentInfo"],
                              "phone",
                              "Phone",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Profile Image Area
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white54, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 34,
                        backgroundColor: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Stats Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(
                  "Total Attendance",
                  _getStringData(studentData["stats"], "attendance", "0%"),
                  const Color(0xFF6C63FF),
                  Icons.calendar_today,
                  onClick: () {
                    // Assuming AttendancePage exists
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AttendancePage(),
                      ),
                    );
                  },
                ),
                _buildStatCard(
                  "Academic Details",
                  _getStringData(studentData["stats"], "academicDetails", "0%"),
                  const Color(0xFF4CAF50),
                  Icons.bar_chart,
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AcademicPage(),
                      ),
                    );
                  },
                ),
                _buildStatCard(
                  "Receipts",
                  _getStringData(studentData["stats"], "receipts", "0"),
                  const Color(0xFFFFC107),
                  Icons.receipt,
                ),
                _buildStatCard(
                  "Invoices",
                  _getStringData(studentData["stats"], "invoices", "0"),
                  const Color(0xFF7986CB),
                  Icons.description,
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InvoicePage(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Fee Progress Section with Circular Progress
            _buildCircularFeeProgressSection(),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          selectedItemColor: const Color(0xFF1976D2),
          unselectedItemColor: const Color(0xFF999999),
          selectedLabelStyle: const TextStyle(fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment),
              label: "Homework",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card_outlined),
              activeIcon: Icon(Icons.credit_card),
              label: "Fees",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "Student",
            ),
          ],
        ),
      ),
    );
  }

  // --- DRAWER IMPLEMENTATION ---
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          // Profile Header Section (top 1/3)
          _buildDrawerHeader(context),

          // Menu Items List (middle 1/3)
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                _buildDrawerItem(
                  icon: Icons.person,
                  title: 'My Profile',
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.description,
                  title: 'Documents',
                  onTap: () {},
                ),
                _buildDrawerItem(
                  icon: Icons.contacts,
                  title: 'Contact Teacher',
                  onTap: () {},
                ),
                _buildDrawerItem(
                  icon: Icons.home_work,
                  title: 'Contact Admin/School',
                  onTap: () {},
                ),
                _buildDrawerItem(icon: Icons.chat, title: 'FAQs', onTap: () {}),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {},
                ),
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'Log out',
                  color: Colors.red,
                  onTap: () {
                    // Handle logout
                    Navigator.pop(context); // Close drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Switch Child Footer (bottom 1/3)
          _buildDrawerFooter(),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Profile Picture
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey.shade300,
            child: Icon(
              Icons.person,
              size: 40,
              color: Colors.grey[600],
            ), // Placeholder
          ),
          const SizedBox(height: 10),
          // Name
          Text(
            _getStringData(studentData["userProfile"], "name", "User Name"),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          // Email
          Text(
            _getStringData(
              studentData["userProfile"],
              "email",
              "user@example.com",
            ),
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: 24),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: color,
          fontWeight: title == 'Log out' ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildDrawerFooter() {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: ListTile(
        leading: const Icon(Icons.cached, color: Color(0xFF2196F3)),
        title: const Text(
          'Switch Child',
          style: TextStyle(
            color: Color(0xFF2196F3),
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          Navigator.pop(context); // close the drawer first
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SelectChildPage()),
          );
        }

      ),
    );
  }
  // --- END DRAWER IMPLEMENTATION ---

  // --- EXISTING HELPER WIDGETS ---
  Widget _buildCircularFeeProgressSection() {
    final feeData = studentData["feeDetails"] as Map<String, dynamic>?;
    final paidPercentage = _getIntData(feeData, "paidPercentage", 0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          // Circular Progress and Amounts Row
          Row(
            children: [
              // Circular Progress Bar
              Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle (for the full circle)
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 12,
                      backgroundColor: const Color(0xFFFFE0E0),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFFF7C71C),
                      ),
                    ),
                  ),
                  // Progress circle
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: paidPercentage / 100,
                      strokeWidth: 12,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFF106EB4),
                      ),
                    ),
                  ),
                  // Percentage text
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$paidPercentage%",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const Text(
                        "Paid",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(width: 20),

              // Amount Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Paid Amount
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "₹${_getStringData(feeData, "paidAmount", "0")}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF106EB4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Paid ($paidPercentage%)",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Due Amount
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "₹${_getStringData(feeData, "dueAmount", "0")}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF7C71C),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Due (${_getIntData(feeData, "duePercentage", 0)}%)",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Next Due Date and Total Amount
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Next Due Date",
                      style: TextStyle(fontSize: 12, color: Color(0xFFFA3D66)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getStringData(feeData, "nextDueDate", "Not Available"),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFA3D66),
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Total Amount",
                      style: TextStyle(fontSize: 12, color: Color(0xFFFA3D66)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "₹${_getStringData(feeData, "totalAmount", "0")}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFA3D66),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon, {
    VoidCallback? onClick,
  }) {
    return InkWell(
      onTap: onClick,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(icon, size: 20, color: Colors.white),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
