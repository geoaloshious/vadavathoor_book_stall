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

Future<void> createPost(Map<String, Iterable<Object>> data) async {
  const url = 'http://localhost:3000/upsync';
  const headers = {'Content-Type': 'application/json'};
  final Map<String, dynamic> bodyData = {'data': data};

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(bodyData),
    );

    if (response.statusCode == 200) {
      print('Post created successfully: ${response.body}');
    } else {
      print('Failed to create post: ${response.statusCode}');
    }
  } catch (e) {
    print('Error occurred: $e');
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

  final bookAuthors = (await getBookAuthorsBox()).values;
  final bookCategories = (await getBookCategoriesBox()).values;
  final bookPublisher = (await getPublishersBox()).values;
  final bookPurchase = (await getBookPurchaseBox()).values;
  final book = (await getBooksBox()).values;
  final loginHistory = (await getLoginHistoryBox()).values;
  final misc = (await getMiscBox()).values;
  final sales = (await getSalesBox()).values;
  final stationaryItems = (await getStationaryItemBox()).values;
  final stationaryPurchases = (await getStationaryPurchaseBox()).values;
  final userBatches = (await getUserBatchBox()).values;
  final users = (await getUsersBox()).values;

  var apiInput = {
    DBNames.bookAuthor:
        bookAuthors.where((i) => i.modifiedDate > lastUpSyncTime).toList(),
    DBNames.bookCategories:
        bookCategories.where((i) => i.modifiedDate > lastUpSyncTime).toList(),
    DBNames.publisher:
        bookPublisher.where((i) => i.modifiedDate > lastUpSyncTime).toList(),
    DBNames.bookPurchase:
        bookPurchase.where((i) => i.modifiedDate > lastUpSyncTime).toList(),
    DBNames.book: book.where((i) => i.modifiedDate > lastUpSyncTime).toList(),
    DBNames.loginHistory: loginHistory
        .where((i) =>
            (i.logInTime > lastUpSyncTime || i.logOutTime > lastUpSyncTime))
        .toList(),
    DBNames.misc: misc.where((i) => i.modifiedDate > lastUpSyncTime).toList(),
    DBNames.sale: sales.where((i) => i.modifiedDate > lastUpSyncTime).toList(),
    DBNames.stationaryItem:
        stationaryItems.where((i) => i.modifiedDate > lastUpSyncTime).toList(),
    DBNames.stationaryPurchase: stationaryPurchases
        .where((i) => i.modifiedDate > lastUpSyncTime)
        .toList(),
    DBNames.userBatch:
        userBatches.where((i) => i.modifiedDate > lastUpSyncTime).toList(),
    DBNames.users: users.where((i) => i.modifiedDate > lastUpSyncTime).toList()
  };

  createPost(apiInput);

  // if (lastUpSyncTime == '') {
  //   await updateMiscValue(MiscDBKeys.lastUpSyncTime,
  //       DateTime.now().millisecondsSinceEpoch.toString());
  // }
  // if (lastDownSyncTime == '') {
  //   await updateMiscValue(MiscDBKeys.lastDownSyncTime,
  //       DateTime.now().millisecondsSinceEpoch.toString());
  // }

  Future.delayed(const Duration(seconds: 3), () {
    Navigator.of(context).pop();
  });
}
