import 'package:intl/intl.dart';

import '../db/constants.dart';

class PaymentModes {
  static const String cash = '1';
  static const String upi = '2';
  static const String card = '3';
}

String getPaymentModeName(String mode) {
  switch (mode) {
    case PaymentModes.cash:
      return 'Cash';
    case PaymentModes.upi:
      return 'UPI';
    case PaymentModes.card:
      return 'Card';
    default:
      return 'Unknown';
  }
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
      return 'Unknown';
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
  int timestamp = getCurrentTimestamp();
  return timestamp.toString();
}

int getCurrentTimestamp() {
  return DateTime.now().millisecondsSinceEpoch;
}

String formatTimestamp({required int timestamp, String? format}) {
  if (timestamp == 0) {
    return '';
  }

  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  DateFormat dateFormat = DateFormat(format ?? 'dd/MM/yyyy hh:mm a');
  return dateFormat.format(dateTime);
}

String numberToWords(int number) {
  if (number == 0) return "Zero";

  const List<String> units = [
    "",
    "One",
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
    "Seven",
    "Eight",
    "Nine",
    "Ten",
    "Eleven",
    "Twelve",
    "Thirteen",
    "Fourteen",
    "Fifteen",
    "Sixteen",
    "Seventeen",
    "Eighteen",
    "Nineteen"
  ];

  const List<String> tens = [
    "",
    "",
    "Twenty",
    "Thirty",
    "Forty",
    "Fifty",
    "Sixty",
    "Seventy",
    "Eighty",
    "Ninety"
  ];

  String words = "";

  if (number >= 1000) {
    words += "${units[number ~/ 1000]} Thousand ";
    number %= 1000;
  }
  if (number >= 100) {
    words += "${units[number ~/ 100]} Hundred";
    number %= 100;
    if (number > 0) {
      words += " and";
    }
  }
  if (number >= 20) {
    words += " ${tens[number ~/ 10]}";
    number %= 10;
  }
  if (number > 0) {
    words += " ${units[number]}";
  }

  return words.trim();
}
