import 'dart:convert';

/// RESPONSE HELPERS

AllAddressListModel allAddressListModelFromJson(String str) =>
    AllAddressListModel.fromJson(json.decode(str));

String allAddressListModelToJson(AllAddressListModel data) =>
    json.encode(data.toJson());

/// ADDRESS LIST MODEL

class AllAddressListModel {
  final bool status;
  final List<GetAddress> data;

  AllAddressListModel({required this.status, required this.data});

  factory AllAddressListModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    return AllAddressListModel(
      status: json['status'] == true,
      data: rawData is List
          ? rawData
                .map<GetAddress>(
                  (e) => GetAddress.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : <GetAddress>[],
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.map((e) => e.toJson()).toList(),
  };
}

/// ADDRESS ITEM MODEL
class GetAddress {
  final int id;
  final String name;
  final String addressLine;
  final String landmark;
  final String city;
  final String state;
  final String pincode;
  final String mobile;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDefault;

  GetAddress({
    required this.id,
    required this.name,
    required this.addressLine,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    required this.mobile,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.isDefault,
  });

  /// SAFE JSON PARSER
  factory GetAddress.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic value) {
      if (value == null || value.toString().isEmpty) {
        return DateTime.now();
      }
      try {
        return DateTime.parse(value.toString());
      } catch (_) {
        return DateTime.now();
      }
    }

    double parseDouble(dynamic value) {
      return double.tryParse(value?.toString() ?? '') ?? 0.0;
    }

    return GetAddress(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      addressLine: json['address_line'] ?? '',
      landmark: json['landmark'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      mobile: json['mobile'] ?? '',
      latitude: parseDouble(json['latitude']),
      longitude: parseDouble(json['longitude']),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
      isDefault: json['is_default'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address_line": addressLine,
    "landmark": landmark,
    "city": city,
    "state": state,
    "pincode": pincode,
    "mobile": mobile,
    "latitude": latitude,
    "longitude": longitude,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "is_default": isDefault,
  };
}
