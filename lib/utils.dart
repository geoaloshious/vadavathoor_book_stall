import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:vadavathoor_book_stall/db/models/book.dart';
import 'package:vadavathoor_book_stall/db/models/book_purchase.dart';
import 'package:vadavathoor_book_stall/db/models/book_sale.dart';
import 'package:vadavathoor_book_stall/db/models/publisher.dart';
import 'package:vadavathoor_book_stall/db/models/purchase_attachment.dart';

class ItemType {
  static const int book = 1;
  static const int bookPurchase = 2;
  static const int sale = 3;
  static const int saleItemBook = 4;
  static const int saleItemBookPurchaseVariant = 5;
  static const int publisher = 6;
  static const int attachment = 7;
  static const int misc = 8;
}

class DBNames {
  static const String book = 'book_db';
  static const String bookPurchase = 'book_purchase_db';
  static const String sale = 'sale_db';
  static const String saleItemBook = 'sale_item_book_db';
  static const String saleItemBookPurchaseVariant =
      'sale_item_book_purchase_variant_db';
  static const String publisher = 'publisher_db';
  static const String attachment = 'attachment_db';
  static const String misc = 'misc_db';
}

// class SaleItemType {
//   static const int book = 1;
//   static const int stationary = 2;
// }

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
  if (!Hive.isAdapterRegistered(BookPurchaseModelAdapter().typeId)) {
    Hive.registerAdapter(BookPurchaseModelAdapter());
  }
  if (!Hive.isAdapterRegistered(SaleModelAdapter().typeId)) {
    Hive.registerAdapter(SaleModelAdapter());
  }
  if (!Hive.isAdapterRegistered(SaleItemBookModelAdapter().typeId)) {
    Hive.registerAdapter(SaleItemBookModelAdapter());
  }
  if (!Hive.isAdapterRegistered(
      SaleItemBookPurchaseVariantModelAdapter().typeId)) {
    Hive.registerAdapter(SaleItemBookPurchaseVariantModelAdapter());
  }
  if (!Hive.isAdapterRegistered(PurchaseAttachmentModelAdapter().typeId)) {
    Hive.registerAdapter(PurchaseAttachmentModelAdapter());
  }
  if (!Hive.isAdapterRegistered(PublisherModelAdapter().typeId)) {
    Hive.registerAdapter(PublisherModelAdapter());
  }

  // return;
}

String generateID(int type) {
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  return timestamp.toString();
}

int getCurrentTimestamp() {
  return DateTime.now().millisecondsSinceEpoch;
}

String formatTimestamp({required int timestamp, String? format}) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  DateFormat dateFormat = DateFormat(format ?? 'dd/MM/yyyy hh:mm a');
  return dateFormat.format(dateTime);
}
