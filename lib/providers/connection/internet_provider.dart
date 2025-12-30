import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/internet_service.dart';

class InternetProvider extends ChangeNotifier {
  bool isConnected = true;
  StreamSubscription<bool>? _subscription;

  InternetProvider() {
    _init();
  }

  Future<void> _init() async {
    isConnected = await InternetService.hasInternet();
    notifyListeners();

    _subscription = InternetService.connectionStream().listen((status) {
      if (isConnected != status) {
        isConnected = status;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
