import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_sizes.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String description;
  final String primaryButtonText;
  final String secondaryButtonText;
  final VoidCallback onPrimaryTap;
  final VoidCallback onSecondaryTap;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.description,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    required this.onPrimaryTap,
    required this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // -------- TITLE --------
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.title,
            ),

            const SizedBox(height: 12),

            // -------- DESCRIPTION --------
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),

            const SizedBox(height: 24),

            // -------- BUTTONS --------
            Row(
              children: [
                // Secondary Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: onSecondaryTap,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(secondaryButtonText),
                  ),
                ),

                const SizedBox(width: 12),

                // Primary Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPrimaryTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      primaryButtonText,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
