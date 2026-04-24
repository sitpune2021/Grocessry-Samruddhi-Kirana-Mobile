import 'dart:convert';

CheckPincodeModel checkPincodeModelFromJson(String str) =>
    CheckPincodeModel.fromJson(json.decode(str));

String checkPincodeModelToJson(CheckPincodeModel data) =>
    json.encode(data.toJson());

class CheckPincodeModel {
  bool? status;
  String? message;
  Data? data;

  CheckPincodeModel({this.status, this.message, this.data});

  factory CheckPincodeModel.fromJson(Map<String, dynamic> json) =>
      CheckPincodeModel(
        status: json["status"] as bool?,
        message: json["message"] as String?,
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  String? pincode;
  int? warehouseId;

  Data({this.pincode, this.warehouseId});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    pincode: json["pincode"]?.toString(),
    warehouseId: json["warehouse_id"] is int
        ? json["warehouse_id"]
        : int.tryParse(json["warehouse_id"]?.toString() ?? ""),
  );

  Map<String, dynamic> toJson() => {
    "pincode": pincode,
    "warehouse_id": warehouseId,
  };
}
