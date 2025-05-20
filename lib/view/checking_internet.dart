// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:font_change_md/view/internet_provider.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
// import 'package:provider/provider.dart';

// class CheckingInternet extends StatefulWidget {
//   const CheckingInternet({super.key});

//   @override
//   State<CheckingInternet> createState() => _CheckingInternetState();
// }

// class _CheckingInternetState extends State<CheckingInternet> {
//   bool isConnectedToInternet = false;

//   StreamSubscription? _internetConectionStreamSubcription;

//   @override
//   void initState() {
//     super.initState();
//     _internetConectionStreamSubcription =
//         InternetConnection().onStatusChange.listen((event) {
//       print(event);
//       switch (event) {
//         case InternetStatus.connected:
//           setState(() {
//             isConnectedToInternet = true;
//           });
//           break;
//         case InternetStatus.disconnected:
//           setState(() {
//             isConnectedToInternet = false;
//           });
//           break;
//         // default:
//         //   setState(() {
//         //     isConnectedToInternet = false;
//         //   });
//         //   break;
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _internetConectionStreamSubcription?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<InternetProvider>(
//       builder: (context, internetProvider, child) {
//         if (internetProvider.isConnected) {
//           Future.microtask(() {
//             Navigator.pop(context);
//           });
//         }

//         return Scaffold(
//           body: SizedBox(
//             width: MediaQuery.sizeOf(context).width,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Icon(
//                   isConnectedToInternet ? Icons.wifi : Icons.wifi_off,
//                   size: 50,
//                   color: isConnectedToInternet ? Colors.green : Colors.red,
//                 ),
//                 SizedBox(height: 30),
//                 Text(
//                   isConnectedToInternet
//                       ? "Connected"
//                       : "Please turn on your WI-FI or Mobile Data",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_change_md/view/internet_provider.dart';

class CheckingInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(
      builder: (context, internetProvider, child) {
        if (internetProvider.isConnected) {
          Future.microtask(() {
            Navigator.pop(
                context); // Quay lại màn hình trước đó khi có Internet
          });
        }

        return Scaffold(
          body: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  internetProvider.isConnected ? Icons.wifi : Icons.wifi_off,
                  size: 50,
                  color:
                      internetProvider.isConnected ? Colors.green : Colors.red,
                ),
                SizedBox(height: 30),
                Text(
                  internetProvider.isConnected
                      ? "Connected"
                      : "Check your WI-FI, Mobile Data or SIM Signal is slowed",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
