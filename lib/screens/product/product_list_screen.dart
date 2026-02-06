import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:samruddha_kirana/providers/product_all/cart_provider.dart';
import 'package:samruddha_kirana/widgets/qty_selector.dart';
import 'package:shimmer/shimmer.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:samruddha_kirana/config/routes.dart';
import 'package:samruddha_kirana/widgets/custom_search_bar.dart';
import 'package:samruddha_kirana/providers/product_all/all_product_provider.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  bool _isSearchOpen = false;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  final ScrollController _scrollController = ScrollController();
  bool _showCartBar = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final subCategoryId = GoRouterState.of(context).extra as int;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AllProductProvider>();
      provider.clearProducts(); // ⭐ VERY IMPORTANT
      provider.fetchProducts(subCategoryId);
    });
  }

  @override
  void initState() {
    super.initState();

    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus && _isSearchOpen) {
        setState(() {
          _isSearchOpen = false;
          _searchController.clear();
        });
        context.read<AllProductProvider>().searchProducts('');
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_showCartBar) setState(() => _showCartBar = false);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_showCartBar) setState(() => _showCartBar = true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
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

    final buttonHeight = ResponsiveValue<double>(
      context,
      defaultValue: 32,
      conditionalValues: const [Condition.largerThan(name: TABLET, value: 40)],
    ).value;

    return Consumer<AllProductProvider>(
      builder: (context, provider, _) {
        final cartProvider = context.watch<CartProvider>();

        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,

              // ================= APP BAR =================
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                surfaceTintColor: Colors.transparent,

                title: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isSearchOpen
                      ? SizedBox(
                          key: const ValueKey('search'),
                          height: 46,
                          child: CustomSearchBar(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            hintText: 'Search products',
                            onChanged: provider.searchProducts,
                          ),
                        )
                      : AutoSizeText(
                          provider.subcategory?.name ?? '',
                          key: const ValueKey('title'),
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),

                actions: [
                  if (!_isSearchOpen)
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() => _isSearchOpen = true);
                        Future.delayed(
                          const Duration(milliseconds: 100),
                          () => _searchFocusNode.requestFocus(),
                        );
                      },
                    ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined),
                        onPressed: () => context.push(Routes.newcart),
                      ),
                      if (cartProvider.totalItems > 0)
                        Positioned(
                          right: 8,
                          top: 5,
                          child: AnimatedScale(
                            scale: 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.elasticOut,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "${cartProvider.totalItems}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              // ================= BODY =================
              body: provider.isProductLoading
                  ? const ProductsGridShimmer()
                  : provider.products.isEmpty
                  ? _noProductsView()
                  : Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _productCount(provider.products.length),
                              Row(
                                children: [
                                  _actionChip(
                                    icon: Icons.filter_list,
                                    label: "Filter",
                                    onTap: () {},
                                  ),
                                  const SizedBox(width: 8),
                                  _actionChip(
                                    icon: Icons.sort,
                                    label: "Sort",
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: GridView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.fromLTRB(
                              horizontalPadding,
                              12,
                              horizontalPadding,
                              cartProvider.totalItems > 0 ? 100 : 12, // 👈 KEY
                            ),

                            itemCount: provider.products.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisExtent: 240,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemBuilder: (_, index) {
                              final product = provider.products[index];
                              return _productCard(
                                provider,
                                product,
                                buttonHeight,
                                context,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
            // ================= FLOATING CART BAR =================
            if (cartProvider.totalItems > 0)
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 300),
                  offset: _showCartBar ? Offset.zero : const Offset(0, 1),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _showCartBar ? 1 : 0,
                    child: _floatingCartBar(
                      context,
                      cartProvider.totalItems, // 👈 TOTAL PRICE
                    ),
                  ),
                ),

                // _floatingCartBar(context, cartProvider.totalItems),
              ),
          ],
        );
      },
    );
  }

  // ================= PRODUCT CARD =================
  Widget _productCard(
    AllProductProvider provider,
    product,
    double buttonHeight,
    BuildContext context,
  ) {
    final int productId = product.id;

    final isFavorite = provider.favorites[productId] ?? false;
    // final quantity = provider.quantities[productId] ?? 0;
    final cartProvider = context.watch<CartProvider>();
    final item = cartProvider.items
        .where((i) => i.product.id == productId)
        .toList();

    final quantity = item.isEmpty ? 0 : item.first.qty;
    // final quantity = cartProvider.cartQuantities[productId] ?? 0;

    final mrp = double.tryParse(product.mrp) ?? 0;
    final finalPrice = double.tryParse(product.finalPrice) ?? 0;
    final discount = mrp > finalPrice
        ? (((mrp - finalPrice) / mrp) * 100).round()
        : 0;

    return GestureDetector(
      onTap: () => context.push(Routes.productDetails, extra: productId),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
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
                    top: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrls.isNotEmpty
                        ? product.imageUrls.first
                        : '',
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(color: Colors.white),
                    ),
                    errorWidget: (_, _, _) => Image.asset(
                      'assets/images/no_image.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (discount > 0)
                  Positioned(top: 8, left: 8, child: _discountBadge(discount)),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => provider.toggleFavorite(productId),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
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
                        "₹${finalPrice.toStringAsFixed(0)}",
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
                    qty: quantity,
                    maxQty: product.maxQuantity,
                    onAdd: () async {
                      final result = await cartProvider.addToCart(
                        product: product,
                      );

                      if (!context.mounted) return;
                      _handleCartResult(context, result);
                    },
                    onRemove: () => cartProvider.removeFromCart(productId),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //
  void _handleCartResult(BuildContext context, CartActionResult result) {
    String message = '';

    switch (result) {
      case CartActionResult.maxReached:
        message = 'Maximum quantity reached';
        break;
      case CartActionResult.outOfStock:
        message = 'Product is out of stock';
        break;
      case CartActionResult.apiError:
        message = 'Unable to add product. Try again.';
        break;
      default:
        return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            90, // 👈 ABOVE FLOATING CART BAR
          ),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  //
  Widget _floatingCartBar(BuildContext context, int itemCount) {
    return GestureDetector(
      onTap: () => context.push(Routes.newcart),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(14),
        color: Colors.green,
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.green,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.shopping_cart, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    "$itemCount item${itemCount > 1 ? 's' : ''} in cart",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Text(
                "View Cart",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HELPERS =================
  Widget _discountBadge(int discount) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      "$discount% OFF",
      style: GoogleFonts.poppins(
        fontSize: 10,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _productCount(int count) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.green),
    ),
    child: Text("$count Products"),
  );

  Widget _noProductsView() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/no_product.png', height: 200),
        const SizedBox(height: 12),
        const Text("No products found"),
      ],
    ),
  );
}

// ================= ACTION CHIP =================
Widget _actionChip({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [Icon(icon, size: 18), const SizedBox(width: 4), Text(label)],
      ),
    ),
  );
}

// ================= SHIMMER =================
class ProductsGridShimmer extends StatelessWidget {
  const ProductsGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 240,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, _) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
