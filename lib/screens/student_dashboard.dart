import 'package:flutter/material.dart';
// For the Fear tab
// Import your existing pages
import 'attendance_widget.dart';
import 'academic_page.dart';
import 'profile_page.dart';
import 'invoice_page.dart';
import 'select_child_page.dart';
import 'login_page.dart';
import 'homework_page.dart';

// Import new pages we'll create
import 'documents_page.dart';
import 'contact_teacher_page.dart';
import 'contact_admin_page.dart';
import 'faq_page.dart';
import 'settings_page.dart';
import 'fees_page.dart'; 

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
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DocumentsPage(),
                      ),
                    );
                  },
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
              currentIndex = 0;
            });

            if (index == 1) {
              // Navigate to Homework page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeworkPage()),
              );
            } else if (index == 2) {
              // Navigate to Fear page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FeesPage()),
              );
            } else if (index == 3) {
              // Navigate to Student Profile page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            }
            // Index 0 stays on home page
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
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DocumentsPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.contacts,
                  title: 'Contact Teacher',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContactTeacherPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.home_work,
                  title: 'Contact Admin/School',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContactAdminPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.chat,
                  title: 'FAQs',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FAQPage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'Log out',
                  color: Colors.red,
                  onTap: () {
                    // Handle logout
                    Navigator.pop(context); // Close drawer
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false,
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
        },
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

// ===== MISSING PAGES IMPLEMENTATION =====

// Documents Page
class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Documents',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          DocumentItem(title: 'Birth Certificate', type: 'PDF'),
          DocumentItem(title: 'Aadhaar Card', type: 'PDF'),
          DocumentItem(title: 'Previous Marksheet', type: 'PDF'),
          DocumentItem(title: 'Medical Certificate', type: 'Image'),
        ],
      ),
    );
  }
}

// Contact Teacher Page
class ContactTeacherPage extends StatelessWidget {
  const ContactTeacherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Contact Teachers',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          TeacherContactItem(
            name: 'Mrs. Sharma',
            subject: 'Mathematics',
            phone: '080987654321',
          ),
          TeacherContactItem(
            name: 'Mr. Patel',
            subject: 'Physics',
            phone: '080987654322',
          ),
          TeacherContactItem(
            name: 'Ms. Reddy',
            subject: 'Chemistry',
            phone: '080987654323',
          ),
        ],
      ),
    );
  }
}

// Contact Admin Page
class ContactAdminPage extends StatelessWidget {
  const ContactAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Contact Admin',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoRow(title: 'School Phone', value: '080-26543210'),
                InfoRow(title: 'Email', value: 'admin@school.com'),
                InfoRow(
                  title: 'Address',
                  value: '123 School St, Education Nagar, City',
                ),
                InfoRow(title: 'Office Hours', value: '9:00 AM - 4:00 PM'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// FAQ Page
class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'FAQs',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          FAQItem(
            question: 'How to check attendance?',
            answer: 'Go to Home page to see your attendance percentage.',
          ),
          FAQItem(
            question: 'Where to submit homework?',
            answer: 'Use the Homework section to view and submit assignments.',
          ),
          FAQItem(
            question: 'How to contact teachers?',
            answer: 'Use the Contact Teacher section in the drawer menu.',
          ),
        ],
      ),
    );
  }
}

// Settings Page
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Push Notifications'),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: const Text('Email Notifications'),
            value: false,
            onChanged: (value) {},
          ),
          const ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const ListTile(
            leading: Icon(Icons.security),
            title: Text('Privacy & Security'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}

// Fear Page (for bottom navigation)
class FearPage extends StatelessWidget {
  const FearPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Fear Analytics',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Fear Score Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Current Fear Score',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '75%',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: 0.75,
                      backgroundColor: Colors.grey.shade200,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Fear Areas
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Areas of Concern',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: const [
                  FearAreaItem(subject: 'Mathematics', score: 85),
                  FearAreaItem(subject: 'Physics', score: 70),
                  FearAreaItem(subject: 'Chemistry', score: 60),
                  FearAreaItem(subject: 'Biology', score: 45),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== SUPPORTING WIDGETS =====

class DocumentItem extends StatelessWidget {
  final String title;
  final String type;

  const DocumentItem({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.description),
        title: Text(title),
        subtitle: Text(type),
        trailing: const Icon(Icons.download),
      ),
    );
  }
}

class TeacherContactItem extends StatelessWidget {
  final String name;
  final String subject;
  final String phone;

  const TeacherContactItem({
    super.key,
    required this.name,
    required this.subject,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(name),
        subtitle: Text('$subject • $phone'),
        trailing: IconButton(icon: const Icon(Icons.phone), onPressed: () {}),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(padding: const EdgeInsets.all(16.0), child: Text(answer)),
        ],
      ),
    );
  }
}

class FearAreaItem extends StatelessWidget {
  final String subject;
  final int score;

  const FearAreaItem({super.key, required this.subject, required this.score});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: score / 100,
              backgroundColor: Colors.grey.shade200,
              color: score > 70
                  ? Colors.red
                  : score > 50
                  ? Colors.orange
                  : Colors.yellow,
            ),
            const SizedBox(height: 5),
            Text('$score% concern level'),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
