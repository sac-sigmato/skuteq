import 'package:flutter/material.dart';

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
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search FAQs...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ),
          // Categories
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                FAQCategory(text: 'All', isSelected: true),
                FAQCategory(text: 'Attendance'),
                FAQCategory(text: 'Homework'),
                FAQCategory(text: 'Fees'),
                FAQCategory(text: 'Technical'),
                FAQCategory(text: 'General'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                FAQItem(
                  question: 'How can I check my attendance?',
                  answer:
                      'You can check your attendance percentage on the Home page. For detailed attendance records, go to the Attendance section from the home stats card.',
                  category: 'Attendance',
                ),
                FAQItem(
                  question: 'Where do I submit my homework?',
                  answer:
                      'Homework can be submitted through the Homework section. You can view pending assignments, due dates, and submit your work directly through the app.',
                  category: 'Homework',
                ),
                FAQItem(
                  question: 'How do I pay school fees?',
                  answer:
                      'School fees can be paid through the Fees section. You can view due amounts, generate invoices, and make payments securely through the app.',
                  category: 'Fees',
                ),
                FAQItem(
                  question: 'What should I do if I forget my password?',
                  answer:
                      'Click on "Forgot Password" on the login page. You will receive an email with instructions to reset your password. Contact admin if you need further assistance.',
                  category: 'Technical',
                ),
                FAQItem(
                  question: 'How can I contact my teachers?',
                  answer:
                      'Use the "Contact Teacher" option in the drawer menu. You will find all teacher contact information including phone numbers and email addresses.',
                  category: 'General',
                ),
                FAQItem(
                  question: 'How often is attendance updated?',
                  answer:
                      'Attendance is updated daily by class teachers. You can see real-time attendance percentages on your dashboard.',
                  category: 'Attendance',
                ),
                FAQItem(
                  question: 'Can I download my receipts?',
                  answer:
                      'Yes, all fee receipts are available in the Documents section. You can view and download them anytime.',
                  category: 'Fees',
                ),
                FAQItem(
                  question: 'What is the Fear Analytics section?',
                  answer:
                      'Fear Analytics helps you track subjects where you might need extra help. It shows your performance trends and areas that need improvement.',
                  category: 'General',
                ),
                FAQItem(
                  question: 'How do I update my profile information?',
                  answer:
                      'Profile updates can be done through the My Profile section. For certain changes, you may need to contact the school administration.',
                  category: 'Technical',
                ),
                FAQItem(
                  question: 'Is the app available for parents?',
                  answer:
                      'Yes, parents can access the app with their own login credentials to monitor their child\'s progress and school activities.',
                  category: 'General',
                ),
              ],
            ),
          ),
        ],
      ),
      // Contact Support Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _contactSupport(context),
        icon: const Icon(Icons.support_agent),
        label: const Text('Contact Support'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }

  void _contactSupport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Support',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSupportOption(
              icon: Icons.phone,
              title: 'Call Support',
              subtitle: '+91-80-26543210',
              onTap: () => _makeSupportCall(context),
            ),
            _buildSupportOption(
              icon: Icons.email,
              title: 'Email Support',
              subtitle: 'support@greenwoodhigh.edu',
              onTap: () => _sendSupportEmail(context),
            ),
            _buildSupportOption(
              icon: Icons.chat,
              title: 'Live Chat',
              subtitle: 'Available 9 AM - 5 PM',
              onTap: () => _startLiveChat(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }

  void _makeSupportCall(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Calling support...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _sendSupportEmail(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening email composer...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _startLiveChat(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Starting live chat...'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class FAQCategory extends StatelessWidget {
  final String text;
  final bool isSelected;

  const FAQCategory({super.key, required this.text, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;
  final String category;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
    required this.category,
  });

  Color getCategoryColor() {
    switch (category.toLowerCase()) {
      case 'attendance':
        return Colors.green;
      case 'homework':
        return Colors.orange;
      case 'fees':
        return Colors.purple;
      case 'technical':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: getCategoryColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(Icons.help_outline, color: getCategoryColor(), size: 20),
        ),
        title: Text(
          question,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  answer,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getCategoryColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 12,
                      color: getCategoryColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
