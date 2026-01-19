import 'dart:convert';

ViewCartModel viewCartModelFromJson(String str) =>
    ViewCartModel.fromJson(json.decode(str));

String viewCartModelToJson(ViewCartModel data) => json.encode(data.toJson());

class ViewCartModel {
  final bool status;
  final Data? data;

  ViewCartModel({required this.status, required this.data});

  factory ViewCartModel.fromJson(Map<String, dynamic> json) {
    return ViewCartModel(
      status: json["status"] ?? false,
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  final int id;
  final int userId;
  final int? productId;
  final int quantity;
  final String? price;
  final String subtotal;
  final String taxTotal;
  final String discount;
  final String total;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Item> items;

  Data({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.taxTotal,
    required this.discount,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["id"],
      userId: json["user_id"],
      productId: json["product_id"],
      quantity: json["quantity"],
      price: json["price"],
      subtotal: json["subtotal"],
      taxTotal: json["tax_total"],
      discount: json["discount"],
      total: json["total"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      items: json["items"] == null
          ? []
          : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "product_id": productId,
    "quantity": quantity,
    "price": price,
    "subtotal": subtotal,
    "tax_total": taxTotal,
    "discount": discount,
    "total": total,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "items": items.map((x) => x.toJson()).toList(),
  };
}

class Item {
  final int id;
  final int cartId;
  final int productId;
  final int? batchId;
  final int qty;
  final String price;
  final String cgstAmount;
  final String sgstAmount;
  final String taxTotal;
  final String itemTotal;
  final String? lineTotal;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Product product;

  Item({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.batchId,
    required this.qty,
    required this.price,
    required this.cgstAmount,
    required this.sgstAmount,
    required this.taxTotal,
    required this.itemTotal,
    required this.lineTotal,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json["id"],
      cartId: json["cart_id"],
      productId: json["product_id"],
      batchId: json["batch_id"],
      qty: json["qty"],
      price: json["price"],
      cgstAmount: json["cgst_amount"],
      sgstAmount: json["sgst_amount"],
      taxTotal: json["tax_total"],
      itemTotal: json["item_total"],
      lineTotal: json["line_total"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      product: Product.fromJson(json["product"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "cart_id": cartId,
    "product_id": productId,
    "batch_id": batchId,
    "qty": qty,
    "price": price,
    "cgst_amount": cgstAmount,
    "sgst_amount": sgstAmount,
    "tax_total": taxTotal,
    "item_total": itemTotal,
    "line_total": lineTotal,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "product": product.toJson(),
  };
}

class Product {
  final int id;
  final int categoryId;
  final int subCategoryId;
  final int brandId;
  final String name;
  final String sku;
  final String description;
  final String basePrice;
  final String retailerPrice;
  final String mrp;
  final String discountType;
  final String? discountValue;
  final int taxId;
  final String gstPercentage;
  final int stock;
  final List<String> productImages;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final List<String> productImageUrls;
  final Tax tax;

  Product({
    required this.id,
    required this.categoryId,
    required this.subCategoryId,
    required this.brandId,
    required this.name,
    required this.sku,
    required this.description,
    required this.basePrice,
    required this.retailerPrice,
    required this.mrp,
    required this.discountType,
    required this.discountValue,
    required this.taxId,
    required this.gstPercentage,
    required this.stock,
    required this.productImages,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.productImageUrls,
    required this.tax,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      categoryId: json["category_id"],
      subCategoryId: json["sub_category_id"],
      brandId: json["brand_id"],
      name: json["name"],
      sku: json["sku"],
      description: json["description"],
      basePrice: json["base_price"],
      retailerPrice: json["retailer_price"],
      mrp: json["mrp"],
      discountType: json["discount_type"],
      discountValue: json["discount_value"],
      taxId: json["tax_id"],
      gstPercentage: json["gst_percentage"],
      stock: json["stock"],
      productImages: json["product_images"] == null
          ? []
          : List<String>.from(json["product_images"]),
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      deletedAt: json["deleted_at"],
      productImageUrls: json["product_image_urls"] == null
          ? []
          : List<String>.from(json["product_image_urls"]),
      tax: Tax.fromJson(json["tax"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "sub_category_id": subCategoryId,
    "brand_id": brandId,
    "name": name,
    "sku": sku,
    "description": description,
    "base_price": basePrice,
    "retailer_price": retailerPrice,
    "mrp": mrp,
    "discount_type": discountType,
    "discount_value": discountValue,
    "tax_id": taxId,
    "gst_percentage": gstPercentage,
    "stock": stock,
    "product_images": productImages,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    "product_image_urls": productImageUrls,
    "tax": tax.toJson(),
  };
}

class Tax {
  final int id;
  final String name;
  final int cgst;
  final int sgst;
  final int igst;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Tax({
    required this.id,
    required this.name,
    required this.cgst,
    required this.sgst,
    required this.igst,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tax.fromJson(Map<String, dynamic> json) {
    return Tax(
      id: json["id"],
      name: json["name"],
      cgst: json["cgst"],
      sgst: json["sgst"],
      igst: json["igst"],
      isActive: json["is_active"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "cgst": cgst,
    "sgst": sgst,
    "igst": igst,
    "is_active": isActive,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
