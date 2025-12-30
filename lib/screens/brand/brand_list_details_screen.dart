import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import 'package:samruddha_kirana/providers/product_brand_provider/product_brand_provider.dart';
import 'package:samruddha_kirana/config/routes.dart';

class BrandProductsListScreen extends StatefulWidget {
  const BrandProductsListScreen({super.key});

  @override
  State<BrandProductsListScreen> createState() =>
      _BrandProductsListScreenState();
}

class _BrandProductsListScreenState extends State<BrandProductsListScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final brandId = GoRouterState.of(context).extra as int;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductBrandProvider>().fetchProductsByBrand(brandId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductBrandProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: Colors.white,

          /// ================= APP BAR =================
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              provider.selectedBrand?.name ?? 'Products',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),

          /// ================= BODY =================
          body: provider.isBrandProductLoading
              ? const _BrandProductGridShimmer()
              : provider.brandProducts.isEmpty
                  ? _noProductsUI()
                  : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: provider.brandProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 220,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        final product = provider.brandProducts[index];
                        return _productCard(product, context);
                      },
                    ),
        );
      },
    );
  }

  /// ================= PRODUCT CARD =================
  Widget _productCard(product, BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          Routes.productDetails,
          extra: product.id,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl:
                    product.imageUrls.isNotEmpty ? product.imageUrls.first : '',
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(color: Colors.white),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),

            /// DETAILS
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "₹${product.retailerPrice}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= NO PRODUCTS UI =================
  Widget _noProductsUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/no_product.png',
            height: 180,
          ),
          const SizedBox(height: 16),
          Text(
            "No products found",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= SHIMMER =================
class _BrandProductGridShimmer extends StatelessWidget {
  const _BrandProductGridShimmer();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 220,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }
}
