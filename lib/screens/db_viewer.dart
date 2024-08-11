import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/models/book.dart';
import 'package:vadavathoor_book_stall/db/models/book_purchase.dart';
import 'package:vadavathoor_book_stall/db/models/book_sale.dart';

import '../utils.dart';

class DbViewer extends StatefulWidget {
  const DbViewer({super.key});

  @override
  State<DbViewer> createState() => _DbViewerState();
}

class _DbViewerState extends State<DbViewer> {
  String purchases = '';
  String sales = '';
  String books = '';

  String getPrettyJSONString(String text) {
    final object = json.decode(text);
    final prettyString = const JsonEncoder.withIndent('  ').convert(object);
    return prettyString;
  }

  void setData() async {
    final purchaseDB =
        (await Hive.openBox<BookPurchaseModel>(DBNames.bookPurchase))
            .values
            .toList();

    setState(() {
      purchases = getPrettyJSONString(
          json.encode(purchaseDB.map((p) => p.toJson()).toList()));
    });

    final salesDB =
        (await Hive.openBox<SaleModel>(DBNames.sale)).values.toList();

    setState(() {
      sales = getPrettyJSONString(
          json.encode(salesDB.map((p) => p.toJson()).toList()));
    });

    final booksDB =
        (await Hive.openBox<BookModel>(DBNames.book)).values.toList();

    setState(() {
      books = booksDB.map((p) => p.toJson()).toString();
    });
  }

  @override
  void initState() {
    super.initState();

    setData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ExpansionTile(
          title: const Text('Purchases'),
          children: [Text(purchases)],
        ),
        ExpansionTile(
          title: const Text('Sales'),
          children: [Text(sales)],
        ),
        ExpansionTile(
          title: const Text('Books'),
          children: [Text(books)],
        )
      ]),
    );
  }
}
