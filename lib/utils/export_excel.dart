import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../classes.dart';

const salesHeadings = [
  'SlNo.',
  'Sale ID',
  'Customer name',
  'Books',
  'Created Date',
  'Grand Total',
  'Payment Mode'
];

const purchaseHeadings = [
  'SlNo.',
  'Purchase ID',
  'Book name',
  'Balance stock',
  'Quantity purchased',
  'Book price',
  'Purchase date'
];

void exportExcel(
    {required BuildContext context,
    List<SaleListItemModel>? sales,
    List<PurchaseListItemModel>? purchases}) async {
  Excel excel = Excel.createExcel();
  Sheet sheet = excel['Sheet1'];

  sheet.appendRow((sales != null ? salesHeadings : purchaseHeadings)
      .map((h) => TextCellValue(h))
      .toList());

  if (sales != null) {
    for (int i = 0; i < sales.length; i++) {
      sheet.appendRow([
        TextCellValue('${i + 1}'),
        TextCellValue(sales[i].saleID),
        TextCellValue(sales[i].customerName),
        TextCellValue(sales[i].books),
        TextCellValue(sales[i].createdDate),
        TextCellValue(sales[i].grandTotal.toString()),
        TextCellValue(sales[i].paymentMode),
      ]);
    }
  } else if (purchases != null) {
    for (int i = 0; i < purchases.length; i++) {
      sheet.appendRow([
        TextCellValue('${i + 1}'),
        TextCellValue(purchases[i].purchaseID),
        TextCellValue(purchases[i].itemName),
        TextCellValue('${purchases[i].balanceStock}'),
        TextCellValue('${purchases[i].quantityPurchased}'),
        TextCellValue('${purchases[i].price}'),
        TextCellValue(purchases[i].formattedPurchaseDate),
      ]);
    }
  }

  final fileName = '${sales != null ? 'sales' : 'purchases'}.xlsx';

  List<int>? fileBytes = excel.save(fileName: fileName);

  if (fileBytes != null) {
    Directory? directory;

    if (Platform.isWindows) {
      directory = await getDownloadsDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    if (directory == null) {
      throw Exception('Could not get Downloads directory');
    }

    File(join(directory.path, fileName))
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);

    _showSnackbar(context, directory.path);
  }
}

void _showSnackbar(BuildContext context, String filePath) {
  final snackBar = SnackBar(
      content: Text('File saved at $filePath'),
      action: SnackBarAction(
          label: 'Go to Folder',
          onPressed: () {
            _openFileExplorer(filePath);
          }),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16));

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void _openFileExplorer(String filePath) {
  if (Platform.isWindows) {
    Process.run('explorer', [filePath]);
  } else if (Platform.isMacOS) {
    Process.run('open', [filePath]);
  } else if (Platform.isAndroid) {
    Process.run('am', [
      'start',
      '-a',
      'android.intent.action.VIEW',
      '-d',
      'file://$filePath'
    ]);
  }
}
