import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class NewOrderCard extends StatelessWidget {
  final String orderId;
  final String badgeText;
  final String rightText;
  final double totalAmount;
  final List orderItems;
  final VoidCallback onViewDetails;

  const NewOrderCard({
    super.key,
    required this.orderId,
    required this.badgeText,
    required this.rightText,
    required this.totalAmount,
    required this.orderItems,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    /// ================= RESPONSIVE VALUES =================
    final cardPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16,
      conditionalValues: const [Condition.largerThan(name: TABLET, value: 20)],
    ).value;

    final buttonHeight = ResponsiveValue<double>(
      context,
      defaultValue: 52,
      conditionalValues: const [Condition.largerThan(name: TABLET, value: 60)],
    ).value;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
        ],
      ),
      padding: EdgeInsets.all(cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C853),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badgeText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                rightText,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          /// -------- ORDER ID (LEFT) + TOTAL AMOUNT (RIGHT) --------
          Row(
            children: [
              Text(
                orderId,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              Text(
                '₹${totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF00C853),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// -------- Product + Quantity Badge --------
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...orderItems.take(2).map<Widget>((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF00C853,
                          ).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${item.quantity}X',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF00C853),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.product.name,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              /// -------- +X MORE --------
              if (orderItems.length > 2)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    '+${orderItems.length - 2} more',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF00C853),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),

          /// ---------- View Details Button ----------
          SizedBox(
            height: buttonHeight,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onViewDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'View Details →',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
