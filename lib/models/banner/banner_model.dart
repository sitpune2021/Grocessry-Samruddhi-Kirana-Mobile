import 'dart:convert';

BannerModel bannerModelFromJson(String str) =>
    BannerModel.fromJson(json.decode(str));

String bannerModelToJson(BannerModel data) => json.encode(data.toJson());

class BannerModel {
  final bool status;
  final String message;
  final List<AppBanner> data;

  const BannerModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null
          ? []
          : List<AppBanner>.from(
              json["data"].map((x) => AppBanner.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.map((x) => x.toJson()).toList(),
  };

  BannerModel copyWith({bool? status, String? message, List<AppBanner>? data}) {
    return BannerModel(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

class AppBanner {
  final int id;
  final String name;
  final String image;

  const AppBanner({required this.id, required this.name, required this.image});

  factory AppBanner.fromJson(Map<String, dynamic> json) {
    return AppBanner(
      id: int.tryParse(json["id"]?.toString() ?? "0") ?? 0,
      name: json["name"] ?? "",
      image: json["image"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {"id": id, "name": name, "image": image};

  AppBanner copyWith({int? id, String? name, String? image}) {
    return AppBanner(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }
}
