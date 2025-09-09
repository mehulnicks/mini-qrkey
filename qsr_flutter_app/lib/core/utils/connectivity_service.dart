import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectivityStatus {
  online,
  offline,
  unknown,
}

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<ConnectivityStatus> _controller = 
      StreamController<ConnectivityStatus>.broadcast();

  Stream<ConnectivityStatus> get statusStream => _controller.stream;
  ConnectivityStatus _currentStatus = ConnectivityStatus.unknown;

  ConnectivityStatus get currentStatus => _currentStatus;

  Future<void> initialize() async {
    // Check initial connectivity
    await _checkConnectivity();

    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _updateConnectivityStatus(result);
    });
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectivityStatus(result);
    } catch (e) {
      _currentStatus = ConnectivityStatus.unknown;
      _controller.add(_currentStatus);
    }
  }

  void _updateConnectivityStatus(ConnectivityResult result) {
    ConnectivityStatus newStatus;
    
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
        newStatus = ConnectivityStatus.online;
        break;
      case ConnectivityResult.none:
        newStatus = ConnectivityStatus.offline;
        break;
      default:
        newStatus = ConnectivityStatus.unknown;
    }

    if (newStatus != _currentStatus) {
      _currentStatus = newStatus;
      _controller.add(_currentStatus);
    }
  }

  bool get isOnline => _currentStatus == ConnectivityStatus.online;
  bool get isOffline => _currentStatus == ConnectivityStatus.offline;

  void dispose() {
    _controller.close();
  }
}
