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

  // edit / update address
  // static Future<ApiResponse> updateAddress(int id) async {
  //   return await ApiClient.put(
  //     ApiConstants.deleteAddress(id),
  //     authRequired: true, // 🔐 token based
  //   );
  // }
}
