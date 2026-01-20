import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samruddha_kirana/config/routes.dart';
import 'package:samruddha_kirana/providers/orders/order_provider.dart';
import 'package:samruddha_kirana/widgets/loader.dart';
import 'package:samruddha_kirana/widgets/new_order_card.dart';

class NewOrdersScreen extends StatefulWidget {
  const NewOrdersScreen({super.key});

  @override
  State<NewOrdersScreen> createState() => _NewOrdersScreenState();
}

class _NewOrdersScreenState extends State<NewOrdersScreen> {
  @override
  void initState() {
    super.initState();

    /// 🔥 API call only once
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

    return Consumer<OrderProvider>(
      builder: (context, provider, _) {
        /// 🔄 LOADING (NO REFRESH AT ALL)
        if (provider.newOrderStatus == ProviderStatus.loading) {
          return const Center(child: Loader());
        }

        /// 📭 EMPTY
        if (provider.newOrderStatus == ProviderStatus.empty) {
          return RefreshIndicator(
            onRefresh: () async {
              if (provider.newOrderStatus == ProviderStatus.loading) return;
              await context.read<OrderProvider>().getNewOrders();
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 300),
                Center(child: Text('No new orders')),
              ],
            ),
          );
        }

        /// ❌ ERROR
        if (provider.newOrderStatus == ProviderStatus.error) {
          return RefreshIndicator(
            onRefresh: () async {
              if (provider.newOrderStatus == ProviderStatus.loading) return;
              await context.read<OrderProvider>().getNewOrders();
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 300),
                Center(child: Text(provider.newOrderError)),
              ],
            ),
          );
        }

        /// ✅ SUCCESS
        return RefreshIndicator(
          color: const Color(0xFF00C853),
          backgroundColor: Colors.white70,
          onRefresh: () async {
            if (provider.newOrderStatus == ProviderStatus.loading) return;
            await context.read<OrderProvider>().getNewOrders();
          },
          child: ListView(
            padding: EdgeInsets.all(horizontalPadding),
            children: provider.newOrders.map((order) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: NewOrderCard(
                  orderId: '#-${order.orderNumber}',
                  badgeText: order.orderStatus.toUpperCase(),
                  rightText: _formatDate(order.createdAt),
                  totalAmount: order.totalAmount,
                  orderItems: order.orderItems,
                  onViewDetails: () {
                    context.push(Routes.orderDetails, extra: order);
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  /// ================= DATE FORMAT =================
  String _formatDate(DateTime date) {
    return DateFormat('dd-MMM-yyyy').format(date);
  }
}
