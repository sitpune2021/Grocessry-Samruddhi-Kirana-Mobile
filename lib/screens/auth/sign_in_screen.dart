import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samruddha_kirana/constants/app_colors.dart';
import 'package:samruddha_kirana/validation/validation.dart';
import 'package:samruddha_kirana/widgets/custome_mobile_no_field.dart';
import 'package:samruddha_kirana/widgets/custome_otp_field.dart';
import 'package:samruddha_kirana/widgets/custome_password_field.dart';
import 'package:samruddha_kirana/widgets/loader.dart';

import '../auth/sign_up_screen.dart';
import '../home/dashboard.dart';

enum LoginType { otp, password }

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  LoginType _loginType = LoginType.otp;
  bool _otpSent = false;
  bool _isLoading = false;

  int _otpTimer = 30;
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
    _otpTimer = 30;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_otpTimer == 0) {
        timer.cancel();
      } else {
        setState(() => _otpTimer--);
      }
    });
  }

  // ---------------- SUBMIT ----------------
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (mobileController.text.length != 10) return;

    // setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2)); // API simulation

    // setState(() => _isLoading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return AnimatedPadding(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// TOP CONTENT
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),

                                Text(
                                  "Log In",
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade800,
                                  ),
                                ),

                                const SizedBox(height: 30),

                                Center(
                                  child: Image.asset(
                                    "assets/images/login_screen_logo.png",
                                    height: 180,
                                  ),
                                ),

                                const SizedBox(height: 25),

                                /// LOGIN TYPE TABS
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

                                /// ✅ CUSTOM MOBILE FIELD
                                AppMobileField(
                                  controller: mobileController,
                                  validator: Validators.mobile,
                                ),

                                const SizedBox(height: 18),

                                /// ✅ CUSTOM PASSWORD / OTP FIELD
                                if (_loginType == LoginType.password)
                                  AppPasswordField(
                                    controller: passwordController,
                                    hintText: "Password",
                                    prefixIcon: const Icon(Icons.lock),
                                    validator: Validators.password,
                                  )
                                else if (_otpSent)
                                  AppOtpField(
                                    controller: otpController,
                                    otpLength: 6,
                                    onCompleted: _submit,
                                  ),

                                if (_loginType == LoginType.otp && _otpSent)
                                  _buildResendOtp(),
                              ],
                            ),

                            /// BOTTOM SECTION
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                children: [
                                  SizedBox(
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
                                      onPressed: _isLoading
                                          ? null
                                          : () {
                                              if (_loginType == LoginType.otp &&
                                                  !_otpSent) {
                                                setState(() {
                                                  _otpSent = true;
                                                });
                                                _startOtpTimer();
                                              } else {
                                                _submit();
                                              }
                                            },
                                      child: Text(
                                        _loginType == LoginType.otp && !_otpSent
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

                                  Center(
                                    child: RichText(
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
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        const SignUpScreen(),
                                                  ),
                                                );
                                              },
                                          ),
                                        ],
                                      ),
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
                );
              },
            ),
          ),

          /// LOADER OVERLAY
          if (_isLoading)
            IgnorePointer(
              ignoring: true,
              child: Container(
                color: Colors.black.withOpacity(0.15),
                child: const Center(child: Loader()),
              ),
            ),
        ],
      ),
    );
  }

  // ---------------- WIDGETS ----------------

  Widget _buildLoginTab(String text, LoginType type) {
    final bool isActive = _loginType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _loginType = type;
            _otpSent = false;
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

  Widget _buildResendOtp() {
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
                onPressed: _startOtpTimer,
                child: const Text("Resend OTP"),
              ),
      ),
    );
  }
}
