import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samruddha_kirana/constants/app_colors.dart';
import 'package:samruddha_kirana/providers/auth/auth_provider.dart';
import 'package:samruddha_kirana/validation/validation.dart';
import 'package:samruddha_kirana/widgets/custome_password_field.dart';
import 'package:go_router/go_router.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> submitPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();

    final res = await auth.setNewPassword(
      newPassword: newPasswordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
    );

    if (!mounted) return; // ✅ async context safe

    if (res.success) {
      auth.resetForgotPasswordState();

      /// Clear entire navigation stack & go to login
      context.go('/login');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(res.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    /// RESPONSIVE VALUES
    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 22,
      conditionalValues: const [
        Condition.largerThan(name: TABLET, value: 60),
        Condition.largerThan(name: DESKTOP, value: 120),
      ],
    ).value;

    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 26,
      conditionalValues: const [Condition.largerThan(name: TABLET, value: 30)],
    ).value;

    final buttonHeight = ResponsiveValue<double>(
      context,
      defaultValue: 55,
      conditionalValues: const [Condition.largerThan(name: TABLET, value: 60)],
    ).value;

    return PopScope(
      canPop: false, // 🚫 Disable system back
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            /// BACKGROUND
            Positioned.fill(
              child: Image.asset(
                "assets/images/login_bg.png",
                fit: BoxFit.cover,
              ),
            ),

            /// MAIN CONTENT
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 60),

                                  /// TITLE
                                  Center(
                                    child: Text(
                                      "Set New Password",
                                      style: GoogleFonts.poppins(
                                        fontSize: titleFontSize,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green.shade800,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 30),

                                  /// LOGO
                                  Center(
                                    child: Image.asset(
                                      "assets/images/login_screen_logo.png",
                                      height: 150,
                                    ),
                                  ),

                                  const SizedBox(height: 30),

                                  /// NEW PASSWORD
                                  AppPasswordField(
                                    controller: newPasswordController,
                                    hintText: "New Password",
                                    prefixIcon: const Icon(Icons.lock),
                                    validator: Validators.password,
                                  ),

                                  const SizedBox(height: 20),

                                  /// CONFIRM PASSWORD
                                  AppPasswordField(
                                    controller: confirmPasswordController,
                                    hintText: "Confirm Password",
                                    prefixIcon: const Icon(Icons.lock),
                                    validator: Validators.password,
                                  ),

                                  const SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ),

                          /// BOTTOM BUTTON
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: SizedBox(
                              width: double.infinity,
                              height: buttonHeight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.darkGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: submitPassword,
                                child: Text(
                                  "Set Password",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
