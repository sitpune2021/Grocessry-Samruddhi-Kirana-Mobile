import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/constants/api_constants.dart';
import 'package:samruddha_kirana/api/api_client.dart';

class AddressService {
  // get all  Address
  static Future<ApiResponse> fetchAllAddresses() async {
    return await ApiClient.get(
      ApiConstants.getAllAddress,
      authRequired: true, // 🔐 token based
    );
  }

  // delete address
  static Future<ApiResponse> deleteAddress(int id) async {
    return await ApiClient.delete(
      ApiConstants.deleteAddress(id),
      authRequired: true, // 🔐 token based
    );
  }

  // ================= UPDATE / EDIT ADDRESS =================
  static Future<ApiResponse> updateAddress({
    required int id,
    required String name,
    required String mobile,
    required String addressLine,
    required String landmark,
    required String city,
    required String state,
    required String pincode,
    required double latitude,
    required double longitude,
    required int type,
    required bool isDefault,
  }) async {
    return await ApiClient.put(
      ApiConstants.updateAddress(id),
      {
        "name": name,
        "mobile": mobile,
        "address_line": addressLine,
        "landmark": landmark,
        "city": city,
        "state": state,
        "pincode": pincode,
        "latitude": latitude,
        "longitude": longitude,
        "type": type,
        "is_default": isDefault,
      },
      authRequired: true, // 🔐 token based
    );
  }

  // ================= ADD ADDRESS =================
  static Future<ApiResponse> addAddress({
    required String name,
    required String mobile,
    required String addressLine,
    required String landmark,
    required String city,
    required String state,
    required String pincode,
    required String latitude,
    required String longitude,
    required int type,
    required bool isDefault,
  }) async {
    return await ApiClient.post(
      ApiConstants.addAddress,
      {
        "name": name,
        "mobile": mobile,
        "address_line": addressLine,
        "landmark": landmark,
        "city": city,
        "state": state,
        "pincode": pincode,
        "latitude": latitude,
        "longitude": longitude,
        "type": type,
        "is_default": isDefault,
      },
      authRequired: true, // 🔐 token based
    );
  }

  // ================= swich DEFAULT ADDRESS =================
  static Future<ApiResponse> switchDefaultAddress(int id) async {
    return await ApiClient.post(
      ApiConstants.defultAddress,
      {"address_id": id},
      authRequired: true, // 🔐 token based
    );
  }
}
