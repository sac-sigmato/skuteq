import 'package:flutter/material.dart';

class SharedAppHead extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final bool showDrawer;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? trailing;

  /// spacing controls
  final double topMargin;
  final double bottomMargin;
  final double height;
  final EdgeInsets padding;

  const SharedAppHead({
    super.key,
    required this.title,
    this.showDrawer = true,
    this.showBack = false,
    this.onBack,
    this.trailing,
    this.topMargin = 30,
    this.bottomMargin = 12,
    this.height = 56,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
  });

  @override
  Size get preferredSize => Size.fromHeight(topMargin + height + bottomMargin);

  @override
  Widget build(BuildContext context) {
    Widget leading = const SizedBox(width: 48);

    if (showBack) {
      leading = IconButton(
        icon: const Icon(Icons.chevron_left, size: 28),
        onPressed: onBack ?? () => Navigator.pop(context),
      );
    } else if (showDrawer) {
      leading = Builder(
        builder: (ctx) => IconButton(
          icon: const Icon(Icons.menu, size: 24),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      );
    }

    return SafeArea(
      bottom: false,
      child: Container(
        margin: EdgeInsets.only(top: topMargin, bottom: bottomMargin),
        padding: padding,
        height: height,
        color: Colors.white,
        child: Row(
          children: [
            leading,
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            trailing != null
                ? SizedBox(width: 48, child: Center(child: trailing))
                : const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}
