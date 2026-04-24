// import 'package:flutter/material.dart';
// import 'package:flutter_confetti/flutter_confetti.dart';
// import 'package:provider/provider.dart';
// import 'package:responsive_framework/responsive_framework.dart';
// import 'package:samruddha_kirana/models/coupon/offers_model.dart';
// import 'package:samruddha_kirana/providers/cuppon%20_offer/cuppon_&_offer_provider.dart';
// import 'package:samruddha_kirana/providers/product_all/cart_provider.dart';
// import 'package:samruddha_kirana/screens/cart/coupones/coupon_card_screen.dart';
// import 'package:samruddha_kirana/screens/cart/coupones/promo_inpute.dart';
// import 'package:samruddha_kirana/widgets/loader.dart';

// class OffersPromoScreen extends StatefulWidget {
//   final double subtotal;
//   const OffersPromoScreen({super.key, required this.subtotal});

//   @override
//   State<OffersPromoScreen> createState() => _OffersPromoScreenState();
// }

// class _OffersPromoScreenState extends State<OffersPromoScreen> {
//   late final TextEditingController promoController;

//   @override
//   void initState() {
//     super.initState();
//     promoController = TextEditingController();

//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   context.read<CouponProvider>().fetchAllCoupons();
//     // });

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final provider = context.read<CouponProvider>();

//       // ✅ FIX: Only fetch if coupons are not already loaded.
//       // This prevents resetting `appliedCoupon` state on back-navigation.
//       if (provider.offers.isEmpty) {
//         provider.fetchAllCoupons();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     promoController.dispose();
//     super.dispose();
//   }

//   /// 🔥 SINGLE APPLY METHOD (USED EVERYWHERE)
//   Future<void> _applyCoupon(Datum coupon) async {
//     final couponProvider = context.read<CouponProvider>();
//     final cartProvider = context.read<CartProvider>();

//     /// ❌ prevent multiple taps
//     if (couponProvider.isLoading) return;

//     /// 🚫 HARD BLOCK — Coupon already applied (persists across navigation)
//     if (couponProvider.appliedCoupon != null) {
//       if (couponProvider.appliedCoupon?.code == coupon.code) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("This coupon is already applied")),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Remove the current coupon before applying another"),
//           ),
//         );
//       }
//       return;
//     }

//     /// ❌ frontend validation
//     if (widget.subtotal < coupon.minAmount) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Minimum order ₹${coupon.minAmount} required")),
//       );
//       return;
//     }

//     final response = await couponProvider.applyCoupon(coupon: coupon);

//     if (!mounted) return;

//     // ❌ FAILURE
//     if (!response.success) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(response.message)));
//       return;
//     }

//     // 🔥 REFRESH CART FROM BACKEND
//     await cartProvider.viewCart();

//     if (!mounted) return;

//     /// ✅ SUCCESS MESSAGE
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(response.message)));

//     // 🎉 CONFETTI ONLY ON SUCCESS
//     Confetti.launch(
//       context,
//       options: const ConfettiOptions(particleCount: 30, spread: 70, y: 0.3),
//     );

//     /// 🧹 CLEAR INPUT
//     promoController.clear();

//     if (!mounted) return;
//     Navigator.pop(context, true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final horizontalPadding = ResponsiveValue<double>(
//       context,
//       defaultValue: 12,
//       conditionalValues: const [
//         Condition.largerThan(name: TABLET, value: 24),
//         Condition.largerThan(name: DESKTOP, value: 60),
//       ],
//     ).value;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.transparent,
//         elevation: 0,
//         leading: const BackButton(color: Colors.black),
//         title: const Text(
//           "Offers & Promo Codes",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//         child: Consumer<CouponProvider>(
//           builder: (_, provider, _) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 12),

//                 // /// ================= PROMO INPUT =================
//                 // PromoInput(
//                 //   height: 40,
//                 //   controller: promoController,
//                 //   onApply: () async {
//                 //     if (provider.isLoading) {
//                 //       ScaffoldMessenger.of(context).showSnackBar(
//                 //         const SnackBar(content: Text("Please wait...")),
//                 //       );
//                 //       return;
//                 //     }

//                 //     final code = promoController.text.trim().toUpperCase();

//                 //     if (code.isEmpty) {
//                 //       ScaffoldMessenger.of(context).showSnackBar(
//                 //         const SnackBar(content: Text("Enter a promo code")),
//                 //       );
//                 //       return;
//                 //     }

//                 //     /// ❗ ensure coupons loaded
//                 //     if (provider.offers.isEmpty) {
//                 //       ScaffoldMessenger.of(context).showSnackBar(
//                 //         const SnackBar(content: Text("Coupons not loaded yet")),
//                 //       );
//                 //       return;
//                 //     }

//                 //     // Coupon? matched;
//                 //     Datum? matched;

//                 //     try {
//                 //       // matched = provider.coupons.firstWhere(
//                 //       //   (c) => c.title.toUpperCase() == code,
//                 //       // );
//                 //       matched = provider.offers.firstWhere(
//                 //         (c) => c.code.toUpperCase() == code, // ✅ FIXED
//                 //       );
//                 //     } catch (_) {
//                 //       matched = null;
//                 //     }

//                 //     if (matched == null) {
//                 //       ScaffoldMessenger.of(context).showSnackBar(
//                 //         const SnackBar(content: Text("Invalid promo code")),
//                 //       );
//                 //       return;
//                 //     }

//                 //     await _applyCoupon(matched);
//                 //   },
//                 // ),
//                 // const SizedBox(height: 24),
//                 const Text(
//                   "AVAILABLE COUPONS",
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black54,
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 Expanded(
//                   child: provider.isLoading
//                       ? const Center(child: Loader())
//                       : ListView.separated(
//                           physics: const BouncingScrollPhysics(),
//                           itemCount: provider.offers.length,
//                           separatorBuilder: (_, _) =>
//                               const SizedBox(height: 12),
//                           itemBuilder: (context, index) {
//                             final c = provider.offers[index];

//                             /// ✅ check applied
//                             final isApplied =
//                                 provider.appliedCoupon?.code == c.code;

//                             return TweenAnimationBuilder<double>(
//                               tween: Tween(begin: 0, end: 1),
//                               duration: Duration(
//                                 milliseconds: 300 + index * 80,
//                               ),
//                               builder: (_, value, child) {
//                                 return Opacity(
//                                   opacity: value,
//                                   child: Transform.translate(
//                                     offset: Offset(0, 20 * (1 - value)),
//                                     child: child,
//                                   ),
//                                 );
//                               },
//                               child: CouponCard(
//                                 code: c.code,
//                                 title: c.title,
//                                 subtitle: c.description ?? "",
//                                 validTill: "VALID TILL ${c.validTill}",
//                                 minOrder: c.minAmount,
//                                 saveAmount: c.discountText,
//                                 imageUrl:
//                                     "https://cdn-icons-png.flaticon.com/512/891/891462.png",

//                                 /// ✅ FIX: null disables the button in CouponCard.
//                                 /// isApplied = true  → button disabled (already applied)
//                                 /// isApplied = false → button active
//                                 onApply: isApplied
//                                     ? () {} // no-op keeps button visible but blocked
//                                     : () {
//                                         _applyCoupon(c);
//                                       },

//                                 // apply coupon
//                                 // onApply: () async {
//                                 //   await _applyCoupon(c);
//                                 // },
//                               ),
//                             );
//                           },
//                         ),
//                 ),

//                 const SizedBox(height: 12),
//                 const Center(
//                   child: Text(
//                     "Terms & Conditions apply",
//                     style: TextStyle(color: Colors.black45),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samruddha_kirana/models/coupon/offers_model.dart';
import 'package:samruddha_kirana/providers/cuppon%20_offer/cuppon_&_offer_provider.dart';
import 'package:samruddha_kirana/providers/product_all/cart_provider.dart';
import 'package:samruddha_kirana/screens/cart/coupones/coupon_card_screen.dart';
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
      final provider = context.read<CouponProvider>();

      // ✅ Only fetch if not already loaded — preserves appliedCoupon across navigation
      if (provider.offers.isEmpty) {
        provider.fetchAllCoupons();
      }
    });
  }

  @override
  void dispose() {
    promoController.dispose();
    super.dispose();
  }

  /// 🔥 SINGLE APPLY METHOD
  /// Provider is the single source of truth — all blocking + messages flow from it
  Future<void> _applyCoupon(Datum coupon) async {
    final couponProvider = context.read<CouponProvider>();
    final cartProvider = context.read<CartProvider>();

    /// ❌ Prevent tap while loading
    if (couponProvider.isLoading) return;

    /// ❌ Minimum order frontend validation
    if (widget.subtotal < coupon.minAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Minimum order ₹${coupon.minAmount} required"),
        ),
      );
      return;
    }

    /// 🔥 Call provider — it handles "already applied" blocking internally
    final response = await couponProvider.applyCoupon(coupon: coupon);

    if (!mounted) return;

    /// ❌ FAILURE or BLOCKED — show message from provider (includes "already applied")
    if (!response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );
      return;
    }

    /// 🔥 Refresh cart from backend
    await cartProvider.viewCart();

    if (!mounted) return;

    /// ✅ SUCCESS
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.message)),
    );

    /// 🎉 Confetti on success
    Confetti.launch(
      context,
      options: const ConfettiOptions(particleCount: 30, spread: 70, y: 0.3),
    );

    promoController.clear();

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
                          itemCount: provider.offers.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final c = provider.offers[index];

                            /// ✅ Used only for UI styling (e.g. show "Applied" badge)
                            /// Blocking logic lives entirely in the provider
                            final isApplied =
                                provider.appliedCoupon?.code == c.code;

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
                                code: c.code,
                                title: c.title,
                                subtitle: c.description ?? "",
                                validTill: "VALID TILL ${c.validTill}",
                                minOrder: c.minAmount,
                                saveAmount: c.discountText,
                                imageUrl:
                                    "https://cdn-icons-png.flaticon.com/512/891/891462.png",
                                isApplied: isApplied,

                                /// ✅ Always call _applyCoupon
                                /// Provider returns "already applied" message if blocked
                                onApply: () { _applyCoupon(c); },
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
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}