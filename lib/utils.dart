import 'package:intl/intl.dart';

import 'db/constants.dart';

class ItemType {
  static const int book = 1;
  static const int bookPurchase = 2;
  static const int sale = 3;
  static const int saleItemBook = 4;
  static const int saleItemBookPurchaseVariant = 5;
  static const int publisher = 6;
  static const int attachment = 7;
  static const int misc = 8;
  static const int users = 9;
  static const int loginHistory = 10;
}

String getRoleName(int role) {
  switch (role) {
    case UserRole.admin:
      return 'Admin';
    case UserRole.developer:
      return 'Developer';
    case UserRole.normal:
      return 'Normal User';
    default:
      return 'Invalid user';
  }
}

String getStatusName(int status) {
  switch (status) {
    case UserStatus.enabled:
      return 'Enabled';
    case UserStatus.disabled:
      return 'Disabled';
    default:
      return 'Invalid status';
  }
}

String generateID() {
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
