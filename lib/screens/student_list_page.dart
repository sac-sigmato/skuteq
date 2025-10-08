// lib/screens/student_list_page.dart

import 'package:flutter/material.dart';

class StudentListPage extends StatelessWidget {
  const StudentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for student list
    final students = [
      {
        'name': 'John Doe',
        'age': 2,
        'course': 'Computer Science',
        'imageUrl': 'https://picsum.photos/200',
      },
      {
        'name': 'Jane Smith',
        'age': 1,
        'course': 'Engineering',
        'imageUrl': 'https://picsum.photos/201',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Student List')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(student['imageUrl'] as String),
                radius: 30,
              ),
              title: Text(student['name'] as String),
              subtitle: Text(
                '${student['age']} years old\n${student['course']}',
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
