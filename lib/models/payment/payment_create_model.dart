class PaymentCreateModel {
  final bool success;
  final String message;
  final String razorpayOrderId;
  final int amount;
  final String key;

  PaymentCreateModel({
    required this.success,
    required this.message,
    required this.razorpayOrderId,
    required this.amount,
    required this.key,
  });

  factory PaymentCreateModel.fromJson(Map<String, dynamic> json) {
    return PaymentCreateModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      razorpayOrderId: json['razorpay_order_id'] ?? '',
      amount: json['amount'] ?? 0,
      key: json['key'] ?? '',
    );
  }
}
