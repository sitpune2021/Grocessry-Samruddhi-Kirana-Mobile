import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samruddha_kirana/screens/location/select_location_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Sample cart data with quantities
  final List<Map<String, dynamic>> _cartItems = [
    {
      'id': 1,
      'image':
          "https://plus.unsplash.com/premium_photo-1664392147011-2a720f214e01?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZHVjdHxlbnwwfHwwfHx8MA%3D%3D",
      'title': "Amul Taaza Toned Fresh Milk (Pouch)",
      'subtitle': "1 pack (500 ml)",
      'price': "₹29",
      'quantity': 1,
    },
    {
      'id': 2,
      'image':
          "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZHVjdHxlbnwwfHwwfHx8MA%3D%3D",
      'title': "Pride of Cows Farm Fresh Milk | Plastic Bottle",
      'subtitle': "1 pc (500 ml)",
      'price': "₹75",
      'quantity': 2,
    },
  ];

  void _addToCart(int index) {
    setState(() {
      _cartItems[index]['quantity']++;
    });
  }

  void _removeFromCart(int index) {
    setState(() {
      if (_cartItems[index]['quantity'] > 1) {
        _cartItems[index]['quantity']--;
      } else {
        _cartItems.removeAt(index);
      }
    });
  }

  int get totalItems {
    return _cartItems.fold(
      0,
      (sum, item) => sum + (item['quantity'] as int).toInt(),
    );
  }

  double get totalPrice {
    return _cartItems.fold(0.0, (sum, item) {
      final price = double.parse(item['price'].replaceAll('₹', ''));
      return sum + (price * item['quantity']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF8F9FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.3,
          title: const Text(
            "Cart",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),

        // *******************************
        // BODY
        // *******************************
        body: SingleChildScrollView(
          child: Column(
            children: [
              // TOP SAVING STRIP
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: const Color(0xffE9F8EC),
                child: const Center(
                  child: Text(
                    "Yay! You saved ₹30 on this order",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 5),

              // DELIVERY ETA
              Container(
                padding: const EdgeInsets.all(18),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.flash_on, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      "Delivery in 12 mins",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // **************** CART ITEMS ****************
              ..._cartItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return _cartItem(
                  index: index,
                  image: item['image'],
                  title: item['title'],
                  subtitle: item['subtitle'],
                  price: item['price'],
                  quantity: item['quantity'],
                );
              }),

              const SizedBox(height: 10),

              // ADD MORE ITEMS BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black),
                  ),
                  child: const Center(
                    child: Text(
                      "+ Add More Items",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // COUPONS SECTION
              _sectionTile(icon: Icons.percent, title: "View Coupons & Offers"),

              // BILL SUMMARY
              _billSummary(),

              const SizedBox(height: 120),
            ],
          ),
        ),

        // *******************************
        // BOTTOM PAY BUTTON
        // *******************************
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ROW: ADDRESS + DOWN ARROW
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            const Text(
                              "Select Address",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Add New Address Button
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SelectLocationScreen(),
                                  ),
                                );
                              },

                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.add,
                                      color: Colors.pink,
                                      size: 26,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "Add New Address",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.pink,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 25),

                            // Saved Addresses Title
                            const Text(
                              "Saved Addresses",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 15),

                            // Address Card
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                                color: Colors.grey.shade100,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.home, size: 28),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Home + Selected badge
                                        Row(
                                          children: [
                                            const Text(
                                              "Home",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: const Text(
                                                "Selected",
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 5),

                                        const Text(
                                          "Lakshmi Bai colony",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),

                                        const Text(
                                          "...",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    const Icon(Icons.home, size: 20),
                    const SizedBox(width: 6),

                    // ADDRESS TEXT
                    Expanded(
                      child: Text(
                        "Home - lakshmi Bai colony, Raghunandan hall",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    const SizedBox(width: 6),

                    // DISTANCE TAG
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "21.1 km away",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    const Icon(Icons.keyboard_arrow_down, size: 28),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // PINK BUTTON
              GestureDetector(
                onTap: () {
                  // Handle payment
                },
                child: Container(
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xffFF2E63),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      "Click to Pay ₹${totalPrice.toInt()} ($totalItems)",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelectLocationScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xffFF2E63),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      "ADD Address To Procced (1)",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // *******************************
  // CART ITEM TILE
  // *******************************
  Widget _cartItem({
    required int index,
    required String image,
    required String title,
    required String subtitle,
    required String price,
    required int quantity,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
      ),
      child: Row(
        children: [
          // IMAGE
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade100,
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // TITLE + SUBTITLE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),

          // PRICE + STEPPER (Dynamic)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Add Button or Quantity Counter
              if (quantity == 0)
                // Add Button
                GestureDetector(
                  onTap: () => _addToCart(index),
                  child: Container(
                    width: 80,
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green.shade600,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "ADD",
                        style: GoogleFonts.poppins(
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                )
              else
                // Quantity Counter
                Container(
                  width: 80,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.green.shade600,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Decrease Button
                      GestureDetector(
                        onTap: () => _removeFromCart(index),
                        child: Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.only(left: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.remove,
                            color: Colors.green.shade600,
                            size: 16,
                          ),
                        ),
                      ),

                      // Quantity
                      Text(
                        quantity.toString(),
                        style: GoogleFonts.poppins(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),

                      // Increase Button
                      GestureDetector(
                        onTap: () => _addToCart(index),
                        child: Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.green.shade600,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 6),
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // *******************************
  // Section Tile (Coupons)
  // *******************************
  Widget _sectionTile({required IconData icon, required String title}) {
    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  // *******************************
  // BILL SUMMARY
  // *******************************
  Widget _billSummary() {
    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Bill summary",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // ITEM TOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Item Total"),
              Text("₹${totalPrice.toInt()}"),
            ],
          ),
          const SizedBox(height: 6),

          // HANDLING FEE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Handling Fee"), const Text("₹20")],
          ),
          const SizedBox(height: 6),

          // DELIVERY FEE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Delivery Fee"),
              const Text("₹30  FREE", style: TextStyle(color: Colors.green)),
            ],
          ),

          const Divider(height: 25),

          // TOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "To Pay",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                "₹${(totalPrice + 20).toInt()}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
