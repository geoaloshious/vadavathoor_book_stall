import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/classes.dart';
import 'package:vadavathoor_book_stall/db/constants.dart';
import 'package:vadavathoor_book_stall/db/functions/sales.dart';
import 'package:vadavathoor_book_stall/db/functions/stationary_item.dart';
import 'package:vadavathoor_book_stall/db/functions/users.dart';
import 'package:vadavathoor_book_stall/db/models/stationary_purchase.dart';
import 'package:vadavathoor_book_stall/utils/utils.dart';

Future<Box<StationaryPurchaseModel>> getStationaryPurchaseBox() async {
  Box<StationaryPurchaseModel> box;

  if (Hive.isBoxOpen(DBNames.stationaryPurchase)) {
    box = Hive.box<StationaryPurchaseModel>(DBNames.stationaryPurchase);
  } else {
    box =
        await Hive.openBox<StationaryPurchaseModel>(DBNames.stationaryPurchase);
  }

  return box;
}

Future<void> addStationaryPurchase(
    String itemID, int purchaseDate, double price, int quantity) async {
  final currentTS = getCurrentTimestamp();
  final loggedInUser = await getLoggedInUserID();

  final db = await getStationaryPurchaseBox();
  await db.add(StationaryPurchaseModel(
      purchaseID: (db.values.length + 1).toString(),
      purchaseDate: purchaseDate,
      itemID: itemID,
      quantityPurchased: quantity,
      quantityLeft: quantity,
      price: price,
      createdDate: currentTS,
      createdBy: loggedInUser,
      modifiedDate: currentTS,
      modifiedBy: loggedInUser,
      status: DBRowStatus.active,
      synced: false));
}

Future<Map<String, String>> editStationaryPurchase(String purchaseID,
    String itemID, int quantity, double price, int purchaseDate) async {
  final purchaseBox = await getStationaryPurchaseBox();
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
    StationaryPurchaseModel? existingData = purchaseBox.get(key);
    if (existingData != null && existingData.purchaseID == purchaseID) {
      if (itemID != existingData.itemID) {
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

      existingData.itemID = itemID;
      existingData.quantityPurchased = quantity;
      existingData.quantityLeft = quantity - quantitySold;
      existingData.price = price;
      existingData.purchaseDate = purchaseDate;
      existingData.modifiedDate = getCurrentTimestamp();
      existingData.modifiedBy = loggedInUser;
      existingData.synced = false;

      await purchaseBox.put(key, existingData);
      break;
    }
  }

  return {};
}

Future<Map<String, String>> deleteStationaryPurchase(String purchaseID) async {
  final box = await getStationaryPurchaseBox();
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
    StationaryPurchaseModel? existingData = box.get(key);
    if (existingData != null && existingData.purchaseID == purchaseID) {
      existingData.status = DBRowStatus.deleted;
      existingData.modifiedDate = getCurrentTimestamp();
      existingData.modifiedBy = loggedInUser;
      existingData.synced = false;

      await box.put(key, existingData);
      break;
    }
  }

  return {};
}

Future<List<PurchaseListItemModel>> getStationaryPurchaseList() async {
  final purchases = (await getStationaryPurchaseBox()).values.toList();
  final items = (await getStationaryItemBox()).values.toList();

  List<PurchaseListItemModel> joinedData = [];

  for (StationaryPurchaseModel stationaryPurchase in purchases) {
    final item =
        items.where((u) => u.itemID == stationaryPurchase.itemID).firstOrNull;

    if (item != null && stationaryPurchase.status == DBRowStatus.active) {
      joinedData.add(PurchaseListItemModel(
          purchaseID: stationaryPurchase.purchaseID,
          itemID: item.itemID,
          itemName: item.itemName,
          purchaseDate: stationaryPurchase.purchaseDate,
          formattedPurchaseDate: formatTimestamp(
              timestamp: stationaryPurchase.purchaseDate,
              format: 'dd MMM yyyy hh:mm a'),
          quantityPurchased: stationaryPurchase.quantityPurchased,
          balanceStock: stationaryPurchase.quantityLeft,
          price: stationaryPurchase.price));
    }
  }

  return joinedData;
}
