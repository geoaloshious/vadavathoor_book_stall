import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/models/book_category.dart';

downSyncBookCategories(Map<String, dynamic> jsonResult, String key,
    Box<BookCategoryModel> bookCategories) async {
  for (var itm in jsonResult['data'][key]) {
    bool exists = bookCategories.values
        .where((i) => i.categoryID == itm['categoryID'])
        .isNotEmpty;
    if (exists) {
      for (int key in bookCategories.keys) {
        var existingData = bookCategories.get(key);
        if (existingData != null &&
            existingData.categoryID == itm['categoryID']) {
          existingData.categoryName = itm['categoryName'];
          existingData.status = itm['status'];
          existingData.createdDate = int.tryParse(itm['createdDate']) ?? 0;
          existingData.createdBy = itm['createdBy'];
          existingData.modifiedDate = int.tryParse(itm['modifiedDate']) ?? 0;
          existingData.modifiedBy = itm['modifiedBy'];
          existingData.synced = true;

          await bookCategories.put(key, existingData);
          break;
        }
      }
    } else {
      await bookCategories.add(BookCategoryModel(
          categoryID: itm['categoryID'],
          categoryName: itm['categoryName'],
          createdDate: int.tryParse(itm['createdDate']) ?? 0,
          createdBy: itm['createdBy'],
          modifiedDate: int.tryParse(itm['modifiedDate']) ?? 0,
          modifiedBy: itm['modifiedBy'],
          status: itm['status'],
          synced: true));
    }
  }
}
