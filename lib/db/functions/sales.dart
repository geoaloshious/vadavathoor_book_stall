import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/classes.dart';
import 'package:vadavathoor_book_stall/db/functions/stationary_item.dart';
import 'package:vadavathoor_book_stall/db/functions/stationary_purchase.dart';
import 'package:vadavathoor_book_stall/db/functions/user_batch.dart';
import 'package:vadavathoor_book_stall/db/functions/users.dart';
import 'package:vadavathoor_book_stall/db/models/book.dart';
import 'package:vadavathoor_book_stall/db/models/book_purchase.dart';
import 'package:vadavathoor_book_stall/db/models/sales.dart';
import 'package:vadavathoor_book_stall/db/models/stationary_item.dart';
import 'package:vadavathoor_book_stall/db/models/users.dart';
import 'package:vadavathoor_book_stall/utils/utils.dart';

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

Future<Map<String, int>> getPurchaseKeysAndIDs(
    Box<BookPurchaseModel> purchaseBox) async {
  Map<String, int> purchaseKeys = {};

  for (int key in purchaseBox.keys) {
    String? pID = purchaseBox.get(key)?.purchaseID;
    if (pID != null) {
      purchaseKeys[pID] = key;
    }
  }

  return purchaseKeys;
}

Future<Map<String, String>> getCustomerIDAndBatchID(
  String customerID,
  String customerName,
  String customerBatch,
) async {
  final userDB = await getUsersBox();

  String customerBatchID = '';

  if (customerID == '') {
    customerBatchID = await addUserBatch(customerBatch);
    customerID = (await addUser(UserModel(
            userID: '',
            name: customerName,
            username: '',
            password: '',
            role: UserRole.normal,
            batchID: customerBatchID,
            status: UserStatus.enabled,
            createdDate: 0,
            createdBy: '',
            modifiedDate: 0,
            modifiedBy: '')))['userID'] ??
        '';
  } else {
    customerBatchID =
        userDB.values.firstWhere((b) => b.userID == customerID).batchID;
  }

  return {'customerID': customerID, 'customerBatchID': customerBatchID};
}

Future<void> addSale(
    List<SaleItemModel> booksToCheckout,
    List<SaleItemModel> stationaryItemsToCheckout,
    double grandTotal,
    String customerID,
    String customerName,
    String customerBatch,
    String paymentMode) async {
  final saleBox = await getSalesBox();
  final currentTS = getCurrentTimestamp();
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);

  final tempRes =
      await getCustomerIDAndBatchID(customerID, customerName, customerBatch);
  customerID = tempRes['customerID']!;
  String customerBatchID = tempRes['customerBatchID']!;

  saleBox.add(SaleModel(
      saleID: '${saleBox.values.length + 1}',
      books: booksToCheckout,
      stationaryItems: stationaryItemsToCheckout,
      grandTotal: grandTotal,
      customerID: customerID,
      customerBatchID: customerBatchID,
      paymentMode: paymentMode,
      createdDate: currentTS,
      createdBy: loggedInUser,
      modifiedDate: 0,
      modifiedBy: '',
      status: DBRowStatus.active));

  final purchaseBox = await getBookPurchaseBox();
  final purchaseKeys = await getPurchaseKeysAndIDs(purchaseBox);

  for (SaleItemModel book in booksToCheckout) {
    for (SaleItemPurchaseVariantModel pv in book.purchaseVariants) {
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
    List<SaleItemModel> booksToCheckout,
    List<SaleItemModel> stationaryItemsToCheckout,
    double grandTotal,
    String customerID,
    String customerName,
    String customerBatch,
    String paymentMode) async {
  final salesBox = await getSalesBox();
  final purchaseBox = await getBookPurchaseBox();
  final currentTS = getCurrentTimestamp();
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);

  final purchaseKeys = await getPurchaseKeysAndIDs(purchaseBox);

  final tempRes =
      await getCustomerIDAndBatchID(customerID, customerName, customerBatch);
  customerID = tempRes['customerID']!;
  String customerBatchID = tempRes['customerBatchID']!;

  for (int saleKey in salesBox.keys) {
    SaleModel? existingSale = salesBox.get(saleKey);
    if (existingSale != null && existingSale.saleID == saleID) {
      //Prepare the object which contains the exisintg sold quantities
      for (SaleItemModel esb in existingSale.books) {
        for (SaleItemPurchaseVariantModel espv in esb.purchaseVariants) {
          final existingPurchase =
              purchaseBox.get(purchaseKeys[espv.purchaseID]);
          if (existingPurchase != null) {
            //Undo the balance stock reduction that have done when the sale is created.
            int newBalance = existingPurchase.quantityLeft + espv.quantity;

            existingPurchase.quantityLeft = newBalance;
            existingPurchase.modifiedDate = currentTS;
            await purchaseBox.put(
                purchaseKeys[espv.purchaseID], existingPurchase);
          }
        }
      }

      existingSale.books = booksToCheckout;
      existingSale.stationaryItems = stationaryItemsToCheckout;
      existingSale.grandTotal = grandTotal;
      existingSale.customerID = customerID;
      existingSale.customerBatchID = customerBatchID;
      existingSale.paymentMode = paymentMode;

      existingSale.modifiedDate = currentTS;
      existingSale.modifiedBy = loggedInUser;

      await salesBox.put(saleKey, existingSale);
      break;
    }
  }

  //Update balance stock in purchase table
  for (var book in booksToCheckout) {
    for (var pv in book.purchaseVariants) {
      BookPurchaseModel? existingPurchase =
          purchaseBox.get(purchaseKeys[pv.purchaseID]);
      if (existingPurchase != null) {
        //Reduce the new quantity from balance stock.
        int newBalance = existingPurchase.quantityLeft - pv.quantity;

        existingPurchase.quantityLeft = newBalance;
        existingPurchase.modifiedDate = currentTS;
        await purchaseBox.put(purchaseKeys[pv.purchaseID], existingPurchase);
      }
    }
  }
}

Future<void> deleteSale(String saleID) async {
  final salesBox = await getSalesBox();
  final purchaseBox = await getBookPurchaseBox();
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);
  final currentTS = getCurrentTimestamp();

  final purchaseKeys = await getPurchaseKeysAndIDs(purchaseBox);

  for (int saleKey in salesBox.keys) {
    SaleModel? existingSale = salesBox.get(saleKey);
    if (existingSale != null && existingSale.saleID == saleID) {
      //Prepare the object which contains the exisintg sold quantities
      for (var esb in existingSale.books) {
        for (var espv in esb.purchaseVariants) {
          BookPurchaseModel? existingPurchase =
              purchaseBox.get(purchaseKeys[espv.purchaseID]);
          if (existingPurchase != null) {
            //Undo the balance stock reduction that have done when the sale is created.
            int newCount = existingPurchase.quantityLeft + espv.quantity;

            existingPurchase.quantityLeft = newCount;
            existingPurchase.modifiedDate = currentTS;
            await purchaseBox.put(
                purchaseKeys[espv.purchaseID], existingPurchase);
          }
        }
      }

      existingSale.status = DBRowStatus.deleted;
      existingSale.modifiedDate = getCurrentTimestamp();
      existingSale.modifiedBy = loggedInUser;

      await salesBox.put(saleKey, existingSale);
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
  final stationaryItems = (await getStationaryItemBox()).values.toList();
  final users = await getUsersBox();

  List<SaleListItemModel> joinedData = [];

  for (SaleModel sale in sales) {
    if (sale.status == DBRowStatus.active) {
      List<String> bookNames = [];
      List<String> stationaryNames = [];

      for (SaleItemModel saleItem in sale.books) {
        final book =
            books.where((u) => u.bookID == saleItem.itemID).firstOrNull;
        int bookQty = 0;

        for (var pv in saleItem.purchaseVariants) {
          bookQty = bookQty + pv.quantity;
        }

        if (book != null) {
          bookNames.add(
              '${book.bookName.length > 10 ? '${book.bookName.substring(0, 10)}...' : book.bookName} ($bookQty)');
        }
      }

      for (SaleItemModel saleItem in sale.stationaryItems) {
        final item = stationaryItems
            .where((u) => u.itemID == saleItem.itemID)
            .firstOrNull;
        int itemQty = 0;

        for (var pv in saleItem.purchaseVariants) {
          itemQty = itemQty + pv.quantity;
        }

        if (item != null) {
          stationaryNames.add(
              '${item.itemName.length > 10 ? '${item.itemName.substring(0, 10)}...' : item.itemName} ($itemQty)');
        }
      }

      joinedData.add(SaleListItemModel(
          saleID: sale.saleID,
          customerName:
              users.values.firstWhere((u) => u.userID == sale.customerID).name,
          books: bookNames.join('\n'),
          stationaryItems: stationaryNames.join('\n'),
          grandTotal: sale.grandTotal,
          paymentMode: getPaymentModeName(sale.paymentMode),
          createdDate: formatTimestamp(timestamp: sale.createdDate),
          modifiedDate: formatTimestamp(timestamp: sale.modifiedDate)));
    }
  }

  return joinedData;
}

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

Future<Map<String, Map<String, Map<String, Object>>>>
    getStationaryItemsWithPurchases(
  List<String> savedPurchaseIDs,
) async {
  final stationaryItems = (await getStationaryItemBox()).values.toList();
  final purchases = (await getStationaryPurchaseBox()).values.toList();

  Map<String, Map<String, Map<String, Object>>> itemsWithPVs = {};

  for (StationaryItemModel item in stationaryItems) {
    Map<String, Map<String, Object>> bk = {};

    var validPs = purchases.where((pr) =>
        pr.itemID == item.itemID &&
        pr.status == DBRowStatus.active &&
        (savedPurchaseIDs.contains(pr.purchaseID) || pr.quantityLeft > 0));
    if (validPs.isNotEmpty) {
      for (var p in validPs) {
        Map<String, Object> prs = {};

        prs['date'] = formatTimestamp(
            timestamp: p.purchaseDate, format: 'dd MMM yyyy hh:mm a');
        prs['price'] = p.price;
        prs['balanceStock'] = p.quantityLeft;

        bk[p.purchaseID] = prs;
      }

      itemsWithPVs[item.itemID] = bk;
    }
  }

  return itemsWithPVs;
}
