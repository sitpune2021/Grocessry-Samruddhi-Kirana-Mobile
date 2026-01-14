import 'package:flutter/material.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/models/address/get_all_address_model.dart';
import 'package:samruddha_kirana/services/address/address_service.dart';

class AddressProvider extends ChangeNotifier {
  // ================= LOADING =================
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ================= DELETE LOADING =================
  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;

  // ================= DATA =================
  List<GetAddress> _addresses = [];
  List<GetAddress> get addresses => _addresses;

  // ================= ERROR =================
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // ================= FETCH ADDRESSES =================
  Future<ApiResponse> fetchAllAddresses() async {
    if (_isLoading) {
      return ApiResponse(success: false, message: 'Please wait');
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    ApiResponse response;

    try {
      response = await AddressService.fetchAllAddresses();

      if (response.success && response.data != null) {
        final model = AllAddressListModel.fromJson({
          "status": true,
          "data": response.data['data'], // ✅ extract list
        });

        _addresses = model.data;
      } else {
        _addresses = [];
        _errorMessage = response.message;
      }
    } catch (e) {
      _addresses = [];
      _errorMessage = e.toString();
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

  // ================= CLEAR =================
  void clearAddresses() {
    _addresses = [];
    _errorMessage = '';
    notifyListeners();
  }
}
