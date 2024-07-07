import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/models/book_purchase.dart';

ValueNotifier<List<BookPurchaseModel>> purchaseNotifier = ValueNotifier([]);

Future<void> addBookPurchase(String publisherID, String purchaseDate,
    String bookID, String bookPrice, String quantity) async {
  String purchaseID = DateTime.now().millisecondsSinceEpoch.toString();
  String createdDate = '';
  String modifiedDate = '';

  final db = await Hive.openBox<BookPurchaseModel>('book_purchase_db');
  await db.add(BookPurchaseModel(
      purchaseID: purchaseID,
      publisherID: publisherID,
      purchaseDate: purchaseDate,
      bookID: bookID,
      quantity: quantity,
      bookPrice: bookPrice,
      createdDate: createdDate,
      modifiedDate: modifiedDate));
  updatePurchaseList();
}

void updatePurchaseList() async {
  final db = await Hive.openBox<BookPurchaseModel>('book_purchase_db');
  purchaseNotifier.value = db.values.toList();
  purchaseNotifier.notifyListeners();
}
