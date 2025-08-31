import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  
  ConnectivityResult _currentConnectivity = ConnectivityResult.none;
  final StreamController<bool> _connectionController = StreamController<bool>.broadcast();

  // Public API
  Stream<bool> get connectionStream => _connectionController.stream;
  bool get isConnected => _currentConnectivity != ConnectivityResult.none;
  bool get isWifi => _currentConnectivity == ConnectivityResult.wifi;
  bool get isMobile => _currentConnectivity == ConnectivityResult.mobile;

  ConnectivityResult get currentConnectivity => _currentConnectivity;

  Future<void> initialize() async {
    try {
      // Check initial connectivity
      _currentConnectivity = await _connectivity.checkConnectivity();
      _connectionController.add(isConnected);

      // Listen for connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        _onConnectivityChanged,
        onError: (error) {
          debugPrint('Connectivity error: $error');
        },
      );

      debugPrint('ConnectivityService initialized. Current: $_currentConnectivity');
    } catch (e) {
      debugPrint('Error initializing ConnectivityService: $e');
    }
  }

  void _onConnectivityChanged(ConnectivityResult result) {
    final wasConnected = isConnected;
    _currentConnectivity = result;
    final isNowConnected = isConnected;

    debugPrint('Connectivity changed: $result');

    // Emit connection status change
    _connectionController.add(isNowConnected);

    // Handle connection state changes
    if (!wasConnected && isNowConnected) {
      _onConnectionRestored();
    } else if (wasConnected && !isNowConnected) {
      _onConnectionLost();
    }
  }

  void _onConnectionRestored() {
    debugPrint('Internet connection restored');
    // Trigger sync when connection is restored
    _triggerSync();
  }

  void _onConnectionLost() {
    debugPrint('Internet connection lost');
    // Could trigger offline mode notifications here
  }

  void _triggerSync() {
    // This would typically trigger the OfflineService sync
    // We'll handle this in the repository layer
    debugPrint('Triggering sync after connection restored');
  }

  Future<bool> testInternetConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      debugPrint('Error testing internet connection: $e');
      return false;
    }
  }

  String getConnectionTypeString() {
    switch (_currentConnectivity) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.other:
        return 'Other';
      case ConnectivityResult.none:
        return 'Offline';
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionController.close();
  }
}