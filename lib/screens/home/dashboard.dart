import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:samruddha_kirana/constants/app_colors.dart';
import 'package:samruddha_kirana/providers/address/address_provider.dart';
import 'package:samruddha_kirana/providers/auth/auth_provider.dart';
import 'package:samruddha_kirana/screens/cart/new_cart_screen.dart';
import 'package:samruddha_kirana/screens/category/browse_categories_screen.dart';
import 'package:samruddha_kirana/screens/home/home_scrrens.dart';
import 'package:samruddha_kirana/screens/orders/active_order_screen.dart';
import 'package:samruddha_kirana/screens/profile/profile_screen.dart';
import 'package:samruddha_kirana/widgets/address_buttom_sheet.dart';

class DashboardScreen extends StatefulWidget {
  final int initialIndex;
  const DashboardScreen({super.key, this.initialIndex = 0});

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
    _currentIndex = widget.initialIndex;

    _scrollController.addListener(() {
      // if (_currentIndex != 0) return;

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
    RealHome(scrollController: _scrollController),
    BrowseCategoriesPage(scrollController: _scrollController),
    NewCartScreen(scrollController: _scrollController),
    ActiveOrdersPage(scrollController: _scrollController),
    ProfileScreen(scrollController: _scrollController),
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

          // ===== CUSTOM CURVED NAVBAR =====
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
          // Curved Bottom Bar
          ClipPath(
            clipper: BottomNavCurveClipper(),
            clipBehavior: Clip.antiAlias,
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white,
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
          ),

          // Floating Cart Button
          Positioned(
            top: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                  _isNavVisible = true;
                });
              },
              child: Container(
                height: 55,
                width: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.shade100,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.15),
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
                      color: AppColors.preGreen,
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
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _currentIndex = index;
          _isNavVisible = true;
        });
      },
      child: SizedBox(
        width: 64,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? AppColors.preGreen : Colors.grey.shade600,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                height: 1.1,
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

// ================= CURVE CLIPPER =================

class BottomNavCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    const double notchRadius = 38;
    const double notchDepth = 73;

    path.lineTo((size.width / 2) - notchRadius, 0);

    path.quadraticBezierTo(
      size.width / 2,
      notchDepth,
      (size.width / 2) + notchRadius,
      0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
