// // import 'package:flutter/material.dart';
// // import '../constants/app_colors.dart';
// // import '../constants/app_sizes.dart';

// // class CustomTextField extends StatefulWidget {
// //   final TextEditingController controller;
// //   final String hintText;
// //   final String? labelText;
// //   final TextInputType keyboardType;
// //   final bool obscureText;
// //   final bool readOnly;
// //   final int maxLines;
// //   final Widget? prefixIcon;
// //   final Widget? suffixIcon;
// //   final String? Function(String?)? validator;
// //   final ValueChanged<String>? onChanged;
// //   final VoidCallback? onTap;

// //   const CustomTextField({
// //     super.key,
// //     required this.controller,
// //     required this.hintText,
// //     this.labelText,
// //     this.keyboardType = TextInputType.text,
// //     this.obscureText = false,
// //     this.readOnly = false,
// //     this.maxLines = 1,
// //     this.prefixIcon,
// //     this.suffixIcon,
// //     this.validator,
// //     this.onChanged,
// //     this.onTap,
// //   });

// //   @override
// //   State<CustomTextField> createState() => _CustomTextFieldState();
// // }

// // class _CustomTextFieldState extends State<CustomTextField> {
// //   final FocusNode _focusNode = FocusNode();
// //   bool _isObscured = true;

// //   @override
// //   void dispose() {
// //     _focusNode.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final bool isPassword = widget.obscureText;

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         if (widget.labelText != null) ...[
// //           Text(
// //             widget.labelText!,
// //             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
// //           ),
// //           const SizedBox(height: 6),
// //         ],
// //         TextFormField(
// //           controller: widget.controller,
// //           focusNode: _focusNode,
// //           keyboardType: widget.keyboardType,
// //           readOnly: widget.readOnly,
// //           maxLines: widget.maxLines,
// //           obscureText: isPassword ? _isObscured : false,
// //           validator: widget.validator,
// //           onChanged: widget.onChanged,
// //           onTap: widget.onTap,
// //           decoration: InputDecoration(
// //             hintText: widget.hintText,
// //             contentPadding: const EdgeInsets.symmetric(
// //               horizontal: 14,
// //               vertical: 14,
// //             ),
// //             prefixIcon: widget.prefixIcon,
// //             suffixIcon: isPassword
// //                 ? IconButton(
// //                     icon: Icon(
// //                       _isObscured ? Icons.visibility_off : Icons.visibility,
// //                     ),
// //                     onPressed: () {
// //                       setState(() {
// //                         _isObscured = !_isObscured;
// //                       });
// //                     },
// //                   )
// //                 : widget.suffixIcon,
// //             border: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(AppSizes.radius),
// //               borderSide: const BorderSide(color: AppColors.border),
// //             ),
// //             enabledBorder: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(AppSizes.radius),
// //               borderSide: const BorderSide(color: AppColors.border),
// //             ),
// //             focusedBorder: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(AppSizes.radius),
// //               borderSide: const BorderSide(color: AppColors.progressIndicator),
// //             ),
// //             errorBorder: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(AppSizes.radius),
// //               borderSide: const BorderSide(color: Colors.red),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import '../constants/app_colors.dart';
// import '../constants/app_sizes.dart';

// class CustomTextField extends StatefulWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final TextInputType keyboardType;
//   final bool obscureText;
//   final int maxLines;
//   final Widget? prefixIcon;
//   final String? Function(String?)? validator;
//   final ValueChanged<String>? onChanged;

//   const CustomTextField({
//     super.key,
//     required this.controller,
//     required this.hintText,
//     this.keyboardType = TextInputType.text,
//     this.obscureText = false,
//     this.maxLines = 1,
//     this.prefixIcon,
//     this.validator,
//     this.onChanged,
//   });

//   @override
//   State<CustomTextField> createState() => _CustomTextFieldState();
// }

// class _CustomTextFieldState extends State<CustomTextField> {
//   bool _isObscured = true;

//   @override
//   Widget build(BuildContext context) {
//     final bool isPassword = widget.obscureText;

//     return TextFormField(
//       controller: widget.controller,
//       keyboardType: widget.keyboardType,
//       maxLines: widget.maxLines,
//       obscureText: isPassword ? _isObscured : false,
//       validator: widget.validator,
//       onChanged: widget.onChanged,
//       decoration: InputDecoration(
//         hintText: widget.hintText,
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
//         prefixIcon: widget.prefixIcon,
//         suffixIcon: isPassword
//             ? IconButton(
//                 icon: Icon(
//                   _isObscured
//                       ? Icons.visibility_off_outlined
//                       : Icons.visibility_outlined,
//                   color: Colors.grey.shade600,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _isObscured = !_isObscured;
//                   });
//                 },
//               )
//             : null,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppSizes.radius),
//           borderSide: const BorderSide(color: AppColors.border),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppSizes.radius),
//           borderSide: const BorderSide(color: AppColors.border),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppSizes.radius),
//           borderSide: const BorderSide(color: AppColors.progressIndicator),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppSizes.radius),
//           borderSide: const BorderSide(color: Colors.red),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final int maxLines;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.prefixIcon,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
      cursorColor: AppColors.progressIndicator, // ✅ Cursor color
      decoration: _inputDecoration(),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      border: _border(AppColors.border),
      enabledBorder: _border(AppColors.border),
      focusedBorder: _border(AppColors.progressIndicator),
      errorBorder: _border(Colors.red),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radius),
      borderSide: BorderSide(color: color),
    );
  }
}
