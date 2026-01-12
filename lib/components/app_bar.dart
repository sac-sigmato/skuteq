import 'package:flutter/material.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  /// If true -> show drawer menu icon
  final bool showDrawer;

  /// If true -> show back icon (priority over drawer)
  final bool showBack;

  /// Optional back action (else Navigator.pop)
  final VoidCallback? onBack;

  /// Optional actions on right
  final Widget? trailing;

  /// Top spacing like your current UI
  final double topMargin;

  const DashboardAppBar({
    super.key,
    required this.title,
    this.showDrawer = true,
    this.showBack = false,
    this.onBack,
    this.trailing,
    this.topMargin = 20,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    Widget leadingWidget = const SizedBox.shrink();

    if (showBack) {
      leadingWidget = IconButton(
        icon: const Icon(Icons.chevron_left, color: Colors.black87),
        onPressed: onBack ?? () => Navigator.pop(context),
      );
    } else if (showDrawer) {
      leadingWidget = Builder(
        builder: (ctx) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(top: topMargin),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        leading: leadingWidget,
        actions: [
          if (trailing != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(child: trailing),
            ),
        ],
      ),
    );
  }
}
