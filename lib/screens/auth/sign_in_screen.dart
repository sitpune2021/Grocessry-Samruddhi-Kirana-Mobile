import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/config/routes.dart';
import 'package:samruddha_kirana/constants/app_colors.dart';
import 'package:samruddha_kirana/providers/auth/auth_provider.dart';
import 'package:samruddha_kirana/validation/validation.dart';
import 'package:samruddha_kirana/widgets/custome_mobile_no_field.dart';
import 'package:samruddha_kirana/widgets/custome_otp_field.dart';
import 'package:samruddha_kirana/widgets/custome_password_field.dart';
import 'package:samruddha_kirana/widgets/loader.dart';

enum LoginType { otp, password }

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();

  LoginType _loginType = LoginType.otp;

  int _otpTimer = 60;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    mobileController.dispose();
    passwordController.dispose();
    otpController.dispose();
    super.dispose();
  }

  // ---------------- OTP TIMER ----------------
  void _startOtpTimer() {
    _otpTimer = 60;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_otpTimer == 0) {
        timer.cancel();
      } else {
        setState(() => _otpTimer--); // UI-only
      }
    });
  }

  // ---------------- SUBMIT ----------------
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (mobileController.text.length != 10) return;

    final auth = context.read<AuthProvider>();
    ApiResponse response;

    if (_loginType == LoginType.password) {
      response = await auth.loginWithPassword(
        mobile: mobileController.text.trim(),
        password: passwordController.text,
      );
    } else {
      response = await auth.verifyLoginOtp(
        mobile: mobileController.text.trim(),
        otp: otpController.text.trim(),
      );
    }

    if (!mounted) return;

    if (response.success) {
      context.go(Routes.dashboard);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));
    }
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          /// BACKGROUND
          Positioned.fill(
            child: Image.asset("assets/images/login_bg.png", fit: BoxFit.cover),
          ),

          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      /// SCROLLABLE CONTENT
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),

                              Text(
                                "Log In",
                                style: GoogleFonts.poppins(
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade800,
                                ),
                              ),

                              const SizedBox(height: 30),

                              Center(
                                child: Image.asset(
                                  "assets/images/logo_app.png",
                                  height: 180,
                                ),
                              ),

                              const SizedBox(height: 25),

                              Row(
                                children: [
                                  _buildLoginTab("OTP Login", LoginType.otp),
                                  _buildLoginTab(
                                    "Password Login",
                                    LoginType.password,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 25),

                              /// MOBILE
                              AppMobileField(
                                controller: mobileController,
                                validator: Validators.mobile,
                              ),

                              const SizedBox(height: 18),

                              /// PASSWORD OR OTP FIELD
                              if (_loginType == LoginType.password) ...[
                                AppPasswordField(
                                  controller: passwordController,
                                  hintText: "Password",
                                  prefixIcon: const Icon(Icons.lock),
                                  validator: Validators.password,
                                ),

                                const SizedBox(height: 6),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      context.push(Routes.forgotPassword);
                                    },
                                    child: Text(
                                      "Forgot Password?",
                                      style: GoogleFonts.poppins(
                                        color: AppColors.darkGreen,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                              // if (_loginType == LoginType.password)
                              //   AppPasswordField(
                              //     controller: passwordController,
                              //     hintText: "Password",
                              //     prefixIcon: const Icon(Icons.lock),
                              //     validator: Validators.password,
                              //   )
                              else if (auth.otpSent)
                                AppOtpField(
                                  controller: otpController,
                                  otpLength: 6,
                                  onCompleted: _submit,
                                ),

                              /// RESEND OTP
                              if (_loginType == LoginType.otp && auth.otpSent)
                                _buildResendOtp(auth),

                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),

                      /// BOTTOM BUTTON
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            SizedBox(
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
                                        if (_loginType == LoginType.otp &&
                                            !auth.otpSent) {
                                          final res = await context
                                              .read<AuthProvider>()
                                              .loginWithOtp(
                                                mobile: mobileController.text
                                                    .trim(),
                                              );

                                          if (res.success) {
                                            _startOtpTimer();
                                          }
                                        } else {
                                          _submit();
                                        }
                                      },
                                child: Text(
                                  _loginType == LoginType.otp && !auth.otpSent
                                      ? "Send OTP"
                                      : "Continue",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Don’t have an account? ",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Register",
                                    style: GoogleFonts.poppins(
                                      color: Colors.orange.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        context.push(Routes.signup);
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// LOADER
          if (auth.isLoading)
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

  // ---------------- LOGIN TAB ----------------
  Widget _buildLoginTab(String text, LoginType type) {
    final isActive = _loginType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _loginType = type;
            context.read<AuthProvider>().resetOtp();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? Colors.green : Colors.grey.shade300,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.green.shade800 : Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- RESEND OTP ----------------
  Widget _buildResendOtp(AuthProvider auth) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Align(
        alignment: Alignment.centerRight,
        child: _otpTimer > 0
            ? Text(
                "Resend OTP in $_otpTimer s",
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              )
            : TextButton(
                onPressed: auth.isLoading
                    ? null
                    : () async {
                        final res = await context
                            .read<AuthProvider>()
                            .loginWithOtp(mobile: mobileController.text.trim());

                        if (res.success) {
                          _startOtpTimer();
                        }
                      },
                child: const Text(
                  "Resend OTP",
                  style: TextStyle(color: AppColors.darkGreen),
                ),
              ),
      ),
    );
  }
}
