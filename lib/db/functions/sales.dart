import 'dart:async';

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
import 'package:vadavathoor_book_stall/db/models/stationary_purchase.dart';
import 'package:vadavathoor_book_stall/db/models/users.dart';
import 'package:vadavathoor_book_stall/utils/utils.dart';

import '../constants.dart';
import 'book.dart';
import 'book_purchase.dart';

Future<Box<SaleModel>> getSalesBox() async {
  Box<SaleModel> box;

  if (Hive.isBoxOpen(DBNames.sale)) {
    box = Hive.box<SaleModel>(DBNames.sale);
  } else {
    box = await Hive.openBox<SaleModel>(DBNames.sale);
  }

  return box;
}

Future<Map<String, int>> getPurchaseKeysAndIDs(Box purchaseBox) async {
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
  String userBatchID,
  String customerBatchName,
) async {
  final userDB = await getUsersBox();

  if (customerID == '') {
    if (userBatchID == '') {
      userBatchID = await addUserBatch(customerBatchName);
    }

    customerID = (await addUser(UserModel(
            userID: '',
            name: customerName,
            username: '',
            password: '',
            role: UserRole.normal,
            batchID: userBatchID,
            status: UserStatus.enabled,
            createdDate: 0,
            createdBy: '',
            modifiedDate: 0,
            modifiedBy: '',
            notes: '')))['userID'] ??
        '';
  } else {
    userBatchID =
        userDB.values.firstWhere((b) => b.userID == customerID).batchID;
  }

  return {'customerID': customerID, 'customerBatchID': userBatchID};
}

Future<void> addSale(
    String billNo,
    List<SaleItemModel> booksToCheckout,
    List<SaleItemModel> stationaryItemsToCheckout,
    double grandTotal,
    String customerID,
    String customerName,
    String userBatchID,
    String customerBatchName,
    String paymentMode) async {
  final saleBox = await getSalesBox();
  final currentTS = getCurrentTimestamp();
  final loggedInUser = await getLoggedInUserID();

  final tempRes = await getCustomerIDAndBatchID(
      customerID, customerName, userBatchID, customerBatchName);
  customerID = tempRes['customerID']!;

  saleBox.add(SaleModel(
      saleID: generateID(),
      billNo: billNo,
      books: booksToCheckout,
      stationaryItems: stationaryItemsToCheckout,
      grandTotal: grandTotal,
      customerID: customerID,
      paymentMode: paymentMode,
      createdDate: currentTS,
      createdBy: loggedInUser,
      modifiedDate: currentTS,
      modifiedBy: loggedInUser,
      status: DBRowStatus.active));

  final bkPurchaseBox = await getBookPurchaseBox();
  final bkPurchaseKeys = await getPurchaseKeysAndIDs(bkPurchaseBox);

  for (SaleItemModel book in booksToCheckout) {
    for (SaleItemPurchaseVariantModel pv in book.purchaseVariants) {
      BookPurchaseModel? existingData =
          bkPurchaseBox.get(bkPurchaseKeys[pv.purchaseID]);
      if (existingData != null) {
        existingData.quantityLeft = existingData.quantityLeft - pv.quantity;
        existingData.modifiedDate = currentTS;
        await bkPurchaseBox.put(bkPurchaseKeys[pv.purchaseID], existingData);
      }
    }
  }

  final siPurchaseBox = await getStationaryPurchaseBox();
  final siPurchaseKeys = await getPurchaseKeysAndIDs(siPurchaseBox);

  for (SaleItemModel si in stationaryItemsToCheckout) {
    for (SaleItemPurchaseVariantModel pv in si.purchaseVariants) {
      StationaryPurchaseModel? existingData =
          siPurchaseBox.get(siPurchaseKeys[pv.purchaseID]);
      if (existingData != null) {
        existingData.quantityLeft = existingData.quantityLeft - pv.quantity;
        existingData.modifiedDate = currentTS;
        await siPurchaseBox.put(siPurchaseKeys[pv.purchaseID], existingData);
      }
    }
  }
}

Future<void> editSale(
    String saleID,
    String billNo,
    List<SaleItemModel> booksToCheckout,
    List<SaleItemModel> stationaryItemsToCheckout,
    double grandTotal,
    String customerID,
    String customerName,
    String userBatchID,
    String customerBatchName,
    String paymentMode) async {
  final salesBox = await getSalesBox();
  final bkPurchaseBox = await getBookPurchaseBox();
  final siPurchaseBox = await getStationaryPurchaseBox();
  final currentTS = getCurrentTimestamp();
  final loggedInUser = await getLoggedInUserID();

  final bkPurchaseKeys = await getPurchaseKeysAndIDs(bkPurchaseBox);
  final siPurchaseKeys = await getPurchaseKeysAndIDs(siPurchaseBox);

  final tempRes = await getCustomerIDAndBatchID(
      customerID, customerName, userBatchID, customerBatchName);
  customerID = tempRes['customerID']!;

  for (int saleKey in salesBox.keys) {
    SaleModel? existingSale = salesBox.get(saleKey);
    if (existingSale != null && existingSale.saleID == saleID) {
      Future<void> updateQty(List<SaleItemModel> saleItemList, Box purchaseBox,
          Map<String, int> purchaseKeys) async {
        //Prepare the object which contains the exisintg sold quantities
        for (SaleItemModel esb in saleItemList) {
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
      }

      await updateQty(existingSale.books, bkPurchaseBox, bkPurchaseKeys);
      await updateQty(
          existingSale.stationaryItems, siPurchaseBox, siPurchaseKeys);

      existingSale.billNo = billNo;
      existingSale.books = booksToCheckout;
      existingSale.stationaryItems = stationaryItemsToCheckout;
      existingSale.grandTotal = grandTotal;
      existingSale.customerID = customerID;
      existingSale.paymentMode = paymentMode;

      existingSale.modifiedDate = currentTS;
      existingSale.modifiedBy = loggedInUser;

      await salesBox.put(saleKey, existingSale);
      break;
    }
  }

  //Update balance stock in purchase table
  Future<void> updateQty2(List<SaleItemModel> saleItemList, Box purchaseBox,
      Map<String, int> purchaseKeys) async {
    for (var item in saleItemList) {
      for (var pv in item.purchaseVariants) {
        final existingPurchase = purchaseBox.get(purchaseKeys[pv.purchaseID]);
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

  await updateQty2(booksToCheckout, bkPurchaseBox, bkPurchaseKeys);
  await updateQty2(stationaryItemsToCheckout, siPurchaseBox, siPurchaseKeys);
}

Future<void> deleteSale(String saleID) async {
  final salesBox = await getSalesBox();
  final bkPurchaseBox = await getBookPurchaseBox();
  final siPurchaseBox = await getStationaryPurchaseBox();
  final loggedInUser = await getLoggedInUserID();
  final currentTS = getCurrentTimestamp();

  final bkPurchaseKeys = await getPurchaseKeysAndIDs(bkPurchaseBox);
  final siPurchaseKeys = await getPurchaseKeysAndIDs(siPurchaseBox);

  for (int saleKey in salesBox.keys) {
    SaleModel? existingSale = salesBox.get(saleKey);
    if (existingSale != null && existingSale.saleID == saleID) {
      Future<void> updateQty(List<SaleItemModel> saleItemList, Box purchaseBox,
          Map<String, int> purchaseKeys) async {
        //Prepare the object which contains the exisintg sold quantities
        for (var esb in saleItemList) {
          for (var espv in esb.purchaseVariants) {
            final existingPurchase =
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
      }

      await updateQty(existingSale.books, bkPurchaseBox, bkPurchaseKeys);
      await updateQty(
          existingSale.stationaryItems, siPurchaseBox, siPurchaseKeys);

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

Future<String> getNewSaleBillNo() async {
  final sales = (await getSalesBox()).values;
  if (sales.isEmpty) {
    return '1';
  }

  int lastBillNo = int.tryParse(sales.last.billNo) ?? 0;
  return (lastBillNo + 1).toString();
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
          billNo: sale.billNo,
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
        pr.status == DBRowStatus.active &&
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
