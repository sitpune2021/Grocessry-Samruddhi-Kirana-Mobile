import 'dart:convert';

AllAddressListModel allAddressListModelFromJson(String str) =>
    AllAddressListModel.fromJson(json.decode(str));

String allAddressListModelToJson(AllAddressListModel data) =>
    json.encode(data.toJson());

class AllAddressListModel {
  final bool status;
  final List<GetAddress> data;

  AllAddressListModel({
    required this.status,
    required this.data,
  });

  factory AllAddressListModel.fromJson(Map<String, dynamic> json) {
    return AllAddressListModel(
      status: json["status"] ?? false,
      data: json["data"] == null
          ? <GetAddress>[]
          : List<GetAddress>.from(
              json["data"].map((x) => GetAddress.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class GetAddress {
  final int id;
  final int userId;
  final String firstName;
  final String? lastName;
  final String address;
  final String city;
  final String country;
  final String postcode;
  final String phone;
  final String email;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool? isDefault;

  GetAddress({
    required this.id,
    required this.userId,
    required this.firstName,
    this.lastName,
    required this.address,
    required this.city,
    required this.country,
    required this.postcode,
    required this.phone,
    required this.email,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    this.isDefault,
  });

  factory GetAddress.fromJson(Map<String, dynamic> json) {
    return GetAddress(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? 0,
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"],
      address: json["address"] ?? "",
      city: json["city"] ?? "",
      country: json["country"] ?? "",
      postcode: json["postcode"] ?? "",
      phone: json["phone"] ?? "",
      email: json["email"] ?? "",
      latitude: double.tryParse(json["latitude"].toString()) ?? 0.0,
      longitude: double.tryParse(json["longitude"].toString()) ?? 0.0,
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      isDefault: json["is_default"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "address": address,
        "city": city,
        "country": country,
        "postcode": postcode,
        "phone": phone,
        "email": email,
        "latitude": latitude,
        "longitude": longitude,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "is_default": isDefault,
      };
}
