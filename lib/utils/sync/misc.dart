import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/models/misc.dart';

updateSyncStatusMisc(Map<String, bool> jsonResult, Box<MiscModel> box) async {
  for (String itemID in jsonResult.keys) {
    for (int key in box.keys) {
      var existingData = box.get(key);
      if (existingData != null && existingData.itemKey == itemID) {
        existingData.synced = true;
        await box.put(key, existingData);
        break;
      }
    }
  }
}

downSyncMisc(
    Map<String, dynamic> jsonResult, String key, Box<MiscModel> box) async {
  for (var itm in jsonResult['data'][key]) {
    bool exists =
        box.values.where((i) => i.itemKey == itm['itemKey']).isNotEmpty;
    if (exists) {
      for (int key in box.keys) {
        var existingData = box.get(key);
        if (existingData != null && existingData.itemKey == itm['itemKey']) {
          existingData.itemValue = itm['itemValue'];
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
      await box.add(MiscModel(
          itemKey: itm['itemKey'],
          itemValue: itm['itemValue'],
          createdDate: int.tryParse(itm['createdDate']) ?? 0,
          createdBy: itm['createdBy'],
          modifiedDate: int.tryParse(itm['modifiedDate']) ?? 0,
          modifiedBy: itm['modifiedBy'],
          synced: true));
    }
  }
}
