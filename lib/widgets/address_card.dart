import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:samruddha_kirana/config/routes.dart';
import 'package:samruddha_kirana/models/address/get_all_address_model.dart';

class AddressCard extends StatelessWidget {
  final GetAddress data;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const AddressCard({
    super.key,
    required this.data,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? Colors.green : Colors.grey.shade300;

    /// Title & Icon mapping (NO UI change)
    // final String title = data.isDefault == true ? 'Default Address' : 'Address';
    // final IconData icon = data.isDefault == true
    //     ? Icons.home
    //     : Icons.location_on;

    final String title = getTitle(data.type);
    final IconData icon = getIcon(data.type);

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

                  /// Name
                  if (hasText(data.name)) ...[
                    Text(
                      data.name,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                  ],

                  /// Address (Street)
                  if (hasText(data.addressLine)) ...[
                    Text(
                      data.addressLine,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 2),
                  ],

                  /// Address (Area)
                  if (hasText(data.landmark)) ...[
                    Text(
                      data.landmark,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 2),
                  ],

                  /// Address (City, Country, Postcode)
                  if (hasText(data.city) ||
                      hasText(data.state) ||
                      hasText(data.pincode)) ...[
                    Text(
                      [
                            data.city,
                            data.state,
                          ].where((e) => hasText(e)).join(', ') +
                          (hasText(data.pincode) ? ' - ${data.pincode}' : ''),
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                  ],

                  /// Contact
                  if (hasText(data.mobile)) ...[
                    Text(
                      'MobileNo : ${data.mobile}',
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

// 👇 PUT HERE (below the widget)
String getTitle(int? type) {
  switch (type) {
    case 1:
      return 'Home';
    case 2:
      return 'Work';
    case 3:
    case 4:
    case 5:
    default:
      return 'Other';
  }
}

IconData getIcon(int? type) {
  switch (type) {
    case 1:
      return Icons.home;
    case 2:
      return Icons.work;
    default:
      return Icons.location_on;
  }
}
