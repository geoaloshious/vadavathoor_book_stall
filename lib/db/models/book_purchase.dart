import 'package:hive_flutter/hive_flutter.dart';
part 'book_purchase.g.dart';

@HiveType(typeId: 3)
class BookPurchaseModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  final String publisherID;

  @HiveField(2)
  final String purchaseDate;

  @HiveField(3)
  final String bookID;

  @HiveField(4)
  final String bookPrice;

  @HiveField(5)
  final String quantity;

  @HiveField(6)
  final String createdDate;

  @HiveField(7)
  final String modifiedDate;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'publisherID': publisherID,
      'purchaseDate': purchaseDate,
      'bookID': bookID,
      'quantity': quantity,
      'bookPrice': bookPrice,
      'createdDate': createdDate,
      'modifiedDate': modifiedDate
    };
  }

  BookPurchaseModel({
    required this.publisherID,
    required this.purchaseDate,
    required this.bookID,
    required this.quantity,
    required this.bookPrice,
    required this.createdDate,
    required this.modifiedDate,
    this.id,
  });
}
