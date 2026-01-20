import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:samruddha_kirana/config/routes.dart';
import 'package:samruddha_kirana/providers/auth/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- PROFILE HEADER ----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 25),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffF06B2D), Color(0xffFFF1EB)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Your Account",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "7899463980",
                    style: TextStyle(color: Colors.grey[800], fontSize: 15),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // ---------------- QUICK ACTIONS ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _actionButton(
                    icon: Icons.shopping_bag_outlined,
                    label: "Orders",
                    onTap: () {
                      context.push(Routes.order);
                    },
                  ),
                  const SizedBox(width: 12),
                  _actionButton(
                    icon: Icons.headset_mic_outlined,
                    label: "Help",
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- YOUR INFO ----------------
            _sectionCard("Your Information", [
              _itemTile(
                Icons.location_on_outlined,
                "Address Book",
                onTap: () {
                  context.push(Routes.getAddress);
                },
              ),
              _itemTile(Icons.favorite_border, "Wishlist"),
            ]),

            const SizedBox(height: 18),

            // ---------------- OTHER ----------------
            _sectionCard("Other Options", [
              _itemTile(Icons.person_outline, "Edit Profile"),
              _itemTile(Icons.share_outlined, "Share App"),
              _itemTile(Icons.info_outline, "About Us"),
              _itemTiles(context, Icons.logout, "Logout", isLogout: true),
            ]),

            const SizedBox(height: 35),
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
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // ITEMS WITH DIVIDER (EXCEPT LAST)
            ...List.generate(items.length, (index) {
              return Column(
                children: [
                  items[index],
                  if (index != items.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 20, // left padding
                      endIndent: 30, // right padding
                    ),
                ],
              );
            }),
          ],
        ),
      ),
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
            leading: Icon(icon, color: isLogout ? Colors.red : Colors.black87),
            title: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: isLogout ? Colors.red : Colors.black87,
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
  Widget _itemTile(
    IconData icon,
    String label, {
    bool isLogout = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: isLogout ? Colors.red : Colors.black87),
            title: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: isLogout ? Colors.red : Colors.black87,
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
}
