import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:samruddha_kirana/config/routes.dart';
import 'package:samruddha_kirana/constants/app_colors.dart';
import 'package:samruddha_kirana/providers/auth/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ---------------- HEADER ----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, bottom: 60),
              decoration: const BoxDecoration(
                color: AppColors.darkGreen,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4), // outer ring thickness
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white54, width: 2),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(6), // inner glow space
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white24,
                      ),
                      child: const CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.transparent,
                        child: Icon(
                          Icons.person,
                          size: 44,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Your Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "ID: 7899463980",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            // ---------------- QUICK ACTIONS FLOAT ----------------
            Transform.translate(
              offset: const Offset(0, -50),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _actionButton(
                      icon: Icons.shopping_bag,
                      label: "ORDERS",
                      onTap: () => context.push(Routes.order),
                    ),
                    const SizedBox(width: 12),
                    _actionButton(
                      icon: Icons.shopping_cart,
                      label: "CART",
                      onTap: () => context.push(Routes.newcart),
                    ),
                    const SizedBox(width: 12),
                    _actionButton(
                      icon: Icons.headset_mic,
                      label: "HELP",
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            // const SizedBox(height: 2),

            // ---------------- YOUR ACTIVITY ----------------
            _sectionCard("YOUR ACTIVITY", [
              _itemTile(
                Icons.location_on_rounded,
                "Address Book",
                onTap: () => context.push(Routes.getAddress),
              ),
              _itemTile(Icons.favorite_rounded, "Wishlist"),
            ]),

            const SizedBox(height: 18),

            // ---------------- SETTINGS ----------------
            _sectionCard("SETTINGS & INFO", [
              _itemTile(Icons.person_sharp, "Edit Profile",
                  onTap: () => context.push(Routes.updateProfile),),
              _itemTile(Icons.share_rounded, "Share App"),
              _itemTile(Icons.info_rounded, "About Us"),
              _itemTiles(
                context,
                Icons.logout_outlined,
                "Logout",
                isLogout: true,
              ),
              // DELETE ACCOUNT (disabled style)
              InkWell(
                onTap: () {
                  showDeleteDialog(context);
                },
                child: ListTile(
                  leading: Icon(Icons.delete_outline, color: Colors.grey),
                  title: Text(
                    "Delete Account",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.grey,
                    size: 22,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 24),

            // ---------------- APP VERSION ----------------
            const Text(
              "APP VERSION 2.0.1",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                letterSpacing: 0.8,
              ),
            ),

            const SizedBox(height: 24),

            // const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // -------------------------------- QUICK ACTION BUTTON --------------------------------
  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Colors.green),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------- SECTION CARD UI --------------------------------
  Widget _sectionCard(String title, List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- TITLE OUTSIDE ----------
          Padding(
            padding: const EdgeInsets.only(left: 6, bottom: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                letterSpacing: 0.6,
              ),
            ),
          ),

          // ---------- CARD ----------
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: List.generate(items.length, (index) {
                return Column(
                  children: [
                    items[index],
                    if (index != items.length - 1)
                      const Divider(
                        height: 1,
                        thickness: 0.20,
                        indent: 20,
                        endIndent: 30,
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteDialog(BuildContext context) {
    final media = MediaQuery.of(context);
    final size = media.size;
    final shortestSide = size.shortestSide;
    final isTablet = shortestSide >= 600;

    const dangerRed = Color(0xFFD32F2F);

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Delete',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (_, _, _) => const SizedBox.shrink(),
      transitionBuilder: (ctx, animation, _, _) {
        final scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );

        final fadeAnim = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );

        return SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: fadeAnim,
              child: ScaleTransition(
                scale: scaleAnim,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: isTablet ? 440 : size.width.clamp(280, 380),
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 28 : 20,
                      vertical: isTablet ? 26 : 22,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ICON
                        Container(
                          height: isTablet ? 56 : 50,
                          width: isTablet ? 56 : 50,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFDECEA),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.delete_forever_rounded,
                            size: 28,
                            color: dangerRed,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // TITLE
                        Text(
                          "Delete Account",
                          style: TextStyle(
                            fontSize: isTablet ? 20 : 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // MESSAGE
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 8 : 4,
                          ),
                          child: Text(
                            "This action is permanent and cannot be undone.\nAre you sure you want to delete your account?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isTablet ? 15 : 14,
                              color: Colors.black54,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),

                        // BUTTONS
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(ctx),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: dangerRed,
                                  side: const BorderSide(color: dangerRed),
                                  padding: EdgeInsets.symmetric(
                                    vertical: isTablet ? 14 : 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text("Cancel"),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: dangerRed,
                                  padding: EdgeInsets.symmetric(
                                    vertical: isTablet ? 14 : 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.pop(ctx);
                                  final res = await context
                                      .read<AuthProvider>()
                                      .deleteAccount(context);

                                  if (!res.success && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(res.message)),
                                    );
                                  }
                                },
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
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
    );
  }

  void showLogoutDialog(BuildContext context) {
    final media = MediaQuery.of(context);
    final size = media.size;
    final shortestSide = size.shortestSide;
    final isTablet = shortestSide >= 600;

    const primaryGreen = Color(0xFF2E7D32);

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Logout',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (_, _, _) => const SizedBox.shrink(),
      transitionBuilder: (ctx, animation, _, _) {
        final scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );

        final fadeAnim = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );

        return SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: fadeAnim,
              child: ScaleTransition(
                scale: scaleAnim,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: isTablet ? 440 : size.width.clamp(280, 380),
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 28 : 20,
                      vertical: isTablet ? 26 : 22,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ---------- ICON ----------
                        Container(
                          height: isTablet ? 56 : 50,
                          width: isTablet ? 56 : 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.logout_rounded,
                            size: 28,
                            color: primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ---------- TITLE ----------
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: isTablet ? 20 : 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // ---------- MESSAGE ----------
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 8 : 4,
                          ),
                          child: Text(
                            "Are you sure you want to logout?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isTablet ? 15 : 14,
                              color: Colors.black54,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),

                        // ---------- BUTTONS ----------
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(ctx),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: primaryGreen,
                                  side: const BorderSide(color: primaryGreen),
                                  padding: EdgeInsets.symmetric(
                                    vertical: isTablet ? 14 : 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text("Cancel"),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryGreen,
                                  padding: EdgeInsets.symmetric(
                                    vertical: isTablet ? 14 : 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  context.read<AuthProvider>().logout(context);
                                },
                                child: const Text(
                                  "Confirm",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
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
    );
  }

  Widget _itemTiles(
    BuildContext context,
    IconData icon,
    String label, {
    bool isLogout = false,
  }) {
    return InkWell(
      onTap: () {
        if (isLogout) {
          showLogoutDialog(context);
        }
      },
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: Colors.grey),
            title: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              size: 22,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------- LIST TILE UI ------------------------------
  Widget _itemTile(IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: Colors.grey),
            title: Text(label),
            trailing: const Icon(
              Icons.chevron_right,
              size: 22,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
