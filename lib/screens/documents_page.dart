import 'package:flutter/material.dart';

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
          DocumentItem(
            title: 'Birth Certificate',
            type: 'PDF',
            date: '15 Jan 2023',
          ),
          DocumentItem(title: 'Aadhaar Card', type: 'PDF', date: '20 Feb 2023'),
          DocumentItem(
            title: 'Previous Marksheet - Class 11',
            type: 'PDF',
            date: '30 Mar 2023',
          ),
          DocumentItem(
            title: 'Medical Certificate',
            type: 'Image',
            date: '05 Apr 2023',
          ),
          DocumentItem(
            title: 'Transfer Certificate',
            type: 'PDF',
            date: '10 May 2023',
          ),
          DocumentItem(
            title: 'Caste Certificate',
            type: 'PDF',
            date: '15 Jun 2023',
          ),
          DocumentItem(
            title: 'Income Certificate',
            type: 'PDF',
            date: '20 Jul 2023',
          ),
          DocumentItem(
            title: 'Sports Achievement Certificate',
            type: 'Image',
            date: '25 Aug 2023',
          ),
        ],
      ),
    );
  }
}

class DocumentItem extends StatelessWidget {
  final String title;
  final String type;
  final String date;

  const DocumentItem({
    super.key,
    required this.title,
    required this.type,
    required this.date,
  });

  IconData getDocumentIcon() {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'image':
        return Icons.photo;
      default:
        return Icons.description;
    }
  }

  Color getDocumentColor() {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'image':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: getDocumentColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(getDocumentIcon(), color: getDocumentColor(), size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Type: $type',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            Text(
              'Uploaded: $date',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.visibility, color: Colors.blue.shade600),
              onPressed: () {
                _showPreviewDialog(context, title, type);
              },
            ),
            IconButton(
              icon: Icon(Icons.download, color: Colors.green.shade600),
              onPressed: () {
                _downloadDocument(context, title);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPreviewDialog(BuildContext context, String title, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Preview: $title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(getDocumentIcon(), size: 60, color: getDocumentColor()),
            const SizedBox(height: 16),
            Text(
              'This is a preview of your $type document.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'File: $title.$type',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _downloadDocument(context, title);
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  void _downloadDocument(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading $title...'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(label: 'OK', onPressed: () {}),
      ),
    );
  }
}
