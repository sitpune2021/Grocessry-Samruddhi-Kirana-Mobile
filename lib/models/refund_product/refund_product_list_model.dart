import 'dart:convert';

RefundProductListModel refundProductListModelFromJson(String str) =>
    RefundProductListModel.fromJson(json.decode(str));

String refundProductListModelToJson(RefundProductListModel data) =>
    json.encode(data.toJson());

class RefundProductListModel {
  final bool status;
  final String message;
  final List<RefundProductItem> data;

  RefundProductListModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RefundProductListModel.fromJson(Map<String, dynamic> json) {
    return RefundProductListModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null
          ? []
          : List<RefundProductItem>.from(
              json["data"].map((x) => RefundProductItem.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.map((x) => x.toJson()).toList(),
  };
}

class RefundProductItem {
  final int orderItemId;
  final int productId;
  final String productName;
  final int orderedQty;
  final int returnableQty;
  final double price;
  final List<String> returnImageUrls;

  RefundProductItem({
    required this.orderItemId,
    required this.productId,
    required this.productName,
    required this.orderedQty,
    required this.returnableQty,
    required this.price,
    required this.returnImageUrls,
  });

  factory RefundProductItem.fromJson(Map<String, dynamic> json) {
    return RefundProductItem(
      orderItemId: json["order_item_id"] ?? 0,
      productId: json["product_id"] ?? 0,
      productName: json["product_name"] ?? "",
      orderedQty: json["ordered_qty"] ?? 0,
      returnableQty: json["returnable_qty"] ?? 0,
      price: double.tryParse(json["price"]?.toString() ?? "0") ?? 0.0,
      returnImageUrls: json["return_image_urls"] == null
          ? []
          : List<String>.from(json["return_image_urls"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "order_item_id": orderItemId,
    "product_id": productId,
    "product_name": productName,
    "ordered_qty": orderedQty,
    "returnable_qty": returnableQty,
    "price": price,
    "return_image_urls": returnImageUrls,
  };

  RefundProductItem copyWith({
    int? orderItemId,
    int? productId,
    String? productName,
    int? orderedQty,
    int? returnableQty,
    double? price,
    List<String>? returnImageUrls,
  }) {
    return RefundProductItem(
      orderItemId: orderItemId ?? this.orderItemId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      orderedQty: orderedQty ?? this.orderedQty,
      returnableQty: returnableQty ?? this.returnableQty,
      price: price ?? this.price,
      returnImageUrls: returnImageUrls ?? this.returnImageUrls,
    );
  }
}
