import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/classes.dart';
import 'package:vadavathoor_book_stall/db/functions/book.dart';
import 'package:vadavathoor_book_stall/db/functions/publisher.dart';
import 'package:vadavathoor_book_stall/db/models/book.dart';
import 'package:vadavathoor_book_stall/db/models/book_purchase.dart';
import 'package:vadavathoor_book_stall/db/models/publisher.dart';
import 'package:vadavathoor_book_stall/utils.dart';

ValueNotifier<List<BookPurchaseListItemModel>> purchaseNotifier =
    ValueNotifier([]);

Future<void> addBookPurchase(
    String publisherID,
    String publisherName,
    DateTime purchaseDate,
    String bookID,
    String bookName,
    String bookPrice,
    int quantity) async {
  String purchaseID = generateID(ItemType.bookPurchase);
  final currentTS = getCurrentTimestamp();

  if (publisherID == '') {
    publisherID = await addPublisher(publisherName, '');
  }

  if (bookID == '') {
    bookID = await addBook(bookName, bookPrice, quantity);
  }

  final db = await Hive.openBox<BookPurchaseModel>(DBNames.bookPurchase);
  await db.add(BookPurchaseModel(
      purchaseID: purchaseID,
      publisherID: publisherID,
      purchaseDate: purchaseDate.toString(),
      bookID: bookID,
      quantity: quantity,
      bookPrice: bookPrice,
      createdDate: currentTS,
      modifiedDate: currentTS,
      deleted: false));

  updateBookPurchaseList();
}

Future<void> editBookPurchase(
    String purchaseID,
    String publisherID,
    String publisherName,
    String bookID,
    String bookName,
    int quantity,
    String bookPrice) async {
  final box = await Hive.openBox<BookPurchaseModel>(DBNames.bookPurchase);

  for (int key in box.keys) {
    BookPurchaseModel? existingData = box.get(key);
    if (existingData != null && existingData.purchaseID == purchaseID) {
      if (publisherID == '') {
        publisherID = await addPublisher(publisherName, '');
      }

      if (bookID == '') {
        bookID = await addBook(bookName, bookPrice, quantity);
      }

      existingData.publisherID = publisherID;
      existingData.bookID = bookID;
      existingData.quantity = quantity;
      existingData.bookPrice = bookPrice;
      existingData.modifiedDate = getCurrentTimestamp();
      await box.put(key, existingData);
      break;
    }
  }
}

Future<void> deleteBookPurchase(String purchaseID) async {
  final box = await Hive.openBox<BookPurchaseModel>(DBNames.bookPurchase);

  for (int key in box.keys) {
    BookPurchaseModel? existingData = box.get(key);
    if (existingData != null && existingData.purchaseID == purchaseID) {
      existingData.deleted = true;
      await box.put(key, existingData);
      break;
    }
  }

  updateBookPurchaseList();
}

void updateBookPurchaseList() async {
  final purchases =
      (await Hive.openBox<BookPurchaseModel>(DBNames.bookPurchase))
          .values
          .toList();
  final books = (await Hive.openBox<BookModel>(DBNames.book)).values.toList();
  final publishers =
      (await Hive.openBox<PublisherModel>(DBNames.publisher)).values.toList();

  List<BookPurchaseListItemModel> joinedData = [];

  for (BookPurchaseModel purchase in purchases) {
    final book = books.where((u) => u.bookID == purchase.bookID).firstOrNull;
    final publisher = publishers
        .where((u) => u.publisherID == purchase.publisherID)
        .firstOrNull;

    if (book != null && publisher != null && !purchase.deleted) {
      joinedData.add(BookPurchaseListItemModel(
          purchaseID: purchase.purchaseID,
          publisherID: purchase.publisherID,
          publisherName: publisher.publisherName,
          purchaseDate: purchase.purchaseDate,
          bookID: book.bookID,
          bookName: book.bookName,
          quantity: purchase.quantity,
          bookPrice: purchase.bookPrice,
          createdDate: formatTimestamp(purchase.createdDate)));
    }
  }

  purchaseNotifier.value = joinedData;
  purchaseNotifier.notifyListeners();
}
