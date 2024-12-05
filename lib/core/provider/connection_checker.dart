import 'dart:async';
import 'dart:developer' as developer; // developer log için import
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectionControlProvider with ChangeNotifier {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  List<ConnectivityResult> get connectionStatus => _connectionStatus;

  ConnectionControlProvider() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initConnectivity();
  }

  Future<void> initConnectivity() async {
    try {
      _connectionStatus = await _connectivity.checkConnectivity();
      developer.log(
        'Initial connectivity status: $_connectionStatus',
        name: 'ConnectionControlProvider',
      );
      notifyListeners();
    } catch (e) {
      developer.log(
        'Error checking connectivity: $e',
        name: 'ConnectionControlProvider',
        level: 1000,
      );
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    _connectionStatus = result;
    developer.log(
      'Connectivity status changed: $_connectionStatus',
      name: 'ConnectionControlProvider',
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel(); 
    super.dispose();
  }
}
