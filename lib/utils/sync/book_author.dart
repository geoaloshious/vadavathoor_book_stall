import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/models/book_author.dart';

updateSyncStatusBookAuthor(
    Map<String, bool> jsonResult, Box<BookAuthorModel> box) async {
  for (String itemID in jsonResult.keys) {
    for (int key in box.keys) {
      var existingData = box.get(key);
      if (existingData != null && existingData.authorID == itemID) {
        existingData.synced = true;
        await box.put(key, existingData);
        break;
      }
    }
  }
}

downSyncBookAuthor(Map<String, dynamic> jsonResult, String key,
    Box<BookAuthorModel> box) async {
  for (var itm in jsonResult['data'][key]) {
    bool exists =
        box.values.where((i) => i.authorID == itm['authorID']).isNotEmpty;
    if (exists) {
      for (int key in box.keys) {
        var existingData = box.get(key);
        if (existingData != null && existingData.authorID == itm['authorID']) {
          existingData.authorName = itm['authorName'];
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
      await box.add(BookAuthorModel(
          authorID: itm['authorID'],
          authorName: itm['authorName'],
          createdDate: int.tryParse(itm['createdDate']) ?? 0,
          createdBy: itm['createdBy'],
          modifiedDate: int.tryParse(itm['modifiedDate']) ?? 0,
          modifiedBy: itm['modifiedBy'],
          status: itm['status'],
          synced: true));
    }
  }
}
