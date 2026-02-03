// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:responsive_framework/responsive_framework.dart';
// import 'package:samruddha_kirana/config/routes.dart';
// import 'package:samruddha_kirana/constants/app_colors.dart';
// import 'package:samruddha_kirana/providers/auth/auth_provider.dart';
// import 'package:samruddha_kirana/validation/validation.dart';
// import 'package:samruddha_kirana/widgets/custome_mobile_no_field.dart';
// import 'package:samruddha_kirana/widgets/custome_otp_field.dart';

// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final mobileController = TextEditingController();
//   final otpController = TextEditingController();

//   @override
//   void dispose() {
//     mobileController.dispose();
//     otpController.dispose();
//     super.dispose();
//   }

//   // bool otpSent = false;
//   // int otpTimer = 60;
//   // Timer? timer;

//   // @override
//   // void dispose() {
//   //   timer?.cancel();
//   //   mobileController.dispose();
//   //   otpController.dispose();
//   //   super.dispose();
//   // }

//   // void startOtpTimer() {
//   //   otpTimer = 60;
//   //   timer?.cancel();

//   //   timer = Timer.periodic(const Duration(seconds: 1), (t) {
//   //     if (otpTimer == 0) {
//   //       t.cancel();
//   //     } else {
//   //       setState(() => otpTimer--);
//   //     }
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthProvider>();

//     /// RESPONSIVE VALUES
//     final horizontalPadding = ResponsiveValue<double>(
//       context,
//       defaultValue: 22,
//       conditionalValues: const [
//         Condition.largerThan(name: TABLET, value: 60),
//         Condition.largerThan(name: DESKTOP, value: 120),
//       ],
//     ).value;

//     final titleFontSize = ResponsiveValue<double>(
//       context,
//       defaultValue: 28,
//       conditionalValues: const [Condition.largerThan(name: TABLET, value: 32)],
//     ).value;

//     final buttonHeight = ResponsiveValue<double>(
//       context,
//       defaultValue: 55,
//       conditionalValues: const [Condition.largerThan(name: TABLET, value: 60)],
//     ).value;

//     return PopScope(
//       canPop: true, // ✅ system back allowed

//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Stack(
//           children: [
//             /// BACKGROUND
//             Positioned.fill(
//               child: Image.asset(
//                 "assets/images/login_bg.png",
//                 fit: BoxFit.cover,
//               ),
//             ),

//             /// MAIN CONTENT (BELOW BACK BUTTON)
//             SafeArea(
//               child: Center(
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(maxWidth: 520),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: horizontalPadding,
//                     ),
//                     child: Column(
//                       children: [
//                         /// SCROLLABLE CONTENT
//                         Expanded(
//                           child: SingleChildScrollView(
//                             physics: const BouncingScrollPhysics(),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const SizedBox(height: 50),

//                                 Center(
//                                   child: Text(
//                                     "Forgot Password",
//                                     style: GoogleFonts.poppins(
//                                       fontSize: titleFontSize,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.green.shade800,
//                                     ),
//                                   ),
//                                 ),

//                                 const SizedBox(height: 30),

//                                 Center(
//                                   child: Image.asset(
//                                     "assets/images/login_screen_logo.png",
//                                     height: 160,
//                                   ),
//                                 ),

//                                 const SizedBox(height: 25),

//                                 /// MOBILE FIELD
//                                 AppMobileField(
//                                   controller: mobileController,
//                                   validator: Validators.mobile,
//                                 ),

//                                 const SizedBox(height: 18),

//                                 /// OTP FIELD
//                                 if (auth.otpSent)
//                                   AppOtpField(
//                                     controller: otpController,
//                                     otpLength: 6,
//                                    onCompleted: () async {
//                                       final res = await context
//                                           .read<AuthProvider>()
//                                           .verifyForgotPasswordOtp(
//                                             mobile: mobileController.text
//                                                 .trim(),
//                                             otp:
//                                                 otpController.text.trim(),
//                                           );

//                                       if (res.success) {
//                                         context.go(Routes.setPassword);
//                                       }
//                                     },
//                                   ),

//                                 /// RESEND OTP
//                                 if (auth.otpSent)
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 10),
//                                     child: Align(
//                                       alignment: Alignment.centerRight,
//                                       child: auth.otpTimer > 0
//                                           ? Text(
//                                               "Resend OTP in ${auth.otpTimer} s",
//                                               style: GoogleFonts.poppins(
//                                                 color: Colors.grey.shade600,
//                                                 fontSize: 14,
//                                               ),
//                                             )
//                                           : TextButton(
//                                               onPressed: auth.isLoading
//                                                   ? null
//                                                   : () {
//                                                       auth.sendForgotPasswordOtp(
//                                                         mobile: mobileController
//                                                             .text
//                                                             .trim(),
//                                                       );
//                                                     },
//                                               child: const Text(
//                                                 "Resend OTP",
//                                                 style: TextStyle(
//                                                   color: AppColors.darkGreen,
//                                                 ),
//                                               ),
//                                             ),
//                                     ),
//                                   ),

//                                 const SizedBox(height: 40),
//                               ],
//                             ),
//                           ),
//                         ),

//                         /// FIXED BOTTOM BUTTON
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 20),
//                           child: SizedBox(
//                             width: double.infinity,
//                             height: buttonHeight,
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.darkGreen,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(14),
//                                 ),
//                               ),
//                               onPressed: auth.isLoading
//                                   ? null
//                                   : () async {
//                                       if (!auth.otpSent) {
//                                         await auth.sendForgotPasswordOtp(
//                                           mobile: mobileController.text.trim(),
//                                         );
//                                       } else {
//                                         final res = await auth
//                                             .verifyForgotPasswordOtp(
//                                               mobile: mobileController.text
//                                                   .trim(),
//                                               otp: otpController.text.trim(),
//                                             );

//                                         if (res.success) {
//                                           // if (!mounted) return;
//                                           context.go(Routes.setPassword);
//                                         }
//                                       }
//                                     },
//                               child: Text(
//                                 auth.otpSent ? "Verify OTP" : "Send OTP",
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             /// BACK BUTTON (TOP MOST → ALWAYS CLICKABLE)
//             Positioned(
//               top: 0,
//               left: 0,
//               child: SafeArea(
//                 child: Material(
//                   color: Colors.transparent,

//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(50),
//                     onTap: () => Navigator.pop(context),
//                     child: Container(
//                       margin: const EdgeInsets.all(8),
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withValues(alpha: 0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.arrow_back_ios_new,
//                         size: 20,
//                         color: AppColors.darkGreen,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
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
import 'package:samruddha_kirana/widgets/custome_otp_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final mobileController = TextEditingController();
  final otpController = TextEditingController();

  @override
  void dispose() {
    mobileController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

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
      defaultValue: 28,
      conditionalValues: const [Condition.largerThan(name: TABLET, value: 32)],
    ).value;

    final buttonHeight = ResponsiveValue<double>(
      context,
      defaultValue: 55,
      conditionalValues: const [Condition.largerThan(name: TABLET, value: 60)],
    ).value;

    return PopScope(
      canPop: true,
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
                    child: Column(
                      children: [
                        /// SCROLLABLE CONTENT
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 50),

                                Center(
                                  child: Text(
                                    "Forgot Password",
                                    style: GoogleFonts.poppins(
                                      fontSize: titleFontSize,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 30),

                                Center(
                                  child: Image.asset(
                                    "assets/images/logo_app.png",
                                    height: 160,
                                  ),
                                ),

                                const SizedBox(height: 25),

                                /// MOBILE FIELD
                                AppMobileField(
                                  controller: mobileController,
                                  validator: Validators.mobile,
                                ),

                                const SizedBox(height: 18),

                                /// OTP FIELD (AUTO VERIFY)
                                if (auth.otpSent)
                                  AppOtpField(
                                    controller: otpController,
                                    otpLength: 6,
                                    onCompleted: () async {
                                      final res = await context
                                          .read<AuthProvider>()
                                          .verifyForgotPasswordOtp(
                                            // mobile: mobileController.text
                                            //     .trim(),
                                            otp: otpController.text.trim(),
                                          );
                                      if (!context.mounted) {
                                        return; // ✅ IMPORTANT
                                      }
                                      if (res.success) {
                                        context.go(Routes.setPassword);
                                      }
                                    },
                                  ),

                                /// RESEND OTP
                                if (auth.otpSent)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: auth.otpTimer > 0
                                          ? Text(
                                              "Resend OTP in ${auth.otpTimer} s",
                                              style: GoogleFonts.poppins(
                                                color: Colors.grey.shade600,
                                                fontSize: 14,
                                              ),
                                            )
                                          : TextButton(
                                              onPressed: auth.isLoading
                                                  ? null
                                                  : () {
                                                      auth.sendForgotPasswordOtp(
                                                        mobile: mobileController
                                                            .text
                                                            .trim(),
                                                      );
                                                    },
                                              child: const Text(
                                                "Resend OTP",
                                                style: TextStyle(
                                                  color: AppColors.darkGreen,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),

                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),

                        /// FIXED BOTTOM BUTTON
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
                              onPressed: auth.isLoading
                                  ? null
                                  : () async {
                                      if (!auth.otpSent) {
                                        await auth.sendForgotPasswordOtp(
                                          mobile: mobileController.text.trim(),
                                        );
                                      } else {
                                        final res = await auth
                                            .verifyForgotPasswordOtp(
                                              // mobile: mobileController.text
                                              //     .trim(),
                                              otp: otpController.text.trim(),
                                            );
                                        if (!context.mounted) {
                                          return; // ✅ IMPORTANT
                                        }
                                        if (res.success) {
                                          context.go(Routes.setPassword);
                                        }
                                      }
                                    },
                              child: Text(
                                auth.otpSent ? "Verify OTP" : "Send OTP",
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

            /// BACK BUTTON (RESET PROVIDER + CLEAR CONTROLLERS)
            Positioned(
              top: 0,
              left: 0,
              child: SafeArea(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      context.read<AuthProvider>().resetForgotPasswordState();

                      mobileController.clear();
                      otpController.clear();

                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: AppColors.darkGreen,
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
