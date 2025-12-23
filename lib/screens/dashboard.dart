import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samruddha_kirana/screens/profile_screen.dart';

import 'home_screen.dart';
import 'main_categories_screen.dart';
import 'order_again_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    // Placeholder
    MainCategoriesScreen(),
    OrderAgainScreen(),
    ProfileScreen(), // Placeholder
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          selectedItemColor: const Color(
            0xffF06B2D,
          ), // Orange color matching your theme
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          showUnselectedLabels: true,
          items: [
            // Home
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == 0
                      ? const Color(0xffF06B2D).withOpacity(0.1)
                      : Colors.transparent,
                ),
                child: Icon(
                  _currentIndex == 0 ? Icons.home_filled : Icons.home_outlined,
                  size: 24,
                ),
              ),
              label: "Home",
            ),

            // Categories
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == 1
                      ? const Color(0xffF06B2D).withOpacity(0.1)
                      : Colors.transparent,
                ),
                child: Icon(
                  _currentIndex == 1 ? Icons.category : Icons.category_outlined,
                  size: 24,
                ),
              ),
              label: "Categories",
            ),

            // Order Again
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == 2
                      ? const Color(0xffF06B2D).withOpacity(0.1)
                      : Colors.transparent,
                ),
                child: Icon(
                  _currentIndex == 2 ? Icons.refresh : Icons.refresh_outlined,
                  size: 24,
                ),
              ),
              label: "Order Again",
            ),

            // Profile
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == 3
                      ? const Color(0xffF06B2D).withOpacity(0.1)
                      : Colors.transparent,
                ),
                child: Icon(
                  _currentIndex == 3 ? Icons.person : Icons.person_outline,
                  size: 24,
                ),
              ),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
