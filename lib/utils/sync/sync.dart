import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/db/constants.dart';
import 'package:vadavathoor_book_stall/db/functions/book.dart';
import 'package:vadavathoor_book_stall/db/functions/book_author.dart';
import 'package:vadavathoor_book_stall/db/functions/book_category.dart';
import 'package:vadavathoor_book_stall/db/functions/book_purchase.dart';
import 'package:vadavathoor_book_stall/db/functions/publisher.dart';
import 'package:vadavathoor_book_stall/db/functions/sales.dart';
import 'package:vadavathoor_book_stall/db/functions/stationary_item.dart';
import 'package:vadavathoor_book_stall/db/functions/stationary_purchase.dart';
import 'package:vadavathoor_book_stall/db/functions/user_batch.dart';
import 'package:vadavathoor_book_stall/db/functions/users.dart';
import 'package:vadavathoor_book_stall/db/functions/utils.dart';
import 'package:vadavathoor_book_stall/utils/api_contants.dart';
import 'package:vadavathoor_book_stall/utils/sync/book_author.dart';
import 'package:vadavathoor_book_stall/utils/sync/book_categories.dart';
import 'package:vadavathoor_book_stall/utils/sync/book_publishers.dart';
import 'package:vadavathoor_book_stall/utils/sync/book_purchase.dart';
import 'package:vadavathoor_book_stall/utils/sync/books.dart';
import 'package:vadavathoor_book_stall/utils/sync/login_history.dart';
import 'package:vadavathoor_book_stall/utils/sync/misc.dart';
import 'package:vadavathoor_book_stall/utils/sync/sales.dart';
import 'package:vadavathoor_book_stall/utils/sync/stationary_items.dart';
import 'package:vadavathoor_book_stall/utils/sync/stationary_purchases.dart';
import 'package:vadavathoor_book_stall/utils/sync/user_batches.dart';
import 'package:vadavathoor_book_stall/utils/sync/users.dart';

Future<String> createPost(endpoint, Map<String, dynamic> data) async {
  String url = '$baseURL$endpoint';
  const headers = {'Content-Type': 'application/json'};

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode({'data': data}),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('Failed to create post: ${response.statusCode}');
      return '{}';
    }
  } catch (e) {
    print('Error occurred: $e');
    return '{}';
  }
}

void syncData(BuildContext context) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
            title: Text('Syncing'),
            content: Row(children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Expanded(child: Text('Syncing in progress...')),
            ]));
      });

  var lastUpSyncTime =
      int.tryParse(await readMiscValue(MiscDBKeys.lastUpSyncTime)) ?? 0;
  final lastDownSyncTime =
      int.tryParse(await readMiscValue(MiscDBKeys.lastDownSyncTime)) ?? 0;

  final bookAuthors = await getBookAuthorsBox();
  final bookCategories = await getBookCategoriesBox();
  final bookPublisher = await getPublishersBox();
  final bookPurchase = await getBookPurchaseBox();
  final book = await getBooksBox();
  final loginHistory = await getLoginHistoryBox();
  final misc = await getMiscBox();
  final sales = await getSalesBox();
  final stationaryItems = await getStationaryItemBox();
  final stationaryPurchases = await getStationaryPurchaseBox();
  final userBatches = await getUserBatchBox();
  final users = await getUsersBox();

  var apiInput = {
    DBNames.bookAuthor: bookAuthors.values
        .where((i) => i.modifiedDate > lastUpSyncTime)
        .toList(),
    DBNames.bookCategories: bookCategories.values
        .where((i) => i.modifiedDate > lastUpSyncTime)
        .toList(),
    DBNames.publisher: bookPublisher.values
        .where((i) => i.modifiedDate > lastUpSyncTime)
        .toList(),
    DBNames.bookPurchase: bookPurchase.values
        .where((i) => i.modifiedDate > lastUpSyncTime)
        .toList(),
    DBNames.book:
        book.values.where((i) => i.modifiedDate > lastUpSyncTime).toList(),
    DBNames.loginHistory: loginHistory.values
        .where((i) =>
            (i.logInTime > lastUpSyncTime || i.logOutTime > lastUpSyncTime))
        .toList(),
    DBNames.misc:
        misc.values.where((i) => i.modifiedDate > lastUpSyncTime).toList(),
    DBNames.sale: sales.values
        .where((i) => i.modifiedDate > lastUpSyncTime)
        .toList()
        .map((sale) => sale.toJson())
        .toList(),
    DBNames.stationaryItem: stationaryItems.values
        .where((i) => i.modifiedDate > lastUpSyncTime)
        .toList(),
    DBNames.stationaryPurchase: stationaryPurchases.values
        .where((i) => i.modifiedDate > lastUpSyncTime)
        .toList(),
    DBNames.userBatch: userBatches.values
        .where((i) => i.modifiedDate > lastUpSyncTime)
        .toList(),
    DBNames.users:
        users.values.where((i) => i.modifiedDate > lastUpSyncTime).toList()
  };

  await createPost(EndPoints.upSync, apiInput);

  await updateMiscValue(MiscDBKeys.lastUpSyncTime,
      DateTime.now().millisecondsSinceEpoch.toString());

  final downResult = await createPost(
      EndPoints.downSync, {'lastDownSyncTime': lastDownSyncTime});

  Map<String, dynamic> jsonResult = jsonDecode(downResult);

  for (String key in jsonResult['data'].keys) {
    switch (key) {
      case DBNames.bookAuthor:
        await downSyncBookAuthor(jsonResult, key, bookAuthors);
        break;
      case DBNames.bookCategories:
        await downSyncBookCategories(jsonResult, key, bookCategories);
        break;
      case DBNames.publisher:
        await downSyncBookPublishers(jsonResult, key, bookPublisher);
        break;
      case DBNames.bookPurchase:
        await downSyncBookPurchases(jsonResult, key, bookPurchase);
        break;
      case DBNames.book:
        await downSyncBooks(jsonResult, key, book);
        break;
      case DBNames.loginHistory:
        await downSyncLoginHistory(jsonResult, key, loginHistory);
        break;
      case DBNames.misc:
        await downSyncMisc(jsonResult, key, misc);
        break;
      case DBNames.sale:
        await downSyncSales(jsonResult, key, sales);
        break;
      case DBNames.stationaryItem:
        await downSyncStationaryItems(jsonResult, key, stationaryItems);
        break;
      case DBNames.stationaryPurchase:
        await downSyncStationaryPurchases(jsonResult, key, stationaryPurchases);
        break;
      case DBNames.userBatch:
        await downSyncUserBatches(jsonResult, key, userBatches);
        break;
      case DBNames.users:
        await downSyncUsers(jsonResult, key, users);
        break;
    }
  }

  await updateMiscValue(MiscDBKeys.lastDownSyncTime,
      DateTime.now().millisecondsSinceEpoch.toString());

  Future.delayed(const Duration(seconds: 3), () {
    Navigator.of(context).pop();
  });
}