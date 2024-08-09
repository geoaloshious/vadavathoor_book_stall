import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/classes.dart';
import 'package:vadavathoor_book_stall/classes/sales.dart';
import 'package:vadavathoor_book_stall/db/models/book.dart';
import 'package:vadavathoor_book_stall/db/models/book_purchase.dart';
import 'package:vadavathoor_book_stall/db/models/book_sale.dart';
import 'package:vadavathoor_book_stall/utils.dart';

ValueNotifier<List<SaleListItemModel>> salesNotifier = ValueNotifier([]);

Future<void> addBookSale(List<BookSaleItemModel> items, double grandTotal,
    String customerName, String customerBatch) async {
  final saleBox = await Hive.openBox<BookSaleModel>(DBNames.bookSale);
  final currentTS = getCurrentTimestamp();

  saleBox.add(BookSaleModel(
      saleID: generateID(ItemType.bookSale),
      items: items,
      grandTotal: grandTotal,
      customerName: customerName,
      customerBatch: customerBatch,
      createdDate: currentTS,
      modifiedDate: currentTS,
      deleted: false));

  final bookBox = await Hive.openBox<BookModel>(DBNames.book);

  for (int key in bookBox.keys) {
    BookModel? existingData = bookBox.get(key);
    if (existingData != null) {
      final match = items.firstWhere(
          (i) =>
              i.itemType == SaleItemType.book &&
              i.bookID == existingData.bookID,
          orElse: emptyBookSaleItem);

      // if (match.bookID != '') {
      //   existingData.discountPrice = match.soldPrice;
      //   existingData.inStockCount = existingData.inStockCount - match.quantity;
      // }

      await bookBox.put(key, existingData);
      break;
    }
  }

  updateBookSaleList();
}

void updateBookSaleList() async {
  final sales =
      (await Hive.openBox<BookSaleModel>(DBNames.bookSale)).values.toList();
  final books = (await Hive.openBox<BookModel>(DBNames.book)).values.toList();

  List<SaleListItemModel> joinedData = [];

  for (BookSaleModel sale in sales) {
    if (!sale.deleted) {
      for (BookSaleItemModel saleItem in sale.items) {
        final book =
            books.where((u) => u.bookID == saleItem.bookID).firstOrNull;

        if (book != null) {
          joinedData.add(SaleListItemModel(
              bookName: book.bookName,
              quantity: saleItem.quantity,
              grandTotal: sale.grandTotal,
              date: formatTimestamp(sale.createdDate)));
        }
      }
    }
  }

  salesNotifier.value = joinedData;
  salesNotifier.notifyListeners();
}

Future<List<ForNewSaleBookItem>> getBooksWithPurchaseVariants() async {
  final books = (await Hive.openBox<BookModel>(DBNames.book)).values.toList();
  final purchases =
      (await Hive.openBox<BookPurchaseModel>(DBNames.bookPurchase))
          .values
          .toList();

  List<ForNewSaleBookItem> returnData = [];

  for (BookModel bk in books) {
    returnData.add(ForNewSaleBookItem(
        bookID: bk.bookID,
        bookName: bk.bookName,
        purchases: purchases
            .where((pr) => pr.bookID == bk.bookID && pr.quantity > 0)
            .map((pr) => ForNewSaleBookPurchaseVariant(
                purchaseID: pr.purchaseID,
                purchaseDate: pr.purchaseDate,
                quantity: pr.quantity,
                price: pr.bookPrice))
            .toList()));
  }

  return returnData;
}
