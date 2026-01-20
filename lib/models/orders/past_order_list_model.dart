import 'dart:convert';

PastOrderListModel pastOrderListModelFromJson(String str) =>
    PastOrderListModel.fromJson(json.decode(str));

String pastOrderListModelToJson(PastOrderListModel data) =>
    json.encode(data.toJson());

class PastOrderListModel {
  final bool status;
  final PaginationData data;

  PastOrderListModel({required this.status, required this.data});

  factory PastOrderListModel.fromJson(Map<String, dynamic> json) {
    return PastOrderListModel(
      status: json["status"] ?? false,
      data: PaginationData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {"status": status, "data": data.toJson()};
}

class PaginationData {
  final int currentPage;
  final List<OrderData> data;
  final String firstPageUrl;
  final int? from;
  final int lastPage;
  final String lastPageUrl;
  final List<Link> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;
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
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
      currentPage: json["current_page"],
      data: json["data"] == null
          ? []
          : List<OrderData>.from(
              json["data"].map((x) => OrderData.fromJson(x)),
            ),
      firstPageUrl: json["first_page_url"],
      from: json["from"],
      lastPage: json["last_page"],
      lastPageUrl: json["last_page_url"],
      links: json["links"] == null
          ? []
          : List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
      nextPageUrl: json["next_page_url"],
      path: json["path"],
      perPage: json["per_page"],
      prevPageUrl: json["prev_page_url"],
      to: json["to"],
      total: json["total"],
    );
  }

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data.map((x) => x.toJson()).toList(),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": links.map((x) => x.toJson()).toList(),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class OrderData {
  final int id;
  final int userId;
  final int? deliveryAgentId;
  final int? offerId;
  final String? couponCode;

  final String orderNumber;

  final double subtotal;
  final double deliveryCharge;
  final double discount;
  final double couponDiscount;
  final double totalAmount;

  final String orderStatus;

  final int? customerRating;
  final List<String>? customerRatingTags;

  final String? cancelReason;
  final String? cancelComment;
  final DateTime? cancelledAt;

  final String? pickupProof;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deliveredAt;

  final List<OrderItem> orderItems;

  OrderData({
    required this.id,
    required this.userId,
    required this.deliveryAgentId,
    required this.offerId,
    required this.couponCode,
    required this.orderNumber,
    required this.subtotal,
    required this.deliveryCharge,
    required this.discount,
    required this.couponDiscount,
    required this.totalAmount,
    required this.orderStatus,
    required this.customerRating,
    required this.customerRatingTags,
    required this.cancelReason,
    required this.cancelComment,
    required this.cancelledAt,
    required this.pickupProof,
    required this.createdAt,
    required this.updatedAt,
    required this.deliveredAt,
    required this.orderItems,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json["id"],
      userId: json["user_id"],
      deliveryAgentId: json["delivery_agent_id"],
      offerId: json["offer_id"],
      couponCode: json["coupon_code"],
      orderNumber: json["order_number"],

      subtotal: _toDouble(json["subtotal"]),
      deliveryCharge: _toDouble(json["delivery_charge"]),
      discount: _toDouble(json["discount"]),
      couponDiscount: _toDouble(json["coupon_discount"]),
      totalAmount: _toDouble(json["total_amount"]),

      orderStatus: json["status"],

      customerRating: json["customer_rating"],
      customerRatingTags: json["customer_rating_tags"] == null
          ? null
          : List<String>.from(json["customer_rating_tags"]),

      cancelReason: json["cancel_reason"],
      cancelComment: json["cancel_comment"],
      cancelledAt: json["cancelled_at"] != null
          ? DateTime.parse(json["cancelled_at"])
          : null,

      pickupProof: json["pickup_proof"],

      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      deliveredAt: json["delivered_at"] != null
          ? DateTime.parse(json["delivered_at"])
          : null,

      orderItems: json["order_items"] == null
          ? []
          : List<OrderItem>.from(
              json["order_items"].map((x) => OrderItem.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "delivery_agent_id": deliveryAgentId,
    "offer_id": offerId,
    "coupon_code": couponCode,
    "order_number": orderNumber,
    "subtotal": subtotal,
    "delivery_charge": deliveryCharge,
    "discount": discount,
    "coupon_discount": couponDiscount,
    "total_amount": totalAmount,
    "status": orderStatus,
    "customer_rating": customerRating,
    "customer_rating_tags": customerRatingTags,
    "cancel_reason": cancelReason,
    "cancel_comment": cancelComment,
    "cancelled_at": cancelledAt?.toIso8601String(),
    "pickup_proof": pickupProof,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "delivered_at": deliveredAt?.toIso8601String(),
    "order_items": orderItems.map((x) => x.toJson()).toList(),
  };
}

class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final bool isPicked;

  final double price;
  final double total;

  final DateTime createdAt;
  final DateTime updatedAt;

  final Product product;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.isPicked,
    required this.price,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json["id"],
      orderId: json["order_id"],
      productId: json["product_id"],
      quantity: json["quantity"],
      isPicked: json["is_picked"] == true || json["is_picked"] == 1,
      price: _toDouble(json["price"]),
      total: _toDouble(json["total"]),
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      product: Product.fromJson(json["product"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "product_id": productId,
    "quantity": quantity,
    "is_picked": isPicked,
    "price": price,
    "total": total,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "product": product.toJson(),
  };
}

class Product {
  final int id;
  final String name;
  final List<String> productImages;
  final List<String> productImageUrls;

  Product({
    required this.id,
    required this.name,
    required this.productImages,
    required this.productImageUrls,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["name"],
      productImages: json["product_images"] == null
          ? []
          : List<String>.from(json["product_images"]),
      productImageUrls: json["product_image_urls"] == null
          ? []
          : List<String>.from(json["product_image_urls"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "product_images": productImages,
    "product_image_urls": productImageUrls,
  };
}

class Link {
  final String? url;
  final String label;
  final int? page;
  final bool active;

  Link({
    required this.url,
    required this.label,
    required this.page,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json["url"],
      label: json["label"],
      page: json["page"],
      active: json["active"],
    );
  }

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "page": page,
    "active": active,
  };
}

/// 🔧 Helper
double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}
