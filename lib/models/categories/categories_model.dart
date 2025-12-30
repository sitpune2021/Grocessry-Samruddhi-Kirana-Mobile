import 'dart:convert';

/// Decode JSON string to model
CategorieModel categorieModelFromJson(String str) =>
    CategorieModel.fromJson(json.decode(str));

/// Encode model to JSON string
String categorieModelToJson(CategorieModel data) => json.encode(data.toJson());

class CategorieModel {
  final bool status;
  final String message;
  final List<Category> data;

  const CategorieModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CategorieModel.fromJson(Map<String, dynamic> json) {
    return CategorieModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e))
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

class Category {
  final int id;
  final String name;
  final String slug;

  const Category({required this.id, required this.name, required this.slug});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'slug': slug};
}
