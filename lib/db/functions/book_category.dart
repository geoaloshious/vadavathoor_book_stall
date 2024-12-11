import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/functions/users.dart';
import 'package:vadavathoor_book_stall/db/models/book_category.dart';
import 'package:vadavathoor_book_stall/utils/utils.dart';

import '../constants.dart';

Future<Box<BookCategoryModel>> getBookCategoriesBox() async {
  Box<BookCategoryModel> box;

  if (Hive.isBoxOpen(DBNames.bookCategories)) {
    box = Hive.box<BookCategoryModel>(DBNames.bookCategories);
  } else {
    box = await Hive.openBox<BookCategoryModel>(DBNames.bookCategories);
  }

  return box;
}

Future<String> addBookCategory(String name) async {
  String categoryID = generateID();
  final db = await getBookCategoriesBox();
  final loggedInUser = await getLoggedInUserID();
  final currentTS = getCurrentTimestamp();

  await db.add(BookCategoryModel(
      categoryID: categoryID,
      categoryName: name,
      createdDate: currentTS,
      createdBy: loggedInUser,
      modifiedDate: currentTS,
      modifiedBy: loggedInUser,
      status: DBRowStatus.active,
      synced: false));

  return categoryID;
}

Future<void> editBookCategory(
    {required String categoryID, String? categoryName, int? status}) async {
  final box = await getBookCategoriesBox();
  final loggedInUser = await getLoggedInUserID();

  for (int key in box.keys) {
    BookCategoryModel? existingData = box.get(key);
    if (existingData != null && existingData.categoryID == categoryID) {
      if (categoryName != null) {
        existingData.categoryName = categoryName;
      } else if (status != null) {
        existingData.status = status;
      }

      existingData.modifiedDate = getCurrentTimestamp();
      existingData.modifiedBy = loggedInUser;
      existingData.synced = false;

      await box.put(key, existingData);
      break;
    }
  }
}

Future<List<BookCategoryModel>> getBookCategories() async {
  final db = await getBookCategoriesBox();
  return db.values.where((i) => i.status == DBRowStatus.active).toList();
}
