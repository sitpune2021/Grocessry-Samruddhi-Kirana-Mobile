import 'dart:convert';

CheckoutOrderModel checkoutOrderModelFromJson(String str) =>
    CheckoutOrderModel.fromJson(json.decode(str));

String checkoutOrderModelToJson(CheckoutOrderModel data) =>
    json.encode(data.toJson());

class CheckoutOrderModel {
  final bool status;
  final String message;
  final Data data;

  CheckoutOrderModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CheckoutOrderModel.fromJson(Map<String, dynamic> json) =>
      CheckoutOrderModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: Data.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  final int orderId;
  final String orderNumber;
  final double subtotal;
  final double deliveryCharge;
  final double couponDiscount;
  final double totalAmount;
  final int addressType;

  Data({
    required this.orderId,
    required this.orderNumber,
    required this.subtotal,
    required this.deliveryCharge,
    required this.couponDiscount,
    required this.totalAmount,
    required this.addressType,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    orderId: json["order_id"] ?? 0,
    orderNumber: json["order_number"] ?? "",
    subtotal: (json["subtotal"] ?? 0).toDouble(),
    deliveryCharge: (json["delivery_charge"] ?? 0).toDouble(),
    couponDiscount: (json["coupon_discount"] ?? 0).toDouble(),
    totalAmount: (json["total_amount"] ?? 0).toDouble(),
    addressType: json["address_type"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "order_number": orderNumber,
    "subtotal": subtotal,
    "delivery_charge": deliveryCharge,
    "coupon_discount": couponDiscount,
    "total_amount": totalAmount,
    "address_type": addressType,
  };
}
