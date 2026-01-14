// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:samruddha_kirana/config/routes.dart';
// import 'package:samruddha_kirana/screens/address/address_list_screen.dart';

// class AddressCard extends StatelessWidget {
//   final AddressModel data;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const AddressCard({
//     super.key,
//     required this.data,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final borderColor = isSelected ? Colors.green : Colors.grey.shade300;

//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: borderColor, width: 2),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Radio
//             Icon(
//               isSelected
//                   ? Icons.radio_button_checked
//                   : Icons.radio_button_unchecked,
//               color: isSelected ? Colors.green : Colors.grey,
//             ),

//             const SizedBox(width: 12),

//             /// Content
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(data.icon, color: Colors.green, size: 20),
//                       const SizedBox(width: 8),
//                       Text(
//                         data.title,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.green,
//                         ),
//                       ),
//                       const Spacer(),
//                       TextButton(onPressed: () {}, child: const Text('Edit')),
//                       IconButton(
//                         onPressed: () {
//                           context.push(Routes.addAddress);
//                         },
//                         icon: const Icon(Icons.delete_outline),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     data.address,
//                     style: const TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Phone: ${data.phone}',
//                     style: const TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:samruddha_kirana/config/routes.dart';
import 'package:samruddha_kirana/models/address/get_all_address_model.dart';

class AddressCard extends StatelessWidget {
  final GetAddress data;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete; // ✅ ADD

  const AddressCard({
    super.key,
    required this.data,
    required this.isSelected,
    required this.onTap,
    required this.onDelete, // ✅ ADD
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? Colors.green : Colors.grey.shade300;

    /// Title & Icon mapping (NO UI change)
    final String title = data.isDefault == true ? 'Default Address' : 'Address';
    final IconData icon = data.isDefault == true
        ? Icons.home
        : Icons.location_on;

    /// Helpers
    bool hasText(String? value) => value != null && value.trim().isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Radio
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? Colors.green : Colors.grey,
            ),

            const SizedBox(width: 12),

            /// Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          context.push(
                            Routes.addAddress,
                            extra: data, // pass for edit
                          );
                        },
                        child: const Text('Edit'),
                      ),
                      IconButton(
                        onPressed: onDelete, // ✅ CONNECT
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 4),
                  /// Name
                  if (hasText(data.firstName)) ...[
                    Text(
                      data.firstName,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                  ],

                  /// Address (Street)
                  if (hasText(data.address)) ...[
                    Text(
                      data.address,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 2),
                  ],

                  /// Address (City, Country, Postcode)
                  if (hasText(data.city) ||
                      hasText(data.country) ||
                      hasText(data.postcode)) ...[
                    Text(
                      [
                            data.city,
                            data.country,
                          ].where((e) => hasText(e)).join(', ') +
                          (hasText(data.postcode) ? ' - ${data.postcode}' : ''),
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                  ],

                  /// Contact
                  if (hasText(data.phone) || hasText(data.email)) ...[
                    Text(
                      [
                        hasText(data.phone) ? 'Phone: ${data.phone}' : null,
                        hasText(data.email) ? 'Email: ${data.email}' : null,
                      ].whereType<String>().join('\n'),
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}
