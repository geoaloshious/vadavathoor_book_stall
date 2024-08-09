import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/utils.dart';
part 'book_purchase.g.dart';

BookPurchaseModel emptyBookPurchaseModel() => BookPurchaseModel(
    purchaseID: '',
    publisherID: '',
    purchaseDate: 0,
    bookID: '',
    quantity: 0,
    bookPrice: 0,
    createdDate: 0,
    modifiedDate: 0,
    deleted: false);

@HiveType(typeId: ItemType.bookPurchase)
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
  int quantity;

  @HiveField(6)
  final int createdDate;

  @HiveField(7)
  int modifiedDate;

  @HiveField(8)
  bool deleted;

  Map<String, dynamic> toJson() {
    return {
      'purchaseID': purchaseID,
      'publisherID': publisherID,
      'purchaseDate': purchaseDate,
      'bookID': bookID,
      'quantity': quantity,
      'bookPrice': bookPrice,
      'createdDate': createdDate,
      'modifiedDate': modifiedDate,
      'deleted': deleted
    };
  }

  BookPurchaseModel(
      {required this.purchaseID,
      required this.publisherID,
      required this.purchaseDate,
      required this.bookID,
      required this.quantity,
      required this.bookPrice,
      required this.createdDate,
      required this.modifiedDate,
      required this.deleted});
}
