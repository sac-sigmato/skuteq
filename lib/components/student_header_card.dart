import 'package:flutter/material.dart';

class StudentHeaderCard extends StatelessWidget {
  final String name;
  final String studentIdText;
  final String branchName;
  final String imageUrl;
  final VoidCallback onTap;

  const StudentHeaderCard({
    super.key,
    required this.name,
    required this.studentIdText,
    required this.branchName,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 168, // 🔥 BIGGER like SS
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0C5C97), Color(0xFF0C5C97)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _Avatar(
              imageUrl: imageUrl,
              size: 118, // 🔥 BIG PROFILE
              borderWidth: 5, // 🔥 THICK RING
              borderColor: Colors.white,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20, // slightly bigger
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "ID $studentIdText",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    branchName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ============================================================
   Embedded Avatar Widget (same file)
============================================================ */

class _Avatar extends StatelessWidget {
  final String imageUrl;
  final double size;
  final double borderWidth;
  final Color borderColor;

  const _Avatar({
    required this.imageUrl,
    this.size = 108,
    this.borderWidth = 3,
    this.borderColor = Colors.white,
  });

  static String resolveStudentImageUrl(String raw) {
    var url = raw.trim();
    if (url.isEmpty) return "";

    if (url.startsWith("http://") || url.startsWith("https://")) return url;

    url = url.replaceFirst(RegExp(r'^/+'), '');

    if (url.startsWith("public/")) {
      return "https://dev-cdn.skuteq.net/$url";
    }

    return "https://dev-cdn.skuteq.net/public/$url";
  }

  @override
  Widget build(BuildContext context) {
    final resolved = resolveStudentImageUrl(imageUrl);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: resolved.isNotEmpty
            ? Image.network(
                resolved,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _fallback(); // 👈 YOUR fallback avatar
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  );
                },
              )
            : _fallback(),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: const Icon(Icons.person, size: 48, color: Colors.grey),
    );
  }
}
