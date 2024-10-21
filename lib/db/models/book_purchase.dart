import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
part 'book_purchase.g.dart';

@HiveType(typeId: DBItemHiveType.bookPurchase)
class BookPurchaseModel {
  @HiveField(0)
  final String purchaseID;

  @HiveField(1)
  int purchaseDate;

  @HiveField(2)
  String bookID;

  @HiveField(3)
  double bookPrice;

  @HiveField(4)
  int quantityPurchased;

  @HiveField(5)
  int quantityLeft;

  @HiveField(6)
  final int createdDate;

  @HiveField(7)
  final String createdBy;

  @HiveField(8)
  int modifiedDate;

  @HiveField(9)
  String modifiedBy;

  @HiveField(10)
  int status;

  Map<String, dynamic> toJson() {
    return {
      'purchaseID': purchaseID,
      'purchaseDate': purchaseDate,
      'bookID': bookID,
      'quantityPurchased': quantityPurchased,
      'quantityLeft': quantityLeft,
      'bookPrice': bookPrice,
      'createdDate': createdDate,
      'createdBy': createdBy,
      'modifiedDate': modifiedDate,
      'modifiedBy': modifiedBy,
      'status': status
    };
  }

  BookPurchaseModel(
      {required this.purchaseID,
      required this.purchaseDate,
      required this.bookID,
      required this.quantityPurchased,
      required this.quantityLeft,
      required this.bookPrice,
      required this.createdDate,
      required this.createdBy,
      required this.modifiedDate,
      required this.modifiedBy,
      required this.status});
}
