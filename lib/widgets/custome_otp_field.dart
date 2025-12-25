import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class AppOtpField extends StatelessWidget {
  final TextEditingController controller;
  final int otpLength;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onCompleted;

  const AppOtpField({
    super.key,
    required this.controller,
    this.otpLength = 6,
    this.validator,
    this.onChanged,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      cursorColor: AppColors.progressIndicator,
      maxLength: otpLength,
      autofocus: true,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: validator,
      onChanged: (value) {
        onChanged?.call(value);
        if (value.length == otpLength) {
          onCompleted?.call();
          FocusScope.of(context).unfocus(); // optional
        }
      },
      decoration: InputDecoration(
        hintText: "Enter OTP",
        counterText: "",
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        border: _border(AppColors.border),
        enabledBorder: _border(AppColors.border),
        focusedBorder: _border(AppColors.progressIndicator),
        errorBorder: _border(Colors.red),
      ),
      style: const TextStyle(
        letterSpacing: 6, // ✅ OTP look without boxes
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radius),
      borderSide: BorderSide(color: color),
    );
  }
}
