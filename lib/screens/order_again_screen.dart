import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class OrderAgainScreen extends StatefulWidget {
  const OrderAgainScreen({super.key});

  @override
  State<OrderAgainScreen> createState() => _OrderAgainScreenState();
}

class _OrderAgainScreenState extends State<OrderAgainScreen> {
  final ScrollController _scrollController = ScrollController();

  // --------------------------------------------------------------------
  // SAMPLE PRODUCT MODEL (replace with your actual model)
  // --------------------------------------------------------------------
  List<Product> topProducts = [
    Product("Tomato", "1kg", 40, "assets/fack_img/img_38.png"),
    Product("Onion", "1kg", 45, "assets/fack_img/img_38.png"),
    Product("Potato", "1kg", 35, "assets/fack_img/img_38.png"),
  ];

  // Update product quantity
  void _incrementQuantity(Product product) {
    setState(() => product.quantity++);
  }

  void _decrementQuantity(Product product) {
    if (product.quantity > 0) {
      setState(() => product.quantity--);
    }
  }

  // --------------------------------------------------------------------
  // MAIN WIDGET BUILD
  // --------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [

          // ========================= TOP 50% ==========================
          Expanded(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [

                  /// BACKGROUND IMAGE
                  Image.asset(
                    "assets/images/reorder.png",
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),

                  /// MIDDLE IMAGE
                  Positioned(
                    top: 40,
                    child: Image.asset(
                      "assets/images/reorder_rabbi.png",
                      width: 160,
                      fit: BoxFit.contain,
                    ),
                  ),

                  /// CENTER TEXT BELOW IMAGE
                  Positioned(
                    bottom: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Order Again",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Quickly reorder your favorite items\nwith just one tap!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ========================= BOTTOM 50% ==========================
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _sectionTitle("Bestsellers"),
                  _topProductsList(),
                  _seeAllButton(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------
  // SECTION TITLE
  // --------------------------------------------------------------------
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: [
              Colors.orange.shade700,
              Colors.green.shade700,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds);
        },
        child: Text(
          "Bestsellers",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------
  // HORIZONTAL PRODUCT LIST
  // --------------------------------------------------------------------
  Widget _topProductsList() {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        itemCount: topProducts.length,
        itemBuilder: (context, index) {
          return _productCard(topProducts[index]);
        },
      ),
    );
  }

  // --------------------------------------------------------------------
  // PRODUCT CARD UI
  // --------------------------------------------------------------------
  Widget _productCard(Product product) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(
              product.image,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text(product.weight,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 2),

                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),

                  Row(
                    children: const [
                      Icon(Icons.timer, size: 14, color: Colors.green),
                      SizedBox(width: 3),
                      Text("10 Mins",
                          style: TextStyle(fontSize: 12, color: Colors.green)),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹${product.price}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),

                      SizedBox(
                        width: 80,
                        child: product.quantity == 0
                            ? GestureDetector(
                          onTap: () => _incrementQuantity(product),
                          child: Container(
                            height: 32,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.green, width: 1.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                "ADD",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        )
                            : Container(
                          height: 32,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.green, width: 1.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      _decrementQuantity(product),
                                  child: const Center(
                                    child: Icon(Icons.remove,
                                        size: 18, color: Colors.green),
                                  ),
                                ),
                              ),

                              Center(
                                child: Text(
                                  product.quantity.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                                ),
                              ),

                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      _incrementQuantity(product),
                                  child: const Center(
                                    child: Icon(Icons.add,
                                        size: 18, color: Colors.green),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _seeAllButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            "See All Products  →",
            style: TextStyle(color: Colors.green, fontSize: 16),
          ),
        ),
      ),
    );
  }
}


// ====================================================================
// PRODUCT MODEL (Adjust according to your real model)
// ====================================================================
class Product {
  String name;
  String weight;
  double price;
  String image;
  int quantity;

  Product(this.name, this.weight, this.price, this.image,
      {this.quantity = 0});
}






