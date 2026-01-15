import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationProvider extends ChangeNotifier {
  bool isLoading = false;

  String city = '';
  String state = '';
  String pincode = '';
  String area = '';

  double? latitude;
  double? longitude;

  bool get hasLocation => latitude != null && longitude != null;

  String locationMessage = ''; // 👈 NEW

  Future<void> fetchCurrentLocation() async {
    try {
      isLoading = true;
      locationMessage = '';
      notifyListeners();

      if (!await Geolocator.isLocationServiceEnabled()) {
        locationMessage = 'Please enable location services';
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        locationMessage = 'Please grant location permission';
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // ⭐ SAVE + PRINT HERE
      latitude = position.latitude;
      longitude = position.longitude;

      debugPrint('Lat: $latitude, Lng: $longitude');

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final place = placemarks.first;

      city = place.locality ?? '';
      state = place.administrativeArea ?? '';
      pincode = place.postalCode ?? '';
      area = place.subLocality ?? '';
      locationMessage = 'Location updated successfully';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearLocation() {
    latitude = null;
    longitude = null;
    city = '';
    state = '';
    pincode = '';
    area = '';
    locationMessage = '';
    notifyListeners();
  }
}
