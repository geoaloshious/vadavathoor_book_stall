import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/classes.dart';
import 'package:vadavathoor_book_stall/classes/sales.dart';
import 'package:vadavathoor_book_stall/db/models/book.dart';
import 'package:vadavathoor_book_stall/db/models/book_purchase.dart';
import 'package:vadavathoor_book_stall/db/models/sales.dart';
import 'package:vadavathoor_book_stall/utils.dart';

import '../constants.dart';
import 'book.dart';
import 'book_purchase.dart';
import 'utils.dart';

Future<Box<SaleModel>> getSalesBox() async {
  Box<SaleModel> box;

  if (Hive.isBoxOpen(DBNames.sale)) {
    box = Hive.box<SaleModel>(DBNames.sale);
  } else {
    box = await Hive.openBox<SaleModel>(DBNames.sale);
  }

  return box;
}

Future<void> addSale(List<SaleItemBookModel> booksToCheckout, double grandTotal,
    String customerName, String customerBatch, String paymentMode) async {
  final saleBox = await getSalesBox();
  final currentTS = getCurrentTimestamp();
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);

  saleBox.add(SaleModel(
      saleID: generateID(),
      books: booksToCheckout,
      grandTotal: grandTotal,
      customerName: customerName,
      customerBatch: customerBatch,
      paymentMode: paymentMode,
      createdDate: currentTS,
      createdBy: loggedInUser,
      modifiedDate: 0,
      modifiedBy: '',
      status: DBRowStatus.active));

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
}

Future<void> editSale(
    String saleID,
    List<SaleItemBookModel> booksToCheckout,
    double grandTotal,
    String customerName,
    String customerBatch,
    String paymentMode) async {
  final salesBox = await getSalesBox();
  final purchaseBox = await getBookPurchaseBox();
  final currentTS = getCurrentTimestamp();
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);

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

  for (int key in salesBox.keys) {
    SaleModel? existingData = salesBox.get(key);
    if (existingData != null && existingData.saleID == saleID) {
      existingData.grandTotal = grandTotal;
      existingData.customerName = customerName;
      existingData.customerBatch = customerBatch;
      existingData.paymentMode = paymentMode;

      existingData.modifiedDate = currentTS;
      existingData.modifiedBy = loggedInUser;

      await salesBox.put(key, existingData);
      break;
    }
  }
}

Future<void> deleteSale(String saleID) async {
  final box = await getSalesBox();
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);

  for (int key in box.keys) {
    SaleModel? existingData = box.get(key);
    if (existingData != null && existingData.saleID == saleID) {
      existingData.status = DBRowStatus.deleted;
      existingData.modifiedDate = getCurrentTimestamp();
      existingData.modifiedBy = loggedInUser;

      await box.put(key, existingData);
      break;
    }
  }
}

Future<SaleModel?> getSaleData(String saleID) async {
  final salesBox = await getSalesBox();
  final data = salesBox.values.where((i) => i.saleID == saleID).firstOrNull;
  return data?.clone();
}

Future<List<SaleListItemModel>> getSalesList() async {
  final sales = (await getSalesBox()).values.toList();
  final books = (await getBooksBox()).values.toList();

  List<SaleListItemModel> joinedData = [];

  for (SaleModel sale in sales) {
    if (sale.status == DBRowStatus.active) {
      for (SaleItemBookModel saleItem in sale.books) {
        final book =
            books.where((u) => u.bookID == saleItem.bookID).firstOrNull;

        int totalQty = 0;

        for (var pv in saleItem.purchaseVariants) {
          totalQty = totalQty + pv.quantity;
        }

        if (book != null) {
          joinedData.add(SaleListItemModel(
              saleID: sale.saleID,
              bookName: book.bookName,
              quantity: totalQty,
              grandTotal: sale.grandTotal,
              paymentMode: sale.paymentMode,
              date: formatTimestamp(timestamp: sale.createdDate)));
        }
      }
    }
  }

  return joinedData;
}

// Future<List<ForNewSaleBookItem>> getBooksWithPurchaseVariants() async {
//   final books = (await getBooksBox()).values.toList();
//   final purchases = (await getBookPurchaseBox()).values.toList();

//   List<ForNewSaleBookItem> returnData = [];

//   for (BookModel bk in books) {
//     returnData.add(ForNewSaleBookItem(
//         bookID: bk.bookID,
//         bookName: bk.bookName,
//         purchases: purchases
//             .where((pr) =>
//                 pr.bookID == bk.bookID &&
//                 pr.deleted == false &&
//                 pr.quantityLeft > 0)
//             .map((pr) => ForNewSaleBookPurchaseVariant(
//                 purchaseID: pr.purchaseID,
//                 purchaseDate: formatTimestamp(
//                     timestamp: pr.purchaseDate, format: 'dd MMM yyyy hh:mm a'),
//                 balanceStock: pr.quantityLeft,
//                 originalPrice: pr.bookPrice,
//                 selected: false))
//             .toList()));
//   }

//   return returnData;
// }

Future<Map<String, Map<String, Map<String, Object>>>> getBookWithPurchases(
  List<String> savedPurchaseIDs,
) async {
  final books = (await getBooksBox()).values.toList();
  final purchases = (await getBookPurchaseBox()).values.toList();

  Map<String, Map<String, Map<String, Object>>> bks = {};

  for (BookModel book in books) {
    Map<String, Map<String, Object>> bk = {};

    var validPs = purchases.where((pr) =>
        pr.bookID == book.bookID &&
        pr.deleted == false &&
        (savedPurchaseIDs.contains(pr.purchaseID) || pr.quantityLeft > 0));
    if (validPs.isNotEmpty) {
      for (var p in validPs) {
        Map<String, Object> prs = {};

        prs['date'] = formatTimestamp(
            timestamp: p.purchaseDate, format: 'dd MMM yyyy hh:mm a');
        prs['price'] = p.bookPrice;
        prs['balanceStock'] = p.quantityLeft;

        bk[p.purchaseID] = prs;
      }

      bks[book.bookID] = bk;
    }
  }

  return bks;
}


// {
//   'b1':{
//     name
//     'p1':{
//       'date':'1/1/24',
//       'price':'1',
//       'balanceStock':0
//     }
//   }
// }