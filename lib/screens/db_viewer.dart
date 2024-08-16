import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/db/functions/publisher.dart';
import 'package:vadavathoor_book_stall/db/functions/utils.dart';

import '../db/functions/book.dart';
import '../db/functions/book_purchase.dart';
import '../db/functions/book_sale.dart';
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

    final purchaseDB = (await getBookPurchaseBox()).values.toList();
    tempArr.add({
      'label': 'Purchases',
      'value': getPrettyJSONString(
          json.encode(purchaseDB.map((p) => p.toJson()).toList()))
    });

    final salesDB = (await getSalesBox()).values.toList();
    tempArr.add({
      'label': 'Sales',
      'value': getPrettyJSONString(
          json.encode(salesDB.map((p) => p.toJson()).toList()))
    });

    final booksDB = (await getBooksBox()).values.toList();
    tempArr.add({
      'label': 'Books',
      'value': getPrettyJSONString(
          json.encode(booksDB.map((p) => p.toJson()).toList()))
    });

    final publishersDB = (await getPublishersBox()).values.toList();
    tempArr.add({
      'label': 'Publishers',
      'value': getPrettyJSONString(
          json.encode(publishersDB.map((p) => p.toJson()).toList()))
    });

    final usersDB = (await getUsersBox()).values.toList();
    tempArr.add({
      'label': 'Users',
      'value': getPrettyJSONString(
          json.encode(usersDB.map((p) => p.toJson()).toList()))
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
