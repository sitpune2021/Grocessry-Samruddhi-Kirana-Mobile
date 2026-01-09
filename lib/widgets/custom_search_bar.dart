import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onVoiceTap;
  final VoidCallback? onTap;
  final bool readOnly;
  final List<String> suggestions;
  final ValueChanged<String>? onSuggestionTap;
  final Duration debounceDuration;

  // ✅ NEW
  final FocusNode? focusNode;
  final VoidCallback? onFocusLost;

  const CustomSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Search',
    this.onChanged,
    this.onVoiceTap,
    this.onTap,
    this.readOnly = false,
    this.suggestions = const [],
    this.onSuggestionTap,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.focusNode,
    this.onFocusLost,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    widget.focusNode?.addListener(() {
      if (!widget.focusNode!.hasFocus) {
        widget.onFocusLost?.call();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onChanged?.call(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasFocus = widget.focusNode?.hasFocus == true;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(AppSizes.radius),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: hasFocus ? AppColors.darkGreen : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 20),
              const SizedBox(width: 8),

              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  cursorColor: AppColors.darkGreen,
                  autofocus: true,
                  readOnly: widget.readOnly,
                  onTap: widget.onTap,
                  onChanged: _onTextChanged,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),

              if (widget.onVoiceTap != null)
                IconButton(
                  icon: const Icon(Icons.mic, size: 20),
                  onPressed: widget.onVoiceTap,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
