class ErrorMessages {
  static const String usernameTaken = 'That username is taken. Try another.';
  static const String userNotEnabled = 'User is not enabled';
  static const String incorrectCredentials = 'Incorrect Username / Password';
}

class MiscDBKeys {
  static const String currentlyLoggedInUserID = 'currentlyLoggedInUserID';
  static const String lastLogInTime = 'lastLogInTime';
  static const String bookStallName = 'bookStallName';
  static const String bookStallAdress = 'bookStallAdress';
  static const String bookStallPhoneNumber = 'bookStallPhoneNumber';
  static const String bankName = 'bankName';
  static const String bankAccountNo = 'bankAccountNo';
  static const String bankIFSC = 'bankIFSC';
  static const String bankBranch = 'bankBranch';
}

class DBItemHiveType {
  static const int book = 1;
  static const int bookAuthor = 2;
  static const int bookPublisher = 3;
  static const int bookCategory = 4;
  static const int bookPurchase = 5;
  static const int sale = 6;
  static const int saleItemBook = 7;
  static const int saleItemBookPurchaseVariant = 8;
  static const int attachment = 9;
  static const int misc = 10;
  static const int users = 11;
  static const int userBatch = 12;
  static const int loginHistory = 13;
  static const int stationaryItem = 14;
  static const int stationaryPurchase = 15;
}

class DBNames {
  static const String book = 'book_db';
  static const String bookAuthor = 'book_author_db';
  static const String bookPurchase = 'book_purchase_db';
  static const String stationaryPurchase = 'stationary_purchase_db';
  static const String bookCategories = 'book_categories_db';
  static const String sale = 'sale_db';
  static const String saleItemBook = 'sale_item_book_db';
  static const String saleItemBookPurchaseVariant =
      'sale_item_book_purchase_variant_db';
  static const String publisher = 'publisher_db';
  static const String attachment = 'attachment_db';
  static const String misc = 'misc_db';
  static const String users = 'users_db';
  static const String userBatch = 'user_batch_db';
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
