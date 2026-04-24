import 'dart:convert';

PaymentOptionModel paymentOptionModelFromJson(String str) =>
    PaymentOptionModel.fromJson(json.decode(str));

String paymentOptionModelToJson(PaymentOptionModel data) =>
    json.encode(data.toJson());

class PaymentOptionModel {
  final bool success;
  final List<PaymentOption> data;

  PaymentOptionModel({required this.success, required this.data});

  factory PaymentOptionModel.fromJson(Map<String, dynamic> json) =>
      PaymentOptionModel(
        success: json["success"] ?? false,
        data: json["data"] == null
            ? []
            : List<PaymentOption>.from(
                (json["data"] as List).map((x) => PaymentOption.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };

  @override
  String toString() => 'PaymentOptionModel(success: $success, data: $data)';
}

class PaymentOption {
  final int id;
  final String name;
  final String code;
  final bool isEnabled;

  PaymentOption({
    required this.id,
    required this.name,
    required this.code,
    required this.isEnabled,
  });

  factory PaymentOption.fromJson(Map<String, dynamic> json) => PaymentOption(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    code: json["code"] ?? "",
    isEnabled: json["is_enabled"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "is_enabled": isEnabled,
  };

  @override
  String toString() =>
      'PaymentOption(id: $id, name: $name, code: $code, isEnabled: $isEnabled)';
}
