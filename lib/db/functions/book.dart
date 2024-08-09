import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/models/book.dart';
import 'package:vadavathoor_book_stall/utils.dart';

final booksNotifier = ValueNotifier<List<BookModel>>([]);

Future<String> addBook(String name) async {
  String bookID = generateID(ItemType.book);
  final bookDB = await Hive.openBox<BookModel>(DBNames.book);
  await bookDB.add(BookModel(bookID: bookID, bookName: name));

  await updateBooksList();

  return bookID;
}

Future<void> updateBooksList() async {
  final db = await Hive.openBox<BookModel>(DBNames.book);
  booksNotifier.value = db.values.toList();
  booksNotifier.notifyListeners();
}
