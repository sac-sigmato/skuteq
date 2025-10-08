// lib/widgets/custom_drawer.dart

import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _buildDrawerItem(
            icon: Icons.swap_horiz,
            text: 'Switch Profile',
            onTap: () {},
          ),
          _buildDrawerItem(
            icon: Icons.person_add_alt_1,
            text: 'Add Account',
            onTap: () {},
          ),
          _buildDrawerItem(
            icon: Icons.info_outline,
            text: 'Teacher Info',
            onTap: () {},
          ),
          _buildDrawerItem(
            icon: Icons.history,
            text: 'Payment History',
            onTap: () {},
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.settings_outlined,
            text: 'Setting',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return const UserAccountsDrawerHeader(
      accountName: Text(
        "Rudresh H",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      accountEmail: Text("View Profile"),
      currentAccountPicture: CircleAvatar(
        backgroundImage: NetworkImage('assets/images/user.png'),
      ),
      decoration: BoxDecoration(color: Colors.blue),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
