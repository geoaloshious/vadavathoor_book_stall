import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/models/book_purchase.dart';

downSyncBookPurchases(Map<String, dynamic> jsonResult, String key,
    Box<BookPurchaseModel> box) async {
  for (var itm in jsonResult['data'][key]) {
    bool exists =
        box.values.where((i) => i.purchaseID == itm['purchaseID']).isNotEmpty;
    if (exists) {
      for (int key in box.keys) {
        var existingData = box.get(key);
        if (existingData != null &&
            existingData.purchaseID == itm['purchaseID']) {
          existingData.purchaseDate = int.tryParse(itm['purchaseDate']) ?? 0;
          existingData.bookID = itm['bookID'];
          existingData.bookPrice = double.tryParse(itm['bookPrice']) ?? 0;
          existingData.quantityPurchased = itm['quantityPurchased'];
          existingData.quantityLeft = itm['quantityLeft'];
          existingData.createdDate = int.tryParse(itm['createdDate']) ?? 0;
          existingData.createdBy = itm['createdBy'];
          existingData.modifiedDate = int.tryParse(itm['modifiedDate']) ?? 0;
          existingData.modifiedBy = itm['modifiedBy'];
          existingData.status = itm['status'];

          await box.put(key, existingData);
          break;
        }
      }
    } else {
      await box.add(BookPurchaseModel(
          purchaseID: itm['purchaseID'],
          purchaseDate: int.tryParse(itm['purchaseDate']) ?? 0,
          bookID: itm['bookID'],
          bookPrice: double.tryParse(itm['bookPrice']) ?? 0,
          quantityPurchased: itm['quantityPurchased'],
          quantityLeft: itm['quantityLeft'],
          createdDate: int.tryParse(itm['createdDate']) ?? 0,
          createdBy: itm['createdBy'],
          modifiedDate: int.tryParse(itm['modifiedDate']) ?? 0,
          modifiedBy: itm['modifiedBy'],
          status: itm['status']));
    }
  }
}
