// import 'package:flutter/material.dart';

// class CouponCard extends StatelessWidget {
//   final String code;
//   final String saveText;
//   final String title;
//   final String subtitle;
//   final String validTill;

//   const CouponCard({
//     super.key,
//     required this.code,
//     required this.saveText,
//     required this.title,
//     required this.subtitle,
//     required this.validTill,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Code Row
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.green),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Text(
//                   code,
//                   style: const TextStyle(
//                     color: Colors.green,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 saveText,
//                 style: const TextStyle(
//                   color: Colors.green,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const Spacer(),
//               const Text(
//                 "USE CODE",
//                 style: TextStyle(
//                   color: Colors.green,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 12),

//           Text(
//             title,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//           ),

//           const SizedBox(height: 6),

//           Text(subtitle, style: const TextStyle(color: Colors.black54)),

//           const SizedBox(height: 8),

//           Text(
//             validTill,
//             style: const TextStyle(fontSize: 12, color: Colors.black45),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class CouponCard extends StatelessWidget {
  final String code;
  final String saveText;
  final String title;
  final String subtitle;
  final String validTill;
  final String imagePath; // 👈 add image

  const CouponCard({
    super.key,
    required this.code,
    required this.saveText,
    required this.title,
    required this.subtitle,
    required this.validTill,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      /// MAIN ROW
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LEFT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Code Row
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
                        code,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      saveText,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      "USE CODE",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(subtitle, style: const TextStyle(color: Colors.black54)),

                const SizedBox(height: 8),

                Text(
                  validTill,
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// RIGHT IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.local_offer,
                color: Colors.green,
                size: 32,
              ),
            ),

            // child: Image.asset(
            //   imagePath,
            //   height: 64,
            //   width: 64,
            //   fit: BoxFit.cover,
            // ),
          ),
        ],
      ),
    );
  }
}
