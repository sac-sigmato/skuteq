import 'package:flutter/material.dart';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Dummy JSON data structure for the student profile
  final String sampleJsonData = '''
  {
    "student_id": "69869119",
    "first_name": "Safiya",
    "middle_name": "Mariam",
    "last_name": "Khan",
    "dob": "13 January, 2015",
    "blood_group": "A++ve",
    "gender": "Female",
    "nationality": "Indian",
    "date_of_admission": "1 June, 2021",
    "economic_status": "APL",
    "religion": "Hindu",
    "caste": "Devang Shetty",
    "caste_category": "OBC",
    "adhar_number": "-",
    "register_number": "-"
  }
  ''';

  late Map<String, dynamic> profileData;

  @override
  void initState() {
    super.initState();
    // Decode the JSON data
    profileData = json.decode(sampleJsonData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background for contrast
      body: CustomScrollView(
        slivers: [
          // Custom AppBar/Header
          _buildSliverAppBar(context),

          SliverList(
            delegate: SliverChildListDelegate([
              // Profile Section (Picture and ID)
              _buildProfileHeader(context),

              // Information Fields (Name, Admission, Status, etc.)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildTextField('First Name', profileData['first_name']),
                    _buildTextField('Middle Name', profileData['middle_name']),
                    _buildTextField('Last Name', profileData['last_name']),
                    const SizedBox(height: 20),

                    // Chips Row
                    _buildChipsRow(),
                    const SizedBox(height: 20),

                    // Remaining Fields
                    _buildTextField(
                      'Date of Admission',
                      profileData['date_of_admission'],
                    ),
                    _buildTextField(
                      'Economic Status',
                      profileData['economic_status'],
                    ),
                    _buildTextField('Religion', profileData['religion']),
                    _buildTextField('Caste', profileData['caste']),
                    _buildTextField(
                      'Caste Category',
                      profileData['caste_category'],
                    ),
                    _buildTextField(
                      'Adhar Number',
                      profileData['adhar_number'],
                    ),
                    _buildTextField(
                      'Register Number',
                      profileData['register_number'],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  // Header with back button
  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true, // Keep the back button area visible
      expandedHeight: 0,
      toolbarHeight: 56.0,
      backgroundColor: Colors.blue[700],
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          // Navigates back
          Navigator.pop(context);
        },
      ),
    );
  }

  // Profile Picture and ID section
  Widget _buildProfileHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        children: [
          // Profile Picture (Placeholder)
          CircleAvatar(
            radius: 70,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: const AssetImage(
              'assets/images/student1.png',
            ), // Replace with actual image asset
            child: const Icon(
              Icons.person,
              size: 70,
              color: Colors.black54,
            ), // Fallback icon
          ),
          const SizedBox(height: 10),
          // Student ID
          Text(
            'Student ID: ${profileData['student_id']}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Chips Row for vital stats (DOB, Blood Group, Gender, Nationality)
  Widget _buildChipsRow() {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: [
        _buildInfoChip(
          icon: Icons.calendar_today,
          title: 'Date of Birth',
          value: profileData['dob'],
        ),
        _buildInfoChip(
          icon: Icons.water_drop,
          title: 'Blood Group',
          value: profileData['blood_group'],
        ),
        _buildInfoChip(
          icon: Icons.location_on,
          title: 'Gender',
          value: profileData['gender'],
        ),
        _buildInfoChip(
          icon: Icons.flag,
          title: 'Nationality',
          value: profileData['nationality'],
        ),
      ],
    );
  }

  // Helper widget for the styled info chips
  Widget _buildInfoChip({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width:
          (MediaQuery.of(context).size.width / 2) -
          21, // Calculation for 2 items per row with padding
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: Colors.blue.shade700),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for the profile text fields
  Widget _buildTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Label
            Text(
              label,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
            ),
            // Value
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
