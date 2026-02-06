import 'dart:convert';

SearchProductModel searchProductModelFromJson(String str) =>
    SearchProductModel.fromJson(json.decode(str));

String searchProductModelToJson(SearchProductModel data) =>
    json.encode(data.toJson());

class SearchProductModel {
  final bool status;
  final int count;
  final PaginationData data;

  SearchProductModel({
    required this.status,
    required this.count,
    required this.data,
  });

  factory SearchProductModel.fromJson(Map<String, dynamic> json) {
    return SearchProductModel(
      status: json['status'] ?? false,
      count: _toInt(json['count']),
      data: PaginationData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'count': count,
    'data': data.toJson(),
  };
}

class PaginationData {
  final int currentPage;
  final List<Products> products;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<PageLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  PaginationData({
    required this.currentPage,
    required this.products,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
      currentPage: _toInt(json['current_page']),
      products: (json['data'] as List<dynamic>? ?? [])
          .map((e) => Products.fromJson(e))
          .toList(),
      firstPageUrl: json['first_page_url']?.toString() ?? '',
      from: _toInt(json['from']),
      lastPage: _toInt(json['last_page']),
      lastPageUrl: json['last_page_url']?.toString() ?? '',
      links: (json['links'] as List<dynamic>? ?? [])
          .map((e) => PageLink.fromJson(e))
          .toList(),
      nextPageUrl: json['next_page_url']?.toString(),
      path: json['path']?.toString() ?? '',
      perPage: _toInt(json['per_page']),
      prevPageUrl: json['prev_page_url']?.toString(),
      to: _toInt(json['to']),
      total: _toInt(json['total']),
    );
  }

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'data': products.map((e) => e.toJson()).toList(),
    'first_page_url': firstPageUrl,
    'from': from,
    'last_page': lastPage,
    'last_page_url': lastPageUrl,
    'links': links.map((e) => e.toJson()).toList(),
    'next_page_url': nextPageUrl,
    'path': path,
    'per_page': perPage,
    'prev_page_url': prevPageUrl,
    'to': to,
    'total': total,
  };
}

class Products {
  final int id;
  final int categoryId;
  final int subCategoryId;
  final int brandId;
  final String name;
  final int unitId;
  final String unitValue;
  final String sku;
  final dynamic barcode;
  final String description;
  final String basePrice;
  final String retailerPrice;
  final String mrp;
  final int taxId;
  final String gstPercentage;
  final String gstAmount;
  final String finalPrice;
  final int stock;
  final List<String> productImages;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final List<String> productImageUrls;

  Products({
    required this.id,
    required this.categoryId,
    required this.subCategoryId,
    required this.brandId,
    required this.name,
    required this.unitId,
    required this.unitValue,
    required this.sku,
    required this.barcode,
    required this.description,
    required this.basePrice,
    required this.retailerPrice,
    required this.mrp,
    required this.taxId,
    required this.gstPercentage,
    required this.gstAmount,
    required this.finalPrice,
    required this.stock,
    required this.productImages,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.productImageUrls,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: _toInt(json['id']),
      categoryId: _toInt(json['category_id']),
      subCategoryId: _toInt(json['sub_category_id']),
      brandId: _toInt(json['brand_id']),
      name: json['name']?.toString() ?? '',
      unitId: _toInt(json['unit_id']),
      unitValue: json['unit_value']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      barcode: json['barcode'],
      description: json['description']?.toString() ?? '',
      basePrice: json['base_price']?.toString() ?? '0',
      retailerPrice: json['retailer_price']?.toString() ?? '0',
      mrp: json['mrp']?.toString() ?? '0',
      taxId: _toInt(json['tax_id']),
      gstPercentage: json['gst_percentage']?.toString() ?? '0',
      gstAmount: json['gst_amount']?.toString() ?? '0',
      finalPrice: json['final_price']?.toString() ?? '0',
      stock: _toInt(json['stock']),
      productImages: (json['product_images'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
      deletedAt: json['deleted_at'],
      productImageUrls: (json['product_image_urls'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'category_id': categoryId,
    'sub_category_id': subCategoryId,
    'brand_id': brandId,
    'name': name,
    'unit_id': unitId,
    'unit_value': unitValue,
    'sku': sku,
    'barcode': barcode,
    'description': description,
    'base_price': basePrice,
    'retailer_price': retailerPrice,
    'mrp': mrp,
    'tax_id': taxId,
    'gst_percentage': gstPercentage,
    'gst_amount': gstAmount,
    'final_price': finalPrice,
    'stock': stock,
    'product_images': productImages,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'deleted_at': deletedAt,
    'product_image_urls': productImageUrls,
  };
}

class PageLink {
  final String? url;
  final String label;
  final int? page;
  final bool active;

  PageLink({
    required this.url,
    required this.label,
    required this.page,
    required this.active,
  });

  factory PageLink.fromJson(Map<String, dynamic> json) {
    return PageLink(
      url: json['url']?.toString(),
      label: json['label']?.toString() ?? '',
      page: json['page'] != null ? _toInt(json['page']) : null,
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'label': label,
    'page': page,
    'active': active,
  };
}

/// 🔐 SAFE HELPERS
int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is double) return value.toInt();
  return 0;
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  try {
    return DateTime.parse(value.toString());
  } catch (_) {
    return null;
  }
}
