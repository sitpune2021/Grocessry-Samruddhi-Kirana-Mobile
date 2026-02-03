import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:samruddha_kirana/constants/app_colors.dart';
import 'package:samruddha_kirana/providers/address/address_provider.dart';
import 'package:samruddha_kirana/providers/auth/auth_provider.dart';
import 'package:samruddha_kirana/screens/cart/new_cart_screen.dart';
import 'package:samruddha_kirana/screens/home/home_scrrens.dart';
import 'package:samruddha_kirana/screens/orders/active_order_screen.dart';
import 'package:samruddha_kirana/screens/profile/profile_screen.dart';
import 'package:samruddha_kirana/widgets/address_buttom_sheet.dart';

// import 'home_screen.dart';
import '../category/main_categories_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  bool _sheetShown = false;
  bool _isNavVisible = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_currentIndex != 0) return;

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isNavVisible) setState(() => _isNavVisible = false);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isNavVisible) setState(() => _isNavVisible = true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<Widget> get _screens => [
    // HomeScreen(scrollController: _scrollController),
    RealHome(scrollController: _scrollController),
    MainCategoriesScreen(),
    NewCartScreen(),
    // OrderAgainScreen(),
    ActiveOrdersPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Consumer2<AddressProvider, AuthProvider>(
            builder: (context, addressProvider, authProvider, _) {
              if (!_sheetShown &&
                  authProvider.isInitialized &&
                  authProvider.isLoggedIn &&
                  addressProvider.hasLoadedOnce &&
                  !addressProvider.isLoading) {
                _sheetShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    showAddressBottomSheet(context);
                  }
                });
              }
              return _screens[_currentIndex];
            },
          ),

          // Custom curved bottom bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 2,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 250),
              offset: _isNavVisible ? Offset.zero : const Offset(0, 1),
              child: _buildCustomBottomBar(),
            ),
          ),
        ],
      ),
    );
  }

  // ================= CUSTOM NAVBAR =================

  Widget _buildCustomBottomBar() {
    return SizedBox(
      height: 99,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Bottom bar
          Container(
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(0, Icons.home_outlined, "Home"),
                _navItem(1, Icons.category_outlined, "Categories"),
                const SizedBox(width: 40),
                _navItem(3, Icons.refresh_outlined, "Order"),
                _navItem(4, Icons.person_outline, "Profile"),
              ],
            ),
          ),

          // Floating Cart Button (same green as before)
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
              child: Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.preGreen, // your brand color
                    ),
                    child: const Icon(Icons.shopping_cart, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final bool isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: SizedBox(
        width: 64, // fixed responsive width
        height: 60, // fixed height = perfect balance
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // KEY LINE
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? AppColors.preGreen : Colors.grey.shade600,
            ),
            const SizedBox(height: 4), // ideal spacing
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                height: 1.1, // KEY LINE (removes extra white space)
                color: isActive ? AppColors.preGreen : Colors.grey.shade600,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
