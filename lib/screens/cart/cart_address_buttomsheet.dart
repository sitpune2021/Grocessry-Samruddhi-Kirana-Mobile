// import 'package:flutter/material.dart';

// class DeliveryAddressSheet extends StatelessWidget {
//   const DeliveryAddressSheet({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [

//           // drag handle
//           Container(
//             height: 5,
//             width: 40,
//             decoration: BoxDecoration(
//               color: Colors.grey[400],
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),

//           SizedBox(height: 16),

//           Text("Delivery Address",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

//           SizedBox(height: 16),

//           // Search Field
//           TextField(
//             decoration: InputDecoration(
//               hintText: "Search your location",
//               prefixIcon: Icon(Icons.search),
//               filled: true,
//               fillColor: Colors.grey[100],
//               border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none),
//             ),
//           ),

//           SizedBox(height: 16),

//           // Use Current Location
//           ListTile(
//             leading: CircleAvatar(
//               backgroundColor: Colors.green.withOpacity(0.1),
//               child: Icon(Icons.my_location, color: Colors.green),
//             ),
//             title: Text("Use current location"),
//             subtitle: Text("Enable GPS"),
//             trailing: Icon(Icons.arrow_forward_ios, size: 16),
//             onTap: () {},
//           ),

//           SizedBox(height: 8),

//           // Map Preview (Fake)
//           Container(
//             height: 150,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: Colors.grey[300],
//             ),
//             child: Center(
//               child: Icon(Icons.map, size: 60, color: Colors.grey),
//             ),
//           ),

//           SizedBox(height: 16),

//           // Selected Address
//           ListTile(
//             leading: Icon(Icons.location_on, color: Colors.red),
//             title: Text("123 Sunshine Valley"),
//             subtitle: Text("Los Angeles, CA 90001"),
//           ),

//           SizedBox(height: 16),

//           // Confirm Button
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 padding: EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//               ),
//               onPressed: () {},
//               child: Text("Confirm Delivery Address",
//                   style: TextStyle(fontSize: 16)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class SavedAddressSheet extends StatelessWidget {
  const SavedAddressSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Saved Addresses",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              Icon(Icons.close),
            ],
          ),

          const SizedBox(height: 20),

          // Add New Address
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add, color: Colors.green),
            ),
            title: const Text("Add New Address",
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),

          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerLeft,
            child: Text("RECENT & SAVED",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600)),
          ),

          const SizedBox(height: 12),

          // Home (selected)
          _addressTile(
            icon: Icons.home,
            title: "Home",
            badge: "DEFAULT",
            badgeColor: Colors.green,
            address:
                "123 Sunshine Valley, Los Angeles,\nCA 90001",
            selected: true,
          ),

          // Office
          _addressTile(
            icon: Icons.work,
            title: "Office",
            address:
                "456 Corporate Plaza, Suite 200,\nSan Francisco, CA 94105",
          ),

          // Mom's House
          _addressTile(
            icon: Icons.location_on,
            title: "Mom's House",
            badge: "OLD ADDRESS",
            badgeColor: Colors.grey,
            address:
                "789 Serenity Lane, Santa Monica,\nCA 90401",
          ),

          const SizedBox(height: 20),

          // Confirm Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {},
              child: const Text("Confirm Address",
                  style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  // Address Tile Widget
  Widget _addressTile({
    required IconData icon,
    required String title,
    required String address,
    bool selected = false,
    String? badge,
    Color? badgeColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected
            ? Colors.green.withOpacity(.08)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected
              ? Colors.green
              : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [

          // icon
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20),
          ),

          const SizedBox(width: 12),

          // text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600)),
                    if (badge != null)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius:
                              BorderRadius.circular(6),
                        ),
                        child: Text(badge,
                            style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white)),
                      ),
                  ],
                ),

                const SizedBox(height: 4),
                Text(address,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),

          // radio
          Icon(
            selected
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
