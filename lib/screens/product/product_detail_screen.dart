import 'package:flutter/material.dart';

import '../cart/cart_screen.dart';

class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  final String weight;
  final String description;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.weight,
    required this.description,
    this.quantity = 0,
  });
}

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int cartCount = 0;
  final ScrollController _scrollController = ScrollController();
  bool _showStickyAddButton = false;

  // 🔥 MAIN PRODUCT
  Product mainProduct = Product(
    id: "1",
    name: "Onion (Kanda)",
    image: "assets/fack_img/img_38.png",
    price: 32.0,
    weight: "0.95 - 1.05 kg",
    description: "Fresh, organically grown onions",
  );

  // 🔥 SIMILAR PRODUCTS LIST
  final List<Product> similarProducts = [
    Product(
      id: "2",
      name: "Organic Onion",
      image: "assets/fack_img/img_38.png",
      price: 35.0,
      weight: "500g",
      description: "Organically grown onion",
    ),
    Product(
      id: "3",
      name: "Fresh Onion",
      image: "assets/fack_img/img_38.png",
      price: 30.0,
      weight: "1kg",
      description: "Fresh farm onion",
    ),
    Product(
      id: "4",
      name: "Red Onion",
      image: "assets/fack_img/img_38.png",
      price: 38.0,
      weight: "500g",
      description: "Premium red onion",
    ),
  ];

  // 🔥 TOP PRODUCTS LIST
  final List<Product> topProducts = [
    Product(
      id: "5",
      name: "Potato",
      image: "assets/fack_img/img_38.png",
      price: 25.0,
      weight: "1kg",
      description: "Fresh potatoes",
    ),
    Product(
      id: "6",
      name: "Tomato",
      image: "assets/fack_img/img_38.png",
      price: 40.0,
      weight: "500g",
      description: "Fresh tomatoes",
    ),
    Product(
      id: "7",
      name: "Carrot",
      image: "assets/fack_img/img_38.png",
      price: 45.0,
      weight: "500g",
      description: "Organic carrots",
    ),
    Product(
      id: "8",
      name: "Capsicum",
      image: "assets/fack_img/img_38.png",
      price: 60.0,
      weight: "500g",
      description: "Fresh capsicum",
    ),
    Product(
      id: "9",
      name: "Broccoli",
      image: "assets/fack_img/img_38.png",
      price: 80.0,
      weight: "1pc",
      description: "Fresh broccoli",
    ),
    Product(
      id: "10",
      name: "Spinach",
      image: "assets/fack_img/img_38.png",
      price: 20.0,
      weight: "200g",
      description: "Fresh spinach",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _updateCartCount();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset > 300 && !_showStickyAddButton) {
      setState(() {
        _showStickyAddButton = true;
      });
    } else if (_scrollController.offset <= 300 && _showStickyAddButton) {
      setState(() {
        _showStickyAddButton = false;
      });
    }
  }

  // 🔥 UPDATE TOTAL CART COUNT
  void _updateCartCount() {
    int total = mainProduct.quantity;
    total += similarProducts.fold(0, (sum, product) => sum + product.quantity);
    total += topProducts.fold(0, (sum, product) => sum + product.quantity);

    setState(() {
      cartCount = total;
    });
  }

  // 🔥 INCREMENT PRODUCT QUANTITY
  void _incrementQuantity(Product product) {
    setState(() {
      product.quantity++;
    });
    _updateCartCount();
  }

  // 🔥 DECREMENT PRODUCT QUANTITY
  void _decrementQuantity(Product product) {
    if (product.quantity > 0) {
      setState(() {
        product.quantity--;
      });
      _updateCartCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: _bottomCartBar(),
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topImageHeader(context),
                  _productInfoCard(),
                  const SizedBox(height: 1),

                  // 🔥 ADDED SECTIONS HERE
                  topIconsRow(),
                  const HighlightsSection(),
                  const InformationSection(),
                  _sectionTitle("Similar Products"),
                  _similarProductsList(),

                  _seeAllButton(),
                  const SizedBox(height: 16),
                  _sectionTitle("Top Products In this Category"),
                  _topProductsList(),
                  _seeAllButton(),
                  const SizedBox(height: 100),
                ],
              ),
            ),

            if (_showStickyAddButton) _stickyAddButton(),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // 🔥 STICKY ADD BUTTON
  // -------------------------------------------------------
  Widget _stickyAddButton() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(mainProduct.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    mainProduct.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "₹${mainProduct.price.toInt()}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Add/Remove Counter for Main Product
            Container(
              height: 36,
              width: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 1.3),
                borderRadius: BorderRadius.circular(18),
              ),
              child: mainProduct.quantity == 0
                  ? GestureDetector(
                      onTap: () => _incrementQuantity(mainProduct),
                      child: const Center(
                        child: Text(
                          "ADD",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => _decrementQuantity(mainProduct),
                          child: const SizedBox(
                            width: 36,
                            child: Icon(
                              Icons.remove,
                              color: Colors.green,
                              size: 18,
                            ),
                          ),
                        ),
                        Text(
                          mainProduct.quantity.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _incrementQuantity(mainProduct),
                          child: const SizedBox(
                            width: 36,
                            child: Icon(
                              Icons.add,
                              color: Colors.green,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // 🔥 TOP IMAGE HEADER
  // -------------------------------------------------------
  Widget _topImageHeader(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: Image.asset(
            mainProduct.image,
            width: double.infinity,
            height: 260,
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          top: 40,
          left: 16,
          child: _roundButton(Icons.arrow_back, () {
            Navigator.pop(context);
          }),
        ),

        Positioned(
          top: 40,
          right: 70,
          child: _roundButton(Icons.favorite_border, () {}),
        ),

        Positioned(
          top: 40,
          right: 16,
          child: _roundButton(Icons.search, () {}),
        ),
      ],
    );
  }

  Widget _roundButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
        child: Icon(icon, color: Colors.black),
      ),
    );
  }

  // -------------------------------------------------------
  // 🔥 PRODUCT INFORMATION CARD (MAIN CARD)
  // -------------------------------------------------------
  Widget _productInfoCard() {
    return Transform.translate(
      offset: const Offset(0, -40),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.only(left: 16, right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.timer, size: 18, color: Colors.green),
                SizedBox(width: 4),
                Text("10 Mins", style: TextStyle(color: Colors.green)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              mainProduct.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text("(${mainProduct.weight})"),
            const SizedBox(height: 10),

            Row(
              children: [
                Text(
                  "₹${mainProduct.price.toInt()}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "MRP ₹40",
                  style: TextStyle(decoration: TextDecoration.lineThrough),
                ),
                const SizedBox(width: 8),
                const Text("20% OFF", style: TextStyle(color: Colors.blue)),
              ],
            ),

            const SizedBox(height: 14),

            const SizedBox(height: 10),
            GestureDetector(
              onTap: _showProductDetailsBottomSheet,
              child: const Text(
                "View product details",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // 🔥 BOTTOM SHEET PRODUCT DETAILS
  // -------------------------------------------------------
  void _showProductDetailsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage(mainProduct.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mainProduct.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text("(${mainProduct.weight})"),
                          const SizedBox(height: 4),
                          Text(
                            "₹${mainProduct.price.toInt()}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Product Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _detailRow("Category", "Vegetables"),
                      _detailRow("Brand", "Fresh Farms"),
                      _detailRow("Shelf Life", "7 days"),
                      _detailRow("Storage", "Store in cool, dry place"),

                      const SizedBox(height: 20),
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        mainProduct.description,
                        style: const TextStyle(color: Colors.grey, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  // 🔥 SECTION TITLE
  // -------------------------------------------------------
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // -------------------------------------------------------
  // 🔥 SIMILAR PRODUCTS LIST
  // -------------------------------------------------------
  Widget _similarProductsList() {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        itemCount: similarProducts.length,
        itemBuilder: (context, index) {
          return _productCard(similarProducts[index]);
        },
      ),
    );
  }

  // -------------------------------------------------------
  // 🔥 TOP PRODUCTS LIST
  // -------------------------------------------------------
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

  // -------------------------------------------------------
  // 🔥 PRODUCT CARD UI (SMALL CARDS) - FIXED COUNTER
  // -------------------------------------------------------
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
          ),
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
                  Text(
                    product.weight,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 2),

                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Row(
                    children: const [
                      Icon(Icons.timer, size: 14, color: Colors.green),
                      SizedBox(width: 3),
                      Text(
                        "10 Mins",
                        style: TextStyle(fontSize: 12, color: Colors.green),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹${product.price.toInt()}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      // 🔥 FIXED COUNTER - Now using Product object state
                      SizedBox(
                        width: 80,
                        child: product.quantity == 0
                            ? GestureDetector(
                                onTap: () => _incrementQuantity(product),
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  height: 32,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.green,
                                      width: 1.2,
                                    ),
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
                                    color: Colors.green,
                                    width: 1.2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),

                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () =>
                                            _decrementQuantity(product),
                                        behavior: HitTestBehavior.opaque,
                                        child: const Center(
                                          child: Icon(
                                            Icons.remove,
                                            size: 18,
                                            color: Colors.green,
                                          ),
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
                                        behavior: HitTestBehavior.opaque,
                                        child: const Center(
                                          child: Icon(
                                            Icons.add,
                                            size: 18,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  // 🔥 SEE ALL BUTTON
  // -------------------------------------------------------
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

  // -------------------------------------------------------
  // 🔥 BOTTOM CART BAR (DYNAMIC)
  // -------------------------------------------------------

  Widget _bottomCartBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 1),
        ],
      ),
      child: Row(
        children: [
          // LEFT SIDE → VIEW CART (only when items exist)
          if (cartCount > 0)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      "View Cart ($cartCount Item${cartCount != 1 ? 's' : ''})",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),

          if (cartCount > 0) const SizedBox(width: 10),

          // RIGHT SIDE → FULL WIDTH ADD TO CART / STEPPER
          Expanded(
            child: cartCount == 0
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        cartCount = 1;
                      });
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(
                        child: Text(
                          "Add to Cart",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  )
                : _quantityStepper(),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────
  //   QUANTITY STEPPER (Zepto style)
  // ───────────────────────────────────────────
  Widget _quantityStepper() {
    return Container(
      height: 50,
      width: 130,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // MINUS BUTTON
          GestureDetector(
            onTap: () {
              setState(() {
                if (cartCount > 1) {
                  cartCount--;
                } else {
                  cartCount = 0; // remove item, show Add to Cart again
                }
              });
            },
            child: const Icon(Icons.remove, color: Colors.white, size: 22),
          ),

          // COUNT
          Text(
            "$cartCount",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          // PLUS BUTTON
          GestureDetector(
            onTap: () {
              setState(() {
                cartCount++;
              });
            },
            child: const Icon(Icons.add, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }

  void _showCartBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Your Cart",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "$cartCount Item${cartCount != 1 ? 's' : ''}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const Divider(),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (mainProduct.quantity > 0) _cartItem(mainProduct),
                    ...similarProducts
                        .where((p) => p.quantity > 0)
                        .map(_cartItem),
                    ...topProducts.where((p) => p.quantity > 0).map(_cartItem),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total", style: TextStyle(fontSize: 16)),
                        Text(
                          "₹${_calculateTotal()}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(
                        child: Text(
                          "Proceed to Checkout",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
  }

  double _calculateTotal() {
    double total = mainProduct.price * mainProduct.quantity;
    total += similarProducts.fold(
      0,
      (sum, product) => sum + (product.price * product.quantity),
    );
    total += topProducts.fold(
      0,
      (sum, product) => sum + (product.price * product.quantity),
    );
    return total;
  }

  Widget _cartItem(Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(product.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "₹${product.price.toInt()}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "Qty: ${product.quantity}",
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  // 🔥 TOP ICONS ROW
  // -------------------------------------------------------
  Widget topIconsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          featureItem(Icons.block, "No Return Or Exchange"),
          featureItem(Icons.flash_on, "Fast Delivery"),
        ],
      ),
    );
  }

  Widget featureItem(IconData icon, String title) {
    return SizedBox(
      height: 120, // SAME HEIGHT
      width: 150, // SAME WIDTH
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.black87),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------
// 🔥 HIGHLIGHTS SECTION
// -------------------------------------------------------
class HighlightsSection extends StatefulWidget {
  const HighlightsSection({super.key});

  @override
  _HighlightsSectionState createState() => _HighlightsSectionState();
}

class _HighlightsSectionState extends State<HighlightsSection> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Highlights",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () => setState(() => expanded = !expanded),
              ),
            ],
          ),

          // SHOW ALL DETAILS ONLY WHEN EXPANDED
          if (expanded) ...[
            buildRow("Brand", "Amul"),
            buildRow("Product Type", "Toned Milk"),

            buildRow(
              "Key Features",
              "Pasteurized and homogenized, rich in nutrients, zero preservatives",
            ),
            buildRow("Material Type Free", "Preservative-free"),
            buildRow("Packaging Type", "Pouch"),
            buildRow("Ingredients", "Milk Solids (3% Fat Min, 8.5% SNF Min)"),
            buildRow("Usage Recommendation", "For Immediate Use"),
            buildRow("Dietary Preference", "Veg"),
            buildRow("Unit", "1 pack (500 ml)"),
            buildRow(
              "Storage Instruction",
              "Store continuously under refrigeration below 5°C",
            ),
          ],

          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => expanded = !expanded),
            child: Center(
              child: Text(
                expanded ? "View less ▲" : "View more ▼",
                style: const TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

// -------------------------------------------------------
// 🔥 INFORMATION SECTION
// -------------------------------------------------------
class InformationSection extends StatefulWidget {
  const InformationSection({super.key});

  @override
  _InformationSectionState createState() => _InformationSectionState();
}

class _InformationSectionState extends State<InformationSection> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () => setState(() => expanded = !expanded),
              ),
            ],
          ),

          // SHOW ITEMS ONLY WHEN EXPANDED
          if (expanded) ...[
            buildRow(
              "Disclaimer",
              "All images are for representational purposes only.",
            ),
            buildRow("Customer Care Details", "Email: support@zeptonow.com"),
          ],

          const SizedBox(height: 8),

          // VIEW MORE / LESS BUTTON
          GestureDetector(
            onTap: () => setState(() => expanded = !expanded),
            child: Center(
              child: Text(
                expanded ? "View less ▲" : "View more ▼",
                style: const TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
