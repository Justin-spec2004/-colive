// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:docx_template/docx_template.dart' as docx; // Add this package
// import 'package:pdf/widgets.dart' as pw; // For PDF generation
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_document_reader_api/flutter_document_reader.dart'; // For extracting text from DOCX
// import 'package:share_plus/share_plus.dart';
// import 'dart:convert';
// import 'dart:io';

// // void main() {
// //   runApp(EcoFontApp());
// // }

// // class EcoFontApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: FileUploadScreen(),
// //     );
// //   }
// // }

// class FileUploadScreen extends StatefulWidget {
//   @override
//   _FileUploadScreenState createState() => _FileUploadScreenState();
// }

// class _FileUploadScreenState extends State<FileUploadScreen> {
//   String? _fileName;
//   bool _isProcessing = false;
//   double _inkSaved = 0;
//   int _pagesSaved = 0;
//   String? _optimizedFilePath;

//   final model = GenerativeModel(
//       model: 'gemini-1.5-flash-latest',
//       apiKey: 'AIzaSyAlP9bSgFi3GOkE-Jw4Z6k6DNpsx6LVgss');

//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'docx']);

//     if (result != null) {
//       setState(() {
//         _fileName = result.files.single.name;
//         _isProcessing = true;
//       });

//       File file = File(result.files.single.path!);
//       await _processFileWithAI(file);
//     }
//   }

//   Future<void> _processFileWithAI(File file) async {
//     String fileExtension = file.path.split('.').last.toLowerCase();
//     String fileContent = "";

//     try {
//       if (fileExtension == "pdf") {
//         // Extract text from PDF (Needs additional package like pdf_text)
//         fileContent = await extractTextFromPDF(
//             file); // Ensure the method is implemented below
//       } else if (fileExtension == "docx") {
//         fileContent = await extractTextFromDocx(file);
//       }

//       final content = [
//         docx.PlainContent(
//             "Optimize this document for ink and paper saving: $fileContent")
//       ];

//       final response = await model.generateContent(content.cast<Content>());
//       var jsonData = json.decode(response.text!);
//       String optimizedText = jsonData['optimizedText'] ?? "";

//       // Save the optimized text back into the appropriate format
//       if (fileExtension == "pdf") {
//         _optimizedFilePath = await saveOptimizedPDF(
//             optimizedText); // Ensure the method is implemented below
//       } else if (fileExtension == "docx") {
//         _optimizedFilePath = await saveOptimizedDocx(optimizedText);
//       }

//       setState(() {
//         _isProcessing = false;
//         _inkSaved = jsonData['inkSaved'] ?? 0;
//         _pagesSaved = jsonData['pagesSaved'] ?? 0;
//       });

//       if (_optimizedFilePath!.isNotEmpty) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => SummaryScreen(
//                 _fileName!, _inkSaved, _pagesSaved, _optimizedFilePath!),
//           ),
//         );
//       }
//     } catch (e) {
//       setState(() {
//         _isProcessing = false;
//       });
//       print("Error processing file: $e");
//     }
//   }

//   Future<String> extractTextFromDocx(File file) async {
//     final docReader = FlutterDocumentReader(filePath: file.path);
//     return await docReader.extractText();
//   }

//   Future<String> extractTextFromPDF(File file) async {
//     // Placeholder implementation for extracting text from PDF
//     // Replace this with a proper PDF text extraction library like 'pdf_text'
//     return "Extracted text from PDF is not implemented yet.";
//   }

//   Future<String> saveOptimizedDocx(String text) async {
//     final doc =
//         await DocxTemplate.fromBytes(await File('template.docx').readAsBytes());
//     final docxFile = await getTemporaryDirectory();
//     String filePath = '${docxFile.path}/optimized.docx';

//     await doc.generate({'optimized_text': text}).then((bytes) {
//       File(filePath).writeAsBytesSync(bytes);
//     });

//     return filePath;
//   }

//   Future<String> saveOptimizedPDF(String text) async {
//     final pdf = pw.Document();
//     pdf.addPage(pw.Page(
//       build: (pw.Context context) => pw.Text(text),
//     ));

//     final pdfFile = await getTemporaryDirectory();
//     String filePath = '${pdfFile.path}/optimized.pdf';

//     final file = File(filePath);
//     await file.writeAsBytes(await pdf.save());

//     return filePath;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('EcoFont Converter')),
//       body: Center(
//         child: _isProcessing
//             ? SpinKitFadingCircle(color: Colors.green, size: 50.0)
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     _fileName == null
//                         ? 'Upload a file to optimize'
//                         : 'File: $_fileName',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _pickFile,
//                     child: Text('Select File'),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }

// class SummaryScreen extends StatelessWidget {
//   final String fileName;
//   final double inkSaved;
//   final int pagesSaved;
//   final String optimizedFilePath;

//   SummaryScreen(
//       this.fileName, this.inkSaved, this.pagesSaved, this.optimizedFilePath);

//   void _shareFile() {
//     if (optimizedFilePath.isNotEmpty && File(optimizedFilePath).existsSync()) {
//       Share.shareXFiles([XFile(optimizedFilePath)],
//           text: 'Check out this optimized document that saves ink and paper!');
//     } else {
//       print("Error: Optimized file not found.");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Optimization Summary')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('File: $fileName', style: TextStyle(fontSize: 18)),
//             SizedBox(height: 20),
//             Text('Ink Saved: $inkSaved%',
//                 style: TextStyle(fontSize: 18, color: Colors.green)),
//             Text('Pages Saved: $pagesSaved',
//                 style: TextStyle(fontSize: 18, color: Colors.blue)),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _shareFile,
//               child: Text('Share Optimized File'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Back to Upload'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:flutter_document_reader_api/flutter_document_reader_api.dart';
// import 'package:docx_template/docx_template.dart';
// import 'dart:convert';
// import 'dart:io';

// void main() {
//   runApp(EcoFontApp());
// }

// class EcoFontApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: FileUploadScreen(),
//     );
//   }
// }

// class FileUploadScreen extends StatefulWidget {
//   @override
//   _FileUploadScreenState createState() => _FileUploadScreenState();
// }

// class _FileUploadScreenState extends State<FileUploadScreen> {
//   String? _fileName;
//   bool _isProcessing = false;
//   double _inkSaved = 0;
//   int _pagesSaved = 0;
//   String? _optimizedFilePath;

//   final model =
//       GenerativeModel(model: 'gemini-pro', apiKey: 'YOUR_GEMINI_API_KEY');

//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'docx']);

//     if (result != null) {
//       setState(() {
//         _fileName = result.files.single.name;
//         _isProcessing = true;
//       });

//       File file = File(result.files.single.path!);
//       await _processFileWithAI(file);
//     }
//   }

//   Future<void> _processFileWithAI(File file) async {
//     try {
//       String extractedText = await DocumentReaderApi.extractText(result.files.single.path!);
//       final content = [
//         Content.text(
//             "Optimize this document for ink and paper saving: $extractedText")
//       ];

//       final response = await model.generateContent(content);

//       if (response.text == null) {
//         throw Exception("Invalid AI response");
//       }

//       String optimizedText;
//       double inkSaved = 0;
//       int pagesSaved = 0;

//       try {
//         var jsonData = json.decode(response.text!);
//         optimizedText = jsonData['optimizedText'];
//         inkSaved = jsonData['inkSaved'];
//         pagesSaved = jsonData['pagesSaved'];
//       } catch (e) {
//         optimizedText = response.text!;
//       }

//       if (file.path.endsWith('.docx')) {
//         _optimizedFilePath = file.path.replaceAll('.docx', '_optimized.docx');
//         await _saveAsDocx(_optimizedFilePath!, optimizedText);
//       } else {
//         _optimizedFilePath = file.path.replaceAll('.pdf', '_optimized.pdf');
//         File(_optimizedFilePath!).writeAsString(optimizedText);
//       }

//       setState(() {
//         _isProcessing = false;
//         _inkSaved = inkSaved;
//         _pagesSaved = pagesSaved;
//       });

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SummaryScreen(
//               _fileName!, _inkSaved, _pagesSaved, _optimizedFilePath!),
//         ),
//       );
//     } catch (e) {
//       setState(() {
//         _isProcessing = false;
//       });
//       print("Error processing file: $e");
//     }
//   }

//   Future<void> _saveAsDocx(String filePath, String content) async {
//     final docx = await DocxTemplate.fromBytes(File(filePath).readAsBytesSync());
//     final docGenerated = await docx.generate(content);
//     if (docGenerated != null) {
//       File(filePath).writeAsBytesSync(docGenerated);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('EcoFont Converter')),
//       body: Center(
//         child: _isProcessing
//             ? SpinKitFadingCircle(color: Colors.green, size: 50.0)
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     _fileName == null
//                         ? 'Upload a file to optimize'
//                         : 'File: $_fileName',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _pickFile,
//                     child: Text('Select File'),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }

// class SummaryScreen extends StatelessWidget {
//   final String fileName;
//   final double inkSaved;
//   final int pagesSaved;
//   final String optimizedFilePath;

//   SummaryScreen(
//       this.fileName, this.inkSaved, this.pagesSaved, this.optimizedFilePath);

//   void _shareFile() {
//     Share.shareFiles([optimizedFilePath],
//         text: 'Check out this optimized document that saves ink and paper!');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Optimization Summary')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('File: $fileName', style: TextStyle(fontSize: 18)),
//             SizedBox(height: 20),
//             Text('Ink Saved: $inkSaved%',
//                 style: TextStyle(fontSize: 18, color: Colors.green)),
//             Text('Pages Saved: $pagesSaved',
//                 style: TextStyle(fontSize: 18, color: Colors.blue)),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _shareFile,
//               child: Text('Share Optimized File'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Back to Upload'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
