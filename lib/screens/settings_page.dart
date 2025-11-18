import 'package:flutter/material.dart';

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
          // Profile Section
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Janavi H K',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Class 12 - Section A',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editProfile(context),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Notifications Section
          const SectionHeader(title: 'Notifications'),
          Card(
            elevation: 2,
            child: Column(
              children: [
                SwitchSettingItem(
                  title: 'Push Notifications',
                  subtitle: 'Receive app notifications',
                  value: true,
                  onChanged: (value) {},
                ),
                const Divider(height: 1),
                SwitchSettingItem(
                  title: 'Email Notifications',
                  subtitle: 'Receive email updates',
                  value: false,
                  onChanged: (value) {},
                ),
                const Divider(height: 1),
                SwitchSettingItem(
                  title: 'Homework Reminders',
                  subtitle: 'Get reminded about due assignments',
                  value: true,
                  onChanged: (value) {},
                ),
                const Divider(height: 1),
                SwitchSettingItem(
                  title: 'Fee Payment Alerts',
                  subtitle: 'Notifications about fee due dates',
                  value: true,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // App Preferences
          const SectionHeader(title: 'App Preferences'),
          Card(
            elevation: 2,
            child: Column(
              children: [
                SettingItem(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: 'English',
                  onTap: () => _changeLanguage(context),
                ),
                const Divider(height: 1),
                SettingItem(
                  icon: Icons.color_lens,
                  title: 'Theme',
                  subtitle: 'System Default',
                  onTap: () => _changeTheme(context),
                ),
                const Divider(height: 1),
                SettingItem(
                  icon: Icons.text_fields,
                  title: 'Font Size',
                  subtitle: 'Medium',
                  onTap: () => _changeFontSize(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Privacy & Security
          const SectionHeader(title: 'Privacy & Security'),
          Card(
            elevation: 2,
            child: Column(
              children: [
                SettingItem(
                  icon: Icons.lock,
                  title: 'Change Password',
                  subtitle: 'Last changed 30 days ago',
                  onTap: () => _changePassword(context),
                ),
                const Divider(height: 1),
                SettingItem(
                  icon: Icons.fingerprint,
                  title: 'Biometric Login',
                  subtitle: 'Use fingerprint to login',
                  onTap: () => _setupBiometric(context),
                ),
                const Divider(height: 1),
                SettingItem(
                  icon: Icons.visibility_off,
                  title: 'Privacy Settings',
                  subtitle: 'Manage your privacy options',
                  onTap: () => _privacySettings(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // About & Support
          const SectionHeader(title: 'About & Support'),
          Card(
            elevation: 2,
            child: Column(
              children: [
                SettingItem(
                  icon: Icons.info,
                  title: 'About App',
                  subtitle: 'Version 2.1.0',
                  onTap: () => _aboutApp(context),
                ),
                const Divider(height: 1),
                SettingItem(
                  icon: Icons.help,
                  title: 'Help & Support',
                  subtitle: 'Get help using the app',
                  onTap: () => _helpSupport(context),
                ),
                const Divider(height: 1),
                SettingItem(
                  icon: Icons.bug_report,
                  title: 'Report a Problem',
                  subtitle: 'Found a bug? Let us know',
                  onTap: () => _reportProblem(context),
                ),
                const Divider(height: 1),
                SettingItem(
                  icon: Icons.star,
                  title: 'Rate the App',
                  subtitle: 'Share your experience',
                  onTap: () => _rateApp(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _confirmLogout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _editProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit profile feature coming soon!')),
    );
  }

  void _changeLanguage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('English', true),
            _buildLanguageOption('Hindi', false),
            _buildLanguageOption('Kannada', false),
            _buildLanguageOption('Tamil', false),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language, bool isSelected) {
    return ListTile(
      title: Text(language),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
      onTap: () {},
    );
  }

  void _changeTheme(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Theme settings coming soon!')),
    );
  }

  void _changeFontSize(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Font size settings coming soon!')),
    );
  }

  void _changePassword(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password change feature coming soon!')),
    );
  }

  void _setupBiometric(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Biometric setup coming soon!')),
    );
  }

  void _privacySettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy settings coming soon!')),
    );
  }

  void _aboutApp(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Student Portal',
      applicationVersion: '2.1.0',
      applicationIcon: const CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.school, color: Colors.white),
      ),
      children: const [
        Text('Student Portal App for Greenwood High School'),
        SizedBox(height: 8),
        Text('Manage your academic journey with ease.'),
      ],
    );
  }

  void _helpSupport(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Opening help center...')));
  }

  void _reportProblem(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report problem feature coming soon!')),
    );
  }

  void _rateApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rate app feature coming soon!')),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Logging out...')));
              // Navigate to login page
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SettingItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

class SwitchSettingItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const SwitchSettingItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
    );
  }
}
