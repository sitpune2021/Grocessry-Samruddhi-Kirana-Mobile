// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:responsive_framework/responsive_framework.dart';
// import 'package:samruddha_kirana/constants/app_colors.dart';
// import 'package:samruddha_kirana/screens/home/dashboard.dart';
// import 'package:samruddha_kirana/validation/validation.dart';
// import 'package:samruddha_kirana/widgets/custome_mobile_no_field.dart';
// import 'package:samruddha_kirana/widgets/custome_password_field.dart';
// import 'package:samruddha_kirana/widgets/custome_text_field.dart';
// import 'package:samruddha_kirana/widgets/loader.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen>
//     with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();

//   final fullNameController = TextEditingController();
//   final mobileController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();

//   bool _isLoading = false;

//   late AnimationController _controller;
//   late Animation<double> _fade;
//   late Animation<Offset> _slide;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//     _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
//     _slide = Tween<Offset>(
//       begin: const Offset(0, 0.1),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;

//     FocusScope.of(context).unfocus();

//     setState(() => _isLoading = true);

//     // 🔥 Simulate API call
//     await Future.delayed(const Duration(seconds: 2));

//     setState(() => _isLoading = false);

//     // Navigate / success handling here
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => const DashboardScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final keyboardInset = MediaQuery.of(context).viewInsets.bottom;

//     final horizontalPadding = ResponsiveValue<double>(
//       context,
//       defaultValue: 20,
//       valueWhen: const [
//         Condition.largerThan(name: TABLET, value: 60),
//         Condition.largerThan(name: DESKTOP, value: 120),
//       ],
//     ).value!;

//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Stack(
//         children: [
//           /// BACKGROUND IMAGE
//           Positioned.fill(
//             child: Image.asset("assets/images/login_bg.png", fit: BoxFit.cover),
//           ),

//           /// CONTENT
//           SafeArea(
//             child: AnimatedPadding(
//               duration: const Duration(milliseconds: 250),
//               curve: Curves.easeOut,
//               padding: EdgeInsets.only(bottom: keyboardInset),
//               child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   return SingleChildScrollView(
//                     child: ConstrainedBox(
//                       constraints: BoxConstraints(
//                         minHeight: constraints.maxHeight,
//                       ),
//                       child: FadeTransition(
//                         opacity: _fade,
//                         child: SlideTransition(
//                           position: _slide,
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 22),
//                             child: Form(
//                               key: _formKey,
//                               child: Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   /// TOP CONTENT
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       const SizedBox(height: 30),

//                                       Text(
//                                         "Create Account",
//                                         style: GoogleFonts.poppins(
//                                           fontSize: 28,
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.green.shade800,
//                                         ),
//                                       ),

//                                       const SizedBox(height: 30),

//                                       AppTextField(
//                                         controller: fullNameController,
//                                         hintText: "Full Name",
//                                         validator: Validators.name,
//                                       ),

//                                       const SizedBox(height: 18),

//                                       AppMobileField(
//                                         controller: mobileController,
//                                         validator: Validators.mobile,
//                                       ),

//                                       const SizedBox(height: 18),

//                                       AppTextField(
//                                         controller: emailController,
//                                         hintText: "Email (Optional)",
//                                         keyboardType:
//                                             TextInputType.emailAddress,
//                                         validator: Validators.email,
//                                       ),

//                                       const SizedBox(height: 18),

//                                       AppPasswordField(
//                                         controller: passwordController,
//                                         hintText: "Password",
//                                         prefixIcon: const Icon(Icons.lock),
//                                         validator: Validators.password,
//                                       ),

//                                       const SizedBox(height: 18),

//                                       AppPasswordField(
//                                         controller: confirmPasswordController,
//                                         hintText: "Confirm Password",
//                                         prefixIcon: const Icon(Icons.lock),
//                                         validator: (value) {
//                                           if (value !=
//                                               passwordController.text) {
//                                             return "Passwords do not match";
//                                           }
//                                           return null;
//                                         },
//                                       ),
//                                     ],
//                                   ),

//                                   /// SUBMIT BUTTON
//                                   Padding(
//                                     padding: const EdgeInsets.only(bottom: 20),
//                                     child: SizedBox(
//                                       width: double.infinity,
//                                       height: 55,
//                                       child: ElevatedButton(
//                                         style: ElevatedButton.styleFrom(
//                                           backgroundColor: AppColors.darkGreen,
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(
//                                               14,
//                                             ),
//                                           ),
//                                         ),
//                                         onPressed: _isLoading ? null : _submit,
//                                         child: const Text(
//                                           "Create Account",
//                                           style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.w600,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),

//           /// 🔥 DOT LOADER OVERLAY
//           if (_isLoading)
//             IgnorePointer(
//               ignoring: true,
//               child: Container(
//                 color: Colors.black.withValues(alpha: 0.15),
//                 child: const Center(
//                   child: Loader(), // DOT LOADER
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

//final code
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samruddha_kirana/config/routes.dart';
import 'package:samruddha_kirana/constants/app_colors.dart';
import 'package:samruddha_kirana/providers/auth/auth_provider.dart';
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
    fullNameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    final authProvider = context.read<AuthProvider>();

    final fullName = fullNameController.text.trim();
    final nameParts = fullName.split(RegExp(r'\s+'));

    final firstName = nameParts.first;
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    final response = await authProvider.signup(
      firstName: firstName,
      lastName: lastName,
      mobile: mobileController.text.trim(),
      email: emailController.text.trim().isEmpty
          ? null
          : emailController.text.trim(),
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
    );

    if (!mounted) return;
    if (response.success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));

      context.go(Routes.dashboard);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;

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
      defaultValue: 52,
      conditionalValues: const [Condition.largerThan(name: TABLET, value: 58)],
    ).value;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          /// 🌄 BACKGROUND IMAGE (FIXED)
          Positioned.fill(
            child: Image.asset("assets/images/login_bg.png", fit: BoxFit.cover),
          ),

          /// 📄 CONTENT (KEYBOARD PUSHES THIS UP)
          SafeArea(
            bottom: false,
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(bottom: keyboardInset),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: FadeTransition(
                    opacity: _fade,
                    child: SlideTransition(
                      position: _slide,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// 🔹 TOP CONTENT
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 12),

                                  Text(
                                    "Create Account",
                                    style: GoogleFonts.poppins(
                                      fontSize: titleFontSize,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green.shade800,
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  AppTextField(
                                    controller: fullNameController,
                                    hintText: "Full Name",
                                    validator: Validators.name,
                                  ),

                                  const SizedBox(height: 16),

                                  AppMobileField(
                                    controller: mobileController,
                                    validator: Validators.mobile,
                                  ),

                                  const SizedBox(height: 16),

                                  AppTextField(
                                    controller: emailController,
                                    hintText: "Email (Optional)",
                                    keyboardType: TextInputType.emailAddress,
                                    validator: Validators.email,
                                  ),

                                  const SizedBox(height: 16),

                                  AppPasswordField(
                                    controller: passwordController,
                                    hintText: "Password",
                                    prefixIcon: const Icon(Icons.lock),
                                    validator: Validators.password,
                                  ),

                                  const SizedBox(height: 16),

                                  AppPasswordField(
                                    controller: confirmPasswordController,
                                    hintText: "Confirm Password",
                                    prefixIcon: const Icon(Icons.lock),
                                    validator: (value) {
                                      if (value != passwordController.text) {
                                        return "Passwords do not match";
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),

                              /// 🔘 BUTTON (ALWAYS VISIBLE)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 24,
                                  bottom: 20,
                                ),
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
                                    onPressed:
                                        context.watch<AuthProvider>().isLoading
                                        ? null
                                        : _submit,

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
              ),
            ),
          ),

          /// 🔥 LOADER
          if (context.watch<AuthProvider>().isLoading)
            IgnorePointer(
              ignoring: true,
              child: Container(
                color: Colors.black.withValues(alpha: 0.15),
                child: const Center(child: Loader()),
              ),
            ),
        ],
      ),
    );
  }
}
