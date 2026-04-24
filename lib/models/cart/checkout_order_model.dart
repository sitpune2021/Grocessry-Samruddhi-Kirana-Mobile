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
  final double amount; // ✅ NEW (replace all old fields)

  Data({
    required this.orderId,
    required this.orderNumber,
    required this.amount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    orderId: json["order_id"] ?? 0,
    orderNumber: json["order_number"] ?? "",
    amount: (json["amount"] ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "order_number": orderNumber,
    "amount": amount,
  };
}
