import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samruddha_kirana/models/orders/new_order_list_model.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrdersData? order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  DateTime? displayDate;

  @override
  void initState() {
    super.initState();

    final data = widget.order;

    /// ✅ Date fallback logic
    if (data?.deliveredAt != null) {
      displayDate = data!.deliveredAt;
    } else if (data?.updatedAt != null) {
      displayDate = data!.updatedAt;
    } else if (data?.createdAt != null) {
      displayDate = data!.createdAt;
    }

    /// ✅ Pulse animation

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _scale = Tween(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.order; // 🔒 SAFE HANDLE

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
      backgroundColor: const Color(0xFFF7F9F8),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Order Details",
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          children: [
            const SizedBox(height: 14),

            /// ================= STATUS =================
            _card(
              child: Column(
                children: [
                  ScaleTransition(
                    scale: _scale,
                    child: Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.green,
                          child: Icon(Icons.check, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    data?.orderStatus.toUpperCase() ?? 'ORDER',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    displayDate != null
                        ? DateFormat(
                            'dd-MMM-yyyy, hh:mm a',
                          ).format(displayDate!)
                        : 'Status updated recently',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ================= DELIVERY ADDRESS =================
            _sectionCard(child: _deliveryAddressWidget(data)),
            const SizedBox(height: 20),

            /// ================= ITEMS ORDERED =================
            _sectionCard(
              title: "ITEMS ORDERED",
              child: Column(
                children: (data?.orderItems ?? []).isNotEmpty
                    ? data!.orderItems.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 44,
                                  height: 44,
                                  child:
                                      item.product.productImageUrls.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: item
                                              .product
                                              .productImageUrls
                                              .first,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              _imageLoader(),
                                          errorWidget: (context, url, error) =>
                                              _imagePlaceholder(),
                                        )
                                      : _imagePlaceholder(),
                                ),
                              ),

                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '${item.quantity} x ₹${item.price}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '₹${item.total}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList()
                    : const [
                        Text(
                          'Items not available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
              ),
            ),

            const SizedBox(height: 20),

            /// ================= BILL DETAILS =================
            _sectionCard(
              title: "BILL DETAILS",
              child: Column(
                children: [
                  _billRow("Item Total", data?.subtotal ?? 0),
                  _billsRow(
                    "Delivery Fee",
                    data?.deliveryCharge ?? 0,
                    isFree: (data?.deliveryCharge ?? 0) == 0,
                  ),

                  _billRow("Discount", data?.discount ?? 0),
                  _billRow("Coupon Discount", data?.couponDiscount ?? 0),
                  const Divider(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _billRow(
                      "Grand Total",
                      data?.totalAmount ?? 0,
                      isBold: true,
                      valueColor: Colors.green,
                      subText: '(including all taxes)',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ================= ORDER INFO =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ORDER ID\n${data?.orderNumber ?? '--'}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const Text(
                  'PAYMENT MODE\nONLINE',
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// ================= HELP =================
            SizedBox(
              height: buttonHeight,
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text("NEED HELP?"),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

Widget _deliveryAddressWidget(OrdersData? data) {
  final address = data?.deliveryAddress;

  if (address == null) {
    return const Text(
      'Address not available',
      style: TextStyle(color: Colors.grey),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /// 🔝 Icon + Title
      Row(
        children: const [
          Icon(Icons.location_on, color: Colors.green, size: 20),
          SizedBox(width: 8),
          Text(
            'DELIVERY ADDRESS',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ],
      ),

      const SizedBox(height: 12),

      /// 📦 Address Details
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ---------- Name + Phone ----------
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        address.firstName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (address.phone.isNotEmpty)
                      Text(
                        'No. ${address.phone}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${address.address}.',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  '${address.city}, ${address.country} -${address.postcode}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _imageLoader() {
  return Container(
    color: Colors.grey.shade200,
    alignment: Alignment.center,
    child: const SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(strokeWidth: 2),
    ),
  );
}

Widget _imagePlaceholder() {
  return Container(
    color: Colors.grey.shade200,
    alignment: Alignment.center,
    child: const Icon(Icons.image_not_supported, size: 20, color: Colors.green),
  );
}

/// ================= HELPERS =================

Widget _card({required Widget child}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: child,
  );
}

Widget _sectionCard({String? title, required Widget child}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null && title.trim().isNotEmpty) ...[
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
        ],
        child,
      ],
    ),
  );
}

Widget _billsRow(String title, double amount, {bool isFree = false}) {
  const greenColor = Color(0xFF00C853);

  return Row(
    children: [
      /// 🚲 Bike Icon
      const Icon(Icons.delivery_dining, color: greenColor, size: 20),

      const SizedBox(width: 8),

      /// 🏷 Delivery Fee Text
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: greenColor,
          ),
        ),
      ),

      /// 💰 Amount / FREE
      Text(
        isFree ? 'FREE' : '₹${amount.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: greenColor,
        ),
      ),
    ],
  );
}

Widget _billRow(
  String title,
  double value, {
  bool isBold = false,
  bool isFree = false,
  Color? valueColor,
  String? subText,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ---------- Main Row ----------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            Text(
              isFree ? 'FREE' : '₹${value.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: valueColor ?? (isFree ? Colors.green : Colors.black),
              ),
            ),
          ],
        ),

        /// ---------- Sub text ----------
        if (subText != null) ...[
          const SizedBox(height: 4),
          Text(
            subText,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ],
    ),
  );
}
