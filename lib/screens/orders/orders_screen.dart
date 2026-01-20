import 'package:flutter/material.dart';
import 'new_orders_screen.dart';
import 'past_orders_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'Orders',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.search, color: Colors.black),
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF00C853),
            indicatorWeight: 4,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: 'New Orders'),
              Tab(text: 'Past Orders'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [NewOrdersScreen(), PastOrdersScreen()],
        ),
      ),
    );
  }
}
