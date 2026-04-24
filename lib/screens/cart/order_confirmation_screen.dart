import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samruddha_kirana/models/cart/checkout_order_model.dart';
import 'package:samruddha_kirana/config/routes.dart';
import 'package:samruddha_kirana/providers/product_all/cart_provider.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final CheckoutOrderModel order;
  final bool needsConfirm; // ✅ NEW

  const OrderConfirmationScreen({
    super.key,
    required this.order,
    this.needsConfirm = false, // ✅ default false — safe for online
  });

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  bool _isConfirming = true;
  bool _confirmSuccess = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _confirmOrder();
      if (widget.needsConfirm) {
        _confirmOrder(); // CASH only
      } else {
        // ONLINE: already confirmed by /payment/verify — skip API call
        setState(() {
          _isConfirming = false;
          _confirmSuccess = true;
        });
      }
    });
  }

  Future<void> _confirmOrder() async {
    final cartProvider = context.read<CartProvider>();

    // ✅ Call confirmOrder API using orderId from checkout response
    final confirmed = await cartProvider.confirmOrder(
      widget.order.data.orderId.toString(), // adjust field name if needed
    );

    if (!mounted) return;

    setState(() {
      _isConfirming = false;
      _confirmSuccess = confirmed;
      _errorMessage = confirmed ? "" : cartProvider.confirmOrderMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final data = order.data;

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

    // ── LOADING — while confirmOrder API is in progress ──────────────────
    if (_isConfirming) {
      return const Scaffold(
        backgroundColor: Color(0xFFF4F6F5),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Color(0xFF00C853)),
              SizedBox(height: 20),
              Text(
                "Confirming your order...",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    // ── ERROR — confirmOrder API failed ──────────────────────────────────
    if (!_confirmSuccess) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4F6F5),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 72),
                const SizedBox(height: 16),
                const Text(
                  "Order Confirmation Failed",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _errorMessage.isNotEmpty
                      ? _errorMessage
                      : "Something went wrong. Please contact support.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 28),

                // Retry button
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
                      setState(() {
                        _isConfirming = true;
                        _confirmSuccess = false;
                        _errorMessage = "";
                      });
                      _confirmOrder();
                    },
                    child: const Text(
                      "Retry",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.go(Routes.dashboard),
                  child: const Text(
                    "Go to Home",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ── SUCCESS ──────────────────────────────────────────────────────────
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F5),
      body: Column(
        children: [
          // ── GREEN HEADER ──
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

          // ── WHITE CARD ──
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

                        // const SizedBox(height: 20),

                        // // BILL BREAKDOWN
                        // Row(
                        //   children: const [
                        //     Icon(Icons.receipt_long, color: Color(0xFF00C853)),
                        //     SizedBox(width: 8),
                        //     Text(
                        //       "Bill Breakdown",
                        //       style: TextStyle(
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.w600,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(height: 16),
                        const Divider(height: 32),
                        // const Spacer(),

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
                            onPressed: () => context.go(Routes.dashboard),
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

                        TextButton(
                          onPressed: () {
                            context.go(Routes.dashboard, extra: 3);
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
}
