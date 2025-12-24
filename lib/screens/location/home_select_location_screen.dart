import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:samruddha_kirana/screens/location/select_location_screen.dart';

class HomeSelectLocationScreen extends StatelessWidget {
  const HomeSelectLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          "Select Location",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            /// Search Bar
            _searchBox(context),

            const SizedBox(height: 20),

            /// Action Options
            _locationOption(
              icon: Icons.my_location,
              color: Colors.pink,
              title: "Use my Current Location",
              onTap: () {},
            ),

            _locationOption(
              icon: Icons.add,
              color: Colors.pink,
              title: "Add New Address",
              showArrow: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SelectLocationScreen(),
                  ),
                );
              },
            ),

            _locationOption(
              icon: FontAwesomeIcons.whatsapp,
              color: Colors.green,
              title: "Request address from friend",
              showArrow: true,
              onTap: () {},
            ),

            const SizedBox(height: 25),

            Text(
              "Saved Addresses",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),

            /// Address Card
            _savedAddressCard(
              context: context, // 👈 pass context here
              title: "Home",
              distance: "58 m",
              subtitle: "Lakshmi Bai Colony, Tambave",
              isSelected: true,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ---------------- Search Box ----------------

  Widget _searchBox(BuildContext context) {
    return TextFormField(
      autofocus: false,
      cursorColor: Colors.black,
      style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: "Search Address",
        prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.6)),
        ),
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey.shade500,
        ),
      ),
      onChanged: (value) {
        // 🔍 Live search logic (API call or filter list)
        print("Searching: $value");
      },
    );
  }

  // ---------------- Action Tile Widget ----------------

  Widget _locationOption({
    required IconData icon,
    required Color color,
    required String title,
    bool showArrow = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
            if (showArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.grey.shade500,
              ),
          ],
        ),
      ),
    );
  }

  // ---------------- Address Card ----------------

  // ---------------- Address Card ----------------

  Widget _savedAddressCard({
    required BuildContext context, // 👈 Add this
    required String title,
    required String distance,
    required String subtitle,
    required bool isSelected,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.home, size: 26, color: Colors.black),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "$title • $distance",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffD7FFDE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Selected",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              children: [
                const Icon(Icons.share_outlined, size: 20),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _showBottomSheet(
                    context,
                    title,
                    subtitle,
                  ), // 👈 Now works
                  child: Icon(
                    Icons.more_vert,
                    size: 22,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, String title, String subtitle) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true, // optional (smooth on large content)
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                ),

                const SizedBox(height: 12),
                const Divider(),

                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: Text("Edit", style: GoogleFonts.poppins(fontSize: 15)),
                  onTap: () {
                    Navigator.pop(context);
                    print("Edit pressed");
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: Text(
                    "Delete",
                    style: GoogleFonts.poppins(fontSize: 15, color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    print("Delete pressed");
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
