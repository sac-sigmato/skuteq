import 'package:flutter/material.dart';
import '../screens/profile_page.dart';
import '../screens/alerts_page.dart';
import '../screens/home_page.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

  void _handleTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget target;

    switch (index) {
      case 0:
        target = const HomePage();
        break;
      case 1:
        target = const ProfilePage();
        break;
      case 2:
        target = const AlertsPage();
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => target),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        backgroundColor: const Color(0xFFFFFFFF), // ✅ BG COLOR
        currentIndex: currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: const Color(0xFF9AA6B2),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        iconSize: 22,
        onTap: (index) => _handleTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: "Alerts",
          ),
        ],
      ),
    );
  }
}
