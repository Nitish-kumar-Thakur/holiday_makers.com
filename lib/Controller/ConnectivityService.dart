// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';

// class ConnectivityService with ChangeNotifier {
//   final Connectivity _connectivity = Connectivity();
//   bool _isOnline = false;
//   StreamSubscription<List<ConnectivityResult>>? _subscription;

//   bool get isOnline => _isOnline;

//   ConnectivityService() {
//     _init();
//   }  

//   Future<void> _init() async {
//     print("🔄 Initializing Connectivity Service...");

//     await _checkInternet(); // Check connection when app starts

//     _subscription = _connectivity.onConnectivityChanged.listen((results) async {
//       print("📡 Connectivity changed: $results"); // Debug print
//       await _updateConnectionStatus(results);
//     });
//   }

//   Future<void> _checkInternet() async {
//     try {
//       List<ConnectivityResult> connectivityResults =
//           await _connectivity.checkConnectivity();
//       print(
//           "🌐 Initial connectivity check: $connectivityResults"); // Debug print
//       await _updateConnectionStatus(connectivityResults);
//     } catch (e) {
//       print("❌ Error checking connectivity: $e");
//     }
//   }

// Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
//   bool wasOnline = _isOnline;
//   _isOnline = results.isNotEmpty &&
//       results.any((result) => result != ConnectivityResult.none);

//   print("🔍 Checking connection status...");
//   print("Previous status: $wasOnline, New status: $_isOnline");
//   print("🔔 new status ${wasOnline != _isOnline}");

//   if (wasOnline != _isOnline) {
//     print("🔔 Connection status changed! Notifying listeners...");
//     notifyListeners();  // This is already here
//   } else {
//     print("⚠️ Connection status did NOT change.");
//   }

//   // 🔥 Force UI update
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     notifyListeners();
//   });
// }



//   Future<void> manualCheck() async {
//   print("🔄 Manually checking connectivity...");

//   await _checkInternet();

//   print("🔔 UI manually refreshed after Retry button tap.");

//   // ✅ Always notify UI, even if status didn't change
//   notifyListeners(); // This ensures UI refresh
// }


//   @override
//   void dispose() {
//     print("🛑 Disposing Connectivity Service...");
//     _subscription?.cancel();
//     super.dispose();
//   }
// }

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService with ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _isOnline = true;
  String? _lastPage;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool get isOnline => _isOnline;
  String? get lastPage => _lastPage;

  ConnectivityService() {
    _init();
  }

  Future<void> _init() async {
    await _checkInternet();
    _subscription = _connectivity.onConnectivityChanged.listen((results) async {
      await _updateConnectionStatus(results);
    });
  }

  Future<void> _checkInternet() async {
    List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    await _updateConnectionStatus(results);
  }

Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
  bool wasOnline = _isOnline;
  _isOnline = results.isNotEmpty && results.any((r) => r != ConnectivityResult.none);

  if (wasOnline && !_isOnline) {
    // ✅ Save the last visited page before losing internet
    print("⚠️ Internet lost! Saving last visited page: $_lastPage");
  }

  if (wasOnline != _isOnline) {
    print("📡 Connectivity changed: ${_isOnline ? 'ONLINE' : 'OFFLINE'}");
    notifyListeners();
  }
}


  void setLastPage(String routeName) {
    if (routeName != "/NoInternetPage") {
      _lastPage = routeName; // ✅ Only save real pages
      print("🔖 Last page set: $_lastPage");
    }
  }

  void manualCheck() async {
    print("🛠️ Manual internet check triggered...");
    await _checkInternet();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}








