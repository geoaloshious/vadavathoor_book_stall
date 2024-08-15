import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/classes.dart';
import 'package:vadavathoor_book_stall/db/constants.dart';
import 'package:vadavathoor_book_stall/db/functions/book.dart';
import 'package:vadavathoor_book_stall/db/functions/publisher.dart';
import 'package:vadavathoor_book_stall/db/functions/utils.dart';
import 'package:vadavathoor_book_stall/db/models/book_purchase.dart';
import 'package:vadavathoor_book_stall/utils.dart';

Future<Box<BookPurchaseModel>> getBookPurchaseBox() async {
  Box<BookPurchaseModel> box;

  if (Hive.isBoxOpen(DBNames.bookPurchase)) {
    box = Hive.box<BookPurchaseModel>(DBNames.bookPurchase);
  } else {
    box = await Hive.openBox<BookPurchaseModel>(DBNames.bookPurchase);
  }

  return box;
}

Future<void> addBookPurchase(
    String publisherID,
    String publisherName,
    int purchaseDate,
    String bookID,
    String bookName,
    double bookPrice,
    int quantity) async {
  String purchaseID = generateID();
  final currentTS = getCurrentTimestamp();
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);

  if (publisherID == '') {
    publisherID = await addPublisher(publisherName);
  }

  if (bookID == '') {
    bookID = await addBook(bookName);
  }

  final db = await getBookPurchaseBox();
  await db.add(BookPurchaseModel(
      purchaseID: purchaseID,
      publisherID: publisherID,
      purchaseDate: purchaseDate,
      bookID: bookID,
      quantityPurchased: quantity,
      quantityLeft: quantity,
      bookPrice: bookPrice,
      createdDate: currentTS,
      createdBy: loggedInUser,
      modifiedDate: currentTS,
      modifiedBy: loggedInUser,
      deleted: false));
}

Future<void> editBookPurchase(
    String purchaseID,
    String publisherID,
    String publisherName,
    String bookID,
    String bookName,
    int quantity,
    double bookPrice,
    int purchaseDate) async {
  final box = await getBookPurchaseBox();
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);

  for (int key in box.keys) {
    BookPurchaseModel? existingData = box.get(key);
    if (existingData != null && existingData.purchaseID == purchaseID) {
      if (publisherID == '') {
        publisherID = await addPublisher(publisherName);
      }

      if (bookID == '') {
        bookID = await addBook(bookName);
      }

      existingData.publisherID = publisherID;
      existingData.bookID = bookID;
      existingData.quantityPurchased = quantity;
      existingData.quantityLeft =
          quantity; //#pending - If editing after a sale is done, then data will conflict
      existingData.bookPrice = bookPrice;
      existingData.purchaseDate = purchaseDate;
      existingData.modifiedDate = getCurrentTimestamp();
      existingData.modifiedBy = loggedInUser;

      await box.put(key, existingData);
      break;
    }
  }
}

Future<void> deleteBookPurchase(String purchaseID) async {
  final box = await getBookPurchaseBox();
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);

  for (int key in box.keys) {
    BookPurchaseModel? existingData = box.get(key);
    if (existingData != null && existingData.purchaseID == purchaseID) {
      existingData.deleted = true;
      existingData.modifiedDate = getCurrentTimestamp();
      existingData.modifiedBy = loggedInUser;

      await box.put(key, existingData);
      break;
    }
  }
}

Future<List<BookPurchaseListItemModel>> getBookPurchaseList() async {
  final purchases = (await getBookPurchaseBox()).values.toList();
  final books = (await getBooksBox()).values.toList();
  final publishers = (await getPublishersBox()).values.toList();

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
          formattedPurchaseDate: formatTimestamp(
              timestamp: purchase.purchaseDate, format: 'dd MMM yyyy hh:mm a'),
          bookID: book.bookID,
          bookName: book.bookName,
          quantityPurchased: purchase.quantityPurchased,
          bookPrice: purchase.bookPrice));
    }
  }

  return joinedData;
}
