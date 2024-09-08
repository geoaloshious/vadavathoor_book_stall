import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/classes/books.dart';
import 'package:vadavathoor_book_stall/db/functions/book_author.dart';
import 'package:vadavathoor_book_stall/db/functions/book_purchase.dart';
import 'package:vadavathoor_book_stall/db/models/book.dart';
import 'package:vadavathoor_book_stall/db/models/book_purchase.dart';
import 'package:vadavathoor_book_stall/utils/utils.dart';

import '../constants.dart';
import 'book_category.dart';
import 'publisher.dart';
import 'utils.dart';

Future<Box<BookModel>> getBooksBox() async {
  Box<BookModel> box;

  if (Hive.isBoxOpen(DBNames.book)) {
    box = Hive.box<BookModel>(DBNames.book);
  } else {
    box = await Hive.openBox<BookModel>(DBNames.book);
  }

  return box;
}

Future<void> addBook(
  String bookName,
  String authorID,
  String authorName,
  String publisherID,
  String publisherName,
  String bookCategoryID,
  String bookCategoryName,
) async {
  final bookDB = await getBooksBox();
  String bookID = generateID();
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);
  final currentTS = getCurrentTimestamp();

  if (authorID == '') {
    authorID = await addBookAuthor(authorName);
  }

  if (publisherID == '') {
    publisherID = await addPublisher(publisherName);
  }

  if (bookCategoryID == '') {
    bookCategoryID = await addBookCategory(bookCategoryName);
  }

  await bookDB.add(BookModel(
      bookID: bookID,
      bookName: bookName,
      authorID: authorID,
      publisherID: publisherID,
      bookCategoryID: bookCategoryID,
      createdDate: currentTS,
      createdBy: loggedInUser,
      modifiedDate: 0,
      modifiedBy: '',
      status: DBRowStatus.active));
}

Future<void> editBook(
  String bookID,
  String bookName,
  String authorID,
  String authorName,
  String publisherID,
  String publisherName,
  String bookCategoryID,
  String bookCategoryName,
) async {
  final bookDB = await getBooksBox();
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);
  final currentTS = getCurrentTimestamp();

  if (authorID == '') {
    authorID = await addBookAuthor(authorName);
  }

  if (publisherID == '') {
    publisherID = await addPublisher(publisherName);
  }

  if (bookCategoryID == '') {
    bookCategoryID = await addBookCategory(bookCategoryName);
  }

  for (int key in bookDB.keys) {
    BookModel? existingData = bookDB.get(key);
    if (existingData != null && existingData.bookID == bookID) {
      existingData.bookName = bookName;
      existingData.authorID = authorID;
      existingData.publisherID = publisherID;
      existingData.bookCategoryID = bookCategoryID;

      existingData.modifiedDate = currentTS;
      existingData.modifiedBy = loggedInUser;

      await bookDB.put(key, existingData);
      break;
    }
  }
}

Future<Map<String, String>> deleteBook(String bookID) async {
  final bookBox = await getBooksBox();
  final purchaseBox = await getBookPurchaseBox();
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);

  final purchases =
      purchaseBox.values.where((p) => p.bookID == bookID && !p.deleted);

  if (purchases.isNotEmpty) {
    return {
      'message':
          'Found some purchases of this book. Please delete them to continue.\nPurchase IDs: ${purchases.map((p) => p.purchaseID).join(', ')}'
    };
  }

  for (int key in bookBox.keys) {
    BookModel? existingData = bookBox.get(key);
    if (existingData != null && existingData.bookID == bookID) {
      existingData.status = DBRowStatus.deleted;

      existingData.modifiedDate = getCurrentTimestamp();
      existingData.modifiedBy = loggedInUser;

      await bookBox.put(key, existingData);
      break;
    }
  }

  return {};
}

Future<List<BookModel>> getBooks() async {
  final db = await getBooksBox();
  return db.values.where((i) => i.status == DBRowStatus.active).toList();
}

Future<List<BookListItemModel>> getBookList() async {
  final books = (await getBooksBox()).values.toList();
  final authors = (await getBookAuthorsBox()).values.toList();
  final publishers = (await getPublishersBox()).values.toList();
  final bookCategories = (await getBookCategoriesBox()).values.toList();
  final purchases = (await getBookPurchaseBox()).values.toList();

  List<BookListItemModel> joinedData = [];

  for (BookModel book in books) {
    final author =
        authors.where((i) => i.authorID == book.authorID).firstOrNull;
    final publisher =
        publishers.where((i) => i.publisherID == book.publisherID).firstOrNull;
    final bookCategory = bookCategories
        .where((i) => i.categoryID == book.bookCategoryID)
        .firstOrNull;
    final prcs = purchases.where((p) => p.bookID == book.bookID && !p.deleted);

    int balanceStock = 0;
    for (BookPurchaseModel p in prcs) {
      balanceStock = balanceStock + p.quantityLeft;
    }

    if (author != null &&
        publisher != null &&
        bookCategory != null &&
        book.status == DBRowStatus.active) {
      joinedData.add(BookListItemModel(
          bookID: book.bookID,
          bookName: book.bookName,
          authorID: book.authorID,
          authorName: author.authorName,
          publisherID: book.publisherID,
          publisherName: publisher.publisherName,
          categoryID: book.bookCategoryID,
          categoryName: bookCategory.categoryName,
          balanceStock: balanceStock));
    }
  }

  return joinedData;
}
