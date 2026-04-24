import 'dart:io';

import 'package:flutter/material.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/models/orders/new_order_list_model.dart';
import 'package:samruddha_kirana/models/orders/past_order_list_model.dart';
import 'package:samruddha_kirana/models/refund_product/refund_product_list_model.dart';
import 'package:samruddha_kirana/models/return_type/return_type_model.dart';
import 'package:samruddha_kirana/services/orders/order_service.dart';

/// ================= PROVIDER STATUS =================
enum ProviderStatus { success, empty, loading, error }

/// ================= UI STATE (NO MODEL CHANGE) =================
class RefundSelection {
  final RefundProductItem product;
  bool isSelected;
  int quantity;

  RefundSelection({
    required this.product,
    this.isSelected = false,
    this.quantity = 1,
  });
}

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

  /// ================= REFUND PRODUCTS =================
  ProviderStatus refundProductStatus = ProviderStatus.success;
  List<RefundProductItem> refundProducts = [];
  String refundProductError = '';

  /// ================= REFUND REASONS =================
  List<RefundSelection> refundSelections = [];
  bool allowMultipleSelection = true;

  /// ================= REFUND REASONS =================
  ProviderStatus refundReasonStatus = ProviderStatus.success;
  List<ReturnTypeItem> refundReasons = [];
  ReturnTypeItem? selectedRefundReason;
  String refundReasonError = '';

  /// ================= REFUND SUBMIT =================
  ProviderStatus refundSubmitStatus = ProviderStatus.success;
  String refundSubmitError = '';

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
      // orders.clear();
      hasMore = true;
    }

    notifyListeners();

    late ApiResponse response;

    try {
      response = await OrderService.fetchPastOrders(page: currentPage);

      if (response.success && response.data != null) {
        final model = PastOrderListModel.fromJson(response.data);

        final newData = model.data.data;

        /// ✅ REPLACE data on refresh, append on pagination
        if (currentPage == 1) {
          orders
            ..clear()
            ..addAll(newData);
        } else {
          orders.addAll(newData);
        }

        // orders.addAll(model.data.data);
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

  /// ================= REFUND REASONS =================
  Future<void> getRefundReasons() async {
    refundReasonStatus = ProviderStatus.loading;
    notifyListeners();

    try {
      final response = await OrderService.fetchRefundReasons();

      if (response.success && response.data != null) {
        final model = ReturnTypeModel.fromJson(response.data);

        refundReasons = model.data;
        refundReasonStatus = refundReasons.isEmpty
            ? ProviderStatus.empty
            : ProviderStatus.success;
      } else {
        refundReasonError = response.message;
        refundReasonStatus = ProviderStatus.error;
      }
    } catch (e) {
      refundReasonError = e.toString();
      refundReasonStatus = ProviderStatus.error;
    }

    notifyListeners();
  }

  void setSelectedRefundReason(ReturnTypeItem? value) {
    selectedRefundReason = value;
    notifyListeners();
  }

  int? get selectedRefundReasonId => selectedRefundReason?.id;

  /// ================= REFUND PRODUCTS (ADDED) =================
  Future<void> getRefundProducts(int orderId) async {
    refundProductStatus = ProviderStatus.loading;
    notifyListeners();

    try {
      final response = await OrderService.fetchRefundProducts(orderId);

      if (response.success && response.data != null) {
        final model = RefundProductListModel.fromJson(response.data);

        refundProducts = model.data;

        /// map into UI state
        refundSelections = refundProducts.map((item) {
          return RefundSelection(
            product: item,
            quantity: item.returnableQty > 0 ? 1 : 0,
          );
        }).toList();

        refundProductStatus = refundProducts.isEmpty
            ? ProviderStatus.empty
            : ProviderStatus.success;
      } else {
        refundProductError = response.message;
        refundProductStatus = ProviderStatus.error;
      }
    } catch (e) {
      refundProductError = e.toString();
      refundProductStatus = ProviderStatus.error;
    }

    notifyListeners();
  }

  /// ================= SELECTION LOGIC (ADDED) =================
  void toggleRefundProduct(int index) {
    if (!allowMultipleSelection) {
      for (int i = 0; i < refundSelections.length; i++) {
        refundSelections[i].isSelected = i == index;
      }
    } else {
      refundSelections[index].isSelected = !refundSelections[index].isSelected;
    }
    notifyListeners();
  }

  void updateRefundQuantity(int index, int value) {
    final item = refundSelections[index];

    if (value < 1) return;

    item.quantity = value > item.product.returnableQty
        ? item.product.returnableQty
        : value;

    notifyListeners();
  }

  List<RefundSelection> get selectedRefundProducts =>
      refundSelections.where((e) => e.isSelected).toList();

  bool get hasSelectedRefundProducts => selectedRefundProducts.isNotEmpty;

  /// ================= SUBMIT REFUND REQUEST =================
  Future<ApiResponse> submitRefundRequest({
    required int orderId,
    required List<File> images,
  }) async {
    refundSubmitStatus = ProviderStatus.loading;
    refundSubmitError = '';
    notifyListeners();

    try {
      final items = selectedRefundProducts.map((selection) {
        return RefundItem(
          productId: selection.product.productId,
          quantity: selection.quantity,
          reasonId: selectedRefundReasonId!,
          images: images,
        );
      }).toList();

      final response = await OrderService.submitRefundRequest(
        orderId: orderId,
        items: items,
      );

      if (response.success) {
        refundSubmitStatus = ProviderStatus.success;
      } else {
        refundSubmitStatus = ProviderStatus.error;
        refundSubmitError = response.message;
      }

      notifyListeners();
      return response;
    } catch (e) {
      refundSubmitStatus = ProviderStatus.error;
      refundSubmitError = e.toString();
      notifyListeners();
      return ApiResponse(success: false, message: refundSubmitError);
    }
  }

  /// ================= HELPERS =================
  bool get isRefundReasonLoading =>
      refundReasonStatus == ProviderStatus.loading;

  bool get isRefundProductLoading =>
      refundProductStatus == ProviderStatus.loading;

  /// ================= HELPER GETTERS =================
  bool get isNewOrderLoading => newOrderStatus == ProviderStatus.loading;
  bool get isNewOrderEmpty => newOrderStatus == ProviderStatus.empty;
  bool get isNewOrderError => newOrderStatus == ProviderStatus.error;

  bool get isPastOrderLoading => pastOrderStatus == ProviderStatus.loading;
  bool get isPastOrderEmpty => pastOrderStatus == ProviderStatus.empty;
  bool get isPastOrderError => pastOrderStatus == ProviderStatus.error;

  /// ================= RESET REFUND STATE =================
  void resetRefundState() {
    refundSelections.clear();
    refundProducts.clear();

    selectedRefundReason = null;
    refundReasons.clear();

    refundSubmitStatus = ProviderStatus.success;
    refundSubmitError = '';

    notifyListeners();
  }
}
