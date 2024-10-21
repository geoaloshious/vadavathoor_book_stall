import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/classes.dart';
import 'package:vadavathoor_book_stall/db/constants.dart';
import 'package:vadavathoor_book_stall/db/functions/book.dart';
import 'package:vadavathoor_book_stall/db/functions/sales.dart';
import 'package:vadavathoor_book_stall/db/functions/users.dart';
import 'package:vadavathoor_book_stall/db/models/book_purchase.dart';
import 'package:vadavathoor_book_stall/utils/utils.dart';

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
    String bookID, int purchaseDate, double bookPrice, int quantity) async {
  final currentTS = getCurrentTimestamp();
  final loggedInUser = await getLoggedInUserID();

  final db = await getBookPurchaseBox();
  await db.add(BookPurchaseModel(
      purchaseID: (db.values.length + 1).toString(),
      purchaseDate: purchaseDate,
      bookID: bookID,
      quantityPurchased: quantity,
      quantityLeft: quantity,
      bookPrice: bookPrice,
      createdDate: currentTS,
      createdBy: loggedInUser,
      modifiedDate: 0,
      modifiedBy: '',
      status: DBRowStatus.active));
}

Future<Map<String, String>> editBookPurchase(String purchaseID, String bookID,
    int quantity, double bookPrice, int purchaseDate) async {
  final purchaseBox = await getBookPurchaseBox();
  final salesBox = await getSalesBox();
  final loggedInUser = await getLoggedInUserID();

  final relatedSales = salesBox.values.where((i) =>
      i.books
          .where((b) => b.purchaseVariants
              .where((p) => p.purchaseID == purchaseID)
              .isNotEmpty)
          .isNotEmpty &&
      i.status == DBRowStatus.active);

  for (int key in purchaseBox.keys) {
    BookPurchaseModel? existingData = purchaseBox.get(key);
    if (existingData != null && existingData.purchaseID == purchaseID) {
      if (bookID != existingData.bookID) {
        return {
          'message':
              'Found some sales related to this purchase.\nPlease edit/delete them to continue.\nSale IDs: ${relatedSales.map((p) => p.saleID).join(', ')}'
        };
      }

      int quantitySold =
          existingData.quantityPurchased = existingData.quantityLeft;
      if (quantity < quantitySold) {
        return {
          'message':
              '$quantitySold stocks are already sold from this purchase.\nPlease edit/delete the sales to continue.\nSale IDs: ${relatedSales.map((p) => p.saleID).join(', ')}'
        };
      }

      existingData.bookID = bookID;
      existingData.quantityPurchased = quantity;
      existingData.quantityLeft = quantity - quantitySold;
      existingData.bookPrice = bookPrice;
      existingData.purchaseDate = purchaseDate;
      existingData.modifiedDate = getCurrentTimestamp();
      existingData.modifiedBy = loggedInUser;

      await purchaseBox.put(key, existingData);
      break;
    }
  }

  return {};
}

Future<Map<String, String>> deleteBookPurchase(String purchaseID) async {
  final box = await getBookPurchaseBox();
  final salesBox = await getSalesBox();
  final loggedInUser = await getLoggedInUserID();

  final relatedSales = salesBox.values.where((i) =>
      i.books
          .where((b) => b.purchaseVariants
              .where((p) => p.purchaseID == purchaseID)
              .isNotEmpty)
          .isNotEmpty &&
      i.status == DBRowStatus.active);

  if (relatedSales.isNotEmpty) {
    return {
      'message':
          'Found some sales related to this purchase.\nPlease delete them to continue.\nSale IDs: ${relatedSales.map((p) => p.saleID).join(', ')}'
    };
  }

  for (int key in box.keys) {
    BookPurchaseModel? existingData = box.get(key);
    if (existingData != null && existingData.purchaseID == purchaseID) {
      existingData.status = DBRowStatus.deleted;
      existingData.modifiedDate = getCurrentTimestamp();
      existingData.modifiedBy = loggedInUser;

      await box.put(key, existingData);
      break;
    }
  }

  return {};
}

Future<List<PurchaseListItemModel>> getBookPurchaseList() async {
  final purchases = (await getBookPurchaseBox()).values.toList();
  final books = (await getBooksBox()).values.toList();

  List<PurchaseListItemModel> joinedData = [];

  for (BookPurchaseModel purchase in purchases) {
    final book = books.where((u) => u.bookID == purchase.bookID).firstOrNull;

    if (book != null && purchase.status == DBRowStatus.active) {
      joinedData.add(PurchaseListItemModel(
          purchaseID: purchase.purchaseID,
          itemID: book.bookID,
          itemName: book.bookName,
          purchaseDate: purchase.purchaseDate,
          formattedPurchaseDate: formatTimestamp(
              timestamp: purchase.purchaseDate, format: 'dd MMM yyyy hh:mm a'),
          quantityPurchased: purchase.quantityPurchased,
          balanceStock: purchase.quantityLeft,
          price: purchase.bookPrice));
    }
  }

  return joinedData;
}
