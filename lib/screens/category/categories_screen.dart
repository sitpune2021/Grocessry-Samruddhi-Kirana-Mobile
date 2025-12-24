import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:samruddha_kirana/screens/product/product_detail_screen.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  int selectedMenu = 0;
  Map<int, bool> favorites = {};
  Map<int, int> quantities = {};

  final List sideMenu = [
    ["All", "assets/fack_img/img_25.png"],
    ["Fresh Vegetables", "assets/fack_img/img_26.png"],
    ["Fresh Fruits", "assets/fack_img/img_27.png"],
    ["Exotics", "assets/fack_img/img_28.png"],
    ["Coriander & Others", "assets/fack_img/img_29.png"],
    ["Flowers & Leaves", "assets/fack_img/img_30.png"],
    ["Seasonal", "assets/fack_img/img_31.png"],
    ["Freshly Cut & Sprouts", "assets/fack_img/img_32.png"],
    ["Frozen Veg", "assets/fack_img/img_33.png"],
    ["Certified Organic", "assets/fack_img/img_34.png"],
  ];

  final List products = [
    {
      "name": "Onion (Kanda)",
      "weight": "(0.95 -1.05)kg",
      "price": "₹ 32",
      "old_price": "₹ 40",
      "discount": "20% OFF",
      "img": "assets/fack_img/img_35.png",
    },
    {
      "name": "Coriander Leaves",
      "weight": "(0.95 -1.05)kg",
      "price": "₹ 15",
      "old_price": "₹ 20",
      "discount": "25% OFF",
      "img": "assets/fack_img/img_36.png",
    },
    {
      "name": "Green Chili",
      "weight": "(0.95 -1.05)kg",
      "price": "₹ 25",
      "old_price": "₹ 30",
      "discount": "17% OFF",
      "img": "assets/fack_img/img_35.png",
    },
    {
      "name": "Potato",
      "weight": "(0.95 -1.05)kg",
      "price": "₹ 20",
      "old_price": "₹ 28",
      "discount": "29% OFF",
      "img": "assets/fack_img/img_38.png",
    },
    {
      "name": "Tomato",
      "weight": "(0.95 -1.05)kg",
      "price": "₹ 30",
      "old_price": "₹ 38",
      "discount": "21% OFF",
      "img": "assets/fack_img/img_38.png",
    },
    {
      "name": "Carrot",
      "weight": "(0.95 -1.05)kg",
      "price": "₹ 40",
      "old_price": "₹ 50",
      "discount": "20% OFF",
      "img": "assets/fack_img/img_38.png",
    },
    {
      "name": "Brinjal",
      "weight": "(0.95 -1.05)kg",
      "price": "₹ 22",
      "old_price": "₹ 30",
      "discount": "27% OFF",
      "img": "assets/fack_img/img_41.png",
    },
    {
      "name": "Cauliflower",
      "weight": "(0.95 -1.05)kg",
      "price": "₹ 28",
      "old_price": "₹ 36",
      "discount": "22% OFF",
      "img": "assets/fack_img/img_35.png",
    },
  ];

  void _toggleFavorite(int index) {
    setState(() {
      favorites[index] = !(favorites[index] ?? false);
    });
  }

  void _addToCart(int index) {
    setState(() {
      quantities[index] = (quantities[index] ?? 0) + 1;
    });
  }

  void _removeFromCart(int index) {
    setState(() {
      if ((quantities[index] ?? 0) > 0) {
        quantities[index] = quantities[index]! - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: AutoSizeText(
          "Vegetables & Fruits",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          maxLines: 1,
          minFontSize: 14,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
              if (quantities.values.fold(0, (sum, quantity) => sum + quantity) >
                  0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${quantities.values.fold(0, (sum, quantity) => sum + quantity)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======================================================
            // LEFT SIDE MENU
            // ======================================================
            Container(
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(right: BorderSide(color: Colors.grey.shade300)),
              ),
              child: ListView.builder(
                itemCount: sideMenu.length,
                itemBuilder: (context, index) {
                  bool selected = index == selectedMenu;
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedMenu = index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.all(6),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selected ? Colors.white : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected ? Colors.green : Colors.grey.shade200,
                        ),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : [],
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            sideMenu[index][1],
                            height: 40,
                            width: 40,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            sideMenu[index][0],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.w400,
                              color: selected
                                  ? Colors.green
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ======================================================
            // RIGHT SIDE PRODUCTS
            // ======================================================
            Expanded(
              child: Container(
                color: Colors.grey.shade50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------------- Header with Sort/Filter ----------------
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      color: Colors.white,
                      child: Row(
                        children: [
                          AutoSizeText(
                            "${products.length} products",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            minFontSize: 12,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.sort,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                AutoSizeText(
                                  "Sort",
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 1,
                                  minFontSize: 10,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.filter_alt_outlined,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                AutoSizeText(
                                  "Filter",
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 1,
                                  minFontSize: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 1),

                    // ---------------- Products Grid ----------------
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 240,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final p = products[index];
                          return productCard(p, index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================================================================
  // PRODUCT CARD WIDGET
  // ===================================================================
  Widget productCard(Map p, int index) {
    final isFavorite = favorites[index] ?? false;
    final quantity = quantities[index] ?? 0;

    // Convert Map to Product object
    // Product product = Product(
    //   id: index.toString(),
    //   name: p["name"] ?? "",
    //   img: p["img"] ?? "",
    //   weight: p["weight"] ?? "",
    //   price: p["price"] ?? "",
    //   oldPrice: p["old_price"] ?? "",
    //   discount: p["discount"] ?? "",
    //   isFav: isFavorite,
    //   qty: quantity,
    // );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- IMAGE WITH DISCOUNT BADGE ----------
            Stack(
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.asset(
                    p["img"],
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // Discount Badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: AutoSizeText(
                      p["discount"] ?? "20% OFF",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      minFontSize: 8,
                      maxFontSize: 10,
                    ),
                  ),
                ),

                // Favorite Icon
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _toggleFavorite(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey.shade600,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ---------- PRODUCT DETAILS ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Weight
                  AutoSizeText(
                    p["weight"],
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    minFontSize: 8,
                    maxFontSize: 10,
                  ),

                  const SizedBox(height: 4),

                  // Product Name
                  AutoSizeText(
                    p["name"],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 1,
                    minFontSize: 11,
                    maxFontSize: 13,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // Price Row
                  Row(
                    children: [
                      AutoSizeText(
                        p["price"],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          color: Colors.green.shade700,
                        ),
                        maxLines: 1,
                        minFontSize: 13,
                        maxFontSize: 15,
                      ),
                      const SizedBox(width: 6),
                      AutoSizeText(
                        p["old_price"],
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                        maxLines: 1,
                        minFontSize: 9,
                        maxFontSize: 11,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Add Button or Quantity Counter
                  if (quantity == 0)
                    // Add Button
                    GestureDetector(
                      onTap: () => _addToCart(index),
                      child: Container(
                        width: double.infinity,
                        height: 32,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green.shade600,
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: AutoSizeText(
                            "ADD",
                            style: GoogleFonts.poppins(
                              color: Colors.green.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            minFontSize: 10,
                            maxFontSize: 12,
                          ),
                        ),
                      ),
                    )
                  else
                    // Quantity Counter
                    Container(
                      width: double.infinity,
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
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.remove,
                                color: Colors.green.shade600,
                                size: 18,
                              ),
                            ),
                          ),

                          // Quantity
                          AutoSizeText(
                            quantity.toString(),
                            style: GoogleFonts.poppins(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            minFontSize: 12,
                            maxFontSize: 14,
                          ),

                          // Increase Button
                          GestureDetector(
                            onTap: () => _addToCart(index),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.green.shade600,
                                size: 18,
                              ),
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
      ),
    );
  }
}

/*class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  int selectedMenu = 0;

  final List sideMenu = [
    ["All", "assets/fack_img/img_25.png"],
    ["Fresh Vegetables", "assets/fack_img/img_26.png"],
    ["Fresh Fruits", "assets/fack_img/img_27.png"],
    ["Exotics", "assets/fack_img/img_28.png"],
    ["Coriander & Others", "assets/fack_img/img_29.png"],
    ["Flowers & Leaves", "assets/fack_img/img_30.png"],
    ["Seasonal", "assets/fack_img/img_31.png"],
    ["Freshly Cut & Sprouts", "assets/fack_img/img_32.png"],
    ["Frozen Veg", "assets/fack_img/img_33.png"],
    ["Certified Organic", "assets/fack_img/img_34.png"],
  ];

  final List<Map> products = [
    {
      "name": "Onion (Kanda)",
      "weight": "(0.95 -1.05)kg",
      "price": "₹ 32",
      "old_price": "₹ 40",
      "discount": "20% OFF",
      "img": "assets/fack_img/img_35.png",
      "isFav": false,
      "qty": 0,
    },
    {
      "name": "Coriander Leaves",
      "weight": "(0.95 -1.05)kg",
      "price": "₹ 15",
      "old_price": "₹ 20",
      "discount": "25% OFF",
      "img": "assets/fack_img/img_36.png",
      "isFav": false,
      "qty": 0,
    },
    {
      "name": "Green Chili",
      "weight": "(0.95 -1.05)kg",
      "price": "₹ 25",
      "old_price": "₹ 30",
      "discount": "17% OFF",
      "img": "assets/fack_img/img_35.png",
      "isFav": false,
      "qty": 0,
    },
    {
      "name": "Potato",
      "weight": "(0.95 -1.05)kg",
      "price": "₹ 20",
      "old_price": "₹ 28",
      "discount": "29% OFF",
      "img": "assets/fack_img/img_38.png",
      "isFav": false,
      "qty": 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Vegetables & Fruits",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),

      // ================= BODY ===================
      body: Row(
        children: [
          // --------------- LEFT SIDE NAV -----------------
          Container(
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                right: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: ListView.builder(
              itemCount: sideMenu.length,
              itemBuilder: (context, index) {
                bool selected = index == selectedMenu;
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedMenu = index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selected ? Colors.white : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected
                            ? Colors.green
                            : Colors.grey.shade200,
                      ),
                      boxShadow: selected
                          ? [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ]
                          : [],
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          sideMenu[index][1],
                          height: 40,
                          width: 40,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          sideMenu[index][0],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight:
                            selected ? FontWeight.bold : FontWeight.w400,
                            color: selected
                                ? Colors.green
                                : Colors.grey.shade600,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ---------------- RIGHT SIDE PRODUCTS -----------------
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 250,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return productCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // PRODUCT CARD WITH FAVORITE + COUNTER
  // =====================================================
  Widget productCard(int index) {
    final p = products[index];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ----------- IMAGE + DISCOUNT + FAVORITE ----------
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  p["img"],
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // Discount
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    p["discount"],
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),

              // Favorite Toggle
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      p["isFav"] = !p["isFav"];
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      p["isFav"] ? Icons.favorite : Icons.favorite_border,
                      color: p["isFav"] ? Colors.red : Colors.grey,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // -------- NAME, PRICE, ADD BUTTON ----------
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p["weight"],
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  p["name"],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      p["price"],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      p["old_price"],
                      style: GoogleFonts.poppins(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ---------------- ADD / COUNTER -----------------
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: p["qty"] == 0
                      ? addButton(index)
                      : qtyCounter(index),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------
  // ADD BUTTON (when qty = 0)
  // -----------------------------------------------------
  Widget addButton(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          products[index]["qty"] = 1;
        });
      },
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 1.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            "ADD",
            style: GoogleFonts.poppins(
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------
  // QTY COUNTER ( + / – )
  // -----------------------------------------------------
  Widget qtyCounter(int index) {
    return Container(
      height: 33,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 1.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Minus
          InkWell(
            onTap: () {
              setState(() {
                if (products[index]["qty"] > 0) {
                  products[index]["qty"]--;
                }
              });
            },
            child: Container(
              width: 32,
              alignment: Alignment.center,
              child: const Icon(Icons.remove, size: 18, color: Colors.green),
            ),
          ),

          // Quantity
          Expanded(
            child: Center(
              child: Text(
                "${products[index]["qty"]}",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),

          // Plus
          InkWell(
            onTap: () {
              setState(() {
                products[index]["qty"]++;
              });
            },
            child: Container(
              width: 32,
              alignment: Alignment.center,
              child: const Icon(Icons.add, size: 18, color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}*/
