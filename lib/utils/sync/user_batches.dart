import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/models/user_batch.dart';

updateSyncStatusUserBatches(
    Map<String, bool> jsonResult, Box<UserBatchModel> box) async {
  for (String itemID in jsonResult.keys) {
    for (int key in box.keys) {
      var existingData = box.get(key);
      if (existingData != null && existingData.batchID == itemID) {
        existingData.synced = true;
        await box.put(key, existingData);
        break;
      }
    }
  }
}

downSyncUserBatches(Map<String, dynamic> jsonResult, String key,
    Box<UserBatchModel> box) async {
  for (var itm in jsonResult['data'][key]) {
    bool exists =
        box.values.where((i) => i.batchID == itm['batchID']).isNotEmpty;
    if (exists) {
      for (int key in box.keys) {
        var existingData = box.get(key);
        if (existingData != null && existingData.batchID == itm['batchID']) {
          existingData.batchName = itm['batchName'];
          existingData.status = itm['status'];
          existingData.createdDate = int.tryParse(itm['createdDate']) ?? 0;
          existingData.createdBy = itm['createdBy'];
          existingData.modifiedDate = int.tryParse(itm['modifiedDate']) ?? 0;
          existingData.modifiedBy = itm['modifiedBy'];
          existingData.synced = true;

          await box.put(key, existingData);
          break;
        }
      }
    } else {
      await box.add(UserBatchModel(
          batchID: itm['batchID'],
          batchName: itm['batchName'],
          createdDate: int.tryParse(itm['createdDate']) ?? 0,
          createdBy: itm['createdBy'],
          modifiedDate: int.tryParse(itm['modifiedDate']) ?? 0,
          modifiedBy: itm['modifiedBy'],
          status: itm['status'],
          synced: true));
    }
  }
}
