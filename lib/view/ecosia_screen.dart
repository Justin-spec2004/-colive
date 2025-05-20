import 'dart:async';
import 'package:flutter/material.dart';

class EcosiaCloneScreen extends StatefulWidget {
  @override
  _EcosiaCloneScreenState createState() => _EcosiaCloneScreenState();
}

class _EcosiaCloneScreenState extends State<EcosiaCloneScreen> {
  int treeCount = 94829305; // Starting number
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startCounting();
  }

  void startCounting() {
    _timer = Timer.periodic(Duration(milliseconds: 2000), (timer) {
      setState(() {
        treeCount += 1; // Increase the count by 1 every 2 seconds
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Stop the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo/ecosia_logo.png', height: 100),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search the web to plant trees...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                // "$treeCount",
                "${treeCount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (match) => "${match[1]},")}",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Trees planted by Ecosia users"),
              SizedBox(height: 30),
              Icon(
                Icons.arrow_downward,
                size: 40,
                color: Colors.blueAccent,
              ),
              Spacer(),
              Image.asset(
                'assets/landscape.png',
                height: 500,
                fit: BoxFit.cover,
              ),
            ],
          ),

          // Back Button (Positioned at Top-Left)
          Positioned(
            top: 40, // Adjust position from the top
            left: 20, // Adjust position from the left
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pop(context); // Navigate back
              },
            ),
          ),
        ],
      ),
    );
  }
}
