import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samruddha_kirana/constants/app_colors.dart';
import 'package:samruddha_kirana/providers/auth/auth_provider.dart';
import 'package:samruddha_kirana/widgets/loader.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final emailCtrl = TextEditingController();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  bool _isDataSet = false;

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().getUserProfileData();
    });
  }

  /// LABEL
  Widget _inputLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.grey,
      ),
    );
  }

  /// INPUT FIELD
  Widget _inputField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      cursorColor: AppColors.darkGreen,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),

        filled: true,
        fillColor: const Color(0xffF3F6F5),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      defaultValue: 22,
      conditionalValues: const [Condition.largerThan(name: TABLET, value: 26)],
    ).value;

    final buttonHeight = ResponsiveValue<double>(
      context,
      defaultValue: 55,
      conditionalValues: const [Condition.largerThan(name: TABLET, value: 60)],
    ).value;

    return Scaffold(
      backgroundColor: const Color(0xffF6FAF8),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Update Profile",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isProfileLoading || auth.profile == null) {
            return const Center(child: Loader());
          }
          final profile = auth.profile;

          // set data only once
          if (profile != null && !_isDataSet) {
            firstNameCtrl.text = profile.data.firstName;
            lastNameCtrl.text = profile.data.lastName;
            emailCtrl.text = profile.data.email ?? '';
            phoneCtrl.text = profile.data.mobile;
            _isDataSet = true;
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// SCROLLABLE CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.manual,
                    child: Column(
                      children: [
                        /// PROFILE IMAGE
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 55,
                              backgroundImage: NetworkImage(
                                profile?.data.profilePhoto != null &&
                                        profile!.data.profilePhoto!.isNotEmpty
                                    ? profile.data.profilePhoto!
                                    : "https://i.pravatar.cc/300",
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        /// CARD
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Personal Information",
                                style: TextStyle(
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 20),

                              _inputLabel("FIRST NAME"),
                              _inputField(
                                hint: "John",
                                icon: Icons.person,
                                controller: firstNameCtrl,
                              ),

                              const SizedBox(height: 15),

                              _inputLabel("LAST NAME"),
                              _inputField(
                                hint: "Doe",
                                icon: Icons.person_outline,
                                controller: lastNameCtrl,
                              ),

                              const SizedBox(height: 15),

                              _inputLabel("EMAIL ADDRESS"),
                              _inputField(
                                hint: "john.doe@example.com",
                                icon: Icons.email_outlined,
                                controller: emailCtrl,
                              ),

                              const SizedBox(height: 15),

                              _inputLabel("PHONE NUMBER"),
                              _inputField(
                                hint: "+1 (555) 000-1234",
                                icon: Icons.phone,
                                controller: phoneCtrl,
                                readOnly: true,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),

                /// FIXED BOTTOM BUTTON
                SizedBox(
                  width: double.infinity,
                  height: buttonHeight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    // onPressed: () {
                    //   debugPrint("First Name: ${firstNameCtrl.text}");
                    //   debugPrint("Last Name: ${lastNameCtrl.text}");
                    //   debugPrint("Email: ${emailCtrl.text}");
                    //   // call update API here later
                    // },
                    onPressed: auth.isUpdateLoading
                        ? null
                        : () async {
                            final profile = auth.profile;

                            String? firstName;
                            String? lastName;
                            String? email;

                            // 🔥 Only send changed fields
                            if (firstNameCtrl.text.trim() !=
                                profile?.data.firstName) {
                              firstName = firstNameCtrl.text.trim();
                            }

                            if (lastNameCtrl.text.trim() !=
                                profile?.data.lastName) {
                              lastName = lastNameCtrl.text.trim();
                            }

                            if (emailCtrl.text.trim().isNotEmpty &&
                                emailCtrl.text.trim() != profile?.data.email) {
                              email = emailCtrl.text.trim();
                            }

                            // 🪵 DEBUG LOGS (REQUEST)
                            debugPrint("🟡 Update Profile Request:");
                            debugPrint("First Name: $firstName");
                            debugPrint("Last Name : $lastName");
                            debugPrint("Email     : $email");

                            final response = await auth.updateUserProfile(
                              firstName: firstName,
                              lastName: lastName,
                              email: email,
                            );

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(response.message),
                                  backgroundColor: response.success
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              );
                            }
                          },
                    child: auth.isUpdateLoading
                        ? const Loader()
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Update Profile",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.check_circle, color: Colors.white),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
