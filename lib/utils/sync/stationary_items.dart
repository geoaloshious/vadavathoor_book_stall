import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/models/stationary_item.dart';

downSyncStationaryItems(Map<String, dynamic> jsonResult, String key,
    Box<StationaryItemModel> box) async {
  for (var itm in jsonResult['data'][key]) {
    bool exists = box.values.where((i) => i.itemID == itm['itemID']).isNotEmpty;
    if (exists) {
      for (int key in box.keys) {
        var existingData = box.get(key);
        if (existingData != null && existingData.itemID == itm['itemID']) {
          existingData.itemName = itm['itemName'];
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
      await box.add(StationaryItemModel(
          itemID: itm['itemID'],
          itemName: itm['itemName'],
          createdDate: int.tryParse(itm['createdDate']) ?? 0,
          createdBy: itm['createdBy'],
          modifiedDate: int.tryParse(itm['modifiedDate']) ?? 0,
          modifiedBy: itm['modifiedBy'],
          status: itm['status'],
          synced: true));
    }
  }
}
