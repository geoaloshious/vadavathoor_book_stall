import 'dart:typed_data';
import 'dart:io';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:url_launcher/url_launcher.dart';
import 'package:vadavathoor_book_stall/db/constants.dart';

import 'db/functions/utils.dart';

Future<String> createPDF({
  required String stallName,
  required String stallAddress,
  required String stallPhone,
  required List<Map<String, dynamic>> books,
  required String salesPerson,
  required String customerName,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a5.copyWith(
          marginTop: 10, marginLeft: 10, marginRight: 10, marginBottom: 10),
      build: (pw.Context context) {
        return pw.Column(
          children: [
            // Stall Information
            pw.Text(stallName,
                style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.lightBlue900)),
            pw.Text(stallAddress,
                style: const pw.TextStyle(
                    fontSize: 12, color: PdfColors.lightBlue900)),
            pw.Text('Phone: $stallPhone',
                style: const pw.TextStyle(
                    fontSize: 12, color: PdfColors.lightBlue900)),
            pw.SizedBox(height: 10),

            // Table Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Book Name',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.lightBlue900)),
                pw.Text('Original Price (Rs)',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.lightBlue900)),
                pw.Text('Discounted Price (Rs)',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.lightBlue900)),
                pw.Text('Quantity',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.lightBlue900)),
              ],
            ),
            pw.Divider(color: PdfColors.lightBlue900),

            // Table Rows
            for (var book in books)
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(book['name'],
                      style: const pw.TextStyle(color: PdfColors.lightBlue900)),
                  pw.Text('${book['original_price']}',
                      style: const pw.TextStyle(color: PdfColors.lightBlue900)),
                  pw.Text('${book['discounted_price']}',
                      style: const pw.TextStyle(color: PdfColors.lightBlue900)),
                  pw.Text((book['quantity'] as int).toString(),
                      style: const pw.TextStyle(color: PdfColors.lightBlue900)),
                ],
              ),
            pw.Divider(color: PdfColors.lightBlue900),

            // Grand Total Calculation
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  'Grand Total: Rs.${books.fold(0.0, (total, book) => total + ((int.tryParse(book['discounted_price']) ?? 0) * book['quantity']))}',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.lightBlue900),
                ),
              ],
            ),
            pw.SizedBox(height: 10),

            // Sales Person and Customer Name
            pw.Text('Sales Person: $salesPerson',
                style: const pw.TextStyle(
                    fontSize: 12, color: PdfColors.lightBlue900)),
            pw.Text('Customer Name: $customerName',
                style: const pw.TextStyle(
                    fontSize: 12, color: PdfColors.lightBlue900)),
          ],
        );
      },
    ),
  );
  // Get the Downloads directory
  final downloadsDirectory = await getApplicationDocumentsDirectory();

  // Ensure the directory exists
  if (downloadsDirectory == null) {
    throw Exception('Could not get Downloads directory');
  }

  // Save the PDF file
  final filePath = '${downloadsDirectory.path}/example.pdf';
  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());

  return filePath; // Return the file path
}

void saveAndOpenPDF(String customerName, String salesPerson) async {
  final bookStallName = await readMiscValue(MiscDBKeys.bookStallName);
  final bookStallAdress = await readMiscValue(MiscDBKeys.bookStallAdress);
  final bookStallPhoneNumber =
      await readMiscValue(MiscDBKeys.bookStallPhoneNumber);

  String filePath = await createPDF(
      books: [
        {
          'name': 'Abcd',
          'original_price': 100,
          'discounted_price': '90',
          'quantity': 10
        }
      ],
      customerName: customerName,
      salesPerson: salesPerson,
      stallAddress: bookStallAdress,
      stallName: bookStallName,
      stallPhone: bookStallPhoneNumber);
  print('PDF saved at: $filePath');
  Process.run('open', ['-a', 'Google Chrome', filePath]);
}
