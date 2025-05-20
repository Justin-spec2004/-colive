import 'dart:io';
import 'package:docx_template/docx_template.dart';
import 'package:flutter_pdf_text/flutter_pdf_text.dart';

class AIConverter {
  /// Extract text from DOCX
  static Future<String> extractTextFromDocx(File file) async {
    final bytes = await file.readAsBytes();
    final docx = await DocxTemplate.fromBytes(bytes);

    // Convert document content to text
    String extractedText = docx.toString();

    return extractedText;
  }

  /// AI Optimization: Convert fonts and adjust spacing
  static String optimizeText(String text) {
    return text.replaceAll("  ", " ").trim(); // Example optimization
  }
}

class PDFReader {
  /// Extract text from PDF
  static Future<String> extractTextFromPDF(File file) async {
    final pdfDoc = await PDFDoc.fromFile(
        file); // ✅ FIXED: Use PDFDoc instead of PDFDocument
    return await pdfDoc.text; // Extracts text from PDF
  }
}
