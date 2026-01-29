import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samruddha_kirana/models/coupon/offer_model.dart';
import 'package:samruddha_kirana/providers/cuppon%20_offer/cuppon_&_offer_provider.dart';
import 'package:samruddha_kirana/providers/product_all/cart_provider.dart';
import 'package:samruddha_kirana/screens/cart/coupones/coupon_card_screen.dart';
import 'package:samruddha_kirana/screens/cart/coupones/promo_inpute.dart';
import 'package:samruddha_kirana/widgets/loader.dart';

class OffersPromoScreen extends StatefulWidget {
  final double subtotal;
  const OffersPromoScreen({super.key, required this.subtotal});

  @override
  State<OffersPromoScreen> createState() => _OffersPromoScreenState();
}

class _OffersPromoScreenState extends State<OffersPromoScreen> {
  late final TextEditingController promoController;
  @override
  void initState() {
    super.initState();
    promoController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CouponProvider>().fetchAllCoupons();
    });
  }

  @override
  void dispose() {
    promoController.dispose();
    super.dispose();
  }

  /// 🔥 SINGLE APPLY METHOD (USED EVERYWHERE)
  Future<void> _applyCoupon(Coupon coupon) async {
    final couponProvider = context.read<CouponProvider>();
    final cartProvider = context.read<CartProvider>();

    final response = await couponProvider.applyCoupon(
      coupon: coupon,
      orderAmount: widget.subtotal, // ✅ CART SUBTOTAL
    );

    if (!mounted) return;

    if (!response.success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));
      return;
    }

    // 🎉 CONFETTI ONLY ON SUCCESS
    Confetti.launch(
      context,
      options: const ConfettiOptions(particleCount: 30, spread: 70, y: 0.3),
    );

    // 🔥 REFRESH CART FROM BACKEND
    await cartProvider.viewCart();
    if (!mounted) return;
    Navigator.pop(context, true);
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Offers & Promo Codes",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Consumer<CouponProvider>(
          builder: (_, provider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                /// ================= PROMO INPUT =================
                PromoInput(
                  height: 40,
                  controller: promoController,
                  onApply: () async {
                    final code = promoController.text.trim().toUpperCase();

                    if (code.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Enter a promo code")),
                      );
                      return;
                    }

                    Coupon? matched;
                    try {
                      matched = provider.coupons.firstWhere(
                        (c) => c.title.toUpperCase() == code,
                      );
                    } catch (_) {
                      matched = null;
                    }

                    if (matched == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Invalid promo code")),
                      );
                      return;
                    }

                    await _applyCoupon(matched);
                  },
                ),

                const SizedBox(height: 24),
                const Text(
                  "AVAILABLE COUPONS",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: provider.isLoading
                      ? const Center(child: Loader())
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: provider.coupons.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final c = provider.coupons[index];

                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1),
                              duration: Duration(
                                milliseconds: 300 + index * 80,
                              ),
                              builder: (_, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, 20 * (1 - value)),
                                    child: child,
                                  ),
                                );
                              },
                              child: CouponCard(
                                code: c.title,
                                title: c.description,
                                subtitle:
                                    "Min order ₹${c.minOrderAmount.toInt()}",
                                validTill: c.endDate != null
                                    ? "VALID TILL ${c.endDate!.day}/${c.endDate!.month}/${c.endDate!.year}"
                                    : "Limited period",
                                minOrder: c.minOrderAmount.toInt(),
                                saveAmount: c.maxDiscount.toInt(),
                                imageUrl:
                                    "https://cdn-icons-png.flaticon.com/512/891/891462.png",

                                // apply coupon
                                onApply: () async {
                                  await _applyCoupon(c);
                                },
                              ),
                            );
                          },
                        ),
                ),

                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    "Terms & Conditions apply",
                    style: TextStyle(color: Colors.black45),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            );
          },
        ),
      ),
    );
  }
}
