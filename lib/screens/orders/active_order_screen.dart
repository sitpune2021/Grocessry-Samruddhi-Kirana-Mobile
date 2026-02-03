
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samruddha_kirana/config/routes.dart';
import 'package:samruddha_kirana/constants/app_colors.dart';
import 'package:samruddha_kirana/models/orders/new_order_list_model.dart';
import 'package:samruddha_kirana/providers/orders/order_provider.dart';
import 'package:samruddha_kirana/widgets/loader.dart';

class ActiveOrdersPage extends StatefulWidget {
  const ActiveOrdersPage({super.key});

  @override
  State<ActiveOrdersPage> createState() => _ActiveOrdersPageState();
}

class _ActiveOrdersPageState extends State<ActiveOrdersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().getNewOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Active Orders",
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, provider, _) {
          if (provider.newOrderStatus == ProviderStatus.loading) {
            return const Center(child: Loader());
          }

          if (provider.newOrderStatus == ProviderStatus.empty) {
            return const Center(child: Text("No active orders"));
          }

          if (provider.newOrderStatus == ProviderStatus.error) {
            return Center(child: Text(provider.newOrderError));
          }

          // SUCCESS
          return RefreshIndicator(
            color: AppColors.preGreen,
            onRefresh: () async {
              await context.read<OrderProvider>().getNewOrders();
            },
            child: ListView.builder(
              padding: EdgeInsets.all(horizontalPadding),
              itemCount: provider.newOrders.length,
              itemBuilder: (context, index) {
                final OrdersData order = provider.newOrders[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: _orderCard(
                    order: order,
                    buttonHeight: buttonHeight,
                    onViewDetails: () {
                      context.push(Routes.orderDetails, extra: order);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // ================= ORDER CARD (REAL MODEL) =================
  Widget _orderCard({
    required OrdersData order,
    required double buttonHeight,
    required VoidCallback onViewDetails,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                "CONFIRMED",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _statusColor(order.orderStatus),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.orderStatus.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Order #${order.orderNumber}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _formatDate(order.createdAt),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),

          const Divider(height: 30, color: AppColors.preGreen),

          // ITEMS (REAL ORDER ITEM)
          ...order.orderItems.map((OrderItem item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.product.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    "Qty: ${item.quantity}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "₹${item.total.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          }),

          const Divider(height: 30, color: AppColors.preGreen),

          // TOTAL
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${order.orderItems.length} items in total",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    "Delivery Charge: ₹${order.deliveryCharge.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "GRAND TOTAL",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    "₹${order.totalAmount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.green,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // VIEW DETAILS
          SizedBox(
            height: buttonHeight,
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onViewDetails,
              icon: const Icon(Icons.visibility),
              label: const Text("View Details"),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.preGreen,
                side: const BorderSide(
                  // 👈 THIS LINE
                  color: AppColors.preGreen, // green border
                  width: 1.5, // thickness
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HELPERS =================

  String _formatDate(DateTime date) {
    return DateFormat('dd-MMM-yyyy').format(date);
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "packing":
        return Colors.green;
      case "scheduled":
        return Colors.orange;
      case "delivered":
        return Colors.blue;
      case "cancelled":
        return Colors.red;
      default:
        return AppColors.preGreen;
    }
  }
}
