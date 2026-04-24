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

  /// 🔍 SEARCH + DATE
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  String searchQuery = '';
  DateTime? selectedDate;

  final Color primaryGreen = const Color(0xFF00C853);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().getPastOrders();
    });

    _scrollController.addListener(_onScroll);

    // ✅ Rebuild on BOTH focus gained and lost
    searchFocusNode.addListener(() {
      setState(() {}); // no condition needed
    });
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
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
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

    return GestureDetector(
      onTap: () => searchFocusNode.unfocus(),
      child: Scaffold(
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

            /// 🔍 FILTER LOGIC
            final filteredOrders = provider.orders.where((order) {
              final orderId = order.orderNumber.toString().toLowerCase();

              final matchesSearch = orderId.contains(searchQuery);

              bool matchesDate = true;

              if (selectedDate != null) {
                matchesDate =
                    order.createdAt.year == selectedDate!.year &&
                    order.createdAt.month == selectedDate!.month &&
                    order.createdAt.day == selectedDate!.day;
              }

              return matchesSearch && matchesDate;
            }).toList();

            return RefreshIndicator(
              color: primaryGreen,
              onRefresh: provider.refreshPastOrders,
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                // +2 for search bar and pagination loader
                itemCount: filteredOrders.length + 2,
                itemBuilder: (context, index) {
                  /// 🔝 FIRST ITEM — Search bar + date chip
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _buildSearchBar(),
                        if (selectedDate != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Text(
                                  "Date: ${DateFormat('dd-MMM-yyyy').format(selectedDate!)}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: primaryGreen,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => selectedDate = null),
                                  child: const Icon(Icons.close, size: 18),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 16),

                        /// 🚫 NO RESULTS
                        if (filteredOrders.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Center(
                              child: Text(
                                selectedDate != null
                                    ? "No orders found for selected date"
                                    : "No matching orders found",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                      ],
                    );
                  }

                  /// 🔽 LAST ITEM — Pagination loader
                  if (index == filteredOrders.length + 1) {
                    return provider.hasMore
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: Loader()),
                          )
                        : const SizedBox.shrink();
                  }

                  /// 📦 ORDER TILE
                  final order = filteredOrders[index - 1];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12, top: 4),
                    child: PastOrderTile(
                      id: order.id,
                      orderId: order.orderNumber,
                      date: _formatDate(order.createdAt),
                      price: '₹${order.totalAmount.toStringAsFixed(2)}',
                      status: order.orderStatus,
                      paymentMethod: order.paymentMethod,
                      orderData: order,
                    ),
                  );
                },
              ),
            );

          },
        ),
      ),
    );
  }

  /// 🔍 SEARCH BAR + DATE PICKER
  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            focusNode: searchFocusNode,
            cursorColor: primaryGreen,
            showCursor: searchFocusNode.hasFocus,

            decoration: InputDecoration(
              hintText: "Search Order ID",
              prefixIcon: const Icon(Icons.search, color: Colors.grey),

              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          searchQuery = '';
                          searchController.clear();
                        });
                        searchFocusNode.requestFocus();
                      },
                    )
                  : null,

              filled: true,
              fillColor: const Color(0xffF3F4F6),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),

              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),

            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
            },
          ),
        ),
        const SizedBox(width: 10),

        /// 📅 DATE BUTTON
        InkWell(
          onTap: _pickDate,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.calendar_today, color: Colors.white),
          ),
        ),
      ],
    );
  }

  /// 📅 DATE PICKER
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00C853),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd-MMM-yyyy').format(date);
  }
}
