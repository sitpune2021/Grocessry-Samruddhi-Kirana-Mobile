import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// class CouponCard extends StatefulWidget {
//   final String code;
//   final String title;
//   final String subtitle;
//   final String validTill;
//   final String imageUrl;
//   final int minOrder;
//   final int saveAmount;
//   final VoidCallback onApply;

//   const CouponCard({
//     super.key,
//     required this.code,
//     required this.title,
//     required this.subtitle,
//     required this.validTill,
//     required this.imageUrl,
//     required this.minOrder,
//     required this.saveAmount,
//     required this.onApply,
//   });

//   @override
//   State<CouponCard> createState() => _CouponCardState();
// }

// class _CouponCardState extends State<CouponCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _scaleController;

//   @override
//   void initState() {
//     super.initState();
//     _scaleController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 120),
//       lowerBound: 0.95,
//       upperBound: 1,
//       value: 1,
//     );
//   }

//   void _applyCoupon() {
//     HapticFeedback.lightImpact();
//     Clipboard.setData(ClipboardData(text: widget.code));

//     /// 🎉 Flutter Confetti
//     Confetti.launch(
//       context,
//       options: const ConfettiOptions(particleCount: 30, spread: 70, y: 0.3),
//     );

//     widget.onApply();
//   }

//   @override
//   void dispose() {
//     _scaleController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScaleTransition(
//       scale: _scaleController,
//       child: Container(
//         padding: const EdgeInsets.all(2),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFF00C853), Color(0xFFB2FF59)],
//           ),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(14),
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 6,
//                           ),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.green),
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: Text(
//                             widget.code,
//                             style: const TextStyle(
//                               color: Colors.green,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                         const Spacer(),
//                         Text(
//                           "Save ₹${widget.saveAmount}",
//                           style: const TextStyle(
//                             color: Colors.green,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 10),

//                     Text(
//                       widget.title,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),

//                     const SizedBox(height: 6),

//                     Text(
//                       widget.subtitle,
//                       style: const TextStyle(color: Colors.black54),
//                     ),

//                     const SizedBox(height: 10),

//                     Row(
//                       children: [
//                         Text(
//                           widget.validTill,
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.black45,
//                           ),
//                         ),
//                         const Spacer(),
//                         GestureDetector(
//                           onTapDown: (_) => _scaleController.reverse(),
//                           onTapUp: (_) {
//                             _scaleController.forward();
//                             _applyCoupon();
//                           },
//                           onTapCancel: () => _scaleController.forward(),
//                           child: const Text(
//                             "USE CODE",
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.green,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: 12),

//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.network(
//                   widget.imageUrl,
//                   height: 64,
//                   width: 64,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, _, _) => const Icon(
//                     Icons.local_offer,
//                     color: Colors.green,
//                     size: 32,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
class CouponCard extends StatefulWidget {
  final String code;
  final String title;
  final String subtitle;
  final String validTill;
  final String imageUrl;
  final int minOrder;
  final int saveAmount;
  final VoidCallback onApply;

  const CouponCard({
    super.key,
    required this.code,
    required this.title,
    required this.subtitle,
    required this.validTill,
    required this.imageUrl,
    required this.minOrder,
    required this.saveAmount,
    required this.onApply,
  });

  @override
  State<CouponCard> createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.95,
      upperBound: 1,
      value: 1,
    );
  }

  void _onTap() {
    HapticFeedback.lightImpact();
    Clipboard.setData(ClipboardData(text: widget.code));

    widget.onApply(); // ✅ let parent decide success
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleController,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00C853), Color(0xFFB2FF59)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
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
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.code,
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "Save ₹${widget.saveAmount}",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          widget.validTill,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTapDown: (_) => _scaleController.reverse(),
                          onTapUp: (_) {
                            _scaleController.forward();
                            _onTap();
                          },
                          onTapCancel: () => _scaleController.forward(),
                          child: const Text(
                            "USE CODE",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.imageUrl,
                  height: 64,
                  width: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.local_offer,
                    color: Colors.green,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
