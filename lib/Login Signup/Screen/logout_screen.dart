import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_change_md/Login%20With%20Google/google_auth.dart';
import 'package:font_change_md/Widget/button.dart';
import 'package:font_change_md/loading/loading.dart';
import 'package:font_change_md/view/checking_internet.dart';
import 'package:font_change_md/view/internet_provider.dart';
import 'package:provider/provider.dart';
import 'login.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return const Loading(); // Uses your custom Loading widget
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(
      builder: (context, internetProvider, child) {
        if (!internetProvider.isConnected) {
          Future.microtask(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CheckingInternet()),
            );
          });
        }

        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "See you soon",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF706134)),
                ),

                MyButtons(
                  onTap: () async {
                    showLoadingDialog(context); // Show Loading Dialog
                    await Future.delayed(
                        const Duration(seconds: 2)); // Simulate a task
                    Navigator.pop(context);
                    await FirebaseServices().googleSignOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  text: "Log Out",
                ),
                // for google sign in ouser detail
                Image.network("${FirebaseAuth.instance.currentUser!.photoURL}"),
                Text("${FirebaseAuth.instance.currentUser!.email}"),
                Text("${FirebaseAuth.instance.currentUser!.displayName}")
              ],
            ),
          ),
        );
      },
    );
  }
}
