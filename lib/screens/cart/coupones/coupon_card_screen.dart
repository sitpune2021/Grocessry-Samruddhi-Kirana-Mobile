// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class CouponCard extends StatefulWidget {
//   final String code;
//   final String title;
//   final String subtitle;
//   final String validTill;
//   final String imageUrl;
//   final int minOrder;
//   final String saveAmount;
//   final VoidCallback onApply;
//   final bool isApplied; // ✅ NEW

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
//     this.isApplied = false, // ✅ default false
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

//   void _onTap() {
//     HapticFeedback.lightImpact();
//     // Clipboard.setData(ClipboardData(text: widget.code));
//     // ✅ Only copy to clipboard if not already applied
//     if (!widget.isApplied) {
//       Clipboard.setData(ClipboardData(text: widget.code));
//     }

//     widget.onApply(); // ✅ let parent decide success
//   }

//   @override
//   void dispose() {
//     _scaleController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ✅ Grey out entire card when applied
//     final cardOpacity = widget.isApplied ? 0.75 : 1.0;

//     // ✅ Green gradient when active, grey when applied
//     final gradientColors = widget.isApplied
//         ? [const Color(0xFFBDBDBD), const Color(0xFFE0E0E0)]
//         : [const Color(0xFF00C853), const Color(0xFFB2FF59)];

//     final accentColor = widget.isApplied ? Colors.grey : Colors.green;

//     return Opacity(
//       opacity: cardOpacity,
//       child: ScaleTransition(
//         scale: _scaleController,
//         child: Container(
//           padding: const EdgeInsets.all(2),
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Color(0xFF00C853), Color(0xFFB2FF59)],
//             ),
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(14),
//             ),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 6,
//                             ),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.green),
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Text(
//                               widget.code,
//                               style: const TextStyle(
//                                 color: Colors.green,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                           const Spacer(),
//                           Text(
//                             "Save ₹${widget.saveAmount}",
//                             style: const TextStyle(
//                               color: Colors.green,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         widget.title,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         widget.subtitle,
//                         style: const TextStyle(color: Colors.black54),
//                       ),
//                       const SizedBox(height: 6),

//                       Text(
//                         "Min order ₹${widget.minOrder}",
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.black45,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         children: [
//                           Text(
//                             widget.validTill,
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: Colors.black45,
//                             ),
//                           ),
//                           const Spacer(),
//                           GestureDetector(
//                             onTapDown: (_) => _scaleController.reverse(),
//                             onTapUp: (_) {
//                               _scaleController.forward();
//                               _onTap();
//                             },
//                             onTapCancel: () => _scaleController.forward(),
//                             child: const Text(
//                               "USE CODE",
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.green,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.network(
//                     widget.imageUrl,
//                     height: 64,
//                     width: 64,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, _, _) => const Icon(
//                       Icons.local_offer,
//                       color: Colors.green,
//                       size: 32,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CouponCard extends StatefulWidget {
  final String code;
  final String title;
  final String subtitle;
  final String validTill;
  final String imageUrl;
  final int minOrder;
  final String saveAmount;
  final VoidCallback onApply;
  final bool isApplied; // ✅ NEW

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
    this.isApplied = false, // ✅ default false — backward compatible
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

    // ✅ Only copy to clipboard if not already applied
    if (!widget.isApplied) {
      Clipboard.setData(ClipboardData(text: widget.code));
    }

    widget.onApply(); // always call — provider handles blocking + message
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Grey out entire card when applied
    final cardOpacity = widget.isApplied ? 0.75 : 1.0;

    // ✅ Green gradient when active, grey when applied
    final gradientColors = widget.isApplied
        ? [const Color(0xFFBDBDBD), const Color(0xFFE0E0E0)]
        : [const Color(0xFF00C853), const Color(0xFFB2FF59)];

    final accentColor = widget.isApplied ? Colors.grey : Colors.green;

    return Opacity(
      opacity: cardOpacity,
      child: ScaleTransition(
        scale: _scaleController,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradientColors),
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
                              border: Border.all(color: accentColor),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              widget.code,
                              style: TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Spacer(),

                          // ✅ Show "✓ Applied" badge or "Save ₹X"
                          widget.isApplied
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.green.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 14,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "Applied",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Text(
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
                      const SizedBox(height: 6),
                      Text(
                        "Min order ₹${widget.minOrder}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                          fontWeight: FontWeight.w500,
                        ),
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

                          // ✅ Show "APPLIED" or "USE CODE"
                          GestureDetector(
                            onTapDown: (_) => _scaleController.reverse(),
                            onTapUp: (_) {
                              _scaleController.forward();
                              _onTap();
                            },
                            onTapCancel: () => _scaleController.forward(),
                            child: Text(
                              widget.isApplied ? "APPLIED ✓" : "USE CODE",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: accentColor,
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
                    errorBuilder: (_, _, _) =>
                        Icon(Icons.local_offer, color: accentColor, size: 32),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
