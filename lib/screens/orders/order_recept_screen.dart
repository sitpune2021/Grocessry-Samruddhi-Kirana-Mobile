import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:samruddha_kirana/models/orders/past_order_list_model.dart';

class OrderReceiptAlert extends StatelessWidget {
  final OrderData order;

  const OrderReceiptAlert({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(),
            const SizedBox(height: 20),

            _sectionTitle(Icons.location_on, 'Delivery Address'),
            const SizedBox(height: 10),
            _addressText(),

            const Divider(height: 30),

            _sectionTitle(Icons.shopping_bag, 'Item Details'),
            const SizedBox(height: 12),

            /// SAME UI – DATA FROM MODEL
            if (order.orderItems.isNotEmpty)
              ...order.orderItems.map(_itemRow)
            else
              _emptyItem(),

            const SizedBox(height: 22),
            _summaryBox(),
            const SizedBox(height: 22),
            _gotItButton(context),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _header() {
    final isDelivered = order.orderStatus == 'delivered';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.orderNumber.isNotEmpty ? order.orderNumber : '#--',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Placed on ${_formatDate(order.createdAt)}',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isDelivered
                ? const Color(0xFFE6F7ED)
                : Colors.orange.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(
                isDelivered ? Icons.check_circle : Icons.schedule,
                color: isDelivered ? Colors.green : Colors.orange,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                order.orderStatus.isNotEmpty
                    ? order.orderStatus.toUpperCase()
                    : 'PENDING',
                style: TextStyle(
                  color: isDelivered ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================= SECTION TITLE =================

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // ================= ADDRESS =================
  // (API not available → UI kept same)

  Widget _addressText() {
    return const Padding(
      padding: EdgeInsets.only(left: 28),
      child: Text(
        'Address not available',
        style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
      ),
    );
  }

  // ================= ITEM ROW =================
  Widget _itemRow(OrderItem item) {
    final imageUrl = item.product.productImageUrls.isNotEmpty
        ? item.product.productImageUrls.first
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🖼️ PRODUCT IMAGE (CachedNetworkImage)
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
            ),
            clipBehavior: Clip.hardEdge,
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.broken_image,
                      color: Colors.green,
                      size: 20,
                    ),
                  )
                : const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 20,
                  ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name.isNotEmpty ? item.product.name : 'Item',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'X ${item.quantity > 0 ? item.quantity : '--'}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),

          Text(
            '₹${item.total > 0 ? item.total.toStringAsFixed(2) : '0.00'}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _emptyItem() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text('No items found', style: TextStyle(color: Colors.grey)),
    );
  }

  // ================= SUMMARY =================

  Widget _summaryBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F9F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _summaryRow('Subtotal', order.subtotal),
          const SizedBox(height: 8),
          _summaryRow(
            'Delivery Fee',
            order.deliveryCharge,
            valueColor: Colors.green,
          ),
          _summaryRow('Discount', order.discount),
          _summaryRow('Coupon Discount', order.couponDiscount),
          const Divider(height: 26),
          _summaryRow('Total Amount', order.totalAmount, isBold: true),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String label,
    double value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          '₹${value > 0 ? value.toStringAsFixed(2) : '0.00'}',
          style: TextStyle(
            fontSize: isBold ? 18 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  // ================= CLOSE BUTTON =================

  Widget _gotItButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00C853),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        onPressed: () => Navigator.pop(context),
        child: const Text(
          'Got it',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ================= HELPERS =================

  String _formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }
}
