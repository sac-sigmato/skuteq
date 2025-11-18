import 'package:flutter/material.dart';

class HomeworkPage extends StatelessWidget {
  const HomeworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Homework',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Date',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Icon(
                    Icons.calendar_today,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Homework list
            Expanded(
              child: ListView(
                children: const [
                  HomeworkCard(
                    subject: 'Mathematics',
                    topic: 'Integration Problems',
                    dueDate: 'Due: 15 Dec 2023',
                    description: 'Solve problems from chapter 7.1 to 7.5',
                    status: 'Pending',
                  ),
                  HomeworkCard(
                    subject: 'Physics',
                    topic: 'Optics Lab Report',
                    dueDate: 'Due: 16 Dec 2023',
                    description: 'Complete lab report for experiment 5',
                    status: 'Submitted',
                  ),
                  HomeworkCard(
                    subject: 'Chemistry',
                    topic: 'Organic Chemistry',
                    dueDate: 'Due: 18 Dec 2023',
                    description: 'Learn nomenclature of hydrocarbons',
                    status: 'Pending',
                  ),
                  HomeworkCard(
                    subject: 'English',
                    topic: 'Essay Writing',
                    dueDate: 'Due: 20 Dec 2023',
                    description: 'Write an essay on "Climate Change"',
                    status: 'Completed',
                  ),
                  HomeworkCard(
                    subject: 'Computer Science',
                    topic: 'Flutter Project',
                    dueDate: 'Due: 22 Dec 2023',
                    description: 'Complete UI implementation',
                    status: 'In Progress',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}

class HomeworkCard extends StatelessWidget {
  final String subject;
  final String topic;
  final String dueDate;
  final String description;
  final String status;

  const HomeworkCard({
    super.key,
    required this.subject,
    required this.topic,
    required this.dueDate,
    required this.description,
    required this.status,
  });

  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'submitted':
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      case 'pending':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: getStatusColor()),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      color: getStatusColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              topic,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              dueDate,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.attachment, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
