import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samruddha_kirana/providers/orders/order_provider.dart';
import 'package:samruddha_kirana/widgets/loader.dart';
import 'package:samruddha_kirana/widgets/past_order_tile.dart';

class PastOrdersScreen extends StatefulWidget {
  const PastOrdersScreen({super.key});

  @override
  State<PastOrdersScreen> createState() => _PastOrdersScreenState();
}

class _PastOrdersScreenState extends State<PastOrdersScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().getPastOrders();
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = context.read<OrderProvider>();

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      provider.getPastOrders(loadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// ================= RESPONSIVE =================
    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16,
      conditionalValues: const [
        Condition.largerThan(name: TABLET, value: 24),
        Condition.largerThan(name: DESKTOP, value: 60),
      ],
    ).value;

    return Scaffold(
      backgroundColor: Colors.white10,
      body: Consumer<OrderProvider>(
        builder: (context, provider, _) {
          /// 🔄 Initial loading
          if (provider.pastOrderStatus == ProviderStatus.loading &&
              provider.orders.isEmpty) {
            return const Center(child: Loader());
          }

          /// 📭 Empty state
          if (provider.pastOrderStatus == ProviderStatus.empty) {
            return const Center(child: Text('No past orders found'));
          }

          /// ❌ Error state
          if (provider.pastOrderStatus == ProviderStatus.error) {
            return Center(child: Text(provider.pastOrderError));
          }

          // ✅ Success
          return RefreshIndicator(
            onRefresh: provider.refreshPastOrders,
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              itemCount: provider.orders.length + (provider.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                // 🔽 Pagination loader
                if (index == provider.orders.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: Loader()),
                  );
                }

                final order = provider.orders[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12, top: 4),
                  child: PastOrderTile(
                    orderId: order.orderNumber,
                    date: _formatDate(order.createdAt),
                    price: '₹${order.totalAmount.toStringAsFixed(2)}',
                    status: order.orderStatus,
                    orderData: order,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd-MMM-yyyy').format(date);
  }
}
