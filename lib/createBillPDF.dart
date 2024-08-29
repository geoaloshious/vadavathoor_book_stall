import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vadavathoor_book_stall/db/constants.dart';
import 'db/functions/utils.dart';

Future<String> createPDF({
  required String stallName,
  required String stallAddress,
  required String stallPhone,
  required List<Map<String, dynamic>> books,
  required String customerName,
  required String salesPerson, // Include salesPerson here
  required String billNo,
  required String date,
  required String category,
}) async {
  final pdf = pw.Document();

  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a5.copyWith(
          marginTop: 10, marginLeft: 10, marginRight: 10, marginBottom: 10),
      build: (pw.Context context) {
        return pw.Column(children: [
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

          // Bill No. and Date in a Row
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Bill No: $billNo',
                          style: const pw.TextStyle(
                              color: PdfColors.lightBlue900)),
                    ]),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Date: $date',
                          style:
                              const pw.TextStyle(color: PdfColors.lightBlue900))
                    ])
              ]),
          pw.SizedBox(height: 10),

          // To and Category in a Row
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('To: $customerName',
                          style: const pw.TextStyle(
                              color: PdfColors.lightBlue900)),
                    ]),
                pw.Row(children: [
                  pw.Text('Category ',
                      style: const pw.TextStyle(color: PdfColors.lightBlue900)),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(4),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.lightBlue900),
                    ),
                    child: pw.Text(category,
                        style:
                            const pw.TextStyle(color: PdfColors.lightBlue900)),
                  )
                ])
              ]),
          pw.SizedBox(height: 10),

          // Table
          pw.Table(
            border: const pw.TableBorder(
              horizontalInside: pw.BorderSide(color: PdfColors.lightBlue900),
              verticalInside: pw.BorderSide(color: PdfColors.lightBlue900),
              top: pw.BorderSide(color: PdfColors.lightBlue900),
              bottom: pw.BorderSide(color: PdfColors.lightBlue900),
              left: pw.BorderSide(color: PdfColors.lightBlue900),
              right: pw.BorderSide(color: PdfColors.lightBlue900),
            ),
            children: [
              // Header Row
              pw.TableRow(children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text('Quantity',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.lightBlue900)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text('Particular',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.lightBlue900)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text('Category',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.lightBlue900)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text('Rate',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.lightBlue900)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text('Discount %',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.lightBlue900)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text('Amount',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.lightBlue900)),
                ),
              ]),
              // Data Rows
              for (var book in books)
                pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('${book['quantity']}',
                        style:
                            const pw.TextStyle(color: PdfColors.lightBlue900)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('${book['name']}',
                        style:
                            const pw.TextStyle(color: PdfColors.lightBlue900)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('${book['category']}',
                        style:
                            const pw.TextStyle(color: PdfColors.lightBlue900)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('${book['original_price']}',
                        style:
                            const pw.TextStyle(color: PdfColors.lightBlue900)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('${book['discount']}%',
                        style:
                            const pw.TextStyle(color: PdfColors.lightBlue900)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('${book['amount']}',
                        style:
                            const pw.TextStyle(color: PdfColors.lightBlue900)),
                  ),
                ]),
            ],
          ),

          // Grand Total Calculation
          pw.SizedBox(height: 10),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
            pw.Text(
              'Grand Total: Rs.${books.fold(0.0, (total, book) => total + ((int.tryParse(book['amount']) ?? 0) * book['quantity']))}',
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.lightBlue900),
            )
          ]),
          pw.SizedBox(height: 10),

          // Name and Sign Fields
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(children: [
                    pw.Text('Name :',
                        style:
                            const pw.TextStyle(color: PdfColors.lightBlue900))
                  ]),
                  pw.SizedBox(height: 10),
                  pw.Row(children: [
                    pw.Text('Sign :',
                        style:
                            const pw.TextStyle(color: PdfColors.lightBlue900))
                  ])
                ]),
            pw.SizedBox(width: 10),
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(salesPerson,
                      style: const pw.TextStyle(color: PdfColors.lightBlue900)),
                  pw.SizedBox(height: 10),
                  pw.Text('____________',
                      style: const pw.TextStyle(color: PdfColors.lightBlue900))
                ])
          ])
        ]);
      }));

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

void saveAndOpenPDF(String customerName, String salesPerson, String billNo,
    String date, String category) async {
  final bookStallName = await readMiscValue(MiscDBKeys.bookStallName);
  final bookStallAddress = await readMiscValue(MiscDBKeys.bookStallAdress);
  final bookStallPhoneNumber =
      await readMiscValue(MiscDBKeys.bookStallPhoneNumber);

  String filePath = await createPDF(
      books: [
        {
          'name': 'Abcd',
          'original_price': 100,
          'discount': '10',
          'quantity': 10,
          'category': 'Theology',
          'amount': '90'
        },
        {
          'name': 'Abcd',
          'original_price': 100,
          'discount': '10',
          'quantity': 10,
          'category': 'Theology',
          'amount': '90'
        },
        {
          'name': 'Abcd',
          'original_price': 100,
          'discount': '10',
          'quantity': 10,
          'category': 'Theology',
          'amount': '90'
        },
        {
          'name': 'Abcd',
          'original_price': 100,
          'discount': '10',
          'quantity': 10,
          'category': 'Theology',
          'amount': '90'
        },
        {
          'name': 'Abcd',
          'original_price': 100,
          'discount': '10',
          'quantity': 10,
          'category': 'Theology',
          'amount': '90'
        }
      ],
      customerName: customerName,
      salesPerson: salesPerson, // Pass the salesperson name here
      stallAddress: bookStallAddress,
      stallName: bookStallName,
      stallPhone: bookStallPhoneNumber,
      billNo: billNo,
      date: date,
      category: category);

  print('PDF saved at: $filePath');
  Process.run('open', ['-a', 'Google Chrome', filePath]);
}
