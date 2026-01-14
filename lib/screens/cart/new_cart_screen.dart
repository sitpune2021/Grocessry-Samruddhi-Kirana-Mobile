import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samruddha_kirana/config/routes.dart';

class NewCartScreen extends StatefulWidget {
  const NewCartScreen({super.key});

  @override
  State<NewCartScreen> createState() => _NewCartScreenState();
}

class _NewCartScreenState extends State<NewCartScreen> {
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
      conditionalValues: const [Condition.largerThan(name: TABLET, value: 24)],
    ).value;

    final buttonHeight = ResponsiveValue<double>(
      context,
      defaultValue: 56,
      conditionalValues: const [Condition.largerThan(name: TABLET, value: 64)],
    ).value;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "My Basket",
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.more_horiz, color: Colors.green),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              _selectAllRow(),
              const SizedBox(height: 12),

              _cartItem(
                image: "🍌",
                title: "Organic Bananas",
                save: "SAVE \$0.50",
                price: "\$1.99",
                oldPrice: "\$2.49",
                unit: "1kg Unit Price",
                qty: 1,
              ),

              _cartItem(
                image: "🥛",
                title: "Whole Milk",
                save: "SAVE \$1.00",
                price: "\$3.50",
                oldPrice: "\$4.50",
                unit: "1L Bottle",
                qty: 2,
              ),

              _cartItem(
                image: "🫐",
                title: "Greek Yogurt",
                save: "SAVE \$0.75",
                price: "\$4.25",
                oldPrice: "\$5.00",
                unit: "500g Tub",
                qty: 1,
              ),

              const SizedBox(height: 16),
              _couponCard(),
              const SizedBox(height: 16),
              _summarySection(),
              const Spacer(),

              _placeOrderButton(buttonHeight),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ================= SELECT ALL =================
  Widget _selectAllRow() {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Select All Items",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              "3 of 5 items selected",
              style: TextStyle(color: Colors.green, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  // ================= CART ITEM =================
  Widget _cartItem({
    required String image,
    required String title,
    required String save,
    required String price,
    required String oldPrice,
    required String unit,
    required int qty,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade100,
            ),
            child: Text(image, style: TextStyle(fontSize: 32)),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  save,
                  style: const TextStyle(color: Colors.green, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      oldPrice,
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  unit,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          _qtySelector(qty),
        ],
      ),
    );
  }

  // ================= QTY =================
  Widget _qtySelector(int qty) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFFBF5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _qtyButton(Icons.remove),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "$qty",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          _qtyButton(Icons.add),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      child: Icon(icon, size: 18, color: Colors.green),
    );
  }

  // ================= COUPON =================
  Widget _couponCard() {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        context.push(Routes.couponOffer);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: const [
            Icon(Icons.local_offer, color: Colors.green),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Apply Coupon Code",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.green),
          ],
        ),
      ),
    );
  }

  // ================= SUMMARY =================
  Widget _summarySection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEFFBF5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "TOTAL SAVINGS",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "-\$2.25",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _summaryRow("Subtotal", "\$13.24"),
        _summaryRow("Delivery Fee", "Free", isGreen: true),
        const SizedBox(height: 8),
        _summaryRow(
          "Total",
          "\$10.99",
          bold: true,
          large: true,
          subtitle: "Incl. all taxes",
        ),
      ],
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool bold = false,
    bool large = false,
    bool isGreen = false,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: large ? 18 : 14,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: large ? 22 : 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: isGreen ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ================= CTA =================
  Widget _placeOrderButton(double height) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Place Order",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 8),
            Icon(Icons.lock, size: 18),
          ],
        ),
      ),
    );
  }
}
