import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samruddha_kirana/models/cart/checkout_order_model.dart';
import 'package:samruddha_kirana/config/routes.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final CheckoutOrderModel order;

  const OrderConfirmationScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final data = order.data;

    // ================= RESPONSIVE VALUES =================
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
      defaultValue: 22,
      conditionalValues: const [Condition.largerThan(name: TABLET, value: 26)],
    ).value;

    final buttonHeight = ResponsiveValue<double>(
      context,
      defaultValue: 56,
      conditionalValues: const [Condition.largerThan(name: TABLET, value: 64)],
    ).value;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F5),
      body: Column(
        children: [
          // ============ GREEN HEADER ============
          Container(
            height: 260,
            width: double.infinity,
            color: const Color(0xFF00C853),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Order Confirmation",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  child: const Center(
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.check,
                        color: Color(0xFF00C853),
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ============ WHITE CARD ============
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -40),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          "Order Placed Successfully!",
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF00C853),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Thank you for your purchase.",
                          style: TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 20),

                        // ORDER NUMBER
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF7F2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "ORDER NUMBER",
                                style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                data.orderNumber,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // BILL BREAKDOWN
                        Row(
                          children: const [
                            Icon(Icons.receipt_long, color: Color(0xFF00C853)),
                            SizedBox(width: 8),
                            Text(
                              "Bill Breakdown",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        _billRow("Subtotal", data.subtotal.toStringAsFixed(2)),
                        _billRow(
                          "Delivery Charge",
                          data.deliveryCharge.toStringAsFixed(2),
                        ),
                        _billRow(
                          "Coupon Discount",
                          "-${data.couponDiscount.toStringAsFixed(2)}",
                          valueColor: Colors.green,
                        ),

                        const Divider(height: 32),

                        _billRow(
                          "Total Amount",
                          data.totalAmount.toStringAsFixed(2),
                          isBold: true,
                          valueColor: const Color(0xFF00C853),
                        ),

                        const Spacer(),

                        // CONTINUE SHOPPING
                        SizedBox(
                          width: double.infinity,
                          height: buttonHeight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00C853),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () {
                              context.go(Routes.dashboard);
                            },
                            child: const Text(
                              "Continue Shopping",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // TRACK ORDER
                        TextButton(
                          onPressed: () {
                            context.push(Routes.order);
                          },
                          child: const Text(
                            "Track Order →",
                            style: TextStyle(
                              color: Color(0xFF00C853),
                              fontSize: 16,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),
                        const Text(
                          "Need help? Contact Support",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= BILL ROW =================
  Widget _billRow(
    String title,
    String value, {
    bool isBold = false,
    Color valueColor = Colors.black,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "₹$value",
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
