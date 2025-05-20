// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

// class InternetProvider with ChangeNotifier {
//   bool _isConnected = false;
//   late StreamSubscription<InternetStatus> _subscription;

//   InternetProvider() {
//     _checkInternetConnection();
//   }

//   bool get isConnected => _isConnected;

//   void _checkInternetConnection() {
//     _subscription = InternetConnection().onStatusChange.listen((status) {
//       _isConnected = status == InternetStatus.connected;
//       notifyListeners();
//     });
//   }

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetProvider extends ChangeNotifier {
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  StreamSubscription? _internetSubscription;

  InternetProvider() {
    _internetSubscription =
        InternetConnection().onStatusChange.listen((status) {
      _isConnected = status == InternetStatus.connected;
      notifyListeners(); // Cập nhật tất cả màn hình
    });
  }

  @override
  void dispose() {
    _internetSubscription?.cancel();
    super.dispose();
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

// class InternetProvider with ChangeNotifier {
//   bool _isConnected = true; // Ban đầu giả định có mạng
//   final Connectivity _connectivity = Connectivity();
//   late StreamSubscription _subscription;

//   InternetProvider() {
//     _checkConnectivity();
//     _subscription = _connectivity.onConnectivityChanged
//         .listen((results) => _updateStatus(results));
//   }

//   bool get isConnected => _isConnected;

//   Future<void> _checkConnectivity() async {
//     var results = await _connectivity.checkConnectivity();
//     _updateStatus(results);
//   }

//   void _updateStatus(List<ConnectivityResult> results) {
//     bool previousState = _isConnected;

//     // Kiểm tra nếu có ít nhất một loại kết nối đang hoạt động
//     _isConnected = results.any((result) => result != ConnectivityResult.none);

//     if (_isConnected != previousState) {
//       notifyListeners();
//     }
//   }

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

// class InternetProvider with ChangeNotifier {
//   bool _isConnected = true;
//   bool get isConnected => _isConnected;

//   final Connectivity _connectivity = Connectivity();
//   late StreamSubscription<ConnectivityResult> _subscription;

//   InternetProvider() {
//     _subscription = _connectivity.onConnectivityChanged.listen((result) {
//       bool wasConnected = _isConnected;
//       _isConnected = (result != ConnectivityResult.none);

//       if (wasConnected != _isConnected) {
//         notifyListeners();
//       }
//     }) as StreamSubscription<ConnectivityResult>;
//   }

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
// }

// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

// // class InternetProvider with ChangeNotifier {
// //   bool _isConnected = true;
// //   late StreamSubscription _subscription;

// //   bool get isConnected => _isConnected;

// //   InternetProvider() {
// //     _subscription = InternetConnection().onStatusChange.listen((status) {
// //       _isConnected = (status == InternetStatus.connected);
// //       notifyListeners();
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _subscription.cancel();
// //     super.dispose();
// //   }
// // }

// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

// // class InternetProvider with ChangeNotifier {
// //   bool _isConnected = true;
// //   late StreamSubscription _subscription;

// //   bool get isConnected => _isConnected;

// //   InternetProvider() {
// //     _subscription = InternetConnection().onStatusChange.listen((status) {
// //       _isConnected = (status == InternetStatus.connected);
// //       notifyListeners();
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _subscription.cancel();
// //     super.dispose();
// //   }
// // }
