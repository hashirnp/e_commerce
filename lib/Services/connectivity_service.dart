import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService with ChangeNotifier {
  bool _hasInternet = true;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool get hasInternet => _hasInternet;

  ConnectivityService() {
    _checkInitialConnection();
    _subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      log(result.toString());
      _hasInternet = result[0] != ConnectivityResult.none;
      notifyListeners();
    });
  }

  Future<void> _checkInitialConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _hasInternet = connectivityResult != ConnectivityResult.none;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
