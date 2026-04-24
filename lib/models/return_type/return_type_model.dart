import 'dart:convert';

ReturnTypeModel returnTypeModelFromJson(String str) =>
    ReturnTypeModel.fromJson(json.decode(str));

String returnTypeModelToJson(ReturnTypeModel data) =>
    json.encode(data.toJson());

class ReturnTypeModel {
  final bool status;
  final List<ReturnTypeItem> data;

  ReturnTypeModel({required this.status, required this.data});

  factory ReturnTypeModel.fromJson(Map<String, dynamic> json) {
    return ReturnTypeModel(
      status: json['status'] ?? false,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ReturnTypeItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class ReturnTypeItem {
  final int id;
  final String key;
  final String label;

  ReturnTypeItem({required this.id, required this.key, required this.label});

  factory ReturnTypeItem.fromJson(Map<String, dynamic> json) {
    return ReturnTypeItem(
      id: json["id"],
      key: json['key'] ?? '',
      label: json['label'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {"id": id, 'key': key, 'label': label};
}
