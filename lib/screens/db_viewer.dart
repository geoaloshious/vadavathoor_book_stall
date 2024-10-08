import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/db/functions/book_author.dart';
import 'package:vadavathoor_book_stall/db/functions/book_category.dart';
import 'package:vadavathoor_book_stall/db/functions/publisher.dart';
import 'package:vadavathoor_book_stall/db/functions/stationary_item.dart';
import 'package:vadavathoor_book_stall/db/functions/stationary_purchase.dart';
import 'package:vadavathoor_book_stall/db/functions/user_batch.dart';
import 'package:vadavathoor_book_stall/db/functions/utils.dart';

import '../db/functions/book.dart';
import '../db/functions/book_purchase.dart';
import '../db/functions/sales.dart';
import '../db/functions/users.dart';

class DbViewer extends StatefulWidget {
  const DbViewer({super.key});

  @override
  State<DbViewer> createState() => _DbViewerState();
}

class _DbViewerState extends State<DbViewer> {
  List<Map<String, String>> res = [];

  String getPrettyJSONString(String text) {
    final object = json.decode(text);
    final prettyString = const JsonEncoder.withIndent('  ').convert(object);
    return prettyString;
  }

  void setData() async {
    List<Map<String, String>> tempArr = [];

    final bkPurchaseDB = (await getBookPurchaseBox()).values.toList();
    tempArr.add({
      'label': 'Book Purchases',
      'value': getPrettyJSONString(
          json.encode(bkPurchaseDB.map((p) => p.toJson()).toList()))
    });

    final stPurchaseDB = (await getStationaryPurchaseBox()).values.toList();
    tempArr.add({
      'label': 'Stationary Purchases',
      'value': getPrettyJSONString(
          json.encode(stPurchaseDB.map((p) => p.toJson()).toList()))
    });

    final salesDB = (await getSalesBox()).values.toList();
    tempArr.add({
      'label': 'Sales',
      'value': getPrettyJSONString(
          json.encode(salesDB.map((p) => p.toJson()).toList()))
    });

    final stationaryItems = (await getStationaryItemBox()).values.toList();
    tempArr.add({
      'label': 'Stationary Items',
      'value': getPrettyJSONString(
          json.encode(stationaryItems.map((p) => p.toJson()).toList()))
    });

    final booksDB = (await getBooksBox()).values.toList();
    tempArr.add({
      'label': 'Books',
      'value': getPrettyJSONString(
          json.encode(booksDB.map((p) => p.toJson()).toList()))
    });

    final bookAuthorsDB = (await getBookAuthorsBox()).values.toList();
    tempArr.add({
      'label': 'Book authors',
      'value': getPrettyJSONString(
          json.encode(bookAuthorsDB.map((p) => p.toJson()).toList()))
    });

    final publishersDB = (await getPublishersBox()).values.toList();
    tempArr.add({
      'label': 'Publishers',
      'value': getPrettyJSONString(
          json.encode(publishersDB.map((p) => p.toJson()).toList()))
    });

    final bookCatgsDB = (await getBookCategoriesBox()).values.toList();
    tempArr.add({
      'label': 'Book Categories',
      'value': getPrettyJSONString(
          json.encode(bookCatgsDB.map((p) => p.toJson()).toList()))
    });

    final usersDB = (await getUsersBox()).values.toList();
    tempArr.add({
      'label': 'Users',
      'value': getPrettyJSONString(
          json.encode(usersDB.map((p) => p.toJson()).toList()))
    });

    final batchDB = (await getUserBatchBox()).values.toList();
    tempArr.add({
      'label': 'User batch',
      'value': getPrettyJSONString(
          json.encode(batchDB.map((p) => p.toJson()).toList()))
    });

    final miscDB = (await getMiscBox()).values.toList();
    tempArr.add({
      'label': 'Misc',
      'value': getPrettyJSONString(
          json.encode(miscDB.map((p) => p.toJson()).toList()))
    });

    final loginHistoryDB = (await getLoginHistoryBox()).values.toList();
    tempArr.add({
      'label': 'Login history',
      'value': getPrettyJSONString(
          json.encode(loginHistoryDB.map((p) => p.toJson()).toList()))
    });

    setState(() {
      res = tempArr;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Database viewer',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Close',
              onPressed: () {
                Navigator.of(context).pop();
              })
        ]),
        ...res.map((r) => ExpansionTile(
            title: Text(r['label']!), children: [Text(r['value']!)]))
      ]),
    );
  }
}
