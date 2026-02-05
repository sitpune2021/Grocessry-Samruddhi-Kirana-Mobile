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
      status: json['status'],
      count: json['count'],
      data: PaginationData.fromJson(json['data']),
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
  final List<Product> products;
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
      currentPage: json['current_page'],
      products: (json['data'] as List).map((e) => Product.fromJson(e)).toList(),
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links: (json['links'] as List).map((e) => PageLink.fromJson(e)).toList(),
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
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

class Product {
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
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final List<String> productImageUrls;

  Product({
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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      categoryId: json['category_id'],
      subCategoryId: json['sub_category_id'],
      brandId: json['brand_id'],
      name: json['name'],
      unitId: json['unit_id'],
      unitValue: json['unit_value'],
      sku: json['sku'],
      barcode: json['barcode'],
      description: json['description'],
      basePrice: json['base_price'],
      retailerPrice: json['retailer_price'],
      mrp: json['mrp'],
      taxId: json['tax_id'],
      gstPercentage: json['gst_percentage'],
      gstAmount: json['gst_amount'],
      finalPrice: json['final_price'],
      stock: json['stock'],
      productImages: json['product_images'] == null
          ? []
          : List<String>.from(json['product_images']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'],
      productImageUrls: json['product_image_urls'] == null
          ? []
          : List<String>.from(json['product_image_urls']),
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
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
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
      url: json['url'],
      label: json['label'],
      page: json['page'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'label': label,
    'page': page,
    'active': active,
  };
}
