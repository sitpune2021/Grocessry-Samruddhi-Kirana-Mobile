import 'package:flutter/material.dart';

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
                  colors: [
                    Color(0xffF06B2D),
                    Color(0xffFFF1EB),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white,
                    child:
                    Icon(Icons.person, size: 50, color: Colors.grey),
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
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 15,
                    ),
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
                    onTap: () {},
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
            _sectionCard(
              "Your Information",
              [
                _itemTile(Icons.location_on_outlined, "Address Book"),
                _itemTile(Icons.favorite_border, "Wishlist"),
              ],
            ),

            const SizedBox(height: 18),

            // ---------------- OTHER ----------------
            _sectionCard(
              "Other Options",
              [
                _itemTile(Icons.person_outline, "Edit Profile"),
                _itemTile(Icons.share_outlined, "Share App"),
                _itemTile(Icons.info_outline, "About Us"),
                _itemTile(Icons.logout, "Logout", isLogout: true),
              ],
            ),

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
                  offset: const Offset(0, 2))
            ],
          ),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Colors.green),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                title,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            ...items,
          ],
        ),
      ),
    );
  }

  // ----------------------------- LIST TILE UI ------------------------------
  Widget _itemTile(IconData icon, String label, {bool isLogout = false}) {
    return InkWell(
      onTap: () {},
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
            trailing: const Icon(Icons.chevron_right, size: 22, color: Colors.grey),
          ),
          const Divider(height: 1)
        ],
      ),
    );
  }
}
