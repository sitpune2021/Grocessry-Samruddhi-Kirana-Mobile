import 'dart:convert';

CouponModel couponModelFromJson(String str) =>
    CouponModel.fromJson(json.decode(str));

String couponModelToJson(CouponModel data) => json.encode(data.toJson());

class CouponModel {
  final bool status;
  final List<Coupon> coupons;

  CouponModel({required this.status, required this.coupons});

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
    status: json["status"] ?? false,
    coupons: json["data"] == null
        ? []
        : List<Coupon>.from(json["data"].map((x) => Coupon.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(coupons.map((x) => x.toJson())),
  };
}

class Coupon {
  final int id;
  final String title;
  final String description;
  final String offerType;
  final double discountValue;
  final double maxDiscount;
  final double minOrderAmount;
  final DateTime? startDate;
  final DateTime? endDate;

  Coupon({
    required this.id,
    required this.title,
    required this.description,
    required this.offerType,
    required this.discountValue,
    required this.maxDiscount,
    required this.minOrderAmount,
    this.startDate,
    this.endDate,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
    id: json["id"] ?? 0,
    title: json["title"] ?? "",
    description: json["description"] ?? "",
    offerType: json["offer_type"] ?? "",
    discountValue: _toDouble(json["discount_value"]),
    maxDiscount: _toDouble(json["max_discount"]),
    minOrderAmount: _toDouble(json["min_order_amount"]),
    startDate: _toDate(json["start_date"]),
    endDate: _toDate(json["end_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "offer_type": offerType,
    "discount_value": discountValue,
    "max_discount": maxDiscount,
    "min_order_amount": minOrderAmount,
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
  };
}

/// ---------- Helper Functions (Bulletproof) ----------

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}

DateTime? _toDate(dynamic value) {
  if (value == null || value.toString().isEmpty) return null;
  return DateTime.tryParse(value.toString());
}
