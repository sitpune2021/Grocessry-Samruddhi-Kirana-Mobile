import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samruddha_kirana/constants/app_colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';

import 'package:samruddha_kirana/providers/product_all/all_product_provider.dart';
import 'package:samruddha_kirana/providers/product_all/cart_provider.dart';
import 'package:samruddha_kirana/widgets/qty_selector.dart';
import 'package:samruddha_kirana/config/routes.dart';

class SearchProductsScreen extends StatefulWidget {
  const SearchProductsScreen({super.key});

  @override
  State<SearchProductsScreen> createState() => _SearchProductsScreenState();
}

class _SearchProductsScreenState extends State<SearchProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AllProductProvider>().clearSearch();
    });

    _scrollController.addListener(() {
      final provider = context.read<AllProductProvider>();

      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          provider.hasMoreSearch &&
          !provider.isSearchLoading &&
          _searchController.text.isNotEmpty) {
        provider.searchProductsApi(
          query: _searchController.text,
          loadMore: true,
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AllProductProvider>(
      builder: (context, provider, _) {
        final products = provider.searchResults;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.white,
            elevation: 0,
            title: TextField(
              cursorColor: AppColors.darkGreen,
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search products',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  provider.searchProductsApi(query: value);
                } else {
                  provider.clearSearch();
                }
              },
            ),
          ),

          body: provider.isSearchLoading && products.isEmpty
              ? const _SearchShimmer()
              : products.isEmpty
              ? _noResults()
              : GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: products.length + (provider.hasMoreSearch ? 1 : 0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: 240,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (_, index) {
                    if (index == products.length) {
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    }

                    return _productCard(context, products[index]);
                  },
                ),
        );
      },
    );
  }

  // ================= PRODUCT CARD (SAME DESIGN) =================
  Widget _productCard(BuildContext context, product) {
    final cartProvider = context.watch<CartProvider>();

    final item = cartProvider.items
        .where((i) => i.product.id == product.id)
        .toList();

    final qty = item.isEmpty ? 0 : item.first.qty;

    final mrp = double.tryParse(product.mrp) ?? 0;
    final price = double.tryParse(product.finalPrice) ?? 0;
    final discount = mrp > price ? (((mrp - price) / mrp) * 100).round() : 0;

    return GestureDetector(
      onTap: () => context.push(Routes.productDetails, extra: product.id),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(2),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product.productImageUrls.isNotEmpty
                        ? product.productImageUrls.first
                        : '',
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(color: Colors.white),
                    ),
                    errorWidget: (_, _, _) =>
                        Image.asset('assets/images/no_image.png'),
                  ),
                ),
                if (discount > 0)
                  Positioned(top: 8, left: 8, child: _discount(discount)),

                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      context.read<AllProductProvider>().toggleFavorite(
                        product.id,
                      );
                    },
                    child: Icon(
                      context
                                  .watch<AllProductProvider>()
                                  .favorites[product.id] ==
                              true
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color:
                          context
                                  .watch<AllProductProvider>()
                                  .favorites[product.id] ==
                              true
                          ? Colors.red
                          : Colors.grey,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        "₹${price.toStringAsFixed(0)}",
                        style: GoogleFonts.poppins(
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "₹${mrp.toStringAsFixed(0)}",
                        style: GoogleFonts.poppins(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AddQtyButton(
                    qty: qty,
                    maxQty: product.stock,
                    onAdd: () => cartProvider.addToCart(product: product),
                    onRemove: () => cartProvider.removeFromCart(product.id),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _discount(int d) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      "$d% OFF",
      style: const TextStyle(
        fontSize: 10,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _noResults() => const Center(child: Text("No products found"));
}

class _SearchShimmer extends StatelessWidget {
  const _SearchShimmer();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 9,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 240,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, _) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image placeholder
                Container(
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name
                      Container(
                        height: 14,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),

                      // Price row
                      Row(
                        children: [
                          Container(height: 14, width: 50, color: Colors.white),
                          const SizedBox(width: 6),
                          Container(height: 12, width: 40, color: Colors.white),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Add to cart button
                      Container(
                        height: 32,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
