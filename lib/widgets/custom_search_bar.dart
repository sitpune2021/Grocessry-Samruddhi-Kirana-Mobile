// import 'package:flutter/material.dart';
// import '../constants/app_colors.dart';
// import '../constants/app_sizes.dart';

// class CustomSearchBar extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final ValueChanged<String>? onChanged;
//   final VoidCallback? onTap;
//   final bool readOnly;

//   const CustomSearchBar({
//     super.key,
//     required this.controller,
//     this.hintText = 'Search',
//     this.onChanged,
//     this.onTap,
//     this.readOnly = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 44,
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(AppSizes.radius),
//         border: Border.all(color: AppColors.border),
//       ),
//       child: Row(
//         children: [
//           // 🔍 Search Icon
//           const Icon(
//             Icons.search,
//             size: 20,
//             color: AppColors.textPrimary,
//           ),

//           const SizedBox(width: 8),

//           // 📝 Text Field
//           Expanded(
//             child: TextField(
//               controller: controller,
//               readOnly: readOnly,
//               onChanged: onChanged,
//               onTap: onTap,
//               decoration: InputDecoration(
//                 hintText: hintText,
//                 border: InputBorder.none,
//                 isDense: true,
//               ),
//             ),
//           ),

//           // ❌ Clear Button
//           if (controller.text.isNotEmpty)
//             GestureDetector(
//               onTap: () {
//                 controller.clear();
//                 onChanged?.call('');
//               },
//               child: const Icon(
//                 Icons.close,
//                 size: 18,
//                 color: Colors.grey,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

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
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.dispose();
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
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radius),
            border: Border.all(
              color: _focusNode.hasFocus
                  ? AppColors.darkGreen
                  : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              // 🔍 Search Icon
              const Icon(Icons.search, size: 20),

              const SizedBox(width: 8),

              // 📝 Text Field
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
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

              // 🎤 Voice Icon
              if (widget.onVoiceTap != null)
                IconButton(
                  icon: const Icon(Icons.mic, size: 20),
                  onPressed: widget.onVoiceTap,
                ),

              // ❌ Clear Button
              if (widget.controller.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    widget.controller.clear();
                    widget.onChanged?.call('');
                    setState(() {});
                  },
                  child: const Icon(Icons.close, size: 18),
                ),
            ],
          ),
        ),

        // 🔽 Suggestions List
        if (_focusNode.hasFocus &&
            widget.suggestions.isNotEmpty &&
            widget.controller.text.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radius),
              border: Border.all(color: AppColors.border),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.suggestions.length,
              itemBuilder: (_, index) {
                final suggestion = widget.suggestions[index];
                return ListTile(
                  dense: true,
                  title: Text(suggestion),
                  onTap: () {
                    widget.controller.text = suggestion;
                    widget.onSuggestionTap?.call(suggestion);
                    _focusNode.unfocus();
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
