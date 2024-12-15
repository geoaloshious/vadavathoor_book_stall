import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/models/stationary_purchase.dart';

updateSyncStatusStationaryPurchases(
    Map<String, bool> jsonResult, Box<StationaryPurchaseModel> box) async {
  for (String itemID in jsonResult.keys) {
    for (int key in box.keys) {
      var existingData = box.get(key);
      if (existingData != null && existingData.itemID == itemID) {
        existingData.synced = true;
        await box.put(key, existingData);
        break;
      }
    }
  }
}

downSyncStationaryPurchases(Map<String, dynamic> jsonResult, String key,
    Box<StationaryPurchaseModel> box) async {
  for (var itm in jsonResult['data'][key]) {
    bool exists =
        box.values.where((i) => i.purchaseID == itm['purchaseID']).isNotEmpty;
    if (exists) {
      for (int key in box.keys) {
        var existingData = box.get(key);
        if (existingData != null &&
            existingData.purchaseID == itm['purchaseID']) {
          existingData.purchaseDate = int.tryParse(itm['purchaseDate']) ?? 0;
          existingData.itemID = itm['itemID'];
          existingData.price = double.tryParse(itm['price']) ?? 0;
          existingData.quantityPurchased = itm['quantityPurchased'];
          existingData.quantityLeft = itm['quantityLeft'];
          existingData.createdDate = int.tryParse(itm['createdDate']) ?? 0;
          existingData.createdBy = itm['createdBy'];
          existingData.modifiedDate = int.tryParse(itm['modifiedDate']) ?? 0;
          existingData.modifiedBy = itm['modifiedBy'];
          existingData.status = itm['status'];
          existingData.synced = true;

          await box.put(key, existingData);
          break;
        }
      }
    } else {
      await box.add(StationaryPurchaseModel(
          purchaseID: itm['purchaseID'],
          purchaseDate: int.tryParse(itm['purchaseDate']) ?? 0,
          itemID: itm['itemID'],
          price: double.tryParse(itm['price']) ?? 0,
          quantityPurchased: itm['quantityPurchased'],
          quantityLeft: itm['quantityLeft'],
          createdDate: int.tryParse(itm['createdDate']) ?? 0,
          createdBy: itm['createdBy'],
          modifiedDate: int.tryParse(itm['modifiedDate']) ?? 0,
          modifiedBy: itm['modifiedBy'],
          status: itm['status'],
          synced: true));
    }
  }
}
