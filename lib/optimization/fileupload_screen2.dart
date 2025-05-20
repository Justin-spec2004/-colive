// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';

// class FileUploadScreen2 extends StatefulWidget {
//   @override
//   _FileUploadScreenDemoState createState() => _FileUploadScreenDemoState();
// }

// class _FileUploadScreenDemoState extends State<FileUploadScreen2> {
//   String? filePath;
//   bool isProcessing = false;
//   bool isConverted = false;
//   String? optimizedFilePath;

//   Future<void> pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);

//     if (result != null) {
//       setState(() {
//         filePath = result.files.single.path;
//         isConverted = false;
//       });
//     }
//   }

//   Future<void> startConversion() async {
//     setState(() {
//       isProcessing = true;
//     });

//     // Simulate the font optimization process (e.g., changing fonts)
//     await Future.delayed(Duration(seconds: 3), () async {
//       // Generate optimized PDF (demo simulation)
//       final pdf = pw.Document();
//       pdf.addPage(
//         pw.Page(
//           build: (pw.Context context) {
//             return pw.Center(
//               child: pw.Text('Optimized Document with EcoFont',
//                   style: pw.TextStyle(fontSize: 24)),
//             );
//           },
//         ),
//       );

//       // Save the optimized PDF
//       final outputDir = await getApplicationDocumentsDirectory();
//       final outputFile = File('${outputDir.path}/optimized_document.pdf');
//       await outputFile.writeAsBytes(await pdf.save());

//       setState(() {
//         optimizedFilePath = outputFile.path;
//         isProcessing = false;
//         isConverted = true;
//       });
//     });
//   }

//   void previewConvertedFile() {
//     // For the demo, simply show the file path
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Preview Converted File"),
//           content: Text("Optimized file is saved at: $optimizedFilePath"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text("Close"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void downloadFile() {
//     // Demo: Just print the file path for now
//     if (optimizedFilePath != null) {
//       print("Downloading file at: $optimizedFilePath");
//       // In a real scenario, you would implement the logic to download the file.
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("File Upload and Demo Conversion")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: pickFile,
//               child: Text("Select File"),
//             ),
//             SizedBox(height: 20),
//             filePath != null
//                 ? Text("Selected File: ${filePath!.split('/').last}",
//                     style: TextStyle(fontSize: 16))
//                 : Text("No file selected", style: TextStyle(fontSize: 16)),
//             SizedBox(height: 20),
//             filePath != null
//                 ? isProcessing
//                     ? CircularProgressIndicator()
//                     : isConverted
//                         ? Column(
//                             children: [
//                               ElevatedButton(
//                                 onPressed: previewConvertedFile,
//                                 child: Text("Preview Converted File"),
//                               ),
//                               SizedBox(height: 10),
//                               ElevatedButton(
//                                 onPressed: downloadFile,
//                                 child: Text("Download Optimized File"),
//                               ),
//                             ],
//                           )
//                         : ElevatedButton(
//                             onPressed: startConversion,
//                             child: Text("Start Conversion"),
//                           )
//                 : Container(),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadScreen2 extends StatefulWidget {
  @override
  _FileUploadScreenDemoState createState() => _FileUploadScreenDemoState();
}

class _FileUploadScreenDemoState extends State<FileUploadScreen2>
    with SingleTickerProviderStateMixin {
  String? filePath;
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Speed up transition
    )..repeat(reverse: true);

    _generateNewColors();
  }

  /// Function to generate random colors and apply to animation
  void _generateNewColors() {
    final random = Random();

    List<Color> randomColors = List.generate(
      4,
      (index) => Color.fromARGB(
        255,
        random.nextInt(256), // Red
        random.nextInt(256), // Green
        random.nextInt(256), // Blue
      ),
    );

    setState(() {
      _colorAnimation = TweenSequence<Color?>([
        for (int i = 0; i < randomColors.length - 1; i++)
          TweenSequenceItem(
            tween: ColorTween(begin: randomColors[i], end: randomColors[i + 1]),
            weight: 1.0,
          ),
      ]).animate(_animationController);
    });

    _animationController.forward(from: 0.0); // Restart animation
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        filePath = result.files.single.path;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Écolive A.I")),
      body: GestureDetector(
        onTap: _generateNewColors, // Change colors on tap
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _colorAnimation.value ?? Colors.blue, // Animated color
                    Colors.white, // Keep a soft transition
                  ],
                ),
              ),
              child: Center(
                child: ElevatedButton(
                  onPressed: pickFile,
                  child: Text("Select File"),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';

// class FileUploadScreen2 extends StatefulWidget {
//   @override
//   _FileUploadScreenDemoState createState() => _FileUploadScreenDemoState();
// }

// class _FileUploadScreenDemoState extends State<FileUploadScreen2>
//     with SingleTickerProviderStateMixin {
//   String? filePath;
//   bool isProcessing = false;
//   bool isConverted = false;
//   String? optimizedFilePath;
//   late AnimationController _animationController;
//   late Animation<Color?> _colorAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 10000),
//     )..repeat();

//     _colorAnimation = TweenSequence<Color?>(
//       [
//         TweenSequenceItem(
//           tween: ColorTween(begin: Colors.blue, end: Colors.red),
//           weight: 1.0,
//         ),
//         TweenSequenceItem(
//           tween: ColorTween(begin: Colors.red, end: Colors.yellow),
//           weight: 1.0,
//         ),
//         TweenSequenceItem(
//           tween: ColorTween(begin: Colors.yellow, end: Colors.green),
//           weight: 1.0,
//         ),
//         TweenSequenceItem(
//           tween: ColorTween(begin: Colors.green, end: Colors.purple),
//           weight: 1.0,
//         ),
//       ],
//     ).animate(_animationController);

//     _animationController.forward();
//   }

//   Future<void> pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);

//     if (result != null) {
//       setState(() {
//         filePath = result.files.single.path;
//         isConverted = false;
//       });
//     }
//   }

//   Future<void> startConversion() async {
//     setState(() {
//       isProcessing = true;
//     });

//     // Simulate the font optimization process (e.g., changing fonts)
//     await Future.delayed(Duration(seconds: 3), () async {
//       // Generate optimized PDF (demo simulation)
//       final pdf = pw.Document();
//       pdf.addPage(
//         pw.Page(
//           build: (pw.Context context) {
//             return pw.Center(
//               child: pw.Text('Optimized Document with EcoFont',
//                   style: pw.TextStyle(fontSize: 24)),
//             );
//           },
//         ),
//       );

//       // Save the optimized PDF
//       final outputDir = await getApplicationDocumentsDirectory();
//       final outputFile = File('${outputDir.path}/optimized_document.pdf');
//       await outputFile.writeAsBytes(await pdf.save());

//       setState(() {
//         optimizedFilePath = outputFile.path;
//         isProcessing = false;
//         isConverted = true;
//       });
//     });
//   }

//   Future<void> previewConvertedFile() async {
//     // Show a preview and save the file to the local memory
//     if (optimizedFilePath != null) {
//       print("Optimized file saved at: $optimizedFilePath");
//       // You can show the file path in the preview dialog.
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Preview Converted File"),
//             content: Text("Optimized file is saved at: $optimizedFilePath"),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text("Close"),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   Future<void> downloadFile(String fileType) async {
//     // Save as PDF or Word based on user selection
//     if (optimizedFilePath != null) {
//       print("Downloading file at: $optimizedFilePath");

//       // Logic to download and save the file
//       // For PDF, it’s already created
//       if (fileType == "pdf") {
//         print("PDF Downloaded: $optimizedFilePath");
//         // You can also implement the logic to open or send the file for printing.
//       }
//       // For Word, we will simulate saving as a Word file
//       else if (fileType == "docx") {
//         final docxOutputFile =
//             File('${optimizedFilePath!.replaceAll('.pdf', '.docx')}');
//         // Simulate saving as a Word file (this is a placeholder; actual conversion is complex)
//         await docxOutputFile.writeAsString("This is a simulated Word file.");
//         print("Word file downloaded at: ${docxOutputFile.path}");
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Écolive A.I")),
//       body: AnimatedBuilder(
//         animation: _animationController,
//         builder: (context, child) {
//           return Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Colors.blue,
//                   Colors.red,
//                   Colors.yellow,
//                   Colors.green,
//                   _colorAnimation.value!,
//                 ],
//                 stops: [0.0, 0.25, 0.5, 0.75, 1.0],
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: pickFile,
//                     child: Text("Select File"),
//                   ),
//                   SizedBox(height: 20),
//                   filePath != null
//                       ? Text("Selected File: ${filePath!.split('/').last}",
//                           style: TextStyle(fontSize: 16))
//                       : Text("No file selected",
//                           style: TextStyle(fontSize: 16)),
//                   SizedBox(height: 20),
//                   filePath != null
//                       ? isProcessing
//                           ? CircularProgressIndicator()
//                           : isConverted
//                               ? Column(
//                                   children: [
//                                     ElevatedButton(
//                                       onPressed: previewConvertedFile,
//                                       child: Text("Preview Converted File"),
//                                     ),
//                                     SizedBox(height: 10),
//                                     ElevatedButton(
//                                       onPressed: () => downloadFile("pdf"),
//                                       child: Text("Download as PDF"),
//                                     ),
//                                     SizedBox(height: 10),
//                                     ElevatedButton(
//                                       onPressed: () => downloadFile("docx"),
//                                       child: Text("Download as Word"),
//                                     ),
//                                   ],
//                                 )
//                               : ElevatedButton(
//                                   onPressed: startConversion,
//                                   child: Text("Start Conversion"),
//                                 )
//                       : Container(),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';

// class FileUploadScreen2 extends StatefulWidget {
//   @override
//   _FileUploadScreenDemoState createState() => _FileUploadScreenDemoState();
// }

// class _FileUploadScreenDemoState extends State<FileUploadScreen2> {
//   String? filePath;
//   bool isProcessing = false;
//   bool isConverted = false;
//   String? optimizedFilePath;

//   Future<void> pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);

//     if (result != null) {
//       setState(() {
//         filePath = result.files.single.path;
//         isConverted = false;
//       });
//     }
//   }

//   Future<void> startConversion() async {
//     setState(() {
//       isProcessing = true;
//     });

//     // Simulate the font optimization process (e.g., changing fonts)
//     await Future.delayed(Duration(seconds: 3), () async {
//       // Generate optimized PDF (demo simulation)
//       final pdf = pw.Document();
//       pdf.addPage(
//         pw.Page(
//           build: (pw.Context context) {
//             return pw.Center(
//               child: pw.Text('Optimized Document with EcoFont',
//                   style: pw.TextStyle(fontSize: 24)),
//             );
//           },
//         ),
//       );

//       // Save the optimized PDF
//       final outputDir = await getApplicationDocumentsDirectory();
//       final outputFile = File('${outputDir.path}/optimized_document.pdf');
//       await outputFile.writeAsBytes(await pdf.save());

//       setState(() {
//         optimizedFilePath = outputFile.path;
//         isProcessing = false;
//         isConverted = true;
//       });
//     });
//   }

//   Future<void> previewConvertedFile() async {
//     // Show a preview and save the file to the local memory
//     if (optimizedFilePath != null) {
//       print("Optimized file saved at: $optimizedFilePath");
//       // You can show the file path in the preview dialog.
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Preview Converted File"),
//             content: Text("Optimized file is saved at: $optimizedFilePath"),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text("Close"),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   Future<void> downloadFile(String fileType) async {
//     // Save as PDF or Word based on user selection
//     if (optimizedFilePath != null) {
//       print("Downloading file at: $optimizedFilePath");

//       // Logic to download and save the file
//       // For PDF, it’s already created
//       if (fileType == "pdf") {
//         print("PDF Downloaded: $optimizedFilePath");
//         // You can also implement the logic to open or send the file for printing.
//       }
//       // For Word, we will simulate saving as a Word file
//       else if (fileType == "docx") {
//         final docxOutputFile =
//             File('${optimizedFilePath!.replaceAll('.pdf', '.docx')}');
//         // Simulate saving as a Word file (this is a placeholder; actual conversion is complex)
//         await docxOutputFile.writeAsString("This is a simulated Word file.");
//         print("Word file downloaded at: ${docxOutputFile.path}");
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Écolive A.I")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: pickFile,
//               child: Text("Select File"),
//             ),
//             SizedBox(height: 20),
//             filePath != null
//                 ? Text("Selected File: ${filePath!.split('/').last}",
//                     style: TextStyle(fontSize: 16))
//                 : Text("No file selected", style: TextStyle(fontSize: 16)),
//             SizedBox(height: 20),
//             filePath != null
//                 ? isProcessing
//                     ? CircularProgressIndicator()
//                     : isConverted
//                         ? Column(
//                             children: [
//                               ElevatedButton(
//                                 onPressed: previewConvertedFile,
//                                 child: Text("Preview Converted File"),
//                               ),
//                               SizedBox(height: 10),
//                               ElevatedButton(
//                                 onPressed: () => downloadFile("pdf"),
//                                 child: Text("Download as PDF"),
//                               ),
//                               SizedBox(height: 10),
//                               ElevatedButton(
//                                 onPressed: () => downloadFile("docx"),
//                                 child: Text("Download as Word"),
//                               ),
//                             ],
//                           )
//                         : ElevatedButton(
//                             onPressed: startConversion,
//                             child: Text("Start Conversion"),
//                           )
//                 : Container(),
//           ],
//         ),
//       ),
//     );
//   }
// }
