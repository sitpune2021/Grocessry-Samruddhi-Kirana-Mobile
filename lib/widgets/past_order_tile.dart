import 'package:flutter/material.dart';
import 'package:samruddha_kirana/models/orders/past_order_list_model.dart';
import 'package:samruddha_kirana/screens/orders/order_recept_screen.dart';

class PastOrderTile extends StatefulWidget {
  final String orderId;
  final String date;
  final String price;
  final String status;

  final OrderData orderData;

  const PastOrderTile({
    super.key,
    required this.orderId,
    required this.date,
    required this.price,
    required this.status,

    required this.orderData,
  });

  @override
  State<PastOrderTile> createState() => _PastOrderTileState();
}

class _PastOrderTileState extends State<PastOrderTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  late Animation<Color?> _colorAnimation;

  bool get isDelivered => widget.status == 'delivered';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 6,
      end: 16,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _colorAnimation = ColorTween(
      begin: isDelivered ? const Color(0xFFE8F5E9) : Colors.orange.shade100,
      end: isDelivered ? const Color(0xFFB9F6CA) : Colors.orange.shade300,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          /// 🌟 GLOWING + BLINKING AVATAR
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: isDelivered
                          ? const Color(0xFF00C853).withValues(alpha: 0.45)
                          : Colors.orange.withValues(alpha: 0.45),
                      blurRadius: _glowAnimation.value,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: _colorAnimation.value,
                  child: Icon(
                    isDelivered ? Icons.check_circle : Icons.schedule,
                    color: isDelivered
                        ? const Color(0xFF00C853)
                        : Colors.orange,
                  ),
                ),
              );
            },
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.orderId,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.date,
                  style: const TextStyle(fontWeight: FontWeight.w100),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.status.toUpperCase(),
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.price,
                style: const TextStyle(
                  color: Color(0xFF00C853),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),

              SizedBox(
                width: screenWidth * 0.24, // responsive width
                height: screenWidth * 0.06, // responsive height
                child: OutlinedButton(
                  onPressed: () {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: 'Order Receipt',
                      barrierColor: Colors.black.withValues(alpha: 0.4),
                      transitionDuration: const Duration(milliseconds: 350),
                      pageBuilder: (_, _, _) {
                        return OrderReceiptAlert(order: widget.orderData);
                      },
                      transitionBuilder: (_, animation, _, child) {
                        final curved = CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutBack,
                        );

                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(
                              begin: 0.9,
                              end: 1.0,
                            ).animate(curved),
                            child: child,
                          ),
                        );
                      },
                    );
                  },

                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF00C853)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Details',
                    style: TextStyle(
                      color: const Color(0xFF00C853),
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.030, // responsive text
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
