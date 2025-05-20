import 'package:flutter/material.dart';

class SavingsScreen extends StatelessWidget {
  final double inkSaved;
  final int pagesSaved;

  SavingsScreen({required this.inkSaved, required this.pagesSaved});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Savings Report"), backgroundColor: Colors.green),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("🎉 Optimization Complete!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("🖨 Ink Saved: $inkSaved%",
                style: TextStyle(fontSize: 18, color: Colors.green)),
            Text("📄 Pages Saved: $pagesSaved",
                style: TextStyle(fontSize: 18, color: Colors.green)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Done"),
            ),
          ],
        ),
      ),
    );
  }
}
