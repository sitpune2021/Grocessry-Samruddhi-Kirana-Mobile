import 'package:flutter/material.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  String selectedLabel = "Home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Add Address",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // // APP BAR
            // Row(
            //   children: [
            //     IconButton(
            //       icon: const Icon(Icons.arrow_back),
            //       onPressed: () {},
            //     ),
            //     const Expanded(
            //       child: Center(
            //         child: Text(
            //           "Add Address...",
            //           style: TextStyle(
            //             fontSize: 22,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 48), // to balance center alignment
            //   ],
            // ),

            // MAP PREVIEW BOX
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 220,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  "Google Map Preview",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // LOCATION TITLE + CHANGE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Kirtane Baugh",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Hadapsar, Magarpatta, Pune",
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Change"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ADD ADDRESS HEADING
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Add Address",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 12),

            // INPUT FIELDS
            buildInputField("House No. & Floor *"),
            buildInputField("Building & Block No. (Optional)"),
            buildInputField("Landmark & Area Name (Optional)"),

            const SizedBox(height: 25),

            // LABEL SELECTOR
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Add Address Label",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  labelChip("Home"),
                  const SizedBox(width: 10),
                  labelChip("Work"),
                  const SizedBox(width: 10),
                  labelChip("Other"),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // RECEIVER DETAILS
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Receiver Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 12),

            buildInputField("Receiver’s Name"),
            buildInputField("Receiver’s Phone Number"),

            const SizedBox(height: 100),
          ],
        ),
      ),

      // SAVE ADDRESS BUTTON
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SizedBox(
          height: 55,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              "SAVE ADDRESS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Common input field widget
  Widget buildInputField(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xffF3F4F6),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Address label selector chip
  Widget labelChip(String label) {
    bool isSelected = selectedLabel == label;

    return InkWell(
      onTap: () {
        setState(() {
          selectedLabel = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.black26),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
