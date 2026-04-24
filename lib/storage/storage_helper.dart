import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const String warehouseKey = "warehouse_id";
  static const String pincodeKey = "pincode";

  // SAVE
  static Future<void> savePincodeData({
    required int warehouseId,
    required String pincode,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    // ✅ CLEAR OLD VALUES FIRST
    await prefs.remove(warehouseKey);
    await prefs.remove(pincodeKey);

    // ✅ SAVE NEW VALUES
    await prefs.setInt(warehouseKey, warehouseId);
    await prefs.setString(pincodeKey, pincode);
  }

  // GET warehouseId
  static Future<int?> getWarehouseId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(warehouseKey);
  }

  // GET pincode
  static Future<String?> getPincode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(pincodeKey);
  }

  // CLEAR (optional)
  static Future<void> clearPincodeData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(warehouseKey);
    await prefs.remove(pincodeKey);
  }
}
