import 'package:flutter/material.dart';

class AboutSkuteqPage extends StatelessWidget {
  const AboutSkuteqPage({super.key});

  static const Color pageBg = Color(0xFFF6FAFF);
  static const Color cardBorder = Color(0xFFE7EFF7);
  static const Color titleBlue = Color(0xFF244A6A);
  static const Color muted = Color(0xFF8B9BB0);
  static const Color pillBg = Color(0xFFF6FAFF);
  static const Color actionBlue = Color(0xFF2E9EE6);
  static const Color iconBg = Color(0xFFF0F7FF);

  @override
 Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              /// HEADER CONTAINER
              Container(
                // margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white, // 🔹 background color
                  
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        "About Skuteq",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// APP INFO CARD
              _card(
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      // decoration: BoxDecoration(
                      //   color: iconBg,
                      //   borderRadius: BorderRadius.circular(24),
                      // ),
                      child: Padding(
                        padding: const EdgeInsets.all(0), // controls PNG size
                        child: Image.asset(
                          'assets/icon/iconify-icon.png', // 👈 your PNG path
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // const SizedBox(height: 14),
                    const Text(
                      "Skuteq Parent-School",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        _VersionChip("v2.3.1"),
                        SizedBox(width: 8),
                        Text(
                          "Build 145",
                          style: TextStyle(
                            fontSize: 12,
                            color: muted,

                            // fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// POLICY GROUP
              _card(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _policyRow(
                      icon: Icons.verified_outlined,
                      title: "License",
                      subtitle: "Standard EULA",
                      action: "View",
                    ),
                    _lightDivider(),
                    _policyRow(
                      icon: Icons.shield_outlined,
                      title: "Privacy Policy",
                      subtitle: "How we handle your data",
                      action: "Open",
                    ),
                    _lightDivider(),
                    _policyRow(
                      icon: Icons.description_outlined,
                      title: "Terms of Service",
                      subtitle: "Your rights and obligations",
                      action: "Open",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              /// SUPPORT LABEL
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 6),
                child: Text(
                  "Support",
                  style: TextStyle(
                    fontSize: 12,
                    color: muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              _supportTile(
                icon: Icons.email_outlined,
                title: "Email Support",
                subtitle: "support@skuteq.com",
              ),
              const SizedBox(height: 10),
              _supportTile(
                icon: Icons.chat_bubble_outline,
                title: "Chat with Us",
                subtitle: "Mon–Fri, 9am–6pm",
              ),

              const SizedBox(height: 16),

              /// RELEASE NOTES
              _card(
                child: Row(
                  children: [
                    _iconBox(Icons.new_releases_outlined),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Release Notes",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "What’s new in this version",
                            style: TextStyle(fontSize: 12, color: muted),
                          ),
                        ],
                      ),
                    ),
                    _actionPill("View"),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// REUSABLE CARD
  Widget _card({required Widget child, EdgeInsets? padding}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: child,
    );
  }

  Widget _policyRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required String action,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          _iconBox(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: muted),
                ),
              ],
            ),
          ),
          _actionPill(action),
        ],
      ),
    );
  }

  Widget _supportTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return _card(
      child: Row(
        children: [
          _iconBox(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: muted),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.black38),
        ],
      ),
    );
  }

  Widget _iconBox(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      
      child: Icon(icon, size: 20),
    );
  }

  Widget _actionPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: pillBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _lightDivider() {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFF0F4FA));
  }
}

/// VERSION CHIP
class _VersionChip extends StatelessWidget {
  final String text;
  const _VersionChip(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFFF6FAFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }
}
