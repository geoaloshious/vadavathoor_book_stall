import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/models/book.dart';

updateSyncStatusBooks(Map<String, bool> jsonResult, Box<BookModel> box) async {
  for (String itemID in jsonResult.keys) {
    for (int key in box.keys) {
      var existingData = box.get(key);
      if (existingData != null && existingData.bookID == itemID) {
        existingData.synced = true;
        await box.put(key, existingData);
        break;
      }
    }
  }
}

downSyncBooks(
    Map<String, dynamic> jsonResult, String key, Box<BookModel> box) async {
  for (var itm in jsonResult['data'][key]) {
    bool exists = box.values.where((i) => i.bookID == itm['bookID']).isNotEmpty;
    if (exists) {
      for (int key in box.keys) {
        var existingData = box.get(key);
        if (existingData != null && existingData.bookID == itm['bookID']) {
          existingData.bookName = itm['bookName'];
          existingData.authorID = itm['authorID'];
          existingData.publisherID = itm['publisherID'];
          existingData.bookCategoryID = itm['bookCategoryID'];
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
      await box.add(BookModel(
          bookID: itm['bookID'],
          bookName: itm['bookName'],
          authorID: itm['authorID'],
          publisherID: itm['publisherID'],
          bookCategoryID: itm['bookCategoryID'],
          createdDate: int.tryParse(itm['createdDate']) ?? 0,
          createdBy: itm['createdBy'],
          modifiedDate: int.tryParse(itm['modifiedDate']) ?? 0,
          modifiedBy: itm['modifiedBy'],
          status: itm['status'],
          synced: true));
    }
  }
}
