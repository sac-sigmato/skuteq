import 'package:flutter/material.dart';

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
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search teachers...',
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                TeacherContactItem(
                  name: 'Mrs. Sharma',
                  subject: 'Mathematics',
                  phone: '+91 80987654321',
                  email: 'sharma.maths@schooldomain.com',
                  imageUrl:
                      'https://via.placeholder.com/100/4CAF50/FFFFFF?text=MS',
                ),
                TeacherContactItem(
                  name: 'Mr. Patel',
                  subject: 'Physics',
                  phone: '+91 80987654322',
                  email: 'patel.physics@schooldomain.com',
                  imageUrl:
                      'https://via.placeholder.com/100/2196F3/FFFFFF?text=MP',
                ),
                TeacherContactItem(
                  name: 'Ms. Reddy',
                  subject: 'Chemistry',
                  phone: '+91 80987654323',
                  email: 'reddy.chemistry@schooldomain.com',
                  imageUrl:
                      'https://via.placeholder.com/100/FF9800/FFFFFF?text=MR',
                ),
                TeacherContactItem(
                  name: 'Dr. Kumar',
                  subject: 'Biology',
                  phone: '+91 80987654324',
                  email: 'kumar.biology@schooldomain.com',
                  imageUrl:
                      'https://via.placeholder.com/100/9C27B0/FFFFFF?text=DK',
                ),
                TeacherContactItem(
                  name: 'Mrs. Gupta',
                  subject: 'English',
                  phone: '+91 80987654325',
                  email: 'gupta.english@schooldomain.com',
                  imageUrl:
                      'https://via.placeholder.com/100/607D8B/FFFFFF?text=MG',
                ),
                TeacherContactItem(
                  name: 'Mr. Singh',
                  subject: 'Computer Science',
                  phone: '+91 80987654326',
                  email: 'singh.cs@schooldomain.com',
                  imageUrl:
                      'https://via.placeholder.com/100/795548/FFFFFF?text=MS',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TeacherContactItem extends StatelessWidget {
  final String name;
  final String subject;
  final String phone;
  final String email;
  final String imageUrl;

  const TeacherContactItem({
    super.key,
    required this.name,
    required this.subject,
    required this.phone,
    required this.email,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Teacher Avatar
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue.shade100,
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(width: 16),
            // Teacher Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subject,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 16, color: Colors.green.shade600),
                      const SizedBox(width: 6),
                      Text(
                        phone,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.email, size: 16, color: Colors.blue.shade600),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Action Buttons
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.phone, color: Colors.green.shade600),
                  onPressed: () => _makePhoneCall(context, phone),
                ),
                IconButton(
                  icon: Icon(Icons.email, color: Colors.blue.shade600),
                  onPressed: () => _sendEmail(context, email),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _makePhoneCall(BuildContext context, String phoneNumber) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Call Teacher'),
        content: Text('Would you like to call $name at $phoneNumber?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling $phoneNumber...'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }

  void _sendEmail(BuildContext context, String email) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Email'),
        content: Text('Would you like to send an email to $email?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening email composer for $email...'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Send Email'),
          ),
        ],
      ),
    );
  }
}
