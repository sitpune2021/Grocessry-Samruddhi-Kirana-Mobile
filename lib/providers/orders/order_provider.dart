import 'package:flutter/material.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/models/orders/new_order_list_model.dart';
import 'package:samruddha_kirana/models/orders/past_order_list_model.dart';
import 'package:samruddha_kirana/services/orders/order_service.dart';

/// ================= PROVIDER STATUS =================
enum ProviderStatus { success, empty, loading, error }

class OrderProvider extends ChangeNotifier {
  /// ================= PAST ORDERS =================
  ProviderStatus pastOrderStatus = ProviderStatus.success;

  final List<OrderData> orders = [];
  int currentPage = 1;
  bool hasMore = true;
  bool isFetchingMore = false;
  String pastOrderError = '';

  /// ================= NEW ORDERS =================
  ProviderStatus newOrderStatus = ProviderStatus.success;
  final List<OrdersData> newOrders = [];
  String newOrderError = '';

  // ================= NEW ORDERS ====================
  Future<void> getNewOrders() async {
    newOrderStatus = ProviderStatus.loading;
    notifyListeners();

    try {
      final ApiResponse response = await OrderService.fetchNewOrders();

      if (response.success && response.data != null) {
        final model = NewOrderListModel.fromJson(response.data);

        newOrders
          ..clear()
          ..addAll(model.data);

        newOrderStatus = newOrders.isEmpty
            ? ProviderStatus.empty
            : ProviderStatus.success;
      } else {
        newOrders.clear();
        newOrderError = response.message;
        newOrderStatus = ProviderStatus.error;
      }
    } catch (e) {
      newOrders.clear();
      newOrderError = e.toString();
      newOrderStatus = ProviderStatus.error;
    }

    notifyListeners();
  }

  // ================= PAST ORDERS ===================
  Future<ApiResponse> getPastOrders({bool loadMore = false}) async {
    if (loadMore) {
      if (!hasMore || isFetchingMore) {
        return ApiResponse(success: false, message: 'No more data');
      }
      isFetchingMore = true;
    } else {
      pastOrderStatus = ProviderStatus.loading;
      currentPage = 1;
      orders.clear();
      hasMore = true;
    }

    notifyListeners();

    late ApiResponse response;

    try {
      response = await OrderService.fetchPastOrders(page: currentPage);

      if (response.success && response.data != null) {
        final model = PastOrderListModel.fromJson(response.data);

        orders.addAll(model.data.data);
        hasMore = model.data.nextPageUrl != null;
        currentPage++;

        pastOrderStatus = orders.isEmpty
            ? ProviderStatus.empty
            : ProviderStatus.success;
      } else {
        pastOrderError = response.message;
        pastOrderStatus = ProviderStatus.error;
      }
    } catch (e) {
      pastOrderError = e.toString();
      pastOrderStatus = ProviderStatus.error;
      response = ApiResponse(success: false, message: pastOrderError);
    } finally {
      isFetchingMore = false;
      notifyListeners();
    }

    return response;
  }

  /// ================= PULL TO REFRESH =================
  Future<void> refreshPastOrders() async {
    await getPastOrders(loadMore: false);
  }

  /// ================= HELPER GETTERS =================
  bool get isNewOrderLoading => newOrderStatus == ProviderStatus.loading;
  bool get isNewOrderEmpty => newOrderStatus == ProviderStatus.empty;
  bool get isNewOrderError => newOrderStatus == ProviderStatus.error;

  bool get isPastOrderLoading => pastOrderStatus == ProviderStatus.loading;
  bool get isPastOrderEmpty => pastOrderStatus == ProviderStatus.empty;
  bool get isPastOrderError => pastOrderStatus == ProviderStatus.error;
}
