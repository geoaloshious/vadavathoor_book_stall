import 'package:intl/intl.dart';

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

class SaleItemType {
  static const int book = 1;
  static const int stationary = 2;
}

String generateID(int type) {
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  return timestamp.toString();

  // switch (type) {
  //   case ItemType.book:
  //     return 'bk_$timestamp';
  //   case ItemType.bookPurchase:
  //     return 'bkp_$timestamp';
  //   case ItemType.bookSale:
  //     return 'bks_$timestamp';
  //   case ItemType.publisher:
  //     return 'pbr_$timestamp';
  //   default:
  //     return '$timestamp';
  // }
}

int getCurrentTimestamp() {
  return DateTime.now().millisecondsSinceEpoch;
}

String formatTimestamp(int timestamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  DateFormat dateFormat = DateFormat('dd/MM/yyyy hh:mm a');
  return dateFormat.format(dateTime);
}
