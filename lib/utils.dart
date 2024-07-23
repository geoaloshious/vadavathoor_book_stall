class ItemType {
  static const int book = 1;
  static const int bookPurchase = 2;
  static const int bookSale = 3;
  static const int publisher = 4;
  static const int attachment = 5;
}

class DBNames {
  static const String book = 'book_db';
  static const String bookPurchase = 'book_purchase_db';
  static const String bookSale = 'book_sale_db';
  static const String publisher = 'publisher_db';
  static const String attachment = 'attachment_db';
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
      return '';
  }
}
