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
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 175, // slightly taller for big avatar
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF0C5C97),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// ✅ BIG PERFECT CIRCLE AVATAR
            _Avatar(
              imageUrl: imageUrl,
              size: 145, // 🔥 BIGGER
              borderWidth: 2,
              borderColor: Colors.white,
            ),

            const SizedBox(width: 20),

            /// ✅ TEXT CONTENT
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
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "ID $studentIdText",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    branchName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
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
   Avatar Widget — FIXED (NO OVAL EVER)
============================================================ */
class _Avatar extends StatelessWidget {
  final String imageUrl;
  final double size;
  final double borderWidth;
  final Color borderColor;

  const _Avatar({
    required this.imageUrl,
    this.size = 145,
    this.borderWidth = 2,
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

    final double innerSize = size - (borderWidth * 2);

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: borderColor, // ✅ visible border
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: SizedBox(
          width: innerSize,
          height: innerSize,
          child: resolved.isNotEmpty
              ? Image.network(
                  resolved,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _fallback(),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                )
              : _fallback(),
        ),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: const Icon(Icons.person, size: 44, color: Colors.grey),
    );
  }
}
