import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/screens/book_sale.dart';

ValueNotifier<List<BookSale>> purchaseNotifier = ValueNotifier([]);

Future<void> addBookSale(BookSale value) async {
  // final purchaseDB = await Hive.openBox<BookSale>('purchase_db');
  // await purchaseDB.add(value);
  // updateBookSaleList();
}

Future<void> deleteBookSale(int id) async {
  // final purchaseDB = await Hive.openBox<BookSale>('purchase_db');
  // await purchaseDB.delete(id);
  // updateBookSaleList();
}

void updateBookSaleList() async {
  // final purchaseDB = await Hive.openBox<BookSale>('purchase_db');
  // purchaseDB.values.forEach(
  //   (element) {
  //     print(jsonEncode(element));
  //   },
  // );
  // purchaseNotifier.value.clear();
  // purchaseNotifier.value.addAll(purchaseDB.values);
  // purchaseNotifier.notifyListeners();
}
