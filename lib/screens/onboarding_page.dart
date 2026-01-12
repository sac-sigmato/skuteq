import 'package:flutter/material.dart';
import 'login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _index = 0;

  final List<Map<String, dynamic>> pages = [
    {
      "image": "assets/images/onboarding_1.png",
      "features": [
        {
          "iconAsset": "assets/icon/attendance.png",
          "title": "Attendance",
          "desc": "Daily presence at a glance with quick absence alerts",
        },
        {
          "iconAsset": "assets/icon/academic.png",
          "title": "Academic Details",
          "desc": "Subjects, grades, and term progress neatly organized",
        },
      ],
      "button": "Next",
    },
    {
      "image": "assets/images/onboarding_2.png",
      "features": [
        {
          "iconAsset": "assets/icon/invoice.png",
          "title": "Invoices",
          "desc": "Access fee invoices, due dates, and download PDF copies",
        },
        {
          "iconAsset": "assets/icon/receipt.png",
          "title": "Receipts",
          "desc": "View payment history with secure, shareable receipts",
        },
      ],
      "button": "Next",
    },
    {
      "image": "assets/images/onboarding_3.png",
      "features": [
        {
          "iconAsset": "assets/icon/switch_child.png",
          "title": "Switch Child",
          "desc": "Easily toggle between linked children",
        },
        {
          "iconAsset": "assets/icon/alerts.png",
          "title": "Alerts",
          "desc": "Stay informed on attendance, fees, and academics",
        },
      ],
      "button": "Sign in",
    },
  ];

  void _onButtonTap() {
    if (_index == pages.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFF),
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          itemCount: pages.length,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (_, i) => _buildPage(pages[i]),
        ),
      ),
    );
  }

  /// 🔹 SINGLE PAGE (FIGMA MATCH)
  Widget _buildPage(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        children: [
          const SizedBox(height: 100),
          /// LOGO
          Image.asset("assets/images/skuteq_logo.png", height: 34),

          const SizedBox(height: 20),

          /// ILLUSTRATION
          SizedBox(
            height: 260,
            child: Image.asset(data["image"], fit: BoxFit.contain),
          ),

          const SizedBox(height: 20),

          /// FEATURE LIST + DOTS + BUTTON (SAME FLOW)
          Expanded(
            child: Column(
              children: [
                /// FEATURE CARDS
                ...data["features"].map<Widget>((f) {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE7EFF7)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF4FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Image.asset(
                              f["iconAsset"],
                              width: 18,
                              height: 18,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f["title"],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF000000),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                f["desc"],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF7A8CA5),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                const SizedBox(height: 16),

                /// DOTS (NOW PART OF THE LIST)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    pages.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _index == i
                            ? const Color(0xFF000000)
                            : const Color(0xFFD6DEEA),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                /// BUTTON (IMMEDIATELY AFTER DOTS)
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _onButtonTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F6FDB),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      data["button"],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
