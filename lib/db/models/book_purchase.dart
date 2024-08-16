import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
part 'book_purchase.g.dart';

BookPurchaseModel emptyBookPurchaseModel() => BookPurchaseModel(
    purchaseID: '',
    publisherID: '',
    purchaseDate: 0,
    bookID: '',
    quantityPurchased: 0,
    quantityLeft: 0,
    bookPrice: 0,
    createdDate: 0,
    createdBy: '',
    modifiedDate: 0,
    modifiedBy: '',
    deleted: false);

@HiveType(typeId: DBItemHiveType.bookPurchase)
class BookPurchaseModel {
  @HiveField(0)
  final String purchaseID;

  @HiveField(1)
  String publisherID;

  @HiveField(2)
  int purchaseDate;

  @HiveField(3)
  String bookID;

  @HiveField(4)
  double bookPrice;

  @HiveField(5)
  int quantityPurchased;

  @HiveField(6)
  int quantityLeft;

  @HiveField(7)
  final int createdDate;

  @HiveField(8)
  final String createdBy;

  @HiveField(9)
  int modifiedDate;

  @HiveField(10)
  String modifiedBy;

  @HiveField(11)
  bool deleted;

  Map<String, dynamic> toJson() {
    return {
      'purchaseID': purchaseID,
      'publisherID': publisherID,
      'purchaseDate': purchaseDate,
      'bookID': bookID,
      'quantityPurchased': quantityPurchased,
      'quantityLeft': quantityLeft,
      'bookPrice': bookPrice,
      'createdDate': createdDate,
      'createdBy': createdBy,
      'modifiedDate': modifiedDate,
      'modifiedBy': modifiedBy,
      'deleted': deleted
    };
  }

  BookPurchaseModel(
      {required this.purchaseID,
      required this.publisherID,
      required this.purchaseDate,
      required this.bookID,
      required this.quantityPurchased,
      required this.quantityLeft,
      required this.bookPrice,
      required this.createdDate,
      required this.createdBy,
      required this.modifiedDate,
      required this.modifiedBy,
      required this.deleted});
}
