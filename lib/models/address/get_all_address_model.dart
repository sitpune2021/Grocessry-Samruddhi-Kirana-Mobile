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
  final String landmark;
  final String city;
  final String pincode;
  final String mobile;
  final double latitude;
  final double longitude;
  final int type;

  final bool isDefault;
  final String flatNo;
  final String floor;
  final String buildingArea;

  GetAddress({
    required this.id,
    required this.name,
    required this.landmark,
    required this.city,
    required this.pincode,
    required this.mobile,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.isDefault,
    required this.flatNo,
    required this.floor,
    required this.buildingArea,
  });

  /// SAFE JSON PARSER
  factory GetAddress.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      return double.tryParse(value?.toString() ?? '') ?? 0.0;
    }

    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) {
        return value == "1" || value.toLowerCase() == "true";
      }
      return false;
    }

    String parseString(dynamic value) {
      return value?.toString() ?? '';
    }

    // return GetAddress(
    //   id: json['id'] ?? 0,
    //   name: json['name'] ?? '',
    //   landmark: json['landmark'] ?? '',
    //   city: json['city'] ?? '',
    //   pincode: json['pincode'] ?? '',
    //   mobile: json['mobile'] ?? '',
    //   latitude: parseDouble(json['latitude']),
    //   longitude: parseDouble(json['longitude']),
    //   type: json["type"],
    //   isDefault: json['is_default'],

    //   flatNo: json['flat_no'],
    //   floor: json['floor'],
    //   buildingArea: json['building_area'],
    // );
    return GetAddress(
      id: json['id'] ?? 0,
      name: parseString(json['name']),
      landmark: parseString(json['landmark']),
      city: parseString(json['city']),
      pincode: parseString(json['pincode']),
      mobile: parseString(json['mobile']),
      latitude: parseDouble(json['latitude']),
      longitude: parseDouble(json['longitude']),
      type: json['type'] ?? 0,
      isDefault: parseBool(json['is_default']),

      flatNo: parseString(json['flat_no']),
      floor: parseString(json['floor']),
      buildingArea: parseString(json['building_area']),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "landmark": landmark,
    "city": city,
    "pincode": pincode,
    "mobile": mobile,
    "latitude": latitude,
    "longitude": longitude,
    "type": type,
    "is_default": isDefault,

    "flat_no": flatNo,
    "floor": floor,
    "building_area": buildingArea,
  };
}
