import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/models/book.dart';
import 'package:vadavathoor_book_stall/utils.dart';

import '../constants.dart';

Future<Box<BookModel>> getBooksBox() async {
  Box<BookModel> box;

  if (Hive.isBoxOpen(DBNames.book)) {
    box = Hive.box<BookModel>(DBNames.book);
  } else {
    box = await Hive.openBox<BookModel>(DBNames.book);
  }

  return box;
}

Future<String> addBook(String name) async {
  String bookID = generateID();
  final bookDB = await getBooksBox();
  await bookDB.add(
      BookModel(bookID: bookID, bookName: name, status: DBRowStatus.active));

  return bookID;
}

Future<List<BookModel>> getBooks() async {
  final db = await getBooksBox();
  return db.values.where((i) => i.status == DBRowStatus.active).toList();
}
