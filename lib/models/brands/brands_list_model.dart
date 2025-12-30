import 'dart:convert';

/// Decode JSON string to model
BrandListModel brandListModelFromJson(String str) =>
    BrandListModel.fromJson(json.decode(str));

/// Encode model to JSON string
String brandListModelToJson(BrandListModel data) => json.encode(data.toJson());

class BrandListModel {
  final bool status;
  final String message;
  final List<Brand> data;

  const BrandListModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BrandListModel.fromJson(Map<String, dynamic> json) {
    return BrandListModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => Brand.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class Brand {
  final int id;
  final String name;

  const Brand({required this.id, required this.name});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
