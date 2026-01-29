
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samruddha_kirana/providers/address/address_provider.dart';
import 'package:samruddha_kirana/providers/auth/auth_provider.dart';
import 'package:samruddha_kirana/screens/profile/profile_screen.dart';
import 'package:samruddha_kirana/widgets/address_buttom_sheet.dart';

import 'home_screen.dart';
import '../category/main_categories_screen.dart';
import '../orders/order_again_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  bool _sheetShown = false; // 🔑 Prevents multiple calls

  final List<Widget> _screens = const [
    HomeScreen(),
    MainCategoriesScreen(),
    OrderAgainScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer2<AddressProvider, AuthProvider>(
        builder: (context, addressProvider, authProvider, _) {
          // 🔍 Debug logging
          debugPrint('=== DASHBOARD BUILD ===');
          debugPrint('ADDR_LOADED = ${addressProvider.hasLoadedOnce}');
          debugPrint('ADDR_LOADING = ${addressProvider.isLoading}');
          debugPrint('AUTH_INIT  = ${authProvider.isInitialized}');
          debugPrint('LOGGED_IN  = ${authProvider.isLoggedIn}');
          // debugPrint('HAS_ADDR   = ${addressProvider.hasSelectedAddress}');

          debugPrint('ADDR_COUNT = ${addressProvider.addresses.length}');

          // 🎯 Show address sheet when ALL conditions are met
          if (!_sheetShown &&
              authProvider.isInitialized &&
              authProvider.isLoggedIn &&
              addressProvider.hasLoadedOnce &&
              !addressProvider.isLoading) {
            debugPrint('✅ ALL CONDITIONS MET - Scheduling bottom sheet');

            _sheetShown = true; // 🔒 Mark as shown (prevents repeats)

            // Schedule for next frame to avoid building during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                debugPrint('📱 Showing address bottom sheet now');
                showAddressBottomSheet(context);
              }
            });
          }

          return _screens[_currentIndex];
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
          selectedItemColor: const Color(0xffF06B2D),
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
            _navItem(0, Icons.home_filled, Icons.home_outlined, "Home"),
            _navItem(1, Icons.category, Icons.category_outlined, "Categories"),
            _navItem(2, Icons.refresh, Icons.refresh_outlined, "Order Again"),
            _navItem(3, Icons.person, Icons.person_outline, "Profile"),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
  ) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentIndex == index
              ? const Color(0xffF06B2D).withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        child: Icon(
          _currentIndex == index ? activeIcon : inactiveIcon,
          size: 24,
        ),
      ),
      label: label,
    );
  }
}
