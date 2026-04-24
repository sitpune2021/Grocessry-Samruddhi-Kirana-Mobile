class PaymentVerifyModel {
  final bool success;
  final String message;

  PaymentVerifyModel({
    required this.success,
    required this.message,
  });

  factory PaymentVerifyModel.fromJson(Map<String, dynamic> json) {
    return PaymentVerifyModel(
      success: json['status'] ?? false,
      message: json['message'] ?? '',
    );
  }
}