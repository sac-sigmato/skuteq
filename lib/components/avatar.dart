import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String imageUrl; // can be "", relative path, or full url
  final double size;
  final double borderWidth;
  final Color borderColor;

  Avatar({
    super.key,
    required this.imageUrl,
    this.size = 150,
    this.borderWidth = 4,
    this.borderColor = Colors.white,
  });

  static String resolveStudentImageUrl(String raw) {
    var url = raw.trim();
    if (url.isEmpty) return "";

    // already full url
    if (url.startsWith("http://") || url.startsWith("https://")) return url;

    // remove leading slashes
    url = url.replaceFirst(RegExp(r'^/+'), '');

    // if api already includes "public/..."
    if (url.startsWith("public/")) {
      return "https://dev-cdn.skuteq.net/$url";
    }

    // normal case: relative under public
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
      ),
      child: ClipOval(
        child: resolved.isNotEmpty
            ? Image.network(
                resolved,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallback(),
              )
            : _fallback(),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: const Icon(Icons.person, size: 36, color: Colors.grey),
    );
  }
}
