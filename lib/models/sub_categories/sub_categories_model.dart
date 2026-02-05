import 'dart:convert';

/// Decode JSON string to model
SubCategorieModel subCategorieModelFromJson(String str) =>
    SubCategorieModel.fromJson(json.decode(str));

/// Encode model to JSON string
String subCategorieModelToJson(SubCategorieModel data) =>
    json.encode(data.toJson());

class SubCategorieModel {
  final bool status;
  final String message;
  final int categoryId;
  final List<SubCategories> data;

  const SubCategorieModel({
    required this.status,
    required this.message,
    required this.categoryId,
    required this.data,
  });

  factory SubCategorieModel.fromJson(Map<String, dynamic> json) {
    return SubCategorieModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      categoryId: json['category_id'] ?? 0,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => SubCategories.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'category_id': categoryId,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class SubCategories {
  final int id;
  final String name;
  final int productsCount;

  const SubCategories({
    required this.id,
    required this.name,
    required this.productsCount,
  });

  factory SubCategories.fromJson(Map<String, dynamic> json) {
    return SubCategories(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      productsCount: json['products_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    "products_count": productsCount,
  };
}
