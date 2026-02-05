import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samruddha_kirana/config/routes.dart';
import 'package:samruddha_kirana/constants/app_colors.dart';
import 'package:samruddha_kirana/providers/address/address_provider.dart';
import 'package:samruddha_kirana/providers/orders/banner_provider.dart';
import 'package:samruddha_kirana/providers/product_all/all_product_provider.dart';
import 'package:samruddha_kirana/providers/product_brand_provider/product_brand_provider.dart';
import 'package:samruddha_kirana/screens/home/home_banner.dart';
import 'package:samruddha_kirana/utils/address_type_mapper.dart';
import 'package:samruddha_kirana/utils/shimmer/home_shimmer.dart';
import 'package:samruddha_kirana/widgets/address_buttom_sheet.dart';
import 'package:samruddha_kirana/widgets/loader.dart';

class RealHome extends StatefulWidget {
  final ScrollController scrollController;
  const RealHome({super.key, required this.scrollController});

  @override
  State<RealHome> createState() => _RealHomeState();
}

class _RealHomeState extends State<RealHome> {
  int selectedTab = 0;

  final ScrollController _brandScrollController = ScrollController();
  int _brandDotIndex = 0;

  final ScrollController _categoryScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BannerProvider>().fetchBanners();
      context.read<AllProductProvider>().fetchCategories();
      context.read<ProductBrandProvider>().fetchBrands();
      context.read<AddressProvider>().fetchAllAddresses();
    });

    _brandScrollController.addListener(() {
      final offset = _brandScrollController.offset;
      setState(() {
        if (offset < 100) {
          _brandDotIndex = 0;
        } else if (offset < 220) {
          _brandDotIndex = 1;
        } else {
          _brandDotIndex = 2;
        }
      });
    });
  }

  @override
  void dispose() {
    _brandScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16,
      conditionalValues: const [
        Condition.largerThan(name: TABLET, value: 24),
        Condition.largerThan(name: DESKTOP, value: 60),
      ],
    ).value;

    final addressProvider = context.watch<AddressProvider>();
    final defaultAddress = addressProvider.defaultAddress;

    // ── shimmer gate: both initial fetches still running? ──
    final catProvider = context.watch<AllProductProvider>();
    final brandProvider = context.watch<ProductBrandProvider>();
    final bool showFullShimmer =
        catProvider.isCategoryLoading && brandProvider.isBrandLoading;

    // ── show full-screen shimmer while loading ──
    if (showFullShimmer) return const HomeShimmerScreen();

    // ── real content ──────────────────────────────────────
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// ================= FIXED TOP =================
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundColor: Color(0xffE8F8EF),
                        child: Icon(Icons.eco, color: AppColors.darkGreen),
                      ),
                      const SizedBox(width: 10),

                      //Address set/selection
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "DELIVER TO:",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),

                          GestureDetector(
                            onTap: () {
                              showAddressBottomSheet(context);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  defaultAddress == null
                                      ? "Select Address"
                                      : "${intToAddressType(defaultAddress.type).name.toUpperCase()} • ${defaultAddress.name}-${defaultAddress.addressLine}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 18,
                                  color: AppColors.darkGreen,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),
                      // notifiction
                      GestureDetector(
                        onTap: () {
                          // Handle notification tap
                        },
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xffF3F4F6),
                          child: Icon(
                            Icons.notifications_none,
                            color: AppColors.darkGreen,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  // search bar
                  GestureDetector(
                    onTap: () {
                      // Handle search bar tap
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffF3F4F6),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const TextField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                          prefixIcon: Icon(Icons.search),
                          hintText: "Search your product by name",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),

            /// ================= SCROLL AREA =================
            Expanded(
              child: SingleChildScrollView(
                controller: widget.scrollController,
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    /// banner
                    const HomeBannerSlider(),
                    
                    const SizedBox(height: 24),

                    /// categories
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Browse by Category",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      height: 100,
                      child: Consumer<AllProductProvider>(
                        builder: (context, provider, _) {
                          if (provider.categories.isEmpty) {
                            return const Center(child: Text("No categories"));
                          }

                          final isDesktop = ResponsiveBreakpoints.of(
                            context,
                          ).isDesktop;

                          return Scrollbar(
                            controller: _categoryScrollController,
                            thumbVisibility: isDesktop,
                            interactive: true,
                            thickness: isDesktop ? 6 : 3,
                            radius: const Radius.circular(12),
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              physics: const ClampingScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
                              itemCount: provider.categories.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 14),
                              itemBuilder: (context, index) {
                                final selected = provider.selectedTab == index;
                                final item = provider.categories[index];

                                return GestureDetector(
                                  onTap: () => context
                                      .read<AllProductProvider>()
                                      .onCategorySelected(index),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: selected
                                          ? LinearGradient(
                                              colors: [
                                                AppColors.darkGreen,
                                                AppColors.darkGreen.withValues(
                                                  alpha: 0.099,
                                                ),
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            )
                                          : null,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: selected
                                            ? AppColors.darkGreen
                                            : Colors.grey.shade300,
                                        width: selected ? 2 : 1,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: item.images.isNotEmpty
                                              ? item.images.first
                                              : "",
                                          height: 32,
                                          width: 32,
                                          fit: BoxFit.contain,
                                          placeholder: (context, url) =>
                                              const SizedBox(
                                                height: 32,
                                                width: 32,
                                                child: Loader(strokeWidth: 2),
                                              ),
                                          errorWidget: (context, url, error) =>
                                              Icon(
                                                Icons
                                                    .image_not_supported_outlined,
                                                size: 28,
                                                color: Colors.grey.shade400,
                                              ),
                                        ),

                                        const SizedBox(height: 4),
                                        Text(
                                          item.name,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: selected
                                                ? Colors.black45
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
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Explore Sub-Categories",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Consumer<AllProductProvider>(
                      builder: (context, provider, _) {
                        if (provider.subCategories.isEmpty) {
                          return Column(
                            children: [
                              const SizedBox(height: 20),
                              Image.asset(
                                'assets/images/no_sub.png',
                                height: 140,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "No Sub-Categories found",
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        }

                        return GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          childAspectRatio: 2.2,
                          physics: const NeverScrollableScrollPhysics(),
                          children: provider.subCategories.map((sub) {
                            final count =
                                provider.subCategoryCounts[sub.id] ?? 0;
                            debugPrint(
                              '🔵 SubCategory ID: ${sub.id} has $count products',
                            );
                            return GestureDetector(
                              onTap: () {
                                debugPrint('🟢 SubCategory ID: ${sub.id}');
                                context.push(Routes.product, extra: sub.id);
                                context
                                    .read<AllProductProvider>()
                                    .fetchProducts(sub.id);
                              },
                              child: SubCategoryCard(
                                sub.name,
                                "$count Items",
                                Icons.category,
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Our Partner Brands",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      height: 140,
                      child: Consumer<ProductBrandProvider>(
                        builder: (context, provider, _) {
                          if (provider.brands.isEmpty) {
                            return const Center(child: Text("No Brands Found"));
                          }

                          // final isDesktop = ResponsiveBreakpoints.of(
                          //   context,
                          // ).isDesktop;

                          return ListView.builder(
                            controller: _brandScrollController,
                            scrollDirection: Axis.horizontal,
                            physics: const ClampingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(15, 8, 15, 20),
                            itemCount: provider.brands.length,
                            itemBuilder: (context, index) {
                              final brand = provider.brands[index];

                              return InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () {
                                  debugPrint("🟢 Brand ID: ${brand.id}");
                                  context.push(
                                    Routes.brandListDetails,
                                    extra: brand.id,
                                  );
                                },
                                child: Container(
                                  width: 110,
                                  margin: const EdgeInsets.only(right: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.darkGreen.withValues(
                                          alpha: 0.08,
                                        ),
                                        Colors.white,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          imageUrl: brand.images.isNotEmpty
                                              ? brand.images.first
                                              : "",
                                          height: 32,
                                          width: 32,
                                          fit: BoxFit.contain,
                                          placeholder: (context, url) =>
                                              const SizedBox(
                                                height: 32,
                                                width: 32,
                                                child: Loader(strokeWidth: 2),
                                              ),
                                          errorWidget: (context, url, error) =>
                                              Icon(
                                                Icons
                                                    .image_not_supported_outlined,
                                                size: 28,
                                                color: Colors.grey.shade400,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
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

                    /// Dot Indicator
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _brandDotIndex
                                ? AppColors.darkGreen
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubCategoryCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;

  const SubCategoryCard(this.title, this.count, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xffF9FAFB),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xffE8F8EF),
              child: Icon(icon, color: AppColors.darkGreen),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(count, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
