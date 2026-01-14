// import 'package:flutter/material.dart';

// class AddAddressScreen extends StatefulWidget {
//   const AddAddressScreen({super.key});

//   @override
//   State<AddAddressScreen> createState() => _AddAddressScreenState();
// }

// class _AddAddressScreenState extends State<AddAddressScreen> {
//   String selectedLabel = "Home";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text(
//           "Add Address",
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 22,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // // APP BAR
//             // Row(
//             //   children: [
//             //     IconButton(
//             //       icon: const Icon(Icons.arrow_back),
//             //       onPressed: () {},
//             //     ),
//             //     const Expanded(
//             //       child: Center(
//             //         child: Text(
//             //           "Add Address...",
//             //           style: TextStyle(
//             //             fontSize: 22,
//             //             fontWeight: FontWeight.w600,
//             //           ),
//             //         ),
//             //       ),
//             //     ),
//             //     const SizedBox(width: 48), // to balance center alignment
//             //   ],
//             // ),

//             // MAP PREVIEW BOX
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 16),
//               height: 220,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: const Center(
//                 child: Text(
//                   "Google Map Preview",
//                   style: TextStyle(color: Colors.black54),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 12),

//             // LOCATION TITLE + CHANGE
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Kirtane Baugh",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         "Hadapsar, Magarpatta, Pune",
//                         style: TextStyle(color: Colors.black54, fontSize: 14),
//                       ),
//                     ],
//                   ),
//                   OutlinedButton(
//                     onPressed: () {},
//                     style: OutlinedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     child: const Text("Change"),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 25),

//             // ADD ADDRESS HEADING
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 "Add Address",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),
//             ),

//             const SizedBox(height: 12),

//             // INPUT FIELDS
//             buildInputField("House No. & Floor *"),
//             buildInputField("Building & Block No. (Optional)"),
//             buildInputField("Landmark & Area Name (Optional)"),

//             const SizedBox(height: 25),

//             // LABEL SELECTOR
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 "Add Address Label",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),
//             ),

//             const SizedBox(height: 15),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   labelChip("Home"),
//                   const SizedBox(width: 10),
//                   labelChip("Work"),
//                   const SizedBox(width: 10),
//                   labelChip("Other"),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 25),

//             // RECEIVER DETAILS
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 "Receiver Details",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),
//             ),

//             const SizedBox(height: 12),

//             buildInputField("Receiver’s Name"),
//             buildInputField("Receiver’s Phone Number"),

//             const SizedBox(height: 100),
//           ],
//         ),
//       ),

//       // SAVE ADDRESS BUTTON
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.all(16),
//         color: Colors.white,
//         child: SizedBox(
//           height: 55,
//           child: ElevatedButton(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.pink,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14),
//               ),
//             ),
//             child: const Text(
//               "SAVE ADDRESS",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 letterSpacing: 1,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Common input field widget
//   Widget buildInputField(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(fontSize: 14, color: Colors.black54),
//           ),
//           const SizedBox(height: 8),
//           TextFormField(
//             decoration: InputDecoration(
//               filled: true,
//               fillColor: const Color(0xffF3F4F6),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 14,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Address label selector chip
//   Widget labelChip(String label) {
//     bool isSelected = selectedLabel == label;

//     return InkWell(
//       onTap: () {
//         setState(() {
//           selectedLabel = label;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.black : Colors.white,
//           borderRadius: BorderRadius.circular(30),
//           border: Border.all(color: Colors.black26),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.black,
//             fontSize: 15,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AddAddressScreen extends StatelessWidget {
  const AddAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// ================= RESPONSIVE VALUES =================
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
      defaultValue: 20,
      conditionalValues: const [
        Condition.largerThan(name: TABLET, value: 24),
      ],
    ).value;

    final buttonHeight = ResponsiveValue<double>(
      context,
      defaultValue: 56,
      conditionalValues: const [
        Condition.largerThan(name: TABLET, value: 64),
      ],
    ).value;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          'Add Address',
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('CONTACT INFORMATION'),
                      _inputField(
                        hint: 'Full Name',
                        icon: Icons.person_outline,
                      ),
                      _inputField(
                        hint: 'Phone Number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 24),
                      _sectionTitle('ADDRESS DETAILS'),
                      _inputField(
                        hint: 'Pincode / ZIP',
                        icon: Icons.location_on_outlined,
                        keyboardType: TextInputType.number,
                      ),
                      _inputField(
                        hint: 'Flat / House No. / Floor',
                        icon: Icons.tag,
                      ),
                      _inputField(
                        hint: 'Building Name / Area / Street',
                        icon: Icons.apartment_outlined,
                      ),

                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _inputField(
                              hint: 'City',
                              icon: Icons.location_city_outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _inputField(
                              hint: 'State',
                              icon: Icons.map_outlined,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      _sectionTitle('SAVE ADDRESS AS'),
                      Row(
                        children: const [
                          _AddressTypeChip(
                            label: 'Home',
                            icon: Icons.home,
                            isSelected: true,
                          ),
                          SizedBox(width: 12),
                          _AddressTypeChip(
                            label: 'Work',
                            icon: Icons.work_outline,
                          ),
                          SizedBox(width: 12),
                          _AddressTypeChip(
                            label: 'Other',
                            icon: Icons.more_horiz,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Save & Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= UI HELPERS =================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _inputField({
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, size: 20),
          filled: true,
          fillColor: const Color(0xFFF6FFF8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

/// ================= ADDRESS TYPE CHIP =================
class _AddressTypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;

  const _AddressTypeChip({
    required this.label,
    required this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.black54,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
