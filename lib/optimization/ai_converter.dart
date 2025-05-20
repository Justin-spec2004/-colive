// import 'dart:io' as io; // For File handling
// import 'package:file_picker/file_picker.dart'; // For picking files
// import 'package:pdf/widgets.dart' as pw; // For PDF generation
// import 'package:path_provider/path_provider.dart'; // For accessing file storage
// import 'package:pdfx/pdfx.dart' as pdfx_lib; // For working with PDF files
// import 'package:flutter_document_reader_api/flutter_document_reader_api.dart'; // For DOCX reading

// class AIConverter {
//   /// Pick a file (PDF or DOCX)
//   static Future<io.File?> pickFile() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf', 'docx'],
//       );

//       if (result != null &&
//           result.files.isNotEmpty &&
//           result.files.single.path != null) {
//         print("File path: ${result.files.single.path}"); // Debugging info
//         return io.File(
//             result.files.single.path!); // Directly return the File object
//       } else {
//         print("No file selected or file path is null.");
//         return null;
//       }
//     } catch (e) {
//       print("Error picking file: $e");
//       return null;
//     }
//   }

/// Extract text from a PDF using pdfx_lib
// static Future<String> extractTextFromPDF(File file) async {
//   try {
//     pdfx_lib.PdfDocument doc = await pdfx_lib.PdfDocument.openFile(file.path);
//     String text = ""; // To store extracted text

//     // Iterate through all pages
//     for (int i = 1; i <= doc.pagesCount; i++) {
//       final page = await doc.getPage(i);

//       // Updated: Use render to image for text extraction as pdfx_lib doesn't support text
//       final pageRender = await page.render(width: 1080, height: 1920);
//       text += pageRender.text ?? ""; // Ensure text is extracted safely
//       await page.close(); // Release resources
//     }

//     return text.isNotEmpty ? text : "No text found in the PDF.";
//   } catch (e) {
//     return "Error extracting text from PDF: $e";
//   }
// }
//   static Future<String> extractTextFromPDF(io.File file) async {
//     try {
//       // Load the PDF document
//       pdfx_lib.PdfDocument pdfDoc =
//           await pdfx_lib.PdfDocument.openFile(file.path);

//       // Extract text from the document
//       String text = ""; // To store extracted text

//       // Iterate through all pages
//       for (int i = 1; i <= pdfDoc.pagesCount; i++) {
//         final page = await pdfDoc.getPage(i);
//         final pageImage = await page.render(
//             width: 1080, height: 1920); // Render the page as an image
//         // Note: Text extraction from images requires OCR, which is not supported by pdfx.
//         text +=
//             "[Text extraction from images is not supported]"; // Placeholder text
//         await page.close(); // Release resources
//       }

//       return text.isNotEmpty ? text : "No text found in the PDF.";
//     } catch (e) {
//       return "Error extracting text from PDF: $e";
//     }
//   }

//   /// Extract text from a DOCX file using flutter_document_reader_api
//   static Future<String> extractTextFromDocx(io.File file) async {
//     try {
//       final reader =
//           DocumentReader.instance; // Initialize the reader using instance
//       String text = await reader.readFile(file.path); // Read text
//       return text.isNotEmpty ? text : "No text found in the DOCX file.";
//     } catch (e) {
//       return "Error extracting text from DOCX: $e";
//     }
//   }

//   /// Optimize text for eco-friendly printing
//   static String optimizeText(String text) {
//     // Basic optimization: Replace double spaces and trim
//     return text.replaceAll("  ", " ").trim();
//   }

//   /// Generate an optimized PDF for eco-friendly printing
//   static Future<io.File> createOptimizedPDF(String text) async {
//     try {
//       final pdf = pw.Document();
//       pdf.addPage(
//         pw.Page(
//           build: (pw.Context context) {
//             return pw.Center(
//               child: pw.Text(
//                 text,
//                 style: pw.TextStyle(
//                   fontSize: 10, // Small font size to save ink
//                 ),
//               ),
//             );
//           },
//         ),
//       );

//       // Save the file to the application's documents directory
//       final output = await getApplicationDocumentsDirectory();
//       final file = io.File('${output.path}/optimized_document.pdf');

//       // Write PDF data to the file
//       await file.writeAsBytes(await pdf.save(),
//           flush: true); // Ensure data integrity
//       return await file;
//     } catch (e) {
//       throw Exception("Error creating optimized PDF: $e");
//     }
//   }
// }

//FIX ERROR

// import 'dart:io'; // For File handling
// import 'package:file_picker/file_picker.dart'; // For picking files
// import 'package:pdf/widgets.dart' as pw; // For PDF generation
// import 'package:path_provider/path_provider.dart'; // For accessing file storage
// import 'package:pdfx/pdfx.dart' as pdfx_lib; // For working with PDF files
// import 'package:flutter_document_reader_api/flutter_document_reader_api.dart'; // For DOCX reading

// class AIConverter {
//   /// Pick a file (PDF or DOCX)
//   static Future<File?> pickFile() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf', 'docx'],
//       );

//       if (result != null && result.files.single.path != null) {
//         return File(
//             result.files.single.path!); // Correct usage: only 1 argument
//       } else {
//         return null; // No file selected
//       }
//     } catch (e) {
//       print("Error picking file: $e");
//       return null;
//     }
//   }

//   /// Extract text from a PDF using pdfx_lib
//   static Future<String> extractTextFromPDF(File file) async {
//     try {
//       pdfx_lib.PdfDocument doc =
//           await pdfx_lib.PdfDocument.openFile(file.path!);
//       String text = ""; // To store extracted text

//       // Iterate through all pages
//       for (int i = 1; i <= doc.pagesCount; i++) {
//         final page = await doc.getPage(i);
//         final pageText = await page
//             .renderText(); // Extract text from the page using renderText
//         text += pageText.text ?? ""; // Add to text, if not null
//         await page.close(); // Release resources
//       }

//       return text.isNotEmpty ? text : "No text found in the PDF.";
//     } catch (e) {
//       return "Error extracting text from PDF: $e";
//     }
//   }

//   /// Extract text from a DOCX file using flutter_document_reader_api
//   static Future<String> extractTextFromDocx(File file) async {
//     try {
//       final reader = DocumentReader
//           .instance(); // Initialize the reader using a named constructor
//       String text = await reader.readTextFromFile(file.path); // Read text
//       return text.isNotEmpty ? text : "No text found in the DOCX file.";
//     } catch (e) {
//       return "Error extracting text from DOCX: $e";
//     }
//   }

//   /// Optimize text for eco-friendly printing
//   static String optimizeText(String text) {
//     // Basic optimization: Replace double spaces and trim
//     return text.replaceAll("  ", " ").trim();
//   }

//   /// Generate an optimized PDF for eco-friendly printing
//   static Future<File> createOptimizedPDF(String text) async {
//     try {
//       final pdf = pw.Document();
//       pdf.addPage(
//         pw.Page(
//           build: (pw.Context context) {
//             return pw.Center(
//               child: pw.Text(
//                 text,
//                 style: pw.TextStyle(
//                   fontSize: 10, // Small font size to save ink
//                 ),
//               ),
//             );
//           },
//         ),
//       );

//       // Save the file to the application's documents directory
//       final output = await getApplicationDocumentsDirectory();
//       final file = File('${output.path}/optimized_document.pdf');

//       // Write PDF data to the file
//       await file.writeAsBytes(await pdf.save());
//       return file;
//     } catch (e) {
//       throw Exception("Error creating optimized PDF: $e");
//     }
//   }
// }

//SECOND SITUATION

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class AIConverter {
  /// Pick a file (PDF or DOCX)
  static Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'],
    );

    if (result != null) {
      return File(result.files.single.path!);
    } else {
      return null;
    }
  }

  /// Extract text from PDF (Dummy implementation for now)
  static Future<String> extractTextFromPDF(File file) async {
    return "This is a sample extracted text from the PDF file. It contains extra spaces and unnecessary words.";
  }

  /// Extract text from DOCX (Dummy implementation for now)
  static Future<String> extractTextFromDocx(File file) async {
    return "This is a sample extracted text from the DOCX file. It also has unnecessary spaces and words.";
  }

  /// Optimize text & calculate savings
  static Map<String, dynamic> optimizeText(String text) {
    int originalWordCount = text.split(RegExp(r"\s+")).length;
    String optimizedText = text.replaceAll(RegExp(r"\s+"), " ").trim();
    int optimizedWordCount = optimizedText.split(" ").length;

    int wordsSaved = originalWordCount - optimizedWordCount;
    double percentageSaved = (wordsSaved / originalWordCount) * 100;

    return {
      "text": optimizedText,
      "wordsSaved": wordsSaved,
      "percentageSaved": percentageSaved
    };
  }

  /// Generate optimized PDF
  static Future<File> createOptimizedPDF(String text) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              text,
              style: pw.TextStyle(
                fontSize: 10, // Small font size to save ink
              ),
            ),
          );
        },
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/optimized_document.pdf");
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  /// Share the optimized PDF
  static Future<void> shareFile(File file) async {
    await Share.shareXFiles([XFile(file.path)],
        text: "Download your optimized document!");
  }
}
