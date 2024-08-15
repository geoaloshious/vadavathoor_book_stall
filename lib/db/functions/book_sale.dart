import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/classes.dart';
import 'package:vadavathoor_book_stall/classes/sales.dart';
import 'package:vadavathoor_book_stall/db/models/book.dart';
import 'package:vadavathoor_book_stall/db/models/book_purchase.dart';
import 'package:vadavathoor_book_stall/db/models/book_sale.dart';
import 'package:vadavathoor_book_stall/utils.dart';

import '../constants.dart';
import 'book.dart';
import 'book_purchase.dart';
import 'utils.dart';

ValueNotifier<List<SaleListItemModel>> salesNotifier = ValueNotifier([]);

Future<Box<SaleModel>> getSalesBox() async {
  Box<SaleModel> box;

  if (Hive.isBoxOpen(DBNames.sale)) {
    box = Hive.box<SaleModel>(DBNames.sale);
  } else {
    box = await Hive.openBox<SaleModel>(DBNames.sale);
  }

  return box;
}

Future<void> addBookSale(List<SaleItemBookModel> booksToCheckout,
    double grandTotal, String customerName, String customerBatch) async {
  final saleBox = await getSalesBox();
  final currentTS = getCurrentTimestamp();
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);

  saleBox.add(SaleModel(
      saleID: generateID(),
      books: booksToCheckout,
      grandTotal: grandTotal,
      customerName: customerName,
      customerBatch: customerBatch,
      createdDate: currentTS,
      createdBy: loggedInUser,
      modifiedDate: currentTS,
      modifiedBy: loggedInUser,
      deleted: false));

  final purchaseBox = await getBookPurchaseBox();
  Map<String, int> purchaseKeys = {};
  for (int key in purchaseBox.keys) {
    String? pID = purchaseBox.get(key)?.purchaseID;
    if (pID != null) {
      purchaseKeys[pID] = key;
    }
  }

  for (var book in booksToCheckout) {
    for (var pv in book.purchaseVariants) {
      BookPurchaseModel? existingData =
          purchaseBox.get(purchaseKeys[pv.purchaseID]);
      if (existingData != null) {
        existingData.quantityLeft = existingData.quantityLeft - pv.quantity;
        existingData.modifiedDate = currentTS;
        await purchaseBox.put(purchaseKeys[pv.purchaseID], existingData);
      }
    }
  }

  updateBookSaleList();
}

void updateBookSaleList() async {
  final sales = (await getSalesBox()).values.toList();
  final books = (await getBooksBox()).values.toList();

  List<SaleListItemModel> joinedData = [];

  for (SaleModel sale in sales) {
    if (!sale.deleted) {
      for (SaleItemBookModel saleItem in sale.books) {
        final book =
            books.where((u) => u.bookID == saleItem.bookID).firstOrNull;

        int totalQty = 0;

        for (var pv in saleItem.purchaseVariants) {
          totalQty = totalQty + pv.quantity;
        }

        if (book != null) {
          joinedData.add(SaleListItemModel(
              bookName: book.bookName,
              quantity: totalQty,
              grandTotal: sale.grandTotal,
              date: formatTimestamp(timestamp: sale.createdDate)));
        }
      }
    }
  }

  salesNotifier.value = joinedData;
  salesNotifier.notifyListeners();
}

Future<List<ForNewSaleBookItem>> getBooksWithPurchaseVariants() async {
  final books = (await getBooksBox()).values.toList();
  final purchases = (await getBookPurchaseBox()).values.toList();

  List<ForNewSaleBookItem> returnData = [];

  for (BookModel bk in books) {
    returnData.add(ForNewSaleBookItem(
        bookID: bk.bookID,
        bookName: bk.bookName,
        purchases: purchases
            .where((pr) => pr.bookID == bk.bookID && pr.quantityLeft > 0)
            .map((pr) => ForNewSaleBookPurchaseVariant(
                purchaseID: pr.purchaseID,
                purchaseDate: formatTimestamp(
                    timestamp: pr.purchaseDate, format: 'dd MMM yyyy hh:mm a'),
                inStockCount: pr.quantityLeft,
                originalPrice: pr.bookPrice,
                selected: false))
            .toList()));
  }

  return returnData;
}
