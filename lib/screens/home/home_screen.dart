import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samruddha_kirana/config/routes.dart';
import 'package:samruddha_kirana/providers/address/address_provider.dart';
import 'package:samruddha_kirana/providers/product_all/all_product_provider.dart';
import 'package:samruddha_kirana/providers/product_brand_provider/product_brand_provider.dart';
import 'package:samruddha_kirana/utils/address_type_mapper.dart';
import 'package:samruddha_kirana/widgets/address_buttom_sheet.dart';
import 'package:samruddha_kirana/widgets/loader.dart';
import 'package:samruddha_kirana/widgets/moving_text.dart';
import 'package:shimmer/shimmer.dart';

import '../category/categories_product_screen.dart';
import '../location/home_select_location_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AllProductProvider>().fetchCategories();
      context.read<ProductBrandProvider>().fetchBrands();
      context.read<AddressProvider>().fetchAllAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = context.watch<AddressProvider>();
    final defaultAddress = addressProvider.defaultAddress;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============= TOP GRADIENT HEADER WITH CATEGORY TABS =============
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffF06B2D), Color(0xffFFF1EB)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  // Time + Profile
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // const Text(
                      //   "10 minutes",
                      //   style: TextStyle(fontSize: 18, color: Colors.white),
                      // ),
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(
                          "assets/app_icon/ic_launcher.png",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// 🔥 DEFAULT ADDRESS SHOWN HERE
                  GestureDetector(
                    onTap: () {
                      showAddressBottomSheet(context);
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            defaultAddress == null
                                ? "Select Address"
                                : "${intToAddressType(defaultAddress.type).name.toUpperCase()} - ${defaultAddress.addressLine}",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),

                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) =>
                  //             const HomeSelectLocationScreen(),
                  //       ),
                  //     );
                  //   },
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: Text(
                  //           "WORK - At post Tambave",
                  //           style: GoogleFonts.poppins(
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.w600,
                  //             fontSize: 16,
                  //           ),
                  //           maxLines: 1,
                  //           overflow: TextOverflow.ellipsis,
                  //         ),
                  //       ),
                  //       Icon(
                  //         Icons.keyboard_arrow_down_rounded,
                  //         color: Colors.white,
                  //         size: 22,
                  //       ),
                  //       Spacer(),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 15),

                  // ------------ SEARCH BOX -------------
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.orange.shade700),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search",
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ============= CATEGORY TABS INSIDE HEADER =============
                  SizedBox(
                    height: 70,
                    child: Consumer<AllProductProvider>(
                      builder: (context, provider, _) {
                        // Loading
                        if (provider.isCategoryLoading) {
                          return const Center(
                            // child: CircularProgressIndicator(),
                            child: Loader(size: 25, strokeWidth: 2),
                          );
                        }

                        // No data
                        if (provider.categories.isEmpty) {
                          return const Center(child: Text("No data"));
                        }

                        // +1 for static "All"
                        final totalTabs = provider.categories.length + 1;

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: totalTabs,
                          itemBuilder: (context, index) {
                            // final selected = index == selectedTab;
                            final selected = provider.selectedTab == index;

                            // ---------- STATIC "ALL" TAB ----------
                            final title = index == 0
                                ? "All"
                                : provider.categories[index - 1].name;

                            return GestureDetector(
                              onTap: () => context
                                  .read<AllProductProvider>()
                                  .onCategorySelected(index),
                              child: Container(
                                margin: const EdgeInsets.only(right: 18),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: selected
                                      ? LinearGradient(
                                          colors: [
                                            Colors.white.withValues(alpha: 0.9),
                                            Colors.white.withValues(alpha: 0.7),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        )
                                      : const LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.transparent,
                                          ],
                                        ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selected
                                        ? Colors.white
                                        : const Color(0xffF06B2D),
                                    width: selected ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.category_rounded,
                                      size: 26,
                                      color: selected
                                          ? Colors.orange.shade700
                                          : Colors.grey.shade600,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      title,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: selected
                                            ? Colors.orange.shade800
                                            : Colors.grey.shade800,
                                        fontWeight: selected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // ============= HORIZONTAL PRODUCT BANNERS =============
            // ============= HORIZONTAL PRODUCT / SUB CATEGORY BANNERS =============
            SizedBox(
              height: 220,
              child: Consumer<AllProductProvider>(
                builder: (context, provider, _) {
                  // 🔄 Loading
                  if (provider.isSubCategoryLoading) {
                    return const Center(
                      child: Loader(size: 25, strokeWidth: 2),
                    );
                  }

                  // 🟢 ALL TAB → Static banners
                  if (provider.selectedTab == 0) {
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 15),
                      children: [
                        bannerCard("assets/fack_img/banner.jpeg"),
                        bannerCard("assets/fack_img/banner2.jpeg"),
                        bannerCard("assets/fack_img/banner3.jpeg"),
                      ],
                    );
                  }

                  // 🔴 CATEGORY CLICKED BUT NO SUB CATEGORIES
                  if (provider.subCategories.isEmpty) {
                    return Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /// IMAGE → CENTERED
                                Image.asset(
                                  'assets/images/no_sub.png',
                                  height: 140,
                                  fit: BoxFit.contain,
                                ),

                                const SizedBox(height: 20),

                                /// MARQUEE → FULL WIDTH
                                SizedBox(
                                  width: double.infinity,
                                  height: 30,
                                  child: InfiniteMarqueeText(
                                    text:
                                        "No Sub-Categories found, Please check back later.",
                                  ),
                                ),

                                const SizedBox(height: 6),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  // 🔵 SUB CATEGORIES FOUND → IMAGE WITH TEXT INSIDE
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 15),
                    itemCount: provider.subCategories.length,
                    itemBuilder: (context, index) {
                      final sub = provider.subCategories[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          debugPrint('🟢 SubCategory ID: ${sub.id}');
                          context.push(
                            Routes.product,
                            extra: sub.id, // ✅ sub-category id
                          );
                        },
                        child: Container(
                          width: 180,
                          height: 200, // 🔑 SAME AS IMAGE HEIGHT
                          margin: const EdgeInsets.only(
                            right: 12,
                          ), // ✅ GAP BETWEEN ITEMS
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              children: [
                                // IMAGE
                                Image.asset(
                                  "assets/fack_img/banner.jpeg",
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),

                                // DARK GRADIENT OVERLAY
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withValues(alpha: 0.6),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                ),

                                // TEXT INSIDE IMAGE (BOTTOM)
                                Positioned(
                                  left: 10,
                                  right: 10,
                                  bottom: 12,
                                  child: Text(
                                    sub.name,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [Colors.orange.shade700, Colors.green.shade700],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds);
                },
                child: Text(
                  "Brands",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            // ============= BRAND =============
            SizedBox(
              height: 140,
              child: Consumer<ProductBrandProvider>(
                builder: (context, provider, _) {
                  // 🔄 SHIMMER LOADING
                  if (provider.isBrandLoading) {
                    return brandShimmer();
                  }

                  // ❌ NO DATA
                  if (provider.brands.isEmpty) {
                    return const Center(child: Text("No Brands Found"));
                  }

                  // ✅ BRAND LIST
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 15),
                    itemCount: provider.brands.length,
                    itemBuilder: (context, index) {
                      final brand = provider.brands[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          debugPrint("🟢 Brand ID: ${brand.id}");

                          // 🔹 NAVIGATION WITH BRAND ID
                          context.push(
                            Routes.brandListDetails,
                            extra: brand.id, // ✅ brand id pass
                          );
                        },
                        child: Container(
                          width: 110,
                          margin: const EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: LinearGradient(
                              colors: [Colors.orange.shade50, Colors.white],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // 🖼️ STATIC BRAND IMAGE (AS YOU SAID)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  "assets/fack_img/img_3.png",
                                  height: 55,
                                  width: 55,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // 🏷️ BRAND NAME
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Text(
                                  brand.name,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // ============= BESTSELLERS TITLE =============
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [Colors.orange.shade700, Colors.green.shade700],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds);
                },
                child: Text(
                  "Bestsellers",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ============= BESTSELLER GRID =============
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 15),
                children: [
                  bestSellerItem(
                    context,
                    "Vegetables & Fruits",
                    "assets/fack_img/img_3.png",
                  ),
                  bestSellerItem(
                    context,
                    "Oil, Ghee & Masala",
                    "assets/fack_img/img_4.png",
                  ),
                  bestSellerItem(
                    context,
                    "Dairy, Bread & Eggs",
                    "assets/fack_img/img_3.png",
                  ),
                  bestSellerItem(
                    context,
                    "Bakery & Biscuits",
                    "assets/fack_img/img_4.png",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // ============= PINK OFFER BANNER =============
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    colors: [Colors.pink.shade300, Colors.purple.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    "assets/fack_img/banner3.png",
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ============= GROCERY SECTION =============
            buildCategorySection(
              title: "Grocery & Kitchen",
              gradientColors: [Colors.green.shade50, Colors.white],
              items: [
                ["Vegetables & Fruits", "assets/fack_img/img_5.png"],
                ["Atta , Rice & Dal", "assets/fack_img/img_6.png"],
                ["Oil, Ghee & Masala", "assets/fack_img/img_6.png"],
                ["Dairy, Bread & Eggs", "assets/fack_img/img_7.png"],
                ["Bakery & Biscuits", "assets/fack_img/img_8.png"],
                ["Vegetables & Fruits", "assets/fack_img/img_5.png"],
                ["Atta , Rice & Dal", "assets/fack_img/img_6.png"],
                ["Dairy, Bread & Eggs", "assets/fack_img/img_7.png"],
              ],
            ),

            // ============= BEAUTY CATEGORY =============
            buildCategorySection(
              title: "Beauty & Personal Care",
              gradientColors: [Colors.pink.shade50, Colors.white],
              items: [
                ["Bath & Body", "assets/fack_img/img_9.png"],
                ["Hair", "assets/fack_img/img_10.png"],
                ["Skin & Face", "assets/fack_img/img_11.png"],
                ["Beauty & Cosmetics", "assets/fack_img/img_12.png"],
                ["Baby Care", "assets/fack_img/img_13.png"],
                ["Bath & Body", "assets/fack_img/img_9.png"],
                ["Hair", "assets/fack_img/img_10.png"],
                ["Skin & Face", "assets/fack_img/img_11.png"],
              ],
            ),

            buildCategorySection(
              title: "Household Essentials",
              gradientColors: [Colors.blue.shade50, Colors.white],
              items: [
                ["Home & Lifestyle", "assets/fack_img/img_14.png"],
                ["Cleansers & Repelients", "assets/fack_img/img_15.png"],
                ["Electronics", "assets/fack_img/img_16.png"],
                ["Stationery & Games", "assets/fack_img/img_17.png"],
              ],
            ),

            // ============= SHOP BY STORE =============
            buildCategorySection(
              title: "Shop by store",
              gradientColors: [Colors.purple.shade50, Colors.white],
              items: [
                ["Spiritual Store", "assets/fack_img/img_18.png"],
                ["Pharma Store", "assets/fack_img/img_19.png"],
                ["E-Gifts Store", "assets/fack_img/img_20.png"],
                ["Pet Store", "assets/fack_img/img_21.png"],
                ["Sports Store", "assets/fack_img/img_22.png"],
                ["Spiritual Store", "assets/fack_img/img_18.png"],
                ["Pharma Store", "assets/fack_img/img_19.png"],
                ["E-Gifts Store", "assets/fack_img/img_20.png"],
              ],
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------

  Widget bannerCard(String img) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade100],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(img, fit: BoxFit.cover),
      ),
    );
  }

  Widget bestSellerItem(BuildContext context, String title, String img) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CategoryProductsScreen()),
        );
      },
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [Colors.orange.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
              child: Image.asset(img, height: 70, fit: BoxFit.cover),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget buildCategorySection({
    required String title,
    required List items,
    List<Color>? gradientColors,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: gradientColors ?? [Colors.white, Colors.grey.shade50],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [Colors.orange.shade700, Colors.green.shade700],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds);
              },
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 1),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisExtent: 110,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey.shade50],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          items[index][1],
                          height: 65,
                          width: 65,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          items[index][0],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget brandShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 15),
      itemCount: 6,
      itemBuilder: (_, __) {
        return Container(
          width: 110,
          margin: const EdgeInsets.only(right: 15),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
