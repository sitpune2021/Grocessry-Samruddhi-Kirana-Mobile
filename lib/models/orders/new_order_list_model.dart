import 'dart:convert';

/// PARSE METHODS
NewOrderListModel newOrderListModelFromJson(String str) =>
    NewOrderListModel.fromJson(json.decode(str));

String newOrderListModelToJson(NewOrderListModel data) =>
    json.encode(data.toJson());

/// ROOT RESPONSE MODEL
class NewOrderListModel {
  final bool status;
  final List<OrdersData> data;

  NewOrderListModel({required this.status, required this.data});

  factory NewOrderListModel.fromJson(Map<String, dynamic> json) {
    return NewOrderListModel(
      status: json["status"] ?? false,
      data: json["data"] == null
          ? []
          : List<OrdersData>.from(
              json["data"].map((x) => OrdersData.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.map((x) => x.toJson()).toList(),
  };
}

/// ORDER DATA
class OrdersData {
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
  final DeliveryAddress? deliveryAddress;

  OrdersData({
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
    required this.deliveryAddress,
  });

  factory OrdersData.fromJson(Map<String, dynamic> json) {
    return OrdersData(
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

      deliveryAddress: json["delivery_address"] == null
          ? null
          : DeliveryAddress.fromJson(json["delivery_address"]),
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
    "delivery_address": deliveryAddress?.toJson(),
  };
}

/// ORDER ITEM
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
      isPicked: json["is_picked"] == 1 || json["is_picked"] == true,
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

/// PRODUCT
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

/// DELIVERY ADDRESS
class DeliveryAddress {
  final int id;
  final int userId;
  final String firstName;
  final String? lastName;

  final String flatHouse;
  final String? floor;
  final String area;
  final String landmark;
  final String address;
  final String city;
  final String country;

  final String postcode;
  final String phone;

  final String latitude;
  final String longitude;

  DeliveryAddress({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.flatHouse,
    required this.floor,
    required this.area,
    required this.landmark,
    required this.address,
    required this.city,
    required this.country,
    required this.postcode,
    required this.phone,
    required this.latitude,
    required this.longitude,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      id: json["id"],
      userId: json["user_id"],
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"],
      flatHouse: json["flat_house"] ?? "",
      floor: json["floor"],
      area: json["area"] ?? "",
      landmark: json["landmark"] ?? "",
      address: json["address"],
      city: json["city"] ?? "",
      country: json["country"],
      postcode: json["postcode"] ?? "",
      phone: json["phone"] ?? "",
      latitude: json["latitude"] ?? "",
      longitude: json["longitude"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "first_name": firstName,
    "last_name": lastName,
    "address": address,
    "flat_house": flatHouse,
    "floor": floor,
    "area": area,
    "landmark": landmark,
    "city": city,
    "country": country,
    "postcode": postcode,
    "phone": phone,
    "latitude": latitude,
    "longitude": longitude,
  };
}

/// HELPER
double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}
