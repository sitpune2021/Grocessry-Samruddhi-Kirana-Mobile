import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samruddha_kirana/config/routes.dart';
import 'package:samruddha_kirana/constants/app_colors.dart';
import 'package:samruddha_kirana/providers/product_all/all_product_provider.dart';
import 'package:samruddha_kirana/widgets/loader.dart';

class BrowseCategoriesPage extends StatefulWidget {
  const BrowseCategoriesPage({super.key});

  @override
  State<BrowseCategoriesPage> createState() => _BrowseCategoriesPageState();
}

class _BrowseCategoriesPageState extends State<BrowseCategoriesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AllProductProvider>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 12,
      conditionalValues: const [
        Condition.largerThan(name: TABLET, value: 24),
        Condition.largerThan(name: DESKTOP, value: 60),
      ],
    ).value;

    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 18,
      conditionalValues: const [Condition.largerThan(name: TABLET, value: 22)],
    ).value;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Browse Categories"),
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      // BODY WITH TOP SEARCH BAR
      body: Column(
        children: [
          // 🔍 TOP SEARCH BAR (DESIGN ONLY)
          Padding(
            padding: const EdgeInsets.all(12),
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
                  hintText: "Search categories",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // REST CONTENT
          Expanded(
            child: Consumer<AllProductProvider>(
              builder: (context, provider, _) {
                if (provider.isCategoryLoading) {
                  return const Center(child: Loader());
                }

                if (provider.categories.isEmpty) {
                  return const Center(child: Text("No categories available"));
                }

                return Row(
                  children: [
                    // LEFT CATEGORY BAR
                    Container(
                      width: ResponsiveValue<double>(
                        context,
                        defaultValue: 100,
                        conditionalValues: const [
                          Condition.largerThan(name: TABLET, value: 100),
                        ],
                      ).value,
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: AppColors.darkGreen),
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: provider.categories.length,
                        itemBuilder: (context, index) {
                          final category = provider.categories[index];
                          final isSelected = provider.selectedTab == index;

                          return _SideCategoryItem(
                            title: category.name,
                            imageUrl: category.images.isNotEmpty
                                ? category.images.first
                                : "",
                            isSelected: isSelected,
                            onTap: () {
                              provider.onCategorySelected(index);
                            },
                          );
                        },
                      ),
                    ),

                    // RIGHT CONTENT
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),

                            Text(
                              "SUBCATEGORIES",
                              style: TextStyle(
                                fontSize: titleFontSize - 4,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                letterSpacing: 1.2,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // SUBCATEGORY LIST
                            Expanded(
                              child: provider.subCategories.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/no_sub.png',
                                            height: 140,
                                            fit: BoxFit.contain,
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            "No Sub-Categories found",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: provider.subCategories.length,
                                      itemBuilder: (context, index) {
                                        final subCategory =
                                            provider.subCategories[index];

                                        final isLast =
                                            index ==
                                            provider.subCategories.length - 1;

                                        return Column(
                                          children: [
                                            _SubCategoryItem(
                                              title: subCategory.name,
                                              count: subCategory.productsCount
                                                  .toString(),
                                              onTap: () {
                                                context.push(
                                                  Routes.product,
                                                  extra: subCategory.id,
                                                );
                                                provider.fetchProducts(
                                                  subCategory.id,
                                                );
                                              },
                                            ),
                                            if (!isLast)
                                              const Divider(
                                                height: 1,
                                                thickness: 1,
                                                color: AppColors.darkGreen,
                                              ),
                                          ],
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- WIDGETS ----------------

class _SideCategoryItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const _SideCategoryItem({
    required this.title,
    required this.imageUrl,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected
            ? AppColors.darkGreen.withValues(alpha: 0.1)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: isSelected
                  ? AppColors.darkGreen.withValues(alpha: 0.2)
                  : Colors.grey.shade200,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: 28,
                width: 28,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Loader(strokeWidth: 2),
                errorWidget: (context, url, error) => Icon(
                  Icons.image_not_supported_outlined,
                  size: 26,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.darkGreen : Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _SubCategoryItem extends StatelessWidget {
  final String title;
  final String count;
  final VoidCallback onTap;

  const _SubCategoryItem({
    required this.title,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text("$count products available"),
      trailing: const Icon(Icons.chevron_right, color: AppColors.darkGreen),
    );
  }
}
