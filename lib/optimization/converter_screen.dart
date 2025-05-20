import 'dart:io';
import 'package:flutter/material.dart';
import 'ai_converter.dart';

class ConverterScreen extends StatefulWidget {
  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  String extractedText = "No file selected";
  int wordsSaved = 0;
  double percentageSaved = 0.0;
  File? optimizedFile;

  Future<void> convertFile() async {
    File? file = await AIConverter.pickFile();
    if (file == null) return;

    String text = file.path.endsWith(".pdf")
        ? await AIConverter.extractTextFromPDF(file)
        : await AIConverter.extractTextFromDocx(file);

    var optimizedData = AIConverter.optimizeText(text);
    File pdfFile = await AIConverter.createOptimizedPDF(optimizedData["text"]);

    setState(() {
      extractedText = optimizedData["text"];
      wordsSaved = optimizedData["wordsSaved"];
      percentageSaved = optimizedData["percentageSaved"];
      optimizedFile = pdfFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Eco-Friendly Text Optimizer")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                "Words Saved: $wordsSaved (${percentageSaved.toStringAsFixed(2)}%)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(extractedText, textAlign: TextAlign.center),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: convertFile,
              child: Text("Select & Optimize File"),
            ),
            if (optimizedFile != null) ...[
              ElevatedButton(
                onPressed: () => AIConverter.shareFile(optimizedFile!),
                child: Text("Share Optimized PDF"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'ai_converter.dart';

// class ConverterScreen extends StatefulWidget {
//   @override
//   _ConverterScreenState createState() => _ConverterScreenState();
// }

// class _ConverterScreenState extends State<ConverterScreen> {
//   String extractedText = "No file selected";
//   File? optimizedFile;

//   Future<void> convertFile() async {
//     File? file = await AIConverter.pickFile();
//     if (file == null) return;

//     String text = file.path.endsWith(".pdf")
//         ? await AIConverter.extractTextFromPDF(file)
//         : await AIConverter.extractTextFromDocx(file);

//     String optimizedText = AIConverter.optimizeText(text);
//     File pdfFile = await AIConverter.createOptimizedPDF(optimizedText);

//     setState(() {
//       extractedText = optimizedText;
//       optimizedFile = pdfFile;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Eco-Friendly Text Optimizer")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(extractedText, textAlign: TextAlign.center),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: convertFile,
//               child: Text("Select & Optimize File"),
//             ),
//             if (optimizedFile != null)
//               ElevatedButton(
//                 onPressed: () {
//                   // Implement file saving or sharing
//                 },
//                 child: Text("Download Optimized PDF"),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
