import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../home/dashboard.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Pattern - Fixed positioning
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/images/login_bg.png", // Make sure this path is correct
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback if image fails to load
                return Container(
                  color: Colors.green.shade50, // Fallback color
                );
              },
            ),
          ),

          // Content overlay
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Title
                    Text(
                      "Log In or Sign Up",
                      style: GoogleFonts.poppins(
                        color: Colors.green.shade700,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Center Logo
                    Center(
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/login_screen_logo.png",
                            height: 200,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 140,
                                width: 140,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.shopping_cart,
                                  size: 60,
                                  color: Colors.green.shade700,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 0),
                        ],
                      ),
                    ),

                    const SizedBox(height: 0),

                    // Gradient Text
                    Center(
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            colors: [
                              Color(0xFF056839), // #056839
                              Color(0xFFF16D30), // #F16D30
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds);
                        },
                        child: Text(
                          "“Freshness at rabbit speed.”",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 1),

                    Center(
                      child: Text(
                        "Log In or Sign Up",
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade700,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    // Mobile Number Field
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          Text(
                            "+91",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter mobile number",
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.grey.shade500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DashboardScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Login Text
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Already have an account? ",
                              style: GoogleFonts.poppins(
                                color: Colors.grey.shade700,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: "Log In",
                              style: GoogleFonts.poppins(
                                color: Colors.orange.shade700,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
