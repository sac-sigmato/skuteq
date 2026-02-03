import 'package:flutter/material.dart';
import 'package:skuteq_app/helpers/invoice_storage.dart';

class AyClassOption {
  final String academicYearId;
  final String academicYearName;
  final String name;
  final String classId;
  final String className;
  final String sectionId;
  final String sectionName;
  final bool latest;

  // extra fields
  final String? studentUuid;
  final String? ayStartDate;
  final String? ayEndDate;

  const AyClassOption({
    required this.academicYearId,
    required this.academicYearName,
    required this.name,
    required this.classId,
    required this.className,
    required this.sectionId,
    required this.sectionName,
    required this.latest,
    this.studentUuid,
    this.ayStartDate,
    this.ayEndDate,
  });
}

enum AyStatus { upcoming, ongoing, completed }

class AyPickerPill extends StatelessWidget {
  final List<AyClassOption> options;
  final AyClassOption? selected;
  final ValueChanged<AyClassOption> onSelected;
  final String placeholder;

  const AyPickerPill({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.placeholder = "Select AY",
  });

  // ---------------- FORMATTERS ----------------

  String _formatAyName(String raw) {
    final s = raw.trim();
    // remove "AY " prefix if present
    if (s.toLowerCase().startsWith("ay ")) {
      return s.substring(3).trim();
    }
    return s;
  }

  String _formatGrade(String rawClassName) {
    // If API gives "Class 5" -> show "Grade 5"
    // If already "Grade 5" keep same
    final s = rawClassName.trim();
    final lower = s.toLowerCase();

    if (lower.startsWith("class ")) {
      final numPart = s.substring(6).trim();
      if (numPart.isNotEmpty) return "Grade $numPart";
    }
    if (lower.startsWith("grade ")) return s;

    // fallback: show as-is
    return s;
  }

 String _formatSection(String rawSectionName) {
    final s = rawSectionName.trim();
    if (s.isEmpty) return s;

    final lower = s.toLowerCase();

    // Already "Section ..."
    if (lower.startsWith("section")) return s;

    // "sec ..." or "Sec ..."
    if (lower.startsWith("sec")) {
      final cleaned = s
          .replaceFirst(RegExp(r'^sec', caseSensitive: false), '')
          .trim();
      return cleaned.isEmpty ? "Section" : "Section $cleaned";
    }

    // single letter/number like "A" / "B" / "1"
    if (s.length <= 3) return "Section $s";

    return s;
  }
DateTime? _tryParseDate(String? s) {
    if (s == null || s.trim().isEmpty) return null;
    final raw = s.trim();
    return DateTime.tryParse(raw) ??
        DateTime.tryParse(raw.replaceFirst(" ", "T")) ??
        DateTime.tryParse(raw.split(" ").first);
  }

  String _ayLabelFromDates(AyClassOption opt) {
    final s = _tryParseDate(opt.ayStartDate);
    final e = _tryParseDate(opt.ayEndDate);

    if (s != null && e != null) {
      return "AY ${s.year}-${e.year}";
    }

    // fallback (if dates missing)
    return _formatAyName(opt.academicYearName);
  }


 String _displayLine(AyClassOption? opt) {
    if (opt == null) return "";
    final ay = opt.name; // ✅ 2025-2026
    final grade = opt.className;
    final section = opt.sectionName;

    final inside = [grade, section].where((e) => e.trim().isNotEmpty).join(" ");
    return inside.isEmpty ? ay : "$ay ($inside)";
  }


  // ---------------- DATE/STATUS ----------------

  // DateTime? _tryParseDate(String? s) {
  //   if (s == null || s.trim().isEmpty) return null;
  //   final raw = s.trim();
  //   return DateTime.tryParse(raw) ??
  //       DateTime.tryParse(raw.replaceFirst(" ", "T")) ??
  //       DateTime.tryParse(raw.split(" ").first);
  // }

  AyStatus _getAyStatus(AyClassOption opt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final s = _tryParseDate(opt.ayStartDate);
    final e = _tryParseDate(opt.ayEndDate);

    if (s != null) {
      final sd = DateTime(s.year, s.month, s.day);
      if (today.isBefore(sd)) return AyStatus.upcoming;
    }

    if (e != null) {
      final ed = DateTime(e.year, e.month, e.day);
      if (today.isAfter(ed)) return AyStatus.completed;
    }

    return AyStatus.ongoing;
  }

  String _statusLabel(AyStatus s) {
    switch (s) {
      case AyStatus.upcoming:
        return "upcoming";
      case AyStatus.ongoing:
        return "ongoing";
      case AyStatus.completed:
        return "completed";
    }
  }

  // ---------------- MENU ----------------

  Future<void> _openMenu(BuildContext context) async {
    if (options.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No Academic Year/Class found")),
      );
      return;
    }

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final screenW = MediaQuery.of(context).size.width;
    final menuWidth = (size.width + 140).clamp(size.width, screenW - 24);

    final sorted = [...options];
    sorted.sort((a, b) {
      final ad = _tryParseDate(a.ayStartDate);
      final bd = _tryParseDate(b.ayStartDate);
      if (ad == null && bd == null) {
        return b.academicYearName.compareTo(a.academicYearName);
      }
      if (ad == null) return 1;
      if (bd == null) return -1;
      return bd.compareTo(ad);
    });

    final items = <PopupMenuEntry<AyClassOption>>[];

    for (int i = 0; i < sorted.length; i++) {
      final opt = sorted[i];

      final isSelected =
          selected != null &&
          opt.academicYearId == selected!.academicYearId &&
          opt.classId == selected!.classId &&
          opt.sectionId == selected!.sectionId;

      final statusText = _statusLabel(_getAyStatus(opt));

      items.add(
        PopupMenuItem<AyClassOption>(
          value: opt,
          padding: EdgeInsets.zero,
          child: SizedBox(
            width: menuWidth,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              color: isSelected ? const Color(0xFFF5FAFF) : Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _displayLine(opt), // ✅ single line format
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF3FF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      statusText,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0B2A4A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      if (i != sorted.length - 1) {
        items.add(const PopupMenuDivider(height: 1));
      }
    }

    final picked = await showMenu<AyClassOption>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height + 8,
        0,
        0,
      ),
      constraints: BoxConstraints.tightFor(width: menuWidth),
      color: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      items: items,
    );

    if (picked != null) {
      // ✅ Update store whenever dropdown AY changes
      await InvoiceStorage.clearAyStatus();

      final status = _getAyStatus(picked);
      await InvoiceStorage.saveAyStatus(_statusLabel(status));

      onSelected(picked);
    }
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    final line = selected == null ? "" : _displayLine(selected);

    return GestureDetector(
      onTap: () => _openMenu(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
         decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE6EEF6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                line.isNotEmpty ? line : placeholder,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),
      ),
    );
  }
}
