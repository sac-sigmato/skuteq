import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'student_dashboard.dart';

class SelectChildPage extends StatefulWidget {
  const SelectChildPage({super.key});

  @override
  State<SelectChildPage> createState() => _SelectChildPageState();
}

class _SelectChildPageState extends State<SelectChildPage> {
  // Example API/JSON response
  final List<Map<String, dynamic>> childrenData = [
    {
      "name": "Sanjan K Naik",
      "class": "X-A",
      "image": "assets/images/student1.png",
      "progress": 0.61,
    },
    {
      "name": "Safiya Mariam",
      "class": "X-A",
      "image": "assets/images/student2.png",
      "progress": 0.41,
    },
    {
      "name": "Chirag Guthi",
      "class": "X-A",
      "image": "assets/images/student3.png",
      "progress": 0.51,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Text
              const Text(
                "Welcome Sanjana,",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Please select your Child",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),

              // 🔹 Dynamic List
              Expanded(
                child: ListView.builder(
                  itemCount: childrenData.length,
                  itemBuilder: (context, index) {
                    final child = childrenData[index];
                    return _buildChildCard(
                      name: child["name"],
                      studentClass: child["class"],
                      imagePath: child["image"],
                      progress: child["progress"],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChildCard({
    required String name,
    required String studentClass,
    required String imagePath,
    required double progress,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Image with fallback
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: ClipOval(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.person, size: 30, color: Colors.grey[600]),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Name + Class
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F4FF),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: const Color(0xFF106EB4).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    "Class : $studentClass",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF106EB4),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Progress Circle - Simplified to match SS
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF106EB4), width: 3),
            ),
            child: Center(
              child: Text(
                "${(progress * 100).toInt()}%",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF106EB4),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Arrow Button - Simplified
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentDashboard()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF106EB4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
