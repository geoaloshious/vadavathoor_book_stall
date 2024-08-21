import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/models/book_author.dart';
import 'package:vadavathoor_book_stall/utils.dart';

import '../constants.dart';
import 'utils.dart';

Future<Box<BookAuthorModel>> getBookAuthorsBox() async {
  Box<BookAuthorModel> box;

  if (Hive.isBoxOpen(DBNames.bookAuthor)) {
    box = Hive.box<BookAuthorModel>(DBNames.bookAuthor);
  } else {
    box = await Hive.openBox<BookAuthorModel>(DBNames.bookAuthor);
  }

  return box;
}

Future<String> addBookAuthor(String authorName) async {
  String authorID = generateID();
  final db = await getBookAuthorsBox();
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);
  final currentTS = getCurrentTimestamp();

  await db.add(BookAuthorModel(
      authorID: authorID,
      authorName: authorName,
      createdDate: currentTS,
      createdBy: loggedInUser,
      modifiedDate: 0,
      modifiedBy: '',
      status: DBRowStatus.active));

  return authorID;
}

Future<void> editBookAuthor(
    {required String authorID, String? authorName, int? status}) async {
  final box = await getBookAuthorsBox();
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);

  for (int key in box.keys) {
    BookAuthorModel? existingData = box.get(key);
    if (existingData != null && existingData.authorID == authorID) {
      if (authorName != null) {
        existingData.authorName = authorName;
      } else if (status != null) {
        existingData.status = status;
      }

      existingData.modifiedDate = getCurrentTimestamp();
      existingData.modifiedBy = loggedInUser;

      await box.put(key, existingData);
      break;
    }
  }
}

Future<List<BookAuthorModel>> getBookAuthors() async {
  final db = await getBookAuthorsBox();
  return db.values.where((i) => i.status == DBRowStatus.active).toList();
}
