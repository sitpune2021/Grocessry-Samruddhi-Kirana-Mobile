import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class AppMobileField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool showCountryCode;

  const AppMobileField({
    super.key,
    required this.controller,
    this.hintText = "Mobile Number",
    this.validator,
    this.onChanged,
    this.showCountryCode = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      cursorColor: AppColors.progressIndicator, // ✅ Cursor color
      maxLength: 10, // ✅ 10-digit limit
      onChanged: onChanged,
      validator: validator,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // only numbers
      ],
      decoration: InputDecoration(
        hintText: hintText,
        counterText: "", // hides counter
        prefixIcon: showCountryCode
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "+91",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : const Icon(Icons.phone),
        prefixIconConstraints: const BoxConstraints(minWidth: 50, minHeight: 0),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        border: _border(AppColors.border),
        enabledBorder: _border(AppColors.border),
        focusedBorder: _border(AppColors.progressIndicator),
        errorBorder: _border(Colors.red),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radius),
      borderSide: BorderSide(color: color),
    );
  }
}
