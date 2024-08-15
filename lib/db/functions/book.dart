import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/models/book.dart';
import 'package:vadavathoor_book_stall/utils.dart';

import '../constants.dart';

final booksNotifier = ValueNotifier<List<BookModel>>([]);

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
  await bookDB.add(BookModel(bookID: bookID, bookName: name));

  await updateBooksList();

  return bookID;
}

Future<void> updateBooksList() async {
  final db = await getBooksBox();
  booksNotifier.value = db.values.toList();
  booksNotifier.notifyListeners();
}
