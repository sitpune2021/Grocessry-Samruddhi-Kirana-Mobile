import 'dart:convert';

OfferModel offerModelFromJson(String str) =>
    OfferModel.fromJson(json.decode(str));

String offerModelToJson(OfferModel data) => json.encode(data.toJson());

class OfferModel {
  final bool status;
  final List<Datum> data;

  OfferModel({required this.status, required this.data});

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      status: json["status"] ?? false,
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

class Datum {
  final int id;
  final String title;
  final String code;
  final String? description;
  final String discountText;
  final int minAmount;
  final String validTill;

  Datum({
    required this.id,
    required this.title,
    required this.code,
    this.description,
    required this.discountText,
    required this.minAmount,
    required this.validTill,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      code: json["code"] ?? "",
      description: json["description"],
      discountText: json["discount_text"] ?? "",
      minAmount: json["min_amount"] ?? 0,
      validTill: json["valid_till"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "code": code,
      "description": description,
      "discount_text": discountText,
      "min_amount": minAmount,
      "valid_till": validTill,
    };
  }
}
