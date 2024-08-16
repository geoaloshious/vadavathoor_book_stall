class ErrorMessages {
  static const String usernameTaken = 'That username is taken. Try another.';
  static const String userNotEnabled = 'User is not enabled';
  static const String incorrectCredentials = 'Incorrect Username / Password';
}

class MiscDBKeys {
  static const String currentlyLoggedInUserID = 'currentlyLoggedInUserID';
  static const String lastLogInTime = 'lastLogInTime';
}

class DBItemHiveType {
  static const int book = 1;
  static const int bookPublisher = 2;
  static const int bookCategory = 3;
  static const int bookPurchase = 4;
  static const int sale = 5;
  static const int saleItemBook = 6;
  static const int saleItemBookPurchaseVariant = 7;
  static const int attachment = 8;
  static const int misc = 9;
  static const int users = 10;
  static const int loginHistory = 11;
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

class DBRowStatus {
  static const int active = 1;
  static const int deleted = 2;
}
