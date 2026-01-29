import 'package:flutter/material.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/models/address/get_all_address_model.dart';
import 'package:samruddha_kirana/screens/address/add_address_screen.dart';
import 'package:samruddha_kirana/services/address/address_service.dart';
import 'package:samruddha_kirana/utils/address_type_mapper.dart';

class AddressProvider extends ChangeNotifier {
  // ================= LOADING =================
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ================= DELETE LOADING =================
  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;

  // ================= FIRST LOAD FLAG =================
  bool _hasLoadedOnce = false;
  bool get hasLoadedOnce => _hasLoadedOnce;

  // ================= DATA =================
  List<GetAddress> _addresses = [];
  List<GetAddress> get addresses => _addresses;

  // ================= ERROR =================
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // ================= ADDRESS TYPE (PROVIDER STATE) =================
  AddressType _selectedType = AddressType.home;
  AddressType get selectedType => _selectedType;

  // 🔥 AUTO LOAD ON PROVIDER INIT
  AddressProvider() {
    fetchAllAddresses();
  }

  void setAddressType(AddressType type) {
    _selectedType = type;
    notifyListeners();
  }

  void setTypeFromBackend(int type) {
    _selectedType = intToAddressType(type);
    notifyListeners();
  }

  void resetType() {
    _selectedType = AddressType.home;
    notifyListeners();
  }

  // 🔥 GENERIC CHECK FOR ALL TYPES
  bool hasType(int type) {
    return _addresses.any((e) => e.type == type);
  }

  // ================= DEFAULT ADDRESS =================
  GetAddress? get defaultAddress {
    try {
      return _addresses.firstWhere((e) => e.isDefault == true);
    } catch (_) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  bool get hasSelectedAddress => _addresses.isNotEmpty;

  // ================= FETCH ADDRESSES =================
  Future<ApiResponse> fetchAllAddresses() async {
    if (_isLoading) {
      return ApiResponse(success: false, message: 'Already loading');
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    ApiResponse response;

    try {
      response = await AddressService.fetchAllAddresses();

      if (response.success && response.data != null) {
        final model = AllAddressListModel.fromJson(response.data);
        _addresses = model.data;
      } else {
        _addresses = [];
        _errorMessage = response.message;
      }
      _hasLoadedOnce = true;
      return response;
    } catch (e, s) {
      debugPrint('FETCH ADDRESS ERROR: $e');
      debugPrintStack(stackTrace: s);

      _addresses = [];
      _errorMessage = e.toString();
      _hasLoadedOnce = true;
      response = ApiResponse(success: false, message: _errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return response;
  }

  // ================= DELETE ADDRESS =================
  Future<ApiResponse> deleteAddress(int id) async {
    debugPrint('🗑️ Delete requested for ID: $id');

    if (_isDeleting) {
      return ApiResponse(success: false, message: 'Please wait');
    }

    _isDeleting = true;
    notifyListeners();

    ApiResponse response;

    try {
      response = await AddressService.deleteAddress(id);

      if (response.success) {
        _addresses.removeWhere((e) => e.id == id);
        debugPrint('✅ Address removed locally: $id');
      }
    } catch (e) {
      response = ApiResponse(success: false, message: e.toString());
    } finally {
      _isDeleting = false;
      notifyListeners();
    }

    return response;
  }

  // ================= ADD ADDRESS =================
  Future<ApiResponse> addAddress({
    required String name,
    required String mobile,
    required String addressLine,
    required String landmark,
    required String city,
    required String state,
    required String pincode,
    required String latitude,
    required String longitude,
    required AddressType type,
  }) async {
    if (_isLoading) {
      return ApiResponse(success: false, message: 'Please wait');
    }

    _isLoading = true;
    notifyListeners();

    ApiResponse response;

    try {
      response = await AddressService.addAddress(
        name: name.trim(),
        mobile: mobile.trim(),
        addressLine: addressLine.trim(),
        landmark: landmark.trim(),
        city: city.trim(),
        state: state.trim(),
        pincode: pincode.trim(),
        latitude: latitude,
        longitude: longitude,
        type: addressTypeToInt(_selectedType),
      );
      if (response.success) {
        await fetchAllAddresses();
        resetType(); // reset after add
      }
    } catch (e) {
      response = ApiResponse(success: false, message: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return response;
  }

  // ================= UPDATE ADDRESS =================
  Future<ApiResponse> updateAddress({
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
    required AddressType type,
  }) async {
    if (_isLoading) {
      return ApiResponse(success: false, message: 'Please wait');
    }

    _isLoading = true;
    notifyListeners();

    ApiResponse response;

    try {
      response = await AddressService.updateAddress(
        id: id,
        name: name.trim(),
        mobile: mobile.trim(),
        addressLine: addressLine.trim(),
        landmark: landmark.trim(),
        city: city.trim(),
        state: state.trim(),
        pincode: pincode.trim(),
        latitude: latitude,
        longitude: longitude,
        type: addressTypeToInt(_selectedType),
      );

      if (response.success) {
        // 🔁 Refresh list after update
        await fetchAllAddresses();
      }
    } catch (e) {
      response = ApiResponse(success: false, message: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return response;
  }

  // ================= CLEAR =================
  void clearAddresses() {
    _addresses = [];
    _errorMessage = '';
    _hasLoadedOnce = false;
    resetType();
    notifyListeners();
  }
}
