import 'dart:io';
// import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class FileExporter {
  /// Generate optimized PDF
  static Future<File> createOptimizedPDF(String text) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              text,
              style: pw.TextStyle(fontSize: 10), // Small font to save ink
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
}
