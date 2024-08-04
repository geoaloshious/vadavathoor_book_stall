import 'package:intl/intl.dart';

class ItemType {
  static const int book = 1;
  static const int bookPurchase = 2;
  static const int bookSale = 3;
  static const int bookSaleItem = 4;
  static const int publisher = 5;
  static const int attachment = 6;
  static const int misc = 7;
}

class DBNames {
  static const String book = 'book_db';
  static const String bookPurchase = 'book_purchase_db';
  static const String bookSale = 'book_sale_db';
  static const String bookSaleItem = 'book_sale_item_db';
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

  switch (type) {
    case ItemType.book:
      return 'bk_$timestamp';
    case ItemType.bookPurchase:
      return 'bkp_$timestamp';
    case ItemType.bookSale:
      return 'bks_$timestamp';
    case ItemType.publisher:
      return 'pbr_$timestamp';
    default:
      return '$timestamp';
  }
}

int getCurrentTimestamp() {
  return DateTime.now().millisecondsSinceEpoch;
}

String formatTimestamp(int timestamp) {
  // Create a DateTime object from the timestamp
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

  // Define the desired format
  DateFormat dateFormat = DateFormat('dd/MM/yyyy hh:mm a');

  // Format the DateTime object
  return dateFormat.format(dateTime);
}
