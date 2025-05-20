import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  final List<String> historyList;

  HistoryScreen({required this.historyList});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<String> _historyList = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  // Future<void> _loadHistory() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _historyList = prefs.getStringList("history") ?? [];
  //   });
  //   print("Loaded History: $_historyList");
  // }
  // Future<void> _loadHistory() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> storedHistory = prefs.getStringList("history") ?? [];

  //   setState(() {
  //     _historyList = storedHistory.map((entry) {
  //       final data = jsonDecode(entry);
  //       return jsonEncode({'text': data['text'], 'font': data['font']});
  //     }).toList();
  //   });

  //   print("Loaded History: $_historyList");
  // }

  Future<void> _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedHistory = prefs.getStringList("history") ?? [];

    setState(() {
      _historyList = storedHistory.map((entry) {
        try {
          final data = jsonDecode(entry); // Try to decode JSON
          return jsonEncode({'text': data['text'], 'font': data['font']});
        } catch (e) {
          // If it's not JSON (old plain text entry), store it with a default font
          return jsonEncode({'text': entry, 'font': 'Arial'}); // Default font
        }
      }).toList();
    });

    print("Loaded History: $_historyList");
  }

  Future<void> _clearHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("history");
    setState(() {
      _historyList.clear();
    });
    print("History cleared!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversion History"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _clearHistory,
          ),
        ],
      ),
      body: _historyList.isEmpty
          ? Center(child: Text("No history yet."))
          : ListView.builder(
              itemCount: _historyList.length,
              itemBuilder: (context, index) {
                final item = jsonDecode(_historyList[index]); // Decode JSON

                return Card(
                  child: ListTile(
                    title: Text(
                      item['text'],
                      style: TextStyle(
                        fontFamily: item['font'], // Apply stored font
                        fontSize: 18,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        setState(() {
                          _historyList.removeAt(index);
                        });

                        // Save updated list back to SharedPreferences
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setStringList("history", _historyList);

                        print("Updated History after delete: $_historyList");
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// trailing: IconButton(
                    //   icon: Icon(Icons.delete, color: Colors.red),
                    //   onPressed: () async {
                    //     setState(() {
                    //       _historyList.removeAt(index);
                    //     });
                    //     SharedPreferences prefs =
                    //         await SharedPreferences.getInstance();
                    //     await prefs.setStringList("history", _historyList);
                    //     print("Updated History: $_historyList");
                    //   },
                    // ),

// import 'package:flutter/material.dart';

// // import 'package:flutter/services.dart';
// class HistoryScreen extends StatelessWidget {
//   final List<String> historyList;

//   HistoryScreen({required this.historyList});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Conversion History")),
//       body: historyList.isEmpty
//           ? Center(child: Text("No history yet."))
//           : ListView.builder(
//               itemCount: historyList.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(historyList[index]),
//                   trailing: IconButton(
//                     icon: Icon(Icons.delete),
//                     onPressed: () {
//                       // Implement delete functionality if needed
//                     },
//                   ),
//                 );
//               },
//             ),
//     );
//   }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text("Conversion History")),
  //     body: historyList.isEmpty
  //         ? Center(child: Text("No history yet!"))
  //         : ListView.builder(
  //             itemCount: historyList.length,
  //             itemBuilder: (context, index) {
  //               return ListTile(
  //                 title:
  //                     Text(historyList[index], style: TextStyle(fontSize: 16)),
  //                 trailing: IconButton(
  //                   icon: Icon(Icons.copy),
  //                   onPressed: () {
  //                     Clipboard.setData(
  //                         ClipboardData(text: historyList[index]));
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       SnackBar(content: Text("Copied to clipboard!")),
  //                     );
  //                   },
  //                 ),
  //               );
  //             },
  //           ),
  //   );
  // }

