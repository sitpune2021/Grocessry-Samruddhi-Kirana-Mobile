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
      count: json["count"] ?? 0,
      data: json["data"] == null
          ? PaginationData.empty()
          : PaginationData.fromJson(json["data"]),
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
  final List<Products> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<PageLink> links;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final String path;
  final int perPage;
  final int to;
  final int total;

  PaginationData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.prevPageUrl,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
      currentPage: json["current_page"] ?? 0,
      data: json["data"] == null
          ? []
          : List<Products>.from(json["data"].map((x) => Products.fromJson(x))),
      firstPageUrl: json["first_page_url"] ?? "",
      from: json["from"] ?? 0,
      lastPage: json["last_page"] ?? 0,
      lastPageUrl: json["last_page_url"] ?? "",
      links: json["links"] == null
          ? []
          : List<PageLink>.from(json["links"].map((x) => PageLink.fromJson(x))),
      nextPageUrl: json["next_page_url"] as String?,
      prevPageUrl: json["prev_page_url"] as String?,
      path: json["path"] ?? "",
      perPage: json["per_page"] ?? 0,
      to: json["to"] ?? 0,
      total: json["total"] ?? 0,
    );
  }

  factory PaginationData.empty() => PaginationData(
    currentPage: 0,
    data: [],
    firstPageUrl: "",
    from: 0,
    lastPage: 0,
    lastPageUrl: "",
    links: [],
    nextPageUrl: null,
    prevPageUrl: null,
    path: "",
    perPage: 0,
    to: 0,
    total: 0,
  );

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    'first_page_url': firstPageUrl,
    'from': from,
    'last_page': lastPage,
    'last_page_url': lastPageUrl,
    "links": List<dynamic>.from(links.map((x) => x.toJson())),
    'next_page_url': nextPageUrl,
    'prev_page_url': prevPageUrl,
    'path': path,
    'per_page': perPage,
    'to': to,
    'total': total,
  };
}

class Products {
  final int id;
  final String name;

  final String description;
  final String basePrice;
  final String retailerPrice;

  final int mrp;
  final double finalPrice;
  final int discountPercentage;
  final String? discountLabel;
  final int stock;
  final bool inStock;
  final List<String> imageUrls;

  Products({
    required this.id,
    required this.name,

    required this.description,
    required this.basePrice,
    required this.retailerPrice,

    required this.mrp,
    required this.finalPrice,
    required this.discountPercentage,
    required this.discountLabel,
    required this.stock,
    required this.inStock,
    required this.imageUrls,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",

      description: json['description']?.toString() ?? '',
      basePrice: json['base_price']?.toString() ?? '0',
      retailerPrice: json['retailer_price']?.toString() ?? '0',

      mrp: json["mrp"] ?? 0,
      finalPrice: (json["final_price"] ?? 0).toDouble(),
      discountPercentage: json["discount_percentage"] ?? 0,
      discountLabel: json["discount_label"] as String?,
      stock: json["stock"] ?? 0,
      inStock: json["in_stock"] ?? false,
      imageUrls: json["image_urls"] == null
          ? []
          : List<String>.from(json["image_urls"].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,

    'description': description,
    'base_price': basePrice,
    'retailer_price': retailerPrice,

    'mrp': mrp,
    'final_price': finalPrice,
    "discount_percentage": discountPercentage,
    "discount_label": discountLabel,
    'stock': stock,
    "in_stock": inStock,
    "image_urls": List<dynamic>.from(imageUrls.map((x) => x)),
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
      label: json["label"] ?? "",
      page: json["page"],
      active: json["active"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'label': label,
    'page': page,
    'active': active,
  };
}
