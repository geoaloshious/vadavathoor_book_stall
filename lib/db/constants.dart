class MiscDBKeys {
  static const String currentlyLoggedInUserID = 'currentlyLoggedInUserID';
  static const String lastLogInTime = 'lastLogInTime';
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
  static const String users = 'users_db';
  static const String loginHistory = 'login_history_db';
}

class UserRole {
  static const int developer = 1;
  static const int admin = 2;
  static const int normal = 3;
}

class UserStatus {
  static const int enabled = 1;
  static const int disabled = 2;
  static const int deleted = 3;
}
