import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vadavathoor_book_stall/db/constants.dart';
import 'package:vadavathoor_book_stall/db/functions/stationary_item.dart';
import 'package:vadavathoor_book_stall/db/functions/stationary_purchase.dart';
import 'package:vadavathoor_book_stall/db/functions/user_batch.dart';
import 'package:vadavathoor_book_stall/db/models/users.dart';
import 'package:vadavathoor_book_stall/utils/logger.dart';
import 'package:vadavathoor_book_stall/utils/utils.dart';
import '../db/functions/book.dart';
import '../db/functions/book_purchase.dart';
import '../db/functions/sales.dart';
import '../db/functions/users.dart';
import '../db/functions/utils.dart';
import '../db/models/sales.dart';

Future<String> createPDF({
  required List<Map<String, dynamic>> books,
  required String customerName,
  required String customerBatch,
  required String salesPerson,
  required String billNo,
  required String paymentMode,
  required String date,
}) async {
  final stallName = await readMiscValue(MiscDBKeys.bookStallName);
  final stallAddress = await readMiscValue(MiscDBKeys.bookStallAdress);
  final stallPhone = await readMiscValue(MiscDBKeys.bookStallPhoneNumber);
  final bankName = await readMiscValue(MiscDBKeys.bankName);
  final bankAccountNo = await readMiscValue(MiscDBKeys.bankAccountNo);
  final bankBranch = await readMiscValue(MiscDBKeys.bankBranch);
  final bankIFSC = await readMiscValue(MiscDBKeys.bankIFSC);

  final grandTotal = books.fold(
      0.0, (total, book) => total + (book['soldPrice'] * book['quantity']));

  final pdf = pw.Document();

  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a5.landscape.copyWith(
          marginTop: 10, marginLeft: 10, marginRight: 10, marginBottom: 10),
      build: (pw.Context context) => [
            pw.Column(children: [
              pw.Text(stallName,
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold)),
              pw.Text(stallAddress, style: const pw.TextStyle(fontSize: 9)),
              pw.Text('Phone: $stallPhone',
                  style: const pw.TextStyle(fontSize: 9)),
              pw.SizedBox(height: 6),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Bill No: $billNo',
                        style: const pw.TextStyle(fontSize: 9)),
                    pw.Text('Payment : ${getPaymentModeName(paymentMode)}',
                        style: const pw.TextStyle(fontSize: 9)),
                    pw.Text('Date: $date',
                        style: const pw.TextStyle(fontSize: 9))
                  ]),
              pw.SizedBox(height: 4),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('To: $customerName',
                        style: const pw.TextStyle(fontSize: 9)),
                    pw.Container(
                        padding: const pw.EdgeInsets.all(4),
                        decoration: pw.BoxDecoration(border: pw.Border.all()),
                        child: pw.Text(customerBatch,
                            style: const pw.TextStyle(fontSize: 9)))
                  ]),
              pw.SizedBox(height: 4),
              pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.black),
                  children: [
                    pw.TableRow(children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(2.0),
                          child: pw.Text('SlNo',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 9))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(2.0),
                          child: pw.Text('Qty.',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 9))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(2.0),
                          child: pw.Text('Particular',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 9))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(2.0),
                          child: pw.Text('MRP',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 9))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(2.0),
                          child: pw.Text('Discount %',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 9))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(2.0),
                          child: pw.Text('Amount',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 9))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(2.0),
                          child: pw.Text('Total',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 9)))
                    ]),
                    for (int i = 0; i < books.length; i++) //
                      pw.TableRow(children: [
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text('${i + 1}',
                                style: const pw.TextStyle(fontSize: 9))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text('${books[i]['quantity']}',
                                style: const pw.TextStyle(fontSize: 9))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text('${books[i]['name']}',
                                style: const pw.TextStyle(fontSize: 9))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text('${books[i]['original_price']}',
                                style: const pw.TextStyle(fontSize: 9))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text('${books[i]['discount']}%',
                                style: const pw.TextStyle(fontSize: 9))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text('${books[i]['soldPrice']}',
                                style: const pw.TextStyle(fontSize: 9))),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                                '${books[i]['soldPrice'] * books[i]['quantity']}',
                                style: const pw.TextStyle(fontSize: 9)))
                      ])
                  ]),
              pw.SizedBox(height: 6),
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                          pw.Text('Total quantity : ${books.length}',
                              style: const pw.TextStyle(fontSize: 9)),
                          pw.SizedBox(height: 6),
                          pw.Text('BANK DETAILS',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 9)),
                          pw.SizedBox(height: 2),
                          pw.Text('Bank Name : $bankName, $bankBranch',
                              style: const pw.TextStyle(fontSize: 9)),
                          pw.SizedBox(height: 2),
                          pw.Text('Account No : $bankAccountNo',
                              style: const pw.TextStyle(fontSize: 9)),
                          pw.SizedBox(height: 2),
                          pw.Text('IFSC Code : $bankIFSC',
                              style: const pw.TextStyle(fontSize: 9)),
                          pw.SizedBox(height: 6),
                          pw.Text('In Words :',
                              style: const pw.TextStyle(fontSize: 9)),
                          pw.Text(
                              '${numberToWords(grandTotal.toInt())} Rupees Only',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 9))
                        ])),
                    pw.Column(children: [
                      pw.Padding(
                          child: pw.Text('Grand Total:   Rs. $grandTotal',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 9)),
                          padding:
                              const pw.EdgeInsets.only(top: 5, bottom: 10)),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Row(children: [
                                    pw.Text('Name :',
                                        style: const pw.TextStyle(fontSize: 9))
                                  ]),
                                  pw.SizedBox(height: 8),
                                  pw.Row(children: [
                                    pw.Text('Sign :',
                                        style: const pw.TextStyle(fontSize: 9))
                                  ])
                                ]),
                            pw.SizedBox(width: 10),
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(salesPerson,
                                      style: const pw.TextStyle(fontSize: 9)),
                                  pw.SizedBox(height: 6),
                                  pw.Text('____________',
                                      style: const pw.TextStyle(fontSize: 9))
                                ])
                          ])
                    ])
                  ])
            ])
          ]));

  Directory? directory;

  if (Platform.isWindows) {
    directory = await getDownloadsDirectory();
  } else {
    directory = await getApplicationDocumentsDirectory();
  }

  if (directory == null) {
    throw Exception('Could not get Downloads directory');
  }

  final filePath = '${directory.path}/sale_bill_$billNo.pdf';
  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());

  return filePath;
}

Future<void> openPdfWithDefaultApp(String filePath) async {
  try {
    ProcessResult result;

    if (Platform.isWindows) {
      result = await Process.run('cmd', ['/c', 'start', '', filePath]);
    } else if (Platform.isMacOS) {
      result = await Process.run('open', [filePath]);
    } else if (Platform.isLinux) {
      result = await Process.run('xdg-open', [filePath]);
    } else {
      throw UnsupportedError('Unsupported platform for opening PDF');
    }

    if (result.exitCode != 0) {
      writeToLog(
          'Error opening PDF on ${Platform.operatingSystem}: ${result.stderr}');
    }
  } catch (e) {
    writeToLog('Failed to open PDF: $e');
  }
}

void saveAndOpenPDF(String saleID) async {
  final salesDB = (await getSalesBox()).values.toList();
  final bookDB = (await getBooksBox()).values.toList();
  final bookPurchaseDB = (await getBookPurchaseBox()).values.toList();
  final stationaries = (await getStationaryItemBox()).values.toList();
  final stationaryPurchaseDB =
      (await getStationaryPurchaseBox()).values.toList();
  final userDB = (await getUsersBox()).values.toList();
  final userBatches = (await getUserBatchBox()).values.toList();

  SaleModel sale = salesDB.firstWhere((s) => s.saleID == saleID);
  List<Map<String, dynamic>> items = [];

  for (SaleItemModel sb in sale.books) {
    for (SaleItemPurchaseVariantModel pv in sb.purchaseVariants) {
      final op = bookPurchaseDB
          .firstWhere((p) => p.purchaseID == pv.purchaseID)
          .bookPrice;

      final discount = 100 - ((pv.soldPrice / op) * 100);

      items.add({
        'name': bookDB.firstWhere((b) => b.bookID == sb.itemID).bookName,
        'original_price': op,
        'soldPrice': pv.soldPrice,
        'quantity': pv.quantity,
        'discount': discount
      });
    }
  }

  for (SaleItemModel ss in sale.stationaryItems) {
    for (SaleItemPurchaseVariantModel pv in ss.purchaseVariants) {
      final op = stationaryPurchaseDB
          .firstWhere((p) => p.purchaseID == pv.purchaseID)
          .price;

      final discount = 100 - ((pv.soldPrice / op) * 100);

      items.add({
        'name': stationaries.firstWhere((b) => b.itemID == ss.itemID).itemName,
        'original_price': op,
        'soldPrice': pv.soldPrice,
        'quantity': pv.quantity,
        'discount': discount
      });
    }
  }

  UserModel salesPerson = userDB.firstWhere((u) => u.userID == sale.createdBy);

  String filePath = await createPDF(
      books: items,
      customerName: userDB.firstWhere((u) => u.userID == sale.customerID).name,
      customerBatch: userBatches
          .firstWhere((u) => u.batchID == sale.customerBatchID)
          .batchName,
      salesPerson: salesPerson.name,
      billNo: saleID,
      paymentMode: sale.paymentMode,
      date: formatTimestamp(timestamp: sale.createdDate));

  openPdfWithDefaultApp(filePath);
}
