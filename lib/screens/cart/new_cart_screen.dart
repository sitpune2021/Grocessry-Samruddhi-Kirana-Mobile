import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samruddha_kirana/config/routes.dart';
import 'package:samruddha_kirana/providers/address/address_provider.dart';
import 'package:samruddha_kirana/providers/product_all/cart_provider.dart';
import 'package:samruddha_kirana/screens/cart/cart_address_buttomsheet.dart';
import 'package:samruddha_kirana/widgets/address_card.dart';
import 'package:samruddha_kirana/widgets/animation_cart_item.dart';
import 'package:samruddha_kirana/widgets/loader.dart';

class NewCartScreen extends StatefulWidget {
  const NewCartScreen({super.key});

  @override
  State<NewCartScreen> createState() => _NewCartScreenState();
}

class _NewCartScreenState extends State<NewCartScreen> {
  // Track which product is being removed
  int? _removingProductId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().viewCart();
    });
  }

  // Handle product removal with animation
  void _handleRemoveProduct(int productId) {
    setState(() {
      _removingProductId = productId;
    });

    // MUST match TweenAnimationBuilder duration
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        context.read<CartProvider>().removeSingleProduct(productId);
        setState(() {
          _removingProductId = null;
        });
      }
    });
  }

  void _showClearCartDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "ClearCart",
      barrierColor: Colors.black.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, _, _) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.delete_forever, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    "Clear Cart?",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "All items will be removed from your cart.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            context.read<CartProvider>().clearAllFromCart();
                            Navigator.pop(context);
                          },
                          child: const Text("Clear"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, _, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(anim.value),
          child: Opacity(opacity: anim.value, child: child),
        );
      },
    );
  }

  void _openDeliveryAddressSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.50, // 55% screen
        child: const SavedAddressSheet(),
      ),
    );
  }

  // void _openDeliveryAddressSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: false, // important for full height
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  //     ),
  //     builder: (_) => const SavedAddressSheet(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    /// ================= RESPONSIVE VALUES =================
    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16,
      conditionalValues: const [
        Condition.largerThan(name: TABLET, value: 24),
        Condition.largerThan(name: DESKTOP, value: 60),
      ],
    ).value;

    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 20,
      conditionalValues: const [Condition.largerThan(name: TABLET, value: 24)],
    ).value;

    final buttonHeight = ResponsiveValue<double>(
      context,
      defaultValue: 56,
      conditionalValues: const [Condition.largerThan(name: TABLET, value: 64)],
    ).value;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "My Basket",
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 4),
            InkWell(
              onTap: () => _openDeliveryAddressSheet(context),
              child: Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Colors.green),
                  SizedBox(width: 4),
                  Consumer<AddressProvider>(
                    builder: (context, provider, _) {
                      final address = provider.defaultAddress;

                      if (address == null) {
                        return const Text("Select address");
                      }

                      final title = getTitle(address.type);
                      final subtitle = [
                        address.landmark,
                        address.addressLine,
                      ].where((e) => e.trim().isNotEmpty).join(", ");

                      return Text(
                        "$title, $subtitle",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),

        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.more_horiz, color: Colors.green),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Consumer<CartProvider>(
            builder: (context, cart, _) {
              if (cart.items.isEmpty) {
                return const Center(
                  child: Text(
                    "Your cart is empty",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                );
              }
              return Column(
                children: [
                  _selectAllRow(cart.totalItems),
                  const SizedBox(height: 12),

                  // ================= CART ITEMS =================
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final item = cart.items[index];
                        final product = item.product;
                        final qty = item.qty;
                        final isRemoving = _removingProductId == product.id;

                        return TweenAnimationBuilder<double>(
                          key: ValueKey(product.id), // identity is important
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          tween: Tween<double>(
                            begin: 0,
                            end: isRemoving ? 1 : 0,
                          ),
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(value * 350, 0), // slide RIGHT
                              child: Opacity(opacity: 1 - value, child: child),
                            );
                          },

                          child: AnimatedCartItem(
                            // index: index,
                            child: _cartItem(
                              image: product.productImageUrls.isNotEmpty
                                  ? product.productImageUrls.first
                                  : "",
                              title: product.name,
                              save: "SAVE ₹0",
                              price: "₹${product.retailerPrice}",
                              oldPrice: "₹${product.mrp}",
                              unit: "GST ${product.gstPercentage}%",
                              qty: qty,
                              productId: product.id,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _couponCard(),
                  const SizedBox(height: 16),
                  _summarySection(cart),
                  const SizedBox(height: 12),
                  _placeOrderButton(buttonHeight),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ================= SELECT ALL =================
  Widget _selectAllRow(int totalItems) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6, top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select All Items",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "$totalItems items selected",
                    style: const TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),

          // 👉 RIGHT SIDE CLEAR BUTTON
          InkWell(
            onTap: () => _showClearCartDialog(context),
            child: const Text(
              "Clear All",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ================= CART ITEM =================
  Widget _cartItem({
    required String image,
    required String title,
    required String save,
    required String price,
    required String oldPrice,
    required String unit,
    required int qty,
    required int productId,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade100,
            ),
            child: image.isEmpty
                ? const Icon(Icons.shopping_bag)
                : Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.shopping_bag,
                        size: 28,
                        color: Colors.green,
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Loader();
                    },
                  ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  save,
                  style: const TextStyle(color: Colors.green, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      oldPrice,
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  unit,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          // _qtySelector(qty, productId),
          // RIGHT SIDE (QTY + DELETE BELOW)
          Column(
            children: [
              _qtySelector(qty, productId),
              const SizedBox(height: 20),

              // GestureDetector(
              //   onTap: () {
              //     context.read<CartProvider>().removeSingleProduct(productId);
              //   },
              //   child: const Icon(Icons.delete, color: Colors.red, size: 22),
              // ),
              GestureDetector(
                onTap: () => _handleRemoveProduct(productId),
                child: const Icon(Icons.delete, color: Colors.red, size: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= QTY =================
  Widget _qtySelector(int qty, int productId) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFFBF5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              context.read<CartProvider>().removeFromCart(productId);
            },
            child: _qtyButton(Icons.remove),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "$qty",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<CartProvider>().incrementFromCart(productId);
            },
            child: _qtyButton(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      child: Icon(icon, size: 18, color: Colors.green),
    );
  }

  // ================= COUPON =================
  Widget _couponCard() {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push(Routes.couponOffer),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: const [
            Icon(Icons.local_offer, color: Colors.green),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Apply Coupon Code",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.green),
          ],
        ),
      ),
    );
  }

  // ================= SUMMARY =================
  Widget _summarySection(CartProvider cart) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEFFBF5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "TOTAL SAVINGS",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "-₹${cart.discount}",

                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _summaryRow("Subtotal", "₹${cart.subtotal}"),
        _summaryRow("Delivery Fee", "Free", isGreen: true),
        _summaryRow("Tax", "₹${cart.taxTotal}"),
        _summaryRow("Discount", "-₹${cart.discount}", isGreen: true),
        const SizedBox(height: 8),
        _summaryRow(
          "Total",
          "₹${cart.total}",
          bold: true,
          large: true,
          subtitle: "Incl. all taxes",
        ),
      ],
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool bold = false,
    bool large = false,
    bool isGreen = false,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: large ? 18 : 14,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: large ? 22 : 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: isGreen ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ================= CTA =================
  Widget _placeOrderButton(double height) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Place Order",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.lock, size: 18, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
