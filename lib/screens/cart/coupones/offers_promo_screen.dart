import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samruddha_kirana/screens/cart/coupones/coupon_card_screen.dart';
import 'package:samruddha_kirana/screens/cart/coupones/promo_inpute.dart';

class OffersPromoScreen extends StatelessWidget {
  const OffersPromoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// ================= RESPONSIVE VALUES =================
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
      defaultValue: 40,
      conditionalValues: const [Condition.largerThan(name: TABLET, value: 48)],
    ).value;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: const BackButton(color: Colors.black),
        title: Text(
          "Offers & Promo Codes",
          style: TextStyle(
            color: Colors.black,
            fontSize: titleFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: ListView(
          children: [
            const SizedBox(height: 12),

            /// Promo Input
            PromoInput(height: buttonHeight),

            const SizedBox(height: 24),

            /// Available Coupons
            const Text(
              "AVAILABLE COUPONS",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 16),

            /// Coupons List
            CouponCard(
              code: "WELCOME50",
              saveText: "You save ₹150",
              title: "50% off on your first 3 orders",
              subtitle:
                  "Valid on orders above ₹199. Max discount ₹100 per order.",
              validTill: "VALID TILL 31ST OCT 2023",
              imagePath: "assets/images/coupon_food.png",
            ),

            CouponCard(
              code: "FREEDEL",
              saveText: "You save ₹40",
              title: "Free delivery on all orders",
              subtitle: "No minimum order value required for select stores.",
              validTill: "VALID TILL 15TH NOV 2023",
              imagePath: "assets/images/coupon_food.png",
            ),

            CouponCard(
              code: "BINGE20",
              saveText: "You save ₹80",
              title: "Flat 20% OFF on Snacks",
              subtitle: "Valid on Lays, Kurkure and other select munchies.",
              validTill: "VALID TILL 25TH OCT 2023",
              imagePath: "assets/images/coupon_food.png",
            ),

            CouponCard(
              code: "HEALTH100",
              saveText: "You save ₹100",
              title: "₹100 OFF on Fresh Vegetables",
              subtitle: "Applicable on orders above ₹599 from organic farms.",
              validTill: "VALID TILL 05TH NOV 2023",
              imagePath: "assets/images/coupon_food.png",
            ),

            CouponCard(
              code: "HEALTH100",
              saveText: "You save ₹100",
              title: "₹100 OFF on Fresh Vegetables",
              subtitle: "Applicable on orders above ₹599 from organic farms.",
              validTill: "VALID TILL 05TH NOV 2023",
              imagePath: "assets/images/coupon_food.png",
            ),

            const SizedBox(height: 24),

            const Center(
              child: Text(
                "Terms & Conditions apply to all offers.",
                style: TextStyle(color: Colors.black45),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
