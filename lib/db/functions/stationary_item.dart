import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/classes/books.dart';
import 'package:vadavathoor_book_stall/db/functions/stationary_purchase.dart';
import 'package:vadavathoor_book_stall/db/models/stationary_item.dart';
import 'package:vadavathoor_book_stall/db/models/stationary_purchase.dart';
import 'package:vadavathoor_book_stall/utils/utils.dart';

import '../constants.dart';
import 'utils.dart';

Future<Box<StationaryItemModel>> getStationaryItemBox() async {
  Box<StationaryItemModel> box;

  if (Hive.isBoxOpen(DBNames.book)) {
    box = Hive.box<StationaryItemModel>(DBNames.book);
  } else {
    box = await Hive.openBox<StationaryItemModel>(DBNames.book);
  }

  return box;
}

Future<void> addStationaryItem(String itemName) async {
  final box = await getStationaryItemBox();
  String itemID = generateID();
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);
  final currentTS = getCurrentTimestamp();

  await box.add(StationaryItemModel(
      itemID: itemID,
      itemName: itemName,
      createdDate: currentTS,
      createdBy: loggedInUser,
      modifiedDate: 0,
      modifiedBy: '',
      status: DBRowStatus.active));
}

Future<void> editStationaryItem(String itemID, String itemName) async {
  final box = await getStationaryItemBox();
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);
  final currentTS = getCurrentTimestamp();

  for (int key in box.keys) {
    StationaryItemModel? existingData = box.get(key);
    if (existingData != null && existingData.itemID == itemID) {
      existingData.itemName = itemName;

      existingData.modifiedDate = currentTS;
      existingData.modifiedBy = loggedInUser;

      await box.put(key, existingData);
      break;
    }
  }
}

Future<Map<String, String>> deleteStationaryItem(String itemID) async {
  final itemBox = await getStationaryItemBox();
  final purchaseBox = await getStationaryPurchaseBox();
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);

  final purchases = purchaseBox.values
      .where((p) => p.itemID == itemID && p.status == DBRowStatus.active);

  if (purchases.isNotEmpty) {
    return {
      'message':
          'Found some purchases of this item. Please delete them to continue.\nPurchase IDs: ${purchases.map((p) => p.purchaseID).join(', ')}'
    };
  }

  for (int key in itemBox.keys) {
    StationaryItemModel? existingData = itemBox.get(key);
    if (existingData != null && existingData.itemID == itemID) {
      existingData.status = DBRowStatus.deleted;

      existingData.modifiedDate = getCurrentTimestamp();
      existingData.modifiedBy = loggedInUser;

      await itemBox.put(key, existingData);
      break;
    }
  }

  return {};
}

Future<List<StationaryItemModel>> getStationaryItems() async {
  final db = await getStationaryItemBox();
  return db.values.where((i) => i.status == DBRowStatus.active).toList();
}

Future<List<StationaryListItemModel>> getStationaryItemList() async {
  final items = (await getStationaryItemBox()).values.toList();
  final purchases = (await getStationaryPurchaseBox()).values.toList();

  List<StationaryListItemModel> joinedData = [];

  for (StationaryItemModel item in items) {
    final prcs = purchases.where(
        (p) => p.itemID == item.itemID && p.status == DBRowStatus.active);

    int balanceStock = 0;
    for (StationaryPurchaseModel p in prcs) {
      balanceStock = balanceStock + p.quantityLeft;
    }

    if (item.status == DBRowStatus.active) {
      joinedData.add(StationaryListItemModel(
          itemID: item.itemID,
          itemName: item.itemName,
          balanceStock: balanceStock));
    }
  }

  return joinedData;
}
