class CheckoutTimerModel {
  final bool orderAllowed;
  final String message;

  CheckoutTimerModel({required this.orderAllowed, required this.message});

  factory CheckoutTimerModel.fromJson(Map<String, dynamic> json) {
    return CheckoutTimerModel(
      orderAllowed: json['order_allowed'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
