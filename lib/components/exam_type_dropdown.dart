import 'package:flutter/material.dart';
import 'package:skuteq_app/services/academic_service.dart';

class ExamTypeDropdown extends StatefulWidget {
  final List<ExamOption> exams;
  final String selectedExamId;
  final String selectedExamName;
  final bool disabled;
  final ValueChanged<ExamOption> onSelected;

  const ExamTypeDropdown({
    super.key,
    required this.exams,
    required this.selectedExamId,
    required this.selectedExamName,
    required this.onSelected,
    this.disabled = false,
  });

  @override
  State<ExamTypeDropdown> createState() => _ExamTypeDropdownState();
}

class _ExamTypeDropdownState extends State<ExamTypeDropdown> {
  static const Color borderBlue = Color(0xFF1E88E5);
  static const Color menuBorder = Color(0xFFE7EFF7);
  static const Color selectedRowBg = Color(0xFFCFD6E6);

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _entry;

  bool get _isOpen => _entry != null;

  List<ExamOption> get _menuExams =>
      widget.exams.where((e) => e.id.trim().isNotEmpty).toList();

  @override
  void dispose() {
    _remove();
    super.dispose();
  }

  void _remove() {
    _entry?.remove();
    _entry = null;
  }

  void _toggle() {
    if (widget.disabled) return;
    if (widget.exams.isEmpty) return;

    if (_isOpen) {
      _remove();
    } else {
      _show();
    }
    setState(() {});
  }

  void _show() {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final size = box.size;

    _entry = OverlayEntry(
      builder: (_) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _remove();
                  setState(() {});
                },
                child: const SizedBox(),
              ),
            ),

            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 8),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 18,
                        offset: Offset(0, 10),
                        color: Color(0x33000000),
                      ),
                    ],
                    border: Border.all(color: menuBorder),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔹 HEADER (only in open state)
                      Container(
                        height: 54,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                          border: Border.all(color: borderBlue, width: 2),
                        ),
                        child: Row(
                          children: const [
                            Expanded(
                              child: Text(
                                "Select Exam",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1B1F2A),
                                ),
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_up, size: 26),
                          ],
                        ),
                      ),

                      // 🔹 LIST
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 320),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: _menuExams.length,
                          itemBuilder: (c, i) {
                            final e = _menuExams[i];
                            final isSel = e.id == widget.selectedExamId;

                            return InkWell(
                              onTap: () {
                                widget.onSelected(e);
                                _remove();
                                setState(() {});
                              },
                              child: Container(
                                height: 56,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                color: isSel ? selectedRowBg : Colors.white,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  e.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSel
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                    color: const Color(0xFF1B1F2A),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_entry!);
  }

  @override
  Widget build(BuildContext context) {
    final fieldText = widget.selectedExamName.trim();

    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: (widget.disabled || widget.exams.isEmpty) ? null : _toggle,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isOpen ? borderBlue : const Color(0xFFE7EFF7),
              width: _isOpen ? 2 : 1.2,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  fieldText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B1F2A),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 26,
                color: const Color(0xFF1B1F2A),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
