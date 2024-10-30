import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/functions/users.dart';
import 'package:vadavathoor_book_stall/db/models/book.dart';
import 'package:vadavathoor_book_stall/db/models/book_category.dart';
import 'package:vadavathoor_book_stall/db/models/book_purchase.dart';
import 'package:vadavathoor_book_stall/db/models/sales.dart';
import 'package:vadavathoor_book_stall/db/models/book_publisher.dart';
import 'package:vadavathoor_book_stall/db/models/book_author.dart';
import 'package:vadavathoor_book_stall/db/models/stationary_item.dart';
import 'package:vadavathoor_book_stall/db/models/stationary_purchase.dart';
import 'package:vadavathoor_book_stall/db/models/user_batch.dart';
import 'package:vadavathoor_book_stall/db/models/users.dart';

import '../../utils/utils.dart';
import '../constants.dart';
import '../models/login_history.dart';
import '../models/misc.dart';

Future<void> initializeHiveDB() async {
  // Get the current executable path
  final executablePath = Directory.current.path;
  final dbPath = Directory('$executablePath/database');

  // Create the database directory if it doesn't exist
  if (!await dbPath.exists()) {
    await dbPath.create(recursive: true);
  }

  await Hive.initFlutter(dbPath.path);
  if (!Hive.isAdapterRegistered(BookModelAdapter().typeId)) {
    Hive.registerAdapter(BookModelAdapter());
  }
  if (!Hive.isAdapterRegistered(BookAuthorModelAdapter().typeId)) {
    Hive.registerAdapter(BookAuthorModelAdapter());
  }
  if (!Hive.isAdapterRegistered(BookPurchaseModelAdapter().typeId)) {
    Hive.registerAdapter(BookPurchaseModelAdapter());
  }
  if (!Hive.isAdapterRegistered(StationaryItemModelAdapter().typeId)) {
    Hive.registerAdapter(StationaryItemModelAdapter());
  }
  if (!Hive.isAdapterRegistered(StationaryPurchaseModelAdapter().typeId)) {
    Hive.registerAdapter(StationaryPurchaseModelAdapter());
  }
  if (!Hive.isAdapterRegistered(SaleModelAdapter().typeId)) {
    Hive.registerAdapter(SaleModelAdapter());
  }
  if (!Hive.isAdapterRegistered(SaleItemModelAdapter().typeId)) {
    Hive.registerAdapter(SaleItemModelAdapter());
  }
  if (!Hive.isAdapterRegistered(SaleItemPurchaseVariantModelAdapter().typeId)) {
    Hive.registerAdapter(SaleItemPurchaseVariantModelAdapter());
  }
  if (!Hive.isAdapterRegistered(PublisherModelAdapter().typeId)) {
    Hive.registerAdapter(PublisherModelAdapter());
  }
  if (!Hive.isAdapterRegistered(BookCategoryModelAdapter().typeId)) {
    Hive.registerAdapter(BookCategoryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(UserModelAdapter().typeId)) {
    Hive.registerAdapter(UserModelAdapter());
  }
  if (!Hive.isAdapterRegistered(LoginHistoryModelAdapter().typeId)) {
    Hive.registerAdapter(LoginHistoryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(MiscModelAdapter().typeId)) {
    Hive.registerAdapter(MiscModelAdapter());
  }
  if (!Hive.isAdapterRegistered(UserBatchModelAdapter().typeId)) {
    Hive.registerAdapter(UserBatchModelAdapter());
  }

  //#pending - might need to add these from TGDB.
  // await addDeveloperUserIfEmpty();
  // await setBookStallDetailsIfEmpty();
}

/*
Future<void> setBookStallDetailsIfEmpty() async {
  if ((await readMiscValue(MiscDBKeys.bookStallName)) == '') {
    await updateMiscValue(MiscDBKeys.bookStallName, 'St. Thomas Book Stall');
  }
  if ((await readMiscValue(MiscDBKeys.bookStallAdress)) == '') {
    await updateMiscValue(MiscDBKeys.bookStallAdress,
        'St.Thomas Ap.Seminary, PB No.1, Kottayam - 686010');
  }
  if ((await readMiscValue(MiscDBKeys.bookStallPhoneNumber)) == '') {
    await updateMiscValue(MiscDBKeys.bookStallPhoneNumber, '7593990978');
  }
  if ((await readMiscValue(MiscDBKeys.bankName)) == '') {
    await updateMiscValue(MiscDBKeys.bankName, 'CSB Bank');
  }
  if ((await readMiscValue(MiscDBKeys.bankAccountNo)) == '') {
    await updateMiscValue(MiscDBKeys.bankAccountNo, '030801736673190001');
  }
  if ((await readMiscValue(MiscDBKeys.bankIFSC)) == '') {
    await updateMiscValue(MiscDBKeys.bankIFSC, 'CSBK0000308');
  }
  if ((await readMiscValue(MiscDBKeys.bankBranch)) == '') {
    await updateMiscValue(MiscDBKeys.bankBranch, 'Kalathippady');
  }
  if ((await readMiscValue(MiscDBKeys.accountName)) == '') {
    await updateMiscValue(MiscDBKeys.accountName, 'Secretary book stall');
  }
  if ((await readMiscValue(MiscDBKeys.visitAgain)) == '') {
    await updateMiscValue(
        MiscDBKeys.visitAgain, 'Thank you and please visit again');
  }
}
*/

Future<Box<MiscModel>> getMiscBox() async {
  Box<MiscModel> box;

  if (Hive.isBoxOpen(DBNames.misc)) {
    box = Hive.box<MiscModel>(DBNames.misc);
  } else {
    box = await Hive.openBox<MiscModel>(DBNames.misc);
  }

  return box;
}

Future<Box<LoginHistoryModel>> getLoginHistoryBox() async {
  Box<LoginHistoryModel> box;

  if (Hive.isBoxOpen(DBNames.loginHistory)) {
    box = Hive.box<LoginHistoryModel>(DBNames.loginHistory);
  } else {
    box = await Hive.openBox<LoginHistoryModel>(DBNames.loginHistory);
  }

  return box;
}

Future<String> readMiscValue(String itemKey) async {
  final miscBox = await getMiscBox();
  final items = miscBox.values.where((i) => i.itemKey == itemKey);
  if (items.isNotEmpty) {
    return items.first.itemValue;
  } else {
    return '';
  }
}

Future<void> updateMiscValue(String itemKey, String itemValue) async {
  int currentTS = getCurrentTimestamp();
  final loggedInUser = await getLoggedInUserID();

  final miscBox = await getMiscBox();

  final items = miscBox.values.where((i) => i.itemKey == itemKey);

  if (items.isEmpty) {
    miscBox.add(MiscModel(
      itemKey: itemKey,
      itemValue: itemValue,
      createdDate: currentTS,
      createdBy: loggedInUser,
      modifiedDate: currentTS,
      modifiedBy: loggedInUser,
    ));
  } else {
    for (int key in miscBox.keys) {
      MiscModel? existingData = miscBox.get(key);
      if (existingData != null && existingData.itemKey == itemKey) {
        existingData.itemValue = itemValue;
        existingData.modifiedDate = currentTS;
        existingData.modifiedBy = loggedInUser;
        await miscBox.put(key, existingData);
        break;
      }
    }
  }
}

Future<void> addLoginHistory(String userID) async {
  final box = await getLoginHistoryBox();
  int currentTS = getCurrentTimestamp();

  box.add(LoginHistoryModel(
      id: generateID(), userID: userID, logInTime: currentTS, logOutTime: 0));
}

Future<void> updateLogoutHistory() async {
  final box = await getLoginHistoryBox();

  for (int key in box.keys) {
    LoginHistoryModel? existingData = box.get(key);
    if (existingData != null && existingData.logOutTime == 0) {
      existingData.logOutTime = getCurrentTimestamp();
    }
  }
}
