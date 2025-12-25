import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samruddha_kirana/constants/app_colors.dart';
import 'package:samruddha_kirana/screens/home/dashboard.dart';
import 'package:samruddha_kirana/validation/validation.dart';
import 'package:samruddha_kirana/widgets/custome_mobile_no_field.dart';
import 'package:samruddha_kirana/widgets/custome_password_field.dart';
import 'package:samruddha_kirana/widgets/custome_text_field.dart';
import 'package:samruddha_kirana/widgets/loader.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    // 🔥 Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    // Navigate / success handling here
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          /// BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset("assets/images/login_bg.png", fit: BoxFit.cover),
          ),

          /// CONTENT
          SafeArea(
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(bottom: keyboardInset),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: FadeTransition(
                        opacity: _fade,
                        child: SlideTransition(
                          position: _slide,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// TOP CONTENT
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 30),

                                      Text(
                                        "Create Account",
                                        style: GoogleFonts.poppins(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green.shade800,
                                        ),
                                      ),

                                      const SizedBox(height: 30),

                                      AppTextField(
                                        controller: fullNameController,
                                        hintText: "Full Name",
                                        validator: Validators.name,
                                      ),

                                      const SizedBox(height: 18),

                                      AppMobileField(
                                        controller: mobileController,
                                        validator: Validators.mobile,
                                      ),

                                      const SizedBox(height: 18),

                                      AppTextField(
                                        controller: emailController,
                                        hintText: "Email (Optional)",
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: Validators.email,
                                      ),

                                      const SizedBox(height: 18),

                                      AppPasswordField(
                                        controller: passwordController,
                                        hintText: "Password",
                                        prefixIcon: const Icon(Icons.lock),
                                        validator: Validators.password,
                                      ),

                                      const SizedBox(height: 18),

                                      AppPasswordField(
                                        controller: confirmPasswordController,
                                        hintText: "Confirm Password",
                                        prefixIcon: const Icon(Icons.lock),
                                        validator: (value) {
                                          if (value !=
                                              passwordController.text) {
                                            return "Passwords do not match";
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),

                                  /// SUBMIT BUTTON
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 55,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.darkGreen,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),
                                        onPressed: _isLoading ? null : _submit,
                                        child: const Text(
                                          "Create Account",
                                          style: TextStyle(
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
                  );
                },
              ),
            ),
          ),

          /// 🔥 DOT LOADER OVERLAY
          if (_isLoading)
            IgnorePointer(
              ignoring: true,
              child: Container(
                color: Colors.black.withValues(alpha: 0.15),
                child: const Center(
                  child: Loader(), // DOT LOADER
                ),
              ),
            ),
        ],
      ),
    );
  }
}
