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
  final Color primaryGreen = const Color(0xFF00C853);

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  String searchQuery = '';
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().getNewOrders();
    });

    // ✅ Rebuild on BOTH focus gained and lost
    searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
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
      behavior: HitTestBehavior.opaque,
      onTap: () {
        searchFocusNode.unfocus();
      },
      child: Consumer<OrderProvider>(
        builder: (context, provider, _) {
          if (provider.newOrderStatus == ProviderStatus.loading) {
            return const Center(child: Loader());
          }

          if (provider.newOrderStatus == ProviderStatus.empty) {
            return _buildEmptyState();
          }

          if (provider.newOrderStatus == ProviderStatus.error) {
            return _buildErrorState(provider);
          }

          /// 🔍 FILTER LOGIC
          final filteredOrders = provider.newOrders.where((order) {
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
            onRefresh: () async {
              await context.read<OrderProvider>().getNewOrders();
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(horizontalPadding),
              itemCount: filteredOrders.length + 1, // +1 for header
              itemBuilder: (context, index) {
                /// 🔝 FIRST ITEM — Search bar + date chip + empty message
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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

                /// 📦 ORDER CARD
                final order = filteredOrders[index - 1];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: NewOrderCard(
                    orderId: 'Order No : ${order.orderNumber}',
                    badgeText: order.orderStatus.toUpperCase(),
                    rightText: DateFormat(
                      'dd-MMM-yyyy',
                    ).format(order.createdAt),
                    totalAmount: order.totalAmount,
                    orderItems: order.orderItems,
                    paymentMethod: order.paymentMethod,
                    onViewDetails: () {
                      context.push(Routes.orderDetails, extra: order);
                    },
                  ),
                );
              },
            ),
          );

          // return RefreshIndicator(
          //   color: primaryGreen,
          //   onRefresh: () async {
          //     await context.read<OrderProvider>().getNewOrders();
          //   },
          //   child: ListView(
          //     physics: const AlwaysScrollableScrollPhysics(),
          //     padding: EdgeInsets.all(horizontalPadding),
          //     children: [
          //       /// 🔍 SEARCH + DATE PICKER
          //       _buildSearchBar(),

          //       /// 📅 SELECTED DATE VIEW
          //       if (selectedDate != null)
          //         Padding(
          //           padding: const EdgeInsets.only(top: 10),
          //           child: Row(
          //             children: [
          //               Text(
          //                 "Date: ${DateFormat('dd-MMM-yyyy').format(selectedDate!)}",
          //                 style: TextStyle(
          //                   fontWeight: FontWeight.w500,
          //                   color: primaryGreen,
          //                 ),
          //               ),
          //               const SizedBox(width: 6),
          //               GestureDetector(
          //                 onTap: () {
          //                   setState(() {
          //                     selectedDate = null; // clear date
          //                   });
          //                 },
          //                 child: const Icon(Icons.close, size: 18),
          //               ),
          //             ],
          //           ),
          //         ),

          //       const SizedBox(height: 16),

          //       /// 🚫 NO RESULT MESSAGE
          //       if (filteredOrders.isEmpty)
          //         Padding(
          //           padding: const EdgeInsets.only(top: 100),
          //           child: Center(
          //             child: Text(
          //               selectedDate != null
          //                   ? "No orders found for selected date"
          //                   : "No matching orders found",
          //               style: const TextStyle(fontSize: 16),
          //             ),
          //           ),
          //         ),

          //       /// 📦 ORDER LIST
          //       ...filteredOrders.map((order) {
          //         return Padding(
          //           padding: const EdgeInsets.only(bottom: 16),
          //           child: NewOrderCard(
          //             orderId: 'Order No : ${order.orderNumber}',
          //             badgeText: order.orderStatus.toUpperCase(),
          //             rightText: DateFormat(
          //               'dd-MMM-yyyy',
          //             ).format(order.createdAt),
          //             totalAmount: order.totalAmount,
          //             orderItems: order.orderItems,
          //             paymentMethod: order.paymentMethod,
          //             onViewDetails: () {
          //               context.push(Routes.orderDetails, extra: order);
          //             },
          //           ),
          //         );
          //       }),
          //     ],
          //   ),
          // );
        },
      ),
    );
  }

  /// 🔍 SEARCH BAR + 📅 DATE PICKER
  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            cursorColor: primaryGreen,
            focusNode: searchFocusNode,
            showCursor: searchFocusNode.hasFocus,
            textInputAction: TextInputAction.done,

            decoration: InputDecoration(
              hintText: "Search Order ID",
              hintStyle: const TextStyle(color: Colors.grey),

              /// 🔍 PREFIX ICON
              prefixIcon: const Icon(Icons.search, color: Colors.grey),

              /// ❌ CLEAR BUTTON
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

              /// 🎨 BACKGROUND STYLE (like your design)
              filled: true,
              fillColor: const Color(0xffF3F4F6),

              /// 🔥 REMOVE BORDER (clean UI)
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),

              /// 👌 COMPACT HEIGHT
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),

            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
            },

            onSubmitted: (_) {
              FocusScope.of(context).unfocus();
            },
          ),
        ),
        const SizedBox(width: 10),

        /// 📅 DATE PICKER BUTTON
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

  /// 📅 DATE PICKER WITH GREEN THEME
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
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xFF00C853)),
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

  /// EMPTY
  Widget _buildEmptyState() {
    return RefreshIndicator(
      color: primaryGreen,
      onRefresh: () async {
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

  /// ERROR
  Widget _buildErrorState(OrderProvider provider) {
    return RefreshIndicator(
      color: primaryGreen,
      onRefresh: () async {
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
}
