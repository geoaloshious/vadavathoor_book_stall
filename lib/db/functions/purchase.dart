import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/db/models/purchase.dart';
import 'package:hive_flutter/hive_flutter.dart';

ValueNotifier<List<PurchaseModel>> purchaseNotifier = ValueNotifier([]);

Future<void> addBookPurchase(PurchaseModel value) async {
  final purchaseDB = await Hive.openBox<PurchaseModel>('purchase_db');
  await purchaseDB.add(value);
  updatePurchaseList();
}

Future<void> deleteBookPurchase(int id) async {
  final purchaseDB = await Hive.openBox<PurchaseModel>('purchase_db');
  await purchaseDB.delete(id);
  updatePurchaseList();
}

void updatePurchaseList() async {
  final purchaseDB = await Hive.openBox<PurchaseModel>('purchase_db');
  purchaseDB.values.forEach(
    (element) {
      print(jsonEncode(element));
    },
  );
  purchaseNotifier.value.clear();
  purchaseNotifier.value.addAll(purchaseDB.values);
  purchaseNotifier.notifyListeners();
}
