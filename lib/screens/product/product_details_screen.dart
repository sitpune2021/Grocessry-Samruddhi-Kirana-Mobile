import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samruddha_kirana/providers/product_all/all_product_provider.dart';
import 'package:samruddha_kirana/screens/cart/cart_screen.dart';
import 'package:samruddha_kirana/widgets/cached_image_view.dart';
import 'package:samruddha_kirana/widgets/loader.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showStickyAddButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AllProductProvider>().fetchProductDetails(widget.productId);
    });
  }

  void _scrollListener() {
    if (_scrollController.offset > 300 && !_showStickyAddButton) {
      setState(() => _showStickyAddButton = true);
    } else if (_scrollController.offset <= 300 && _showStickyAddButton) {
      setState(() => _showStickyAddButton = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AllProductProvider>();

    if (provider.isProductDetailsLoading) {
      return const Scaffold(body: Center(child: Loader()));
    }

    if (provider.productDetails == null) {
      return Scaffold(body: Center(child: Text(provider.errorMessage)));
    }

    final product = provider.productDetails!.data;
    final _ = provider.quantities[product.id] ?? 0;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _bottomCartBar(provider, product.id),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _topImageHeader(context, product),
                _productInfoCard(provider, product),
                topIconsRow(),
                // const HighlightsSection(),
                InformationSection(product: product),
                // const InformationSection(),
                HighlightsSection(product: product),

                _sectionTitle("Similar Products"),
                _productsHorizontalList(provider),

                _seeAllButton(),
                const SizedBox(height: 100),
              ],
            ),
          ),

          if (_showStickyAddButton) _stickyAddButton(provider, product),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────
  // TOP IMAGE
  // ───────────────────────────────────────────
  Widget _topImageHeader(BuildContext context, product) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: CachedImageView(
            imageUrl: product.images.isNotEmpty ? product.images.first : null,
            height: 260,
            width: double.infinity,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        Positioned(
          top: 40,
          left: 16,
          child: _roundButton(Icons.arrow_back, () {
            Navigator.pop(context);
          }),
        ),
        Positioned(
          top: 40,
          right: 16,
          child: _roundButton(Icons.favorite_border, () {}),
        ),
      ],
    );
  }

  Widget _roundButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
        child: Icon(icon, color: Colors.black),
      ),
    );
  }

  // ───────────────────────────────────────────
  // PRODUCT INFO CARD
  // ───────────────────────────────────────────
  Widget _productInfoCard(AllProductProvider provider, product) {
    final _ = provider.quantities[product.id] ?? 0;

    return Transform.translate(
      offset: const Offset(0, -40),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.timer, size: 18, color: Colors.green),
                SizedBox(width: 4),
                Text("10 Mins", style: TextStyle(color: Colors.green)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              product.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Text(
                  "₹${product.pricing.retailerPrice}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "MRP ₹${product.pricing.mrp}",
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            GestureDetector(
              onTap: () => _showProductDetailsBottomSheet(product),
              child: const Text(
                "View product details",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────
  // BOTTOM SHEET
  // ───────────────────────────────────────────
  void _showProductDetailsBottomSheet(product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow("Category", product.category.name),
                _detailRow("Brand", product.brand.name),
                _detailRow("Stock", product.stock.toString()),
                const SizedBox(height: 12),
                const Text(
                  "Description",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(product.description),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────
  // SIMILAR PRODUCTS (USING provider.products)
  // ───────────────────────────────────────────
  Widget _productsHorizontalList(AllProductProvider provider) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        itemCount: provider.products.length,
        itemBuilder: (_, index) {
          final p = provider.products[index];
          final qty = provider.quantities[p.id] ?? 0;

          return _smallProductCard(provider, p, qty);
        },
      ),
    );
  }

  Widget _smallProductCard(AllProductProvider provider, p, int qty) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        children: [
          CachedImageView(
            imageUrl: p.images.isNotEmpty ? p.images.first : null,
            height: 110,
            width: double.infinity,
            borderRadius: BorderRadius.circular(16),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, maxLines: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("₹${p.price}"),
                    qty == 0
                        ? GestureDetector(
                            onTap: () => provider.addToCart(p.id),
                            child: const Text(
                              "ADD",
                              style: TextStyle(color: Colors.green),
                            ),
                          )
                        : Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => provider.removeFromCart(p.id),
                              ),
                              Text(qty.toString()),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => provider.addToCart(p.id),
                              ),
                            ],
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────
  // STICKY ADD BUTTON
  // ───────────────────────────────────────────
  Widget _stickyAddButton(AllProductProvider provider, product) {
    final qty = provider.quantities[product.id] ?? 0;

    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Expanded(child: Text(product.name)),
            qty == 0
                ? TextButton(
                    onPressed: () => provider.addToCart(product.id),
                    child: const Text("ADD"),
                  )
                : Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => provider.removeFromCart(product.id),
                      ),
                      Text(qty.toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => provider.addToCart(product.id),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────
  // BOTTOM CART BAR
  // ───────────────────────────────────────────
  Widget _bottomCartBar(AllProductProvider provider, int productId) {
    final totalItems = provider.totalCartCount;

    return totalItems == 0
        ? const SizedBox()
        : Container(
            height: 70,
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
              child: Text(
                "View Cart ($totalItems items)",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _seeAllButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            "See All Products →",
            style: TextStyle(color: Colors.green, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget topIconsRow() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [Icon(Icons.block), Icon(Icons.flash_on)],
      ),
    );
  }
}

class HighlightsSection extends StatefulWidget {
  final dynamic product;

  const HighlightsSection({super.key, required this.product});

  @override
  State<HighlightsSection> createState() => _HighlightsSectionState();
}

class _HighlightsSectionState extends State<HighlightsSection> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Highlights",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () => setState(() => expanded = !expanded),
              ),
            ],
          ),

          if (expanded) ...[
            _row("Brand", p.brand.name),
            _row("Category", p.category.name),
            _row("Sub Category", p.subCategory.name),
            _row("Stock Available", p.stock.toString()),
            _row("MRP", "₹${p.pricing.mrp}"),
            _row("GST %", "${p.pricing.gstPercentage}%"),
          ],

          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => expanded = !expanded),
            child: Center(
              child: Text(
                expanded ? "View less ▲" : "View more ▼",
                style: const TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class InformationSection extends StatefulWidget {
  final dynamic product;

  const InformationSection({super.key, required this.product});

  @override
  State<InformationSection> createState() => _InformationSectionState();
}

class _InformationSectionState extends State<InformationSection> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () => setState(() => expanded = !expanded),
              ),
            ],
          ),

          if (expanded) ...[
            _row(
              "Description",
              p.description.isNotEmpty
                  ? p.description
                  : "No description available",
            ),
            _row(
              "Disclaimer",
              "All images are for representational purposes only.",
            ),
          ],

          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => expanded = !expanded),
            child: Center(
              child: Text(
                expanded ? "View less ▲" : "View more ▼",
                style: const TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
